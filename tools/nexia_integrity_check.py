#!/usr/bin/env python3
"""NEXIA local integrity checker.

Checks STATE/BOOT/LIVE bindings, the active composite index chain, all indexed
event bytes/IDs, and explicit artifact path/hash pairs in events at or after
the current STATE. Exact, anchored errata preserve historical mistakes.
Historical artifacts require offline full Git history or --blob-cache.
It never edits files or contacts external services. Checks concern byte-level
integrity, not prose truth, historical path ownership or production readiness.

Exit codes:
  0 = no errors or warnings
  1 = one or more integrity errors
  2 = warnings only
"""
from __future__ import annotations

import argparse
import hashlib
import json
import re
import os
import subprocess
from dataclasses import dataclass, asdict
from pathlib import Path, PurePosixPath
from typing import Any, Iterable

STATE = "NEXIA_STATE.json"
BOOT = "NEXIA_BOOT.json"
LIVE = "NEXIA_LIVE.json"
MEMORY = "NEXIA_MEMORY.md"
SHA = re.compile(r"^[0-9a-f]{40}$")
MAX_FILE_BYTES = 2_000_000
MAX_INDEX_DEPTH = 1024
MAX_EVENTS = 10_000


def artifact_references(value: Any, depth=0):
    """Yield explicit path/hash pairs; commit IDs are not blob references."""
    if depth > 64:
        raise ValueError("Artifact nesting exceeds 64")
    if isinstance(value, list):
        for child in value:
            yield from artifact_references(child, depth + 1)
    elif isinstance(value, dict):
        hashes = [value[k] for k in ("verified_blob_sha", "blob_sha", "artifact_blob_sha", "candidate_blob_sha") if k in value]
        if any(not isinstance(h, str) for h in hashes) or len(set(hashes)) > 1:
            raise ValueError("Ambiguous artifact SHA fields")
        path = value.get("path", value.get("artifact", value.get("candidate")))
        sha = value.get("verified_blob_sha", value.get("blob_sha",
              value.get("artifact_blob_sha", value.get("candidate_blob_sha"))))
        if isinstance(path, str) and sha is not None:
            if not isinstance(sha, str):
                raise ValueError("Artifact SHA must be a string")
            yield path, sha
        for child in value.values():
            yield from artifact_references(child, depth + 1)


class EvidenceAudit:
    """Offline, read-only audit of the bound index chain and indexed events.

    Historical artifact hashes describe blobs, not today's mutable files. Full
    Git history or an explicit content-addressed cache supplies those bytes.
    Historical path ownership and the truth of prose are outside this check.
    """

    def __init__(self, root, findings, state_version, state_sha, blob_cache=None):
        self.root = root.resolve()
        self.findings = findings
        self.version = state_version
        self.state_sha = state_sha
        self.cache = blob_cache.resolve() if blob_cache else None
        self.indexes = []
        self.events = []
        self.blobs = {}
        self.file_data = {}
        self.reference_count = 0
        self.historical_count = 0
        self.corrected_count = 0

    def add(self, code, message, severity="ERROR"):
        self.findings.append(Finding(severity, code, message))

    def safe_path(self, name):
        if not isinstance(name, str) or not name or "\\" in name or ":" in name or "\0" in name:
            self.add("UNSAFE_REFERENCE_PATH", "Reference is not a relative POSIX path")
            return None
        p = PurePosixPath(name)
        if p.is_absolute() or ".." in p.parts:
            self.add("UNSAFE_REFERENCE_PATH", f"Rejected reference: {name!r}")
            return None
        result = (self.root / name).resolve()
        if not result.is_relative_to(self.root):
            self.add("UNSAFE_REFERENCE_PATH", f"Reference escapes root: {name!r}")
            return None
        return result

    def read(self, name, required=True):
        path = self.safe_path(name)
        if path is None:
            return None
        try:
            if path.stat().st_size > MAX_FILE_BYTES:
                self.add("REFERENCE_TOO_LARGE", name)
                return None
            data = path.read_bytes()
            self.file_data[name] = data
            return data
        except OSError:
            if required:
                self.add("MISSING_REFERENCE", name)
            return None

    def check_sha(self, sha, label):
        if not isinstance(sha, str) or not SHA.fullmatch(sha):
            self.add("INVALID_BLOB_SHA", label)
            return False
        return True

    def bound_json(self, path, expected, code):
        data = self.read(path)
        if data is None:
            return None
        if expected is None:
            self.add("REFERENCE_HASH_MISSING", path, "WARNING")
        elif self.check_sha(expected, path) and git_blob_sha(data) != expected:
            self.add(code, f"{path}: content does not match {expected}")
        try:
            value = json.loads(data)
            if not isinstance(value, dict):
                raise ValueError("root must be object")
            return value
        except (ValueError, UnicodeError, RecursionError):
            self.add("INVALID_REFERENCE_JSON", path)
            return None

    def blob(self, sha):
        if sha in self.blobs:
            return self.blobs[sha]
        data = None
        if self.cache:
            path = (self.cache / sha).resolve()
            try:
                if path.is_relative_to(self.cache) and path.stat().st_size <= MAX_FILE_BYTES:
                    data = path.read_bytes()
            except OSError:
                pass
        if data is None:
            try:
                env = {**os.environ, "GIT_NO_LAZY_FETCH": "1", "GIT_TERMINAL_PROMPT": "0"}
                size = subprocess.run(["git", "-C", str(self.root), "cat-file", "-s", sha],
                                      capture_output=True, timeout=5, check=False, env=env)
                if size.returncode != 0 or not 0 <= int(size.stdout.strip()) <= MAX_FILE_BYTES:
                    self.blobs[sha] = None
                    return None
                result = subprocess.run(
                    ["git", "-C", str(self.root), "cat-file", "blob", sha],
                    capture_output=True, timeout=5, check=False,
                    env=env,
                )
                if result.returncode == 0 and len(result.stdout) <= MAX_FILE_BYTES:
                    data = result.stdout
            except (OSError, ValueError, subprocess.TimeoutExpired):
                pass
        if data is not None and git_blob_sha(data) != sha:
            self.add("HISTORICAL_BLOB_HASH_MISMATCH", sha)
            data = None
        self.blobs[sha] = data
        return data

    def verify_artifact(self, path, sha):
        self.reference_count += 1
        if self.safe_path(path) is None or not self.check_sha(sha, path):
            return
        data = self.read(path, required=False)
        if data is not None and git_blob_sha(data) == sha:
            return
        if self.blob(sha) is not None:
            self.historical_count += 1
            return
        self.add("ARTIFACT_BLOB_UNVERIFIED", f"{path}: {sha}; need matching bytes or offline Git history/cache")

    def chain(self, boot, live):
        bs, ls = boot.get("event_storage"), live.get("event_storage")
        if not isinstance(bs, dict) or not isinstance(ls, dict):
            self.add("EVENT_STORAGE_MISSING", "Modern BOOT/LIVE require event_storage")
            return
        for key in ("active_index", "active_index_blob_sha", "latest_verified_event_id",
                    "latest_verified_event_path", "latest_verified_event_blob_sha"):
            if not bs.get(key) or bs.get(key) != ls.get(key):
                self.add("EVENT_STORAGE_MISMATCH", key)
        path, expected = bs.get("active_index"), bs.get("active_index_blob_sha")
        visited = set()
        for depth in range(MAX_INDEX_DEPTH):
            if not isinstance(path, str):
                self.add("INVALID_INDEX_REFERENCE", "Index path must be a string")
                return
            if path in visited:
                self.add("INDEX_CYCLE", str(path))
                return
            visited.add(path)
            index = self.bound_json(path, expected, "INDEX_HASH_MISMATCH")
            if index is None:
                return
            actual_sha = git_blob_sha(self.file_data[path])
            self.indexes.append((path, actual_sha, index))
            if depth == 0:
                add_equal(self.findings, "INDEX_STATE_VERSION_MISMATCH", path,
                          index.get("canonical_state_version"), self.version)
                add_equal(self.findings, "INDEX_STATE_SHA_MISMATCH", path,
                          index.get("canonical_state_blob_sha"), self.state_sha)
                for ik, sk in (("latest_event_id", "latest_verified_event_id"),
                               ("latest_event_path", "latest_verified_event_path"),
                               ("latest_event_blob_sha", "latest_verified_event_blob_sha")):
                    add_equal(self.findings, "LATEST_EVENT_POINTER_MISMATCH", ik,
                              index.get(ik), bs.get(sk))
            base = index.get("base_index")
            if base is None:
                break
            if not isinstance(base, dict):
                self.add("INVALID_INDEX_REFERENCE", f"{path}: base_index must bind path and SHA")
                return
            path, expected = base.get("path"), base.get("verified_blob_sha")
        else:
            self.add("INDEX_DEPTH_LIMIT", str(MAX_INDEX_DEPTH))
            return
        self.check_base_index_errata()
        self.check_events(bs)

    def check_base_index_errata(self):
        """Resolve only *missing* legacy base-index hashes using anchored later claims.

        Never modify a historical index or override an existing SHA claim.
        Both the source index bytes and the target index bytes must match the
        declared Git blob hashes. A conflict keeps the reference unresolved.
        """
        positions = {p: i for i, (p, _, _) in enumerate(self.indexes)}
        shas = {p: sha for p, sha, _ in self.indexes}
        resolved = {}
        conflicts = set()
        for issuer_position, (issuer, _, index) in enumerate(self.indexes):
            rows = index.get("base_index_reference_errata", [])
            if not isinstance(rows, list):
                self.add("INVALID_BASE_INDEX_ERRATUM", issuer)
                continue
            for row in rows:
                if not isinstance(row, dict):
                    self.add("INVALID_BASE_INDEX_ERRATUM", issuer)
                    continue
                source = row.get("source_index")
                target = row.get("path")
                source_position = positions.get(source) if isinstance(source, str) else None
                target_position = positions.get(target) if isinstance(target, str) else None
                corrected = row.get("verified_blob_sha")
                if (source_position is None or source_position <= issuer_position
                        or target_position is None or target_position <= source_position
                        or "declared_blob_sha" not in row
                        or row.get("declared_blob_sha") is not None
                        or not isinstance(corrected, str) or not SHA.fullmatch(corrected)):
                    self.add("INVALID_BASE_INDEX_ERRATUM", issuer)
                    continue
                old = self.indexes[source_position][2].get("base_index")
                if (not isinstance(old, dict) or old.get("path") != target
                        or old.get("verified_blob_sha") is not None
                        or shas[source] != row.get("source_index_blob_sha")
                        or shas[target] != corrected):
                    self.add("INVALID_BASE_INDEX_ERRATUM", issuer)
                    continue
                key = (source, target)
                if key in resolved:
                    conflicts.add(key)
                    self.add("CONFLICTING_BASE_INDEX_ERRATA", f"{issuer}: {source} -> {target}")
                resolved[key] = corrected
        for key in conflicts:
            resolved.pop(key, None)
        for (source, target), _ in resolved.items():
            # The traversal is a single chain; only the warning for this
            # genuinely hashless direct base-index edge may be removed.
            warning = next((i for i, f in enumerate(self.findings)
                            if f.severity == "WARNING" and f.code == "REFERENCE_HASH_MISSING"
                            and f.message == target), None)
            if warning is None:
                self.add("INVALID_BASE_INDEX_ERRATUM", f"{source}: warning not present")
                continue
            self.findings.pop(warning)
            self.corrected_count += 1
            self.add("BASE_INDEX_REFERENCE_CORRECTED", f"{source}: {target}", "INFO")

    def check_events(self, storage):
        # Corrections may bind only exact claims in an older index, never a base
        # index hash or a same/newer index's event claims.
        index_positions = {p: i for i, (p, _, _) in enumerate(self.indexes)}
        index_shas = {p: sha for p, sha, _ in self.indexes}
        index_overrides = {}
        for pos, (p, _, index) in enumerate(self.indexes):
            rows = index.get("event_reference_errata", [])
            if not isinstance(rows, list):
                self.add("INVALID_INDEX_ERRATUM", p)
                continue
            for row in rows:
                if not isinstance(row, dict):
                    self.add("INVALID_INDEX_ERRATUM", p)
                    continue
                source = row.get("source_index")
                if not isinstance(source, str):
                    self.add("INVALID_INDEX_ERRATUM", p)
                    continue
                if index_positions.get(source, -1) <= pos or index_shas.get(source) != row.get("source_index_blob_sha"):
                    self.add("INVALID_INDEX_ERRATUM", p)
                    continue
                source_index = self.indexes[index_positions[source]][2]
                original_rows = [source_index.get("events", []), source_index.get("delta_events", [])]
                if not all(isinstance(rows, list) for rows in original_rows):
                    self.add("INVALID_INDEX_ERRATUM", p)
                    continue
                originals = original_rows[0] + original_rows[1]
                claim = (row.get("path"), row.get("declared_blob_sha"))
                if not isinstance(claim[0], str) or (claim[1] is not None and not isinstance(claim[1], str)):
                    self.add("INVALID_INDEX_ERRATUM", p)
                    continue
                if not any(isinstance(e, dict) and (e.get("path"), e.get("verified_blob_sha")) == claim for e in originals):
                    self.add("INVALID_INDEX_ERRATUM", p)
                    continue
                key = (source, *claim)
                if key in index_overrides:
                    self.add("CONFLICTING_INDEX_ERRATA", str(key))
                index_overrides[key] = row.get("verified_blob_sha")
        seen = {}
        for index_path, _, index in reversed(self.indexes):
            for field in ("events", "delta_events"):
                rows = index.get(field, [])
                if not isinstance(rows, list):
                    self.add("INVALID_EVENT_LIST", index_path)
                    continue
                for ref in rows:
                    if len(self.events) >= MAX_EVENTS:
                        self.add("EVENT_LIMIT", str(MAX_EVENTS))
                        return
                    if not isinstance(ref, dict) or not isinstance(ref.get("path"), str):
                        self.add("INVALID_EVENT_REFERENCE", index_path)
                        continue
                    path, sha = ref["path"], ref.get("verified_blob_sha")
                    if sha is not None and not isinstance(sha, str):
                        self.add("INVALID_BLOB_SHA", path)
                        continue
                    key = (index_path, path, sha)
                    if key in index_overrides:
                        sha = index_overrides[key]
                        self.corrected_count += 1
                        self.add("INDEX_REFERENCE_CORRECTED", f"{index_path}: {path}", "INFO")
                    if path in seen:
                        if seen[path] != sha:
                            self.add("CONFLICTING_EVENT_REFERENCE", path)
                        continue
                    seen[path] = sha
                    event = self.bound_json(path, sha, "EVENT_HASH_MISMATCH")
                    if event is None:
                        continue
                    add_equal(self.findings, "EVENT_ID_MISMATCH", path,
                              event.get("event_id"), ref.get("event_id"))
                    self.events.append((path, git_blob_sha(self.file_data[path]), event, index))
        latest = storage.get("latest_verified_event_path")
        if latest not in seen or seen.get(latest) != storage.get("latest_verified_event_blob_sha"):
            self.add("LATEST_EVENT_NOT_INDEXED", str(latest))
        self.check_payloads()

    def check_payloads(self):
        positions = {p: i for i, (p, _, _, _) in enumerate(self.events)}
        overrides = {}
        for pos, (p, _, event, _) in enumerate(self.events):
            source = event.get("supersedes_reference_claims_in")
            if source is None:
                continue
            if not isinstance(source, str):
                self.add("INVALID_ARTIFACT_ERRATUM", p)
                continue
            source_pos = positions.get(source)
            if source_pos is None or source_pos >= pos:
                self.add("INVALID_ARTIFACT_ERRATUM", p)
                continue
            _, source_sha, original, _ = self.events[source_pos]
            if source_sha != event.get("corrects_event_blob_sha"):
                self.add("INVALID_ARTIFACT_ERRATUM", p)
                continue
            try:
                claims = set(artifact_references(original))
            except ValueError:
                self.add("INVALID_ARTIFACT_REFERENCE", source)
                continue
            rows = event.get("corrected_references", [])
            if not isinstance(rows, list):
                self.add("INVALID_ARTIFACT_ERRATUM", p)
                continue
            for row in rows:
                if not isinstance(row, dict):
                    self.add("INVALID_ARTIFACT_ERRATUM", p)
                    continue
                claim = (row.get("path"), row.get("declared_blob_sha"))
                if not all(isinstance(v, str) for v in claim):
                    self.add("INVALID_ARTIFACT_ERRATUM", p)
                    continue
                if claim not in claims:
                    self.add("INVALID_ARTIFACT_ERRATUM", p)
                    continue
                key = (source, *claim)
                if key in overrides:
                    self.add("CONFLICTING_ARTIFACT_ERRATA", str(key))
                overrides[key] = row.get("verified_blob_sha")
        for p, _, event, index in self.events:
            new_state = event.get("new_state")
            new_version = new_state.get("version") if isinstance(new_state, dict) else None
            version = event.get("canonical_state_version", event.get("state_version",
                      event.get("canonical_state_base_version", new_version if new_version is not None else
                      index.get("canonical_state_version", 0))))
            if not isinstance(version, int):
                self.add("INVALID_EVENT_STATE_VERSION", p)
                continue
            if version > self.version:
                self.add("EVENT_FUTURE_STATE", p)
            if version < self.version:
                continue
            try:
                references = list(artifact_references(event))
            except ValueError:
                self.add("INVALID_ARTIFACT_REFERENCE", p)
                continue
            for path, sha in references:
                if (p, path, sha) in overrides:
                    sha = overrides[p, path, sha]
                    self.corrected_count += 1
                    self.add("ARTIFACT_REFERENCE_CORRECTED", f"{p}: {path}", "INFO")
                self.verify_artifact(path, sha)


@dataclass(frozen=True)
class Finding:
    severity: str
    code: str
    message: str


def git_blob_sha(data: bytes) -> str:
    header = f"blob {len(data)}\0".encode("ascii")
    return hashlib.sha1(header + data).hexdigest()


def load_json(path: Path, findings: list[Finding]) -> dict[str, Any] | None:
    if not path.exists():
        findings.append(Finding("ERROR", "MISSING_FILE", f"Missing required file: {path.name}"))
        return None
    try:
        value = json.loads(path.read_text(encoding="utf-8"))
    except Exception as exc:
        findings.append(Finding("ERROR", "INVALID_JSON", f"{path.name}: {exc}"))
        return None
    if not isinstance(value, dict):
        findings.append(Finding("ERROR", "INVALID_ROOT", f"{path.name}: root must be a JSON object"))
        return None
    return value


def add_equal(findings: list[Finding], code: str, label: str, actual: Any, expected: Any) -> None:
    if actual != expected:
        findings.append(Finding("ERROR", code, f"{label}: got {actual!r}, expected {expected!r}"))


def non_null_values(mapping: dict[str, Any], keys: Iterable[str]) -> list[tuple[str, Any]]:
    return [(key, mapping.get(key)) for key in keys if mapping.get(key) is not None]


def extract_state_version(state: dict[str, Any]) -> Any:
    return state.get("version", state.get("state_version"))


def scan_stale_version_mentions(value: Any, current: int, prefix: str = "") -> list[str]:
    hits: list[str] = []
    if isinstance(value, dict):
        for key, child in value.items():
            child_prefix = f"{prefix}.{key}" if prefix else str(key)
            hits.extend(scan_stale_version_mentions(child, current, child_prefix))
    elif isinstance(value, list):
        for idx, child in enumerate(value):
            hits.extend(scan_stale_version_mentions(child, current, f"{prefix}[{idx}]"))
    elif isinstance(value, str):
        for match in re.finditer(r"\bSTATE\s+v(\d+)\b", value, flags=re.I):
            mentioned = int(match.group(1))
            if mentioned < current:
                hits.append(f"{prefix}: mentions STATE v{mentioned}")
    return hits


def run_checks(root: Path, *, blob_cache: Path | None = None) -> dict[str, Any]:
    findings: list[Finding] = []
    state_path, boot_path, live_path = root / STATE, root / BOOT, root / LIVE
    state = load_json(state_path, findings)
    boot = load_json(boot_path, findings)
    live = load_json(live_path, findings)

    if not all((state, boot, live)):
        return summarize(findings)

    state_version = extract_state_version(state)
    if type(state_version) is not int:
        findings.append(Finding("ERROR", "STATE_VERSION_INVALID", "STATE version is missing or not an integer"))
        return summarize(findings)

    for label, document, keys in (
        ("STATE", state, ("current_mission", "active_experiment", "active_reality_probe", "economics")),
        ("BOOT", boot, ("mission", "active_experiment", "active_reality_probe", "economics", "event_storage")),
        ("LIVE", live, ("economics", "event_storage", "active_reality_probe")),
    ):
        for key in keys:
            if key in document and not isinstance(document[key], dict):
                findings.append(Finding("ERROR", "INVALID_FIELD_TYPE", f"{label}.{key} must be object"))
    if findings:
        return summarize(findings)

    state_sha = git_blob_sha(state_path.read_bytes())
    boot_sha = git_blob_sha(boot_path.read_bytes())

    for key, value in non_null_values(boot, ["state_version", "last_verified_state_version"]):
        add_equal(findings, "BOOT_STATE_VERSION_MISMATCH", f"BOOT.{key}", value, state_version)
    for key, value in non_null_values(boot, ["state_blob_sha", "last_verified_state_blob_sha"]):
        add_equal(findings, "BOOT_STATE_SHA_MISMATCH", f"BOOT.{key}", value, state_sha)
    if not non_null_values(boot, ["state_version", "last_verified_state_version"]):
        findings.append(Finding("ERROR", "BOOT_STATE_VERSION_MISSING", "BOOT must bind STATE version"))
    if not non_null_values(boot, ["state_blob_sha", "last_verified_state_blob_sha"]):
        findings.append(Finding("ERROR", "BOOT_STATE_SHA_MISSING", "BOOT must bind STATE blob"))

    add_equal(findings, "LIVE_STATE_VERSION_MISMATCH", "LIVE.state_version", live.get("state_version"), state_version)
    add_equal(findings, "LIVE_STATE_SHA_MISMATCH", "LIVE.state_blob_sha", live.get("state_blob_sha"), state_sha)
    modern = isinstance(live.get("schema_version"), int) and live["schema_version"] >= 26
    if modern:
        add_equal(findings, "BOOT_LIVE_SHA_MISMATCH", "BOOT.live_state_blob_sha",
                  boot.get("live_state_blob_sha"), git_blob_sha(live_path.read_bytes()))
    for key, expected, code in (("boot_version", boot.get("boot_version"), "LIVE_BOOT_VERSION_MISMATCH"),
                                ("boot_blob_sha", boot_sha, "LIVE_BOOT_SHA_MISMATCH")):
        if not modern or key in live:
            add_equal(findings, code, f"LIVE.{key}", live.get(key), expected)

    state_mission = (state.get("current_mission") or {}).get("id")
    boot_mission = (boot.get("mission") or {}).get("id")
    if state_mission is not None or boot_mission is not None:
        add_equal(findings, "MISSION_MISMATCH", "BOOT mission id", boot_mission, state_mission)

    state_exp = (state.get("active_reality_probe") or state.get("active_experiment") or {}).get("id")
    boot_exp = (boot.get("active_reality_probe") or boot.get("active_experiment") or {}).get("id")
    if state_exp is not None or boot_exp is not None:
        add_equal(findings, "EXPERIMENT_MISMATCH", "BOOT active experiment id", boot_exp, state_exp)
    if "active_reality_probe" in state:
        add_equal(findings, "EXPERIMENT_MISMATCH", "LIVE active reality probe id",
                  (live.get("active_reality_probe") or {}).get("id"), state_exp)

    for metric in ("revenue_eur", "profit_eur"):
        if metric in state and metric in live:
            add_equal(findings, "ECONOMIC_METRIC_MISMATCH", f"LIVE.{metric}", live.get(metric), state.get(metric))
        if metric in state and metric in boot:
            add_equal(findings, "ECONOMIC_METRIC_MISMATCH", f"BOOT.{metric}", boot.get(metric), state.get(metric))
    for name, view in (("BOOT", boot), ("LIVE", live)):
        if "hard_precedence" in state:
            add_equal(findings, "HARD_PRECEDENCE_MISMATCH", name,
                      view.get("hard_precedence"), state["hard_precedence"])
        if isinstance(state.get("economics"), dict) and isinstance(view.get("economics"), dict):
            for metric in ("revenue_eur", "settled_revenue_eur", "profit_eur", "reconciled_net_profit_eur"):
                if metric in state["economics"] and metric in view["economics"]:
                    add_equal(findings, "ECONOMIC_METRIC_MISMATCH", f"{name}.economics.{metric}",
                              view["economics"][metric], state["economics"][metric])

    evidence = EvidenceAudit(root, findings, state_version, state_sha, blob_cache)
    if modern or "event_storage" in boot or "event_storage" in live:
        evidence.chain(boot, live)

    memory_path = root / MEMORY
    if not memory_path.exists():
        findings.append(Finding("WARNING", "MEMORY_MISSING", "NEXIA_MEMORY.md not found; continuity ledger could not be checked"))
    else:
        head = memory_path.read_text(encoding="utf-8", errors="replace")[:5000]
        match = re.search(r"NEXIA_STATE\.json\s+v(\d+)\s+is\s+canonical", head, flags=re.I)
        if match and int(match.group(1)) != state_version:
            findings.append(Finding(
                "WARNING",
                "STALE_MEMORY_CANONICAL_NOTICE",
                f"MEMORY header names STATE v{match.group(1)} as canonical, but current STATE is v{state_version}",
            ))

    operational_subset = {
        key: live.get(key)
        for key in ("current_action", "last_completed_action", "parallel_work", "next_action", "current_blockers", "evidence")
    }
    for hit in scan_stale_version_mentions(operational_subset, state_version):
        findings.append(Finding("WARNING", "STALE_LIVE_VERSION_REFERENCE", hit))

    return summarize(findings, state_version=state_version, state_blob_sha=state_sha, boot_blob_sha=boot_sha,
                     indexes_checked=len(evidence.indexes), events_checked=len(evidence.events),
                     artifact_references_checked=evidence.reference_count,
                     historical_artifact_blobs_checked=evidence.historical_count,
                     corrected_historical_references=evidence.corrected_count,
                     payload_reference_scope="PATH_SHA_PAIRS_IN_INDEXED_EVENTS_AT_OR_AFTER_CURRENT_STATE_VERSION",
                     verification_limit="Blob integrity is not proof of historical path ownership, business claims or runtime execution.")


def summarize(findings: list[Finding], **metadata: Any) -> dict[str, Any]:
    errors = sum(f.severity == "ERROR" for f in findings)
    warnings = sum(f.severity == "WARNING" for f in findings)
    status = "FAIL" if errors else ("WARN" if warnings else "PASS")
    return {
        "status": status,
        "errors": errors,
        "warnings": warnings,
        **metadata,
        "findings": [asdict(f) for f in findings],
    }


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Check NEXIA STATE/BOOT/LIVE integrity without modifying files.")
    parser.add_argument("--root", default=".", help="Repository root (default: current directory)")
    parser.add_argument("--json", action="store_true", help="Emit machine-readable JSON")
    parser.add_argument("--blob-cache", type=Path, help="Optional offline cache of historical blobs named by Git SHA")
    args = parser.parse_args(argv)

    report = run_checks(Path(args.root).resolve(), blob_cache=args.blob_cache)
    if args.json:
        print(json.dumps(report, ensure_ascii=False, indent=2))
    else:
        print(f"NEXIA integrity: {report['status']} — {report['errors']} error(s), {report['warnings']} warning(s)")
        if report.get("state_version") is not None:
            print(f"STATE v{report['state_version']} | state blob {report['state_blob_sha']} | boot blob {report['boot_blob_sha']}")
        for item in report["findings"]:
            print(f"[{item['severity']}] {item['code']}: {item['message']}")

    if report["errors"]:
        return 1
    if report["warnings"]:
        return 2
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

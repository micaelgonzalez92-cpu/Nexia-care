#!/usr/bin/env python3
"""NEXIA local integrity checker.

Checks consistency between canonical NEXIA_STATE.json and derived BOOT/LIVE metadata.
It never edits files or contacts external services.

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
from dataclasses import dataclass, asdict
from pathlib import Path
from typing import Any, Iterable

STATE = "NEXIA_STATE.json"
BOOT = "NEXIA_BOOT.json"
LIVE = "NEXIA_LIVE.json"
MEMORY = "NEXIA_MEMORY.md"


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


def run_checks(root: Path) -> dict[str, Any]:
    findings: list[Finding] = []
    state_path, boot_path, live_path = root / STATE, root / BOOT, root / LIVE
    state = load_json(state_path, findings)
    boot = load_json(boot_path, findings)
    live = load_json(live_path, findings)

    if not all((state, boot, live)):
        return summarize(findings)

    state_version = extract_state_version(state)
    if not isinstance(state_version, int):
        findings.append(Finding("ERROR", "STATE_VERSION_INVALID", "STATE version is missing or not an integer"))
        return summarize(findings)

    state_sha = git_blob_sha(state_path.read_bytes())
    boot_sha = git_blob_sha(boot_path.read_bytes())

    for key, value in non_null_values(boot, ["state_version", "last_verified_state_version"]):
        add_equal(findings, "BOOT_STATE_VERSION_MISMATCH", f"BOOT.{key}", value, state_version)
    for key, value in non_null_values(boot, ["state_blob_sha", "last_verified_state_blob_sha"]):
        add_equal(findings, "BOOT_STATE_SHA_MISMATCH", f"BOOT.{key}", value, state_sha)

    add_equal(findings, "LIVE_STATE_VERSION_MISMATCH", "LIVE.state_version", live.get("state_version"), state_version)
    add_equal(findings, "LIVE_STATE_SHA_MISMATCH", "LIVE.state_blob_sha", live.get("state_blob_sha"), state_sha)
    add_equal(findings, "LIVE_BOOT_VERSION_MISMATCH", "LIVE.boot_version", live.get("boot_version"), boot.get("boot_version"))
    add_equal(findings, "LIVE_BOOT_SHA_MISMATCH", "LIVE.boot_blob_sha", live.get("boot_blob_sha"), boot_sha)

    state_mission = (state.get("current_mission") or {}).get("id")
    boot_mission = (boot.get("mission") or {}).get("id")
    if state_mission is not None or boot_mission is not None:
        add_equal(findings, "MISSION_MISMATCH", "BOOT mission id", boot_mission, state_mission)

    state_exp = (state.get("active_experiment") or {}).get("id")
    boot_exp = (boot.get("active_experiment") or {}).get("id")
    if state_exp is not None or boot_exp is not None:
        add_equal(findings, "EXPERIMENT_MISMATCH", "BOOT active experiment id", boot_exp, state_exp)

    for metric in ("revenue_eur", "profit_eur"):
        if metric in state and metric in live:
            add_equal(findings, "ECONOMIC_METRIC_MISMATCH", f"LIVE.{metric}", live.get(metric), state.get(metric))
        if metric in state and metric in boot:
            add_equal(findings, "ECONOMIC_METRIC_MISMATCH", f"BOOT.{metric}", boot.get(metric), state.get(metric))

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

    return summarize(findings, state_version=state_version, state_blob_sha=state_sha, boot_blob_sha=boot_sha)


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
    args = parser.parse_args(argv)

    report = run_checks(Path(args.root).resolve())
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

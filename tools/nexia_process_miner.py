#!/usr/bin/env python3
"""Nexia Process Intelligence miner.

Traverses the canonical composite event-index chain, normalizes process episodes,
derives evidence-bound reusable lessons, and emits aggregate process metrics.

No network access and no external side effects. Standard-library only.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import subprocess
import sys
from collections import Counter
from pathlib import Path
from typing import Any, Iterable

SCHEMA_VERSION = 1
MAX_INDEX_DEPTH = 1024

TOKEN_RE = re.compile(r"[a-z0-9_+-]{2,}", re.I)


class MinerError(RuntimeError):
    pass


def _load_json(path: Path) -> dict[str, Any]:
    try:
        value = json.loads(path.read_text(encoding="utf-8"))
    except FileNotFoundError as exc:
        raise MinerError(f"Missing required file: {path}") from exc
    except json.JSONDecodeError as exc:
        raise MinerError(f"Invalid JSON in {path}: {exc}") from exc
    if not isinstance(value, dict):
        raise MinerError(f"Expected JSON object in {path}")
    return value


def _git_blob_sha(path: Path) -> str:
    data = path.read_bytes()
    header = f"blob {len(data)}\0".encode("utf-8")
    return hashlib.sha1(header + data).hexdigest()


def _base_index_path(index: dict[str, Any]) -> str | None:
    base = index.get("base_index")
    if base is None:
        return None
    if isinstance(base, str):
        return base
    if isinstance(base, dict):
        path = base.get("path")
        return path if isinstance(path, str) and path else None
    raise MinerError("base_index must be string, object, or null")


def _base_index_expected_sha(index: dict[str, Any]) -> str | None:
    base = index.get("base_index")
    if isinstance(base, dict):
        sha = base.get("verified_blob_sha")
        return sha if isinstance(sha, str) and sha else None
    return None


def discover_active_index(repo_root: Path) -> str:
    boot = _load_json(repo_root / "NEXIA_BOOT.json")
    storage = boot.get("event_storage")
    if isinstance(storage, dict):
        active = storage.get("active_index")
        if isinstance(active, str) and active:
            return active
    for item in boot.get("recovery_order", []):
        if isinstance(item, str) and re.fullmatch(r"NEXIA_EVENT_INDEX_V\d+\.json", item):
            return item
    raise MinerError("Could not discover active event index from NEXIA_BOOT.json")


def traverse_index_chain(repo_root: Path, active_index: str) -> tuple[list[dict[str, Any]], list[dict[str, Any]]]:
    """Return indexes oldest->newest and reference diagnostics."""
    newest_to_oldest: list[dict[str, Any]] = []
    diagnostics: list[dict[str, Any]] = []
    seen: set[str] = set()
    current = active_index

    for depth in range(MAX_INDEX_DEPTH + 1):
        if depth >= MAX_INDEX_DEPTH:
            raise MinerError(f"Index chain exceeds MAX_INDEX_DEPTH={MAX_INDEX_DEPTH}")
        if current in seen:
            raise MinerError(f"Index cycle detected at {current}")
        seen.add(current)
        path = repo_root / current
        index = _load_json(path)
        newest_to_oldest.append({"path": current, "data": index, "blob_sha": _git_blob_sha(path)})

        base_path = _base_index_path(index)
        if not base_path:
            break

        expected = _base_index_expected_sha(index)
        base_file = repo_root / base_path
        actual = _git_blob_sha(base_file) if base_file.exists() else None
        diagnostics.append({
            "kind": "base_index",
            "from": current,
            "path": base_path,
            "expected_blob_sha": expected,
            "actual_blob_sha": actual,
            "match": None if expected is None or actual is None else expected == actual,
        })
        current = base_path

    return list(reversed(newest_to_oldest)), diagnostics


def event_references(indexes: list[dict[str, Any]]) -> tuple[list[dict[str, Any]], list[dict[str, Any]]]:
    refs: list[dict[str, Any]] = []
    diagnostics: list[dict[str, Any]] = []
    seen_event_ids: set[str] = set()
    for index_entry in indexes:
        index = index_entry["data"]
        for ref in index.get("delta_events", []):
            if not isinstance(ref, dict):
                continue
            event_id = ref.get("event_id")
            path = ref.get("path")
            if not isinstance(event_id, str) or not isinstance(path, str):
                continue
            if event_id in seen_event_ids:
                diagnostics.append({
                    "kind": "duplicate_event_reference",
                    "event_id": event_id,
                    "path": path,
                    "index": index_entry["path"],
                })
                continue
            seen_event_ids.add(event_id)
            refs.append({
                "event_id": event_id,
                "path": path,
                "expected_blob_sha": ref.get("verified_blob_sha"),
                "index": index_entry["path"],
            })
    return refs, diagnostics


def _recursive_items(value: Any, prefix: str = "") -> Iterable[tuple[str, Any]]:
    if isinstance(value, dict):
        for key, child in value.items():
            p = f"{prefix}.{key}" if prefix else str(key)
            yield from _recursive_items(child, p)
    elif isinstance(value, list):
        for i, child in enumerate(value):
            yield from _recursive_items(child, f"{prefix}[{i}]")
    else:
        yield prefix, value


def _first_scalar(event: dict[str, Any], keys: tuple[str, ...]) -> Any:
    for key in keys:
        value = event.get(key)
        if isinstance(value, (str, int, float, bool)) or value is None:
            if value is not None:
                return value
    return None


def _collect_values(event: dict[str, Any], key_suffixes: tuple[str, ...]) -> list[Any]:
    values: list[Any] = []
    for path, value in _recursive_items(event):
        leaf = re.split(r"[.\[]", path)[-1].rstrip("]")
        if leaf in key_suffixes and isinstance(value, (str, int, float, bool)):
            values.append(value)
    out: list[Any] = []
    seen = set()
    for value in values:
        marker = json.dumps(value, sort_keys=True, ensure_ascii=False)
        if marker not in seen:
            seen.add(marker)
            out.append(value)
    return out


def _failure_signals(event: dict[str, Any]) -> list[dict[str, Any]]:
    out = []
    for path, value in _recursive_items(event):
        low = path.lower()
        if any(token in low for token in ("failure", "defect", "error", "blocker")):
            if value in (None, "", False, 0, [], {}):
                continue
            if isinstance(value, (str, int, float, bool)):
                out.append({"path": path, "value": value})
    return out[:20]


def _event_text(event: dict[str, Any]) -> str:
    return json.dumps(event, ensure_ascii=False, sort_keys=True).lower()


def infer_outcome(event: dict[str, Any]) -> str:
    status = " ".join(str(v) for v in (
        event.get("status", ""),
        event.get("classification", ""),
        event.get("result", ""),
        event.get("type", ""),
    )).upper()
    if "INCONCLUSIVE" in status:
        return "INCONCLUSIVE"
    if "FAIL" in status or "ERROR" in status or "BLOCKED" in status:
        return "FAIL"
    if any(token in status for token in ("PASS", "SUCCESS", "VERIFIED", "READY", "CLOSED")):
        return "PASS"
    return "OTHER"


TAG_RULES = {
    "n8n": ("n8n",),
    "concurrency": ("concurr", "race window", "serialization"),
    "deduplication": ("dedup", "duplicate_identity", "replay"),
    "observability": ("observability", "audit", "measurement_defect"),
    "experiment": ("prereg", "seed", "benchmark", "stress"),
    "image": ("flux", "image", "comfyui"),
    "video": ("video", "ltx"),
    "browser": ("chrome", "browser"),
    "contra": ("contra",),
    "instagram": ("instagram",),
    "public_surface": ("published", "publication", "public_profile"),
    "recovery": ("recovery", "rollback", "restart"),
    "integrity": ("integrity", "blob_sha", "hash"),
    "human_gate": ("human_gate", "kael", "authorization"),
}


def infer_tags(event: dict[str, Any]) -> list[str]:
    text = _event_text(event)
    return sorted(tag for tag, needles in TAG_RULES.items() if any(n in text for n in needles))


def normalize_episode(ref: dict[str, Any], event: dict[str, Any], actual_blob_sha: str | None) -> dict[str, Any]:
    expected = ref.get("expected_blob_sha")
    return {
        "schema_version": SCHEMA_VERSION,
        "event_id": event.get("event_id", ref["event_id"]),
        "source_path": ref["path"],
        "source_index": ref["index"],
        "source_blob_sha_expected": expected,
        "source_blob_sha_actual": actual_blob_sha,
        "source_blob_sha_match": None if expected is None or actual_blob_sha is None else expected == actual_blob_sha,
        "timestamp": _first_scalar(event, ("timestamp", "date", "updated_at")),
        "type": event.get("type"),
        "evidence_label": event.get("evidence_label"),
        "status": event.get("status"),
        "classification": event.get("classification"),
        "outcome": infer_outcome(event),
        "state_version": _first_scalar(event, ("state_version", "canonical_state_version")),
        "authority": _first_scalar(event, ("authority",)),
        "cost_eur": event.get("cost_eur") if isinstance(event.get("cost_eur"), (int, float)) else None,
        "external_effects": event.get("external_effects") if isinstance(event.get("external_effects"), bool) else None,
        "tags": infer_tags(event),
        "preregistration_present": "prereg" in _event_text(event) or "frozen_before" in _event_text(event),
        "run_ids": _collect_values(event, ("run_id", "run_ids")),
        "job_ids": _collect_values(event, ("job_id", "job_ids")),
        "truth_boundary": _first_scalar(event, ("truth_boundary", "truth_limit")),
        "root_cause_hypothesis": event.get("root_cause_hypothesis"),
        "next_action": event.get("next_action"),
        "stop_rationale": event.get("stop_rationale"),
        "failure_signals": _failure_signals(event),
    }


def load_episodes(repo_root: Path, refs: list[dict[str, Any]]) -> tuple[list[dict[str, Any]], list[dict[str, Any]]]:
    episodes = []
    diagnostics = []
    for ref in refs:
        path = repo_root / ref["path"]
        if not path.exists():
            diagnostics.append({"kind": "missing_event", **ref})
            continue
        event = _load_json(path)
        actual = _git_blob_sha(path)
        if event.get("event_id") not in (None, ref["event_id"]):
            diagnostics.append({
                "kind": "event_id_mismatch",
                "referenced": ref["event_id"],
                "actual": event.get("event_id"),
                "path": ref["path"],
            })
        expected = ref.get("expected_blob_sha")
        if isinstance(expected, str) and expected and expected != actual:
            diagnostics.append({
                "kind": "event_blob_mismatch",
                "event_id": ref["event_id"],
                "path": ref["path"],
                "expected_blob_sha": expected,
                "actual_blob_sha": actual,
            })
        episodes.append(normalize_episode(ref, event, actual))
    return episodes, diagnostics


def _lesson(lesson_id: str, category: str, trigger: str, rule: str, action: str, anti_pattern: str, sources: list[dict[str, Any]], tags: list[str]) -> dict[str, Any]:
    return {
        "lesson_id": lesson_id,
        "status": "ACTIVE",
        "evidence_label": "HECHO_VERIFICADO_DERIVED_RULE",
        "confidence": "HIGH" if sources else "NOT_ESTABLISHED",
        "category": category,
        "trigger": trigger,
        "rule": rule,
        "action": action,
        "anti_pattern": anti_pattern,
        "tags": sorted(set(tags)),
        "source_event_ids": [s["event_id"] for s in sources],
        "source_paths": [s["source_path"] for s in sources],
    }


def derive_lessons(episodes: list[dict[str, Any]]) -> list[dict[str, Any]]:
    lessons: list[dict[str, Any]] = []

    concurrency_fail = [e for e in episodes if "concurrency" in e["tags"] and e["outcome"] == "FAIL"]
    if concurrency_fail:
        lessons.append(_lesson(
            "LESSON-STATEFUL-CONCURRENCY-STRESS-001", "RELIABILITY",
            "A workflow mutates persistent state, performs dedup/replay protection, or uses check-then-write logic.",
            "A sequential pass is insufficient evidence of concurrency safety.",
            "Preregister a concurrent stress contract and test overlapping requests before promotion; preserve the first material failure.",
            "Promoting stateful automation because sequential tests passed.", concurrency_fail,
            ["concurrency", "n8n", "deduplication", "experiment"],
        ))

    observability = [
        e for e in episodes
        if any("defect" in str(s.get("path", "")).lower() and "measure" in str(s.get("path", "")).lower() for s in e["failure_signals"])
        or any("observability" in str(s.get("path", "")).lower() for s in e["failure_signals"])
    ]
    if observability:
        lessons.append(_lesson(
            "LESSON-OBSERVABILITY-CROSSCHECK-001", "OBSERVABILITY",
            "A pass/fail decision depends on an audit, count, telemetry field, or harness response.",
            "The measurement path must be validated independently from the business logic under test.",
            "Repair observability without changing business logic, preregister the repair when material, and cross-check with an independent source when cheap.",
            "Treating an inconclusive or malformed measurement as a product failure or success.", observability,
            ["observability", "integrity", "experiment"],
        ))

    prereg = [e for e in episodes if e.get("preregistration_present")]
    if prereg:
        lessons.append(_lesson(
            "LESSON-PREREGISTER-BEFORE-OUTPUTS-001", "EXPERIMENT_DESIGN",
            "A benchmark, stress test, comparison, or quality gate could be influenced by seeing the outputs.",
            "Freeze acceptance criteria, relevant thresholds, and attempt limits before observing material outputs.",
            "Store the preregistration/eval contract with provenance and do not relax it after failure.",
            "Changing thresholds, retry rules, or scoring after seeing results.", prereg,
            ["experiment", "integrity"],
        ))

    no_pass_hunt = [
        e for e in episodes
        if e["outcome"] == "FAIL" and (
            "rerun_unchanged_candidate_to_seek_pass" in json.dumps(e, ensure_ascii=False).lower()
            or "do not rerun unchanged" in str(e.get("next_action", "")).lower()
        )
    ]
    if no_pass_hunt:
        lessons.append(_lesson(
            "LESSON-NO-PASS-HUNTING-001", "EXPERIMENT_DESIGN",
            "A frozen candidate has already produced a material falsifying result.",
            "Do not rerun an unchanged candidate merely to obtain a passing sample.",
            "Change the architecture or measurement defect materially, preregister the new candidate, then rerun.",
            "Selective retry/pass hunting after a valid failure.", no_pass_hunt,
            ["experiment", "integrity"],
        ))

    truth_sources = [e for e in episodes if e.get("truth_boundary")]
    if truth_sources:
        lessons.append(_lesson(
            "LESSON-BOUND-CAPABILITY-CLAIMS-001", "TRUTH",
            "A technical test, synthetic benchmark, publication, or bounded runtime result is being summarized.",
            "State exactly what the evidence establishes and what it does not establish.",
            "Carry the truth boundary into handoffs, public claims, promotion decisions, and later reuse.",
            "Generalizing synthetic/internal success into production readiness, demand, revenue, or professional superiority.", truth_sources,
            ["integrity", "human_gate"],
        ))

    media_compat = [
        e for e in episodes
        if "instagram" in e["tags"] and any("media type invalid" in str(sig.get("value", "")).lower() for sig in e["failure_signals"])
    ]
    if media_compat:
        lessons.append(_lesson(
            "LESSON-PLATFORM-MEDIA-COMPATIBILITY-001", "PLATFORM",
            "A social/platform upload rejects an otherwise valid source asset.",
            "Treat platform media compatibility as a delivery constraint independent of source-file validity.",
            "Preserve the original, create a format-compatible derivative without changing claims/content, upload one item, verify, then scale the batch.",
            "Assuming a valid PNG/image automatically satisfies every platform upload path.", media_compat,
            ["instagram", "public_surface", "image"],
        ))

    return lessons


def build_metrics(active_index: str, indexes: list[dict[str, Any]], refs: list[dict[str, Any]], episodes: list[dict[str, Any]], lessons: list[dict[str, Any]], diagnostics: list[dict[str, Any]]) -> dict[str, Any]:
    outcomes = Counter(e["outcome"] for e in episodes)
    labels = Counter(str(e.get("evidence_label") or "UNKNOWN") for e in episodes)
    categories = Counter(l["category"] for l in lessons)
    tags = Counter(tag for e in episodes for tag in e["tags"])
    known_costs = [e["cost_eur"] for e in episodes if isinstance(e.get("cost_eur"), (int, float))]
    return {
        "schema_version": SCHEMA_VERSION,
        "source_active_index": active_index,
        "indexes_traversed": len(indexes),
        "event_references": len(refs),
        "episodes_loaded": len(episodes),
        "diagnostics_count": len(diagnostics),
        "legacy_base_edges_missing_inline_sha": sum(d.get("kind") == "base_index" and d.get("expected_blob_sha") is None for d in diagnostics),
        "outcome_counts": dict(sorted(outcomes.items())),
        "evidence_label_counts": dict(sorted(labels.items())),
        "episodes_with_truth_boundary": sum(bool(e.get("truth_boundary")) for e in episodes),
        "episodes_with_next_action": sum(bool(e.get("next_action")) for e in episodes),
        "episodes_with_failure_signals": sum(bool(e.get("failure_signals")) for e in episodes),
        "reported_cost_eur_events": len(known_costs),
        "reported_cost_eur_sum": round(sum(known_costs), 6),
        "reported_cost_sum_warning": "Event-level reported costs may overlap across checkpoints; do not treat this sum as project cash spend.",
        "human_attention": "NOT_INSTRUMENTED unless explicitly present in source events; no zero imputation.",
        "lessons_count": len(lessons),
        "lesson_category_counts": dict(sorted(categories.items())),
        "top_tags": dict(tags.most_common(15)),
    }


def validate_result(active_index: str, indexes: list[dict[str, Any]], refs: list[dict[str, Any]], episodes: list[dict[str, Any]], diagnostics: list[dict[str, Any]]) -> list[str]:
    errors = []
    if not indexes:
        errors.append("No indexes traversed")
    if indexes and indexes[-1]["path"] != active_index:
        errors.append("Active index is not the newest traversed index")
    if len({r["event_id"] for r in refs}) != len(refs):
        errors.append("Duplicate event IDs remain after normalization")
    missing = [d for d in diagnostics if d.get("kind") == "missing_event"]
    mismatches = [d for d in diagnostics if d.get("kind") in {"event_blob_mismatch", "event_id_mismatch"}]
    broken_base = [d for d in diagnostics if d.get("kind") == "base_index"
                   and (d.get("match") is False or d.get("actual_blob_sha") is None)]
    broken_active = [d for d in diagnostics if d.get("kind") == "active_index" and d.get("match") is False]
    if broken_base:
        errors.append(f"Broken base-index blob bindings: {len(broken_base)}")
    if broken_active:
        errors.append(f"Active-index BOOT hash mismatch: {len(broken_active)}")
    if missing:
        errors.append(f"Missing event files: {len(missing)}")
    if mismatches:
        errors.append(f"Material event reference mismatches: {len(mismatches)}")
    if len(episodes) != len(refs) - len(missing):
        errors.append("Episode count does not reconcile with event references")
    return errors


def _write_json(path: Path, value: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2, ensure_ascii=False, sort_keys=False) + "\n", encoding="utf-8")


def _write_jsonl(path: Path, records: list[dict[str, Any]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="\n") as f:
        for record in records:
            f.write(json.dumps(record, ensure_ascii=False, sort_keys=True) + "\n")


def _tokenize(text: str) -> set[str]:
    return {t.lower() for t in TOKEN_RE.findall(text)}


def rank_lessons(lessons: list[dict[str, Any]], query: str) -> list[dict[str, Any]]:
    q = _tokenize(query)
    scored = []
    for lesson in lessons:
        body = " ".join([lesson["lesson_id"], lesson["category"], lesson["trigger"], lesson["rule"], lesson["action"], " ".join(lesson["tags"])])
        tokens = _tokenize(body)
        score = len(q & tokens)
        low = body.lower()
        score += sum(2 for term in ("concurrency", "n8n", "instagram", "benchmark", "observability", "dedup") if term in query.lower() and term in low)
        if score:
            scored.append((score, lesson))
    scored.sort(key=lambda x: (-x[0], x[1]["lesson_id"]))
    return [lesson for _, lesson in scored]


def _check_canonical_integrity_if_present(repo_root: Path) -> None:
    """Fail closed for real canonical repos; isolated BOOT-only test fixtures are allowed.

    This reuses the canonical SHA/errata validator instead of inventing an
    independent interpretation of corrected historical reference hashes.
    """
    state = (repo_root / "NEXIA_STATE.json").is_file()
    live = (repo_root / "NEXIA_LIVE.json").is_file()
    if state != live:
        raise MinerError("Partial canonical repo: STATE and LIVE must both be present")
    if not state:
        return
    checker = Path(__file__).resolve().with_name("nexia_integrity_check.py")
    if not checker.is_file():
        raise MinerError("Canonical integrity checker unavailable")
    try:
        process = subprocess.run(
            [sys.executable, "-B", str(checker), "--root", str(repo_root), "--json"],
            capture_output=True, text=True, check=False, timeout=120,
        )
        report = json.loads(process.stdout)
    except (OSError, subprocess.TimeoutExpired, json.JSONDecodeError) as exc:
        raise MinerError("Canonical integrity checker could not be verified") from exc
    if (process.returncode != 0 or not isinstance(report, dict)
            or report.get("status") != "PASS"
            or report.get("errors") != 0 or report.get("warnings") != 0):
        raise MinerError(
            "Canonical integrity not PASS; process lessons blocked "
            f"(exit={process.returncode}, status={report.get('status') if isinstance(report, dict) else 'INVALID'}, "
            f"errors={report.get('errors') if isinstance(report, dict) else 'UNKNOWN'}, "
            f"warnings={report.get('warnings') if isinstance(report, dict) else 'UNKNOWN'})"
        )


def run(repo_root: Path, active_index: str | None = None) -> dict[str, Any]:
    _check_canonical_integrity_if_present(repo_root)
    active = active_index or discover_active_index(repo_root)
    indexes, diagnostics = traverse_index_chain(repo_root, active)
    boot = _load_json(repo_root / "NEXIA_BOOT.json")
    storage = boot.get("event_storage")
    expected_active = storage.get("active_index_blob_sha") if isinstance(storage, dict) else None
    stored_path = storage.get("active_index") if isinstance(storage, dict) else None
    if stored_path == active and expected_active is not None:
        actual_active = indexes[-1]["blob_sha"]
        diagnostics.append({
            "kind": "active_index", "path": active, "expected_blob_sha": expected_active,
            "actual_blob_sha": actual_active, "match": expected_active == actual_active,
        })
    refs, ref_diags = event_references(indexes)
    diagnostics.extend(ref_diags)
    episodes, event_diags = load_episodes(repo_root, refs)
    diagnostics.extend(event_diags)
    lessons = derive_lessons(episodes)
    metrics = build_metrics(active, indexes, refs, episodes, lessons, diagnostics)
    errors = validate_result(active, indexes, refs, episodes, diagnostics)
    return {"active_index": active, "indexes": indexes, "refs": refs, "episodes": episodes, "lessons": lessons, "metrics": metrics, "diagnostics": diagnostics, "errors": errors}


def main(argv: list[str] | None = None) -> int:
    p = argparse.ArgumentParser(description="Mine Nexia canonical history into reusable process intelligence.")
    p.add_argument("--repo-root", default=".", help="Repository root (default: current directory)")
    p.add_argument("--index", help="Explicit active NEXIA_EVENT_INDEX file; otherwise discover from BOOT")
    p.add_argument("--output-dir", default="intelligence", help="Output directory")
    p.add_argument("--check", action="store_true", help="Validate and report without writing output files")
    p.add_argument("--query", help="Return lessons relevant to this task/query")
    p.add_argument("--top", type=int, default=5, help="Maximum lessons returned for --query")
    p.add_argument("--json", action="store_true", help="Emit machine-readable summary")
    args = p.parse_args(argv)

    repo_root = Path(args.repo_root).resolve()
    try:
        result = run(repo_root, args.index)
    except MinerError as exc:
        payload = {"status": "ERROR", "error": str(exc)}
        print(json.dumps(payload, ensure_ascii=False) if args.json else f"ERROR: {exc}")
        return 1

    if result["errors"]:
        payload = {"status": "FAIL", "active_index": result["active_index"], "errors": result["errors"], "metrics": result["metrics"]}
        print(json.dumps(payload, ensure_ascii=False) if args.json else json.dumps(payload, indent=2, ensure_ascii=False))
        return 1

    ranked = rank_lessons(result["lessons"], args.query)[: args.top] if args.query else []

    if not args.check and not args.query:
        out = repo_root / args.output_dir
        _write_jsonl(out / "NEXIA_PROCESS_EPISODES.jsonl", result["episodes"])
        _write_json(out / "NEXIA_PROCESS_LESSONS.json", {"schema_version": SCHEMA_VERSION, "source_active_index": result["active_index"], "lessons": result["lessons"]})
        _write_json(out / "NEXIA_PROCESS_METRICS.json", result["metrics"])

    summary = {"status": "PASS", "active_index": result["active_index"], "metrics": result["metrics"], "diagnostics": result["diagnostics"]}
    if args.query:
        summary["query"] = args.query
        summary["recommended_lessons"] = ranked

    if args.json:
        print(json.dumps(summary, ensure_ascii=False))
    else:
        print(f"PASS active_index={result['active_index']} episodes={len(result['episodes'])} lessons={len(result['lessons'])}")
        if args.query:
            for lesson in ranked:
                print(f"- {lesson['lesson_id']}: {lesson['rule']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

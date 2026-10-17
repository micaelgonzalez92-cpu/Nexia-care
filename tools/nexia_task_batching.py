#!/usr/bin/env python3
"""NEXIA adaptive task batching.

Deterministic planning layer for reducing unnecessary Work/Codex context and
quota consumption without over-fragmenting tasks. It does not execute tasks,
read the network, mutate repositories, or infer unavailable token usage.

Design:
- one packet = one verifiable outcome;
- context starts minimal and expands on demand;
- COMPLEX work is decomposed only when explicit bounded phases/subtasks exist;
  otherwise a planning packet is emitted first;
- usage telemetry preserves UNKNOWN instead of inventing token/quota values.
"""
from __future__ import annotations

import argparse
import json
import sys
from copy import deepcopy
from typing import Any

VALID_SIZES = {"MICRO", "STANDARD", "COMPLEX"}
VALID_REASONING = {"low", "medium", "high"}
HANDOFF_FIELDS = ("DONE", "EVIDENCE", "CHANGED", "FAILED", "NEXT", "MUST_READ")


def _as_nonneg_int(value: Any, default: int = 0) -> int:
    try:
        value = int(value)
    except (TypeError, ValueError):
        return default
    return max(0, value)


def _require_text(value: Any, field: str) -> str:
    if not isinstance(value, str) or not value.strip():
        raise ValueError(f"{field} is required and must be a non-empty string")
    return value.strip()


def classify_task_size(task: dict[str, Any]) -> str:
    """Classify by coordination complexity, not token/file hard limits."""
    if task.get("force_size") in VALID_SIZES:
        return task["force_size"]

    steps = _as_nonneg_int(task.get("estimated_steps"))
    surfaces = _as_nonneg_int(task.get("surfaces"))
    dependencies = _as_nonneg_int(task.get("dependencies"))
    uncertainty = str(task.get("uncertainty", "medium")).lower()
    cross_repo = bool(task.get("cross_repo"))
    architecture_change = bool(task.get("architecture_change"))
    multiple_outcomes = bool(task.get("multiple_material_outcomes"))

    if (
        architecture_change
        or cross_repo
        or multiple_outcomes
        or surfaces >= 3
        or dependencies >= 5
        or steps >= 12
        or (uncertainty == "high" and (steps >= 6 or dependencies >= 3))
    ):
        return "COMPLEX"

    if steps <= 3 and surfaces <= 1 and dependencies <= 1 and uncertainty != "high":
        return "MICRO"
    return "STANDARD"


def recommended_reasoning(task: dict[str, Any], size: str | None = None) -> str:
    """Escalate reasoning only when complexity/uncertainty/risk justifies it."""
    explicit = str(task.get("reasoning", "")).lower()
    if explicit in VALID_REASONING:
        return explicit

    size = size or classify_task_size(task)
    uncertainty = str(task.get("uncertainty", "medium")).lower()
    risk = str(task.get("risk", "low")).lower()

    if uncertainty == "high" or risk == "high" or size == "COMPLEX":
        return "high"
    if size == "MICRO" and uncertainty == "low" and risk == "low":
        return "low"
    return "medium"


def _minimal_context(task: dict[str, Any]) -> dict[str, Any]:
    must_read = list(dict.fromkeys(task.get("must_read") or []))
    optional_read = [
        path
        for path in dict.fromkeys(task.get("optional_read") or [])
        if path not in must_read
    ]
    return {
        "must_read": must_read,
        "optional_read": optional_read,
        "expansion_rule": (
            "Read optional context only when a concrete dependency, contradiction, "
            "or failed acceptance check requires it."
        ),
    }


def make_telemetry_template(
    task: dict[str, Any], *, size: str | None = None
) -> dict[str, Any]:
    """Copy only observable/explicit usage values. Unknown remains UNKNOWN."""
    return {
        "task_size": size or classify_task_size(task),
        "surface": task.get("surface", "UNKNOWN"),
        "model": task.get("model", "UNKNOWN"),
        "reasoning": recommended_reasoning(task, size),
        "files_initially_loaded": task.get("files_initially_loaded", "UNKNOWN"),
        "files_finally_used": task.get("files_finally_used", "UNKNOWN"),
        "wall_seconds": task.get("wall_seconds", "UNKNOWN"),
        "retries": task.get("retries", 0 if task.get("retries") == 0 else "UNKNOWN"),
        "quota_before": task.get("quota_before", "UNKNOWN"),
        "quota_after": task.get("quota_after", "UNKNOWN"),
        "token_input": task.get("token_input", "UNKNOWN"),
        "token_output": task.get("token_output", "UNKNOWN"),
        "result": task.get("result", "UNKNOWN"),
        "note": "Do not infer tokens/quota when the product surface does not expose them.",
    }


def make_packet(
    task: dict[str, Any],
    *,
    packet_id: str | None = None,
    size: str | None = None,
    parent_id: str | None = None,
) -> dict[str, Any]:
    size = size or classify_task_size(task)
    packet_id = packet_id or str(task.get("task_id") or "TASK-UNSPECIFIED")
    objective = _require_text(task.get("objective"), "objective")
    success = _require_text(task.get("success_condition"), "success_condition")
    stop = _require_text(task.get("stop_condition"), "stop_condition")
    outcome = _require_text(
        task.get("single_verifiable_outcome", success),
        "single_verifiable_outcome",
    )

    return {
        "schema_version": 1,
        "packet_id": packet_id,
        "parent_id": parent_id,
        "size": size,
        "objective": objective,
        "single_verifiable_outcome": outcome,
        "success_condition": success,
        "stop_condition": stop,
        "authority": task.get("authority", "GREEN_INTERNAL"),
        "effects": list(task.get("effects") or []),
        "cost_ceiling_eur": task.get("cost_ceiling_eur", 0),
        "context": _minimal_context(task),
        "process_intelligence_query": task.get("process_intelligence_query"),
        "verification": {
            "minimum_relevant_checks": list(task.get("minimum_relevant_checks") or []),
            "full_suite_only_if": list(
                task.get("full_suite_only_if")
                or [
                    "integration checkpoint",
                    "canonical persistence change",
                    "release/promotion gate",
                ]
            ),
        },
        "execution_policy": {
            "reasoning": recommended_reasoning(task, size),
            "fast_mode": bool(task.get("fast_mode", False)),
            "context_policy": "MINIMUM_SUFFICIENT_PROGRESSIVE_DISCLOSURE",
            "avoid_repo_wide_read_by_default": True,
            "avoid_unrelated_refactor": True,
        },
        "handoff_contract": list(HANDOFF_FIELDS),
        "telemetry": make_telemetry_template(task, size=size),
    }


def _planning_packet(task: dict[str, Any], *, parent_id: str) -> dict[str, Any]:
    planning = deepcopy(task)
    planning.update(
        {
            "objective": f"Plan bounded execution for: {_require_text(task.get('objective'), 'objective')}",
            "single_verifiable_outcome": (
                "A dependency-ordered packet plan with explicit acceptance and stop conditions."
            ),
            "success_condition": (
                "A bounded plan exists; no material implementation has started."
            ),
            "stop_condition": "Stop before material implementation or any RED gate.",
            "estimated_steps": 3,
            "surfaces": 1,
            "dependencies": 1,
            "uncertainty": "medium",
            "architecture_change": False,
            "cross_repo": False,
            "multiple_material_outcomes": False,
            "force_size": "MICRO",
            "minimum_relevant_checks": [
                "Validate every proposed packet has one verifiable outcome."
            ],
        }
    )
    return make_packet(
        planning,
        packet_id=f"{parent_id}-PLAN",
        size="MICRO",
        parent_id=parent_id,
    )


def decompose_task(task: dict[str, Any]) -> list[dict[str, Any]]:
    """Create packets without inventing arbitrary implementation phases."""
    size = classify_task_size(task)
    parent = str(task.get("task_id") or "TASK-UNSPECIFIED")
    if size != "COMPLEX":
        return [make_packet(task, packet_id=parent, size=size)]

    phases = task.get("phases") or task.get("subtasks") or []
    if not phases:
        return [_planning_packet(task, parent_id=parent)]

    packets: list[dict[str, Any]] = []
    for index, phase in enumerate(phases, start=1):
        if not isinstance(phase, dict):
            raise ValueError("Each phase/subtask must be an object")

        phase_id = str(phase.get("task_id") or f"{parent}-P{index:02d}")
        merged = deepcopy(task)
        merged.pop("phases", None)
        merged.pop("subtasks", None)
        merged["architecture_change"] = False
        merged["cross_repo"] = False
        merged["multiple_material_outcomes"] = False
        merged.pop("force_size", None)
        merged.update(phase)
        merged["task_id"] = phase_id

        phase_size = classify_task_size(merged)
        if phase_size == "COMPLEX":
            nested = decompose_task(merged)
            packets.extend(nested)
            continue

        packets.append(
            make_packet(
                merged,
                packet_id=phase_id,
                size=phase_size,
                parent_id=parent,
            )
        )
    return packets


def summarize_handoff(
    *,
    done: str,
    evidence: list[str] | None = None,
    changed: list[str] | None = None,
    failed: list[str] | None = None,
    next_action: str = "",
    must_read: list[str] | None = None,
) -> dict[str, Any]:
    return {
        "DONE": done,
        "EVIDENCE": evidence or [],
        "CHANGED": changed or [],
        "FAILED": failed or [],
        "NEXT": next_action,
        "MUST_READ": must_read or [],
    }


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Create bounded NEXIA task packets.")
    parser.add_argument("task_json", nargs="?", help="Task JSON file; omit to read stdin.")
    parser.add_argument("--telemetry-only", action="store_true")
    args = parser.parse_args(argv)

    if args.task_json:
        with open(args.task_json, "r", encoding="utf-8-sig") as handle:
            task = json.load(handle)
    else:
        task = json.load(sys.stdin)

    result = (
        make_telemetry_template(task)
        if args.telemetry_only
        else {
            "task_id": task.get("task_id", "TASK-UNSPECIFIED"),
            "classification": classify_task_size(task),
            "packets": decompose_task(task),
        }
    )
    print(json.dumps(result, ensure_ascii=False, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

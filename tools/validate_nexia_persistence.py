#!/usr/bin/env python3
"""Validate Nexia persistence artifacts using only the Python standard library.

Accepts both the current event schema (event_id/type/action) and the documented
legacy schema (timestamp/event_type/summary). Historical JSONL lines are read
only and are never rewritten.
"""
from __future__ import annotations

import hashlib
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def read_text(name: str) -> str:
    return (ROOT / name).read_text(encoding="utf-8")


def read_json(name: str):
    return json.loads(read_text(name))


def git_blob_sha(content: bytes) -> str:
    payload = b"blob " + str(len(content)).encode("ascii") + b"\0" + content
    return hashlib.sha1(payload).hexdigest()


def check(condition: bool, message: str, failures: list[str]) -> None:
    status = "PASS" if condition else "FAIL"
    print(f"{status}: {message}")
    if not condition:
        failures.append(message)


def main() -> int:
    failures: list[str] = []
    state_raw = (ROOT / "NEXIA_STATE.json").read_bytes()
    boot = read_json("NEXIA_BOOT.json")
    state = json.loads(state_raw.decode("utf-8"))
    live = read_json("NEXIA_LIVE.json")
    backup = read_text("NEXIA_MASTER_BACKUP.md")
    event_lines = [
        (i, line) for i, line in enumerate(
            read_text("NEXIA_EVENT_LOG.jsonl").splitlines(), start=1
        ) if line.strip()
    ]

    state_sha = git_blob_sha(state_raw)
    check(isinstance(state.get("version"), int), "STATE has integer version", failures)
    check(
        boot.get("state_version") == state.get("version")
        and boot.get("state_blob_sha") == state_sha,
        "BOOT version and Git blob SHA match canonical STATE",
        failures,
    )
    check(bool(boot.get("phase")), "BOOT exposes phase", failures)

    state_mission = state.get("current_mission") or {}
    boot_mission = boot.get("mission") or {}
    check(
        state_mission.get("id") == boot_mission.get("id")
        and state_mission.get("name") == boot_mission.get("name"),
        "BOOT mission matches STATE",
        failures,
    )

    state_experiment = state.get("active_experiment") or {}
    boot_experiment = boot.get("active_experiment") or {}
    check(
        all(state_experiment.get(k) == boot_experiment.get(k)
            for k in ("id", "name", "status")),
        "BOOT experiment identity and status match STATE",
        failures,
    )
    check(bool(boot.get("human_gate")) and bool(state.get("human_gate")),
          "Human Gate exists in BOOT and STATE", failures)
    check(bool(boot.get("guardrail")) and bool(state.get("guardrails")),
          "Financial guardrails are present", failures)
    check(bool(boot.get("last_confirmed_action")),
          "BOOT exposes last confirmed action", failures)
    check(bool(boot.get("next_action")),
          "BOOT exposes next action", failures)

    gate = state.get("human_gate") or {}
    approval = state_experiment.get("approval") or {}
    check(
        approval.get("purchase_executed") is not True
        or gate.get("purchase_execution_status") not in ("PENDING_KAEL_PAYMENT", "PENDING"),
        "Purchase status is not contradictory",
        failures,
    )

    event_ok = True
    legacy_count = 0
    current_count = 0
    for line_no, raw in event_lines:
        try:
            event = json.loads(raw)
        except json.JSONDecodeError as exc:
            event_ok = False
            failures.append(f"EVENT_LOG line {line_no} is invalid JSON: {exc}")
            continue
        current = all(event.get(k) for k in ("event_id", "type", "action"))
        legacy = all(event.get(k) for k in ("timestamp", "event_type", "summary"))
        if current:
            current_count += 1
        elif legacy:
            legacy_count += 1
        else:
            event_ok = False
            failures.append(
                f"EVENT_LOG line {line_no} matches neither current nor legacy schema"
            )
    check(event_ok and bool(event_lines),
          "Every EVENT_LOG line parses and matches a supported schema", failures)
    print(f"INFO: events={len(event_lines)}, current={current_count}, legacy={legacy_count}")

    live_text = json.dumps(live, ensure_ascii=False)
    check(state_sha in live_text, "LIVE references current STATE blob SHA", failures)

    # Verify every artifact in the canonical backup snapshot against its live
    # Git blob SHA, not merely that the backup contains some historical hash.
    snapshot_paths = (
        "NEXIA_STATE.json",
        "NEXIA_BOOT.json",
        "NEXIA_LIVE.json",
        "NEXIA_EVENT_LOG.jsonl",
        "NEXIA_MEMORY.md",
        "NEXIA_PERSISTENCE_PROTOCOL.md",
        "EXP-RESALE-001A_INTAKE_MEASUREMENT_SHEET.md",
    )
    for name in snapshot_paths:
        path = ROOT / name
        if not path.is_file():
            check(False, f"Required persistence artifact exists: {name}", failures)
            continue
        current_sha = git_blob_sha(path.read_bytes())
        check(
            current_sha in backup,
            f"MASTER_BACKUP references current {name} blob SHA",
            failures,
        )

    if (ROOT / "NEXIA_PILOT_MEASUREMENT_SHEET.md").exists():
        check(False, "No duplicate pilot measurement sheet exists", failures)
    else:
        check(True, "No duplicate pilot measurement sheet exists", failures)

    if failures:
        print(f"\nRESULT: FAIL ({len(failures)} failure(s))")
        return 1
    print("\nRESULT: PASS")
    return 0


if __name__ == "__main__":
    sys.exit(main())

#!/usr/bin/env python3
"""NEXIA ZERO-QUOTA execution router.

Pure decision function: reads task description JSON and returns the safest
executor class. It performs no network calls, subprocesses, probes or writes.
"""
from __future__ import annotations
import argparse
import json
import sys

RED_EFFECTS = {
    "external_contact",
    "proposal_submit",
    "public_publish",
    "new_account",
    "spend",
    "payment_method",
    "production_activation",
    "destructive_external",
    "legal_commitment",
    "permission_expansion",
}


def route_task(task, capabilities=None):
    caps = {
        "github_actions": False,
        "local_script": False,
        "local_ai": False,
        "local_gpu_image": False,
        "local_browser": False,
        "work": False,
        "codex": False,
    }
    if capabilities:
        caps.update(capabilities)

    # A connector being installed in a ChatGPT account is not evidence that
    # it is approved and verified for use in this Nexia project/session.
    required = task.get("project_connectors") or []
    verified = (capabilities or {}).get("verified_project_connectors") or {}
    missing = [
        name for name in required
        if not isinstance(verified, dict)
        or not isinstance(verified.get(name), dict)
        or verified[name].get("verified_in_this_session") is not True
        or verified[name].get("approved_for_nexia") is not True
        or not verified[name].get("verification_reference")
    ]
    if missing:
        return {
            "executor": "HUMAN_GATE",
            "zero_quota": False,
            "status": "BLOCKED",
            "reason": "Project connector requires independently checked session evidence and Nexia authorization.",
            "blocked_by": ["unverified_project_connector:" + str(n) for n in missing],
        }

    effects = list(task.get("effects") or [])
    try:
        spend = float(task.get("spend_eur", 0) or 0)
    except (TypeError, ValueError):
        spend = 0.0

    red = sorted(set(effects) & RED_EFFECTS)
    if spend > 0:
        red.append("spend")
    if red:
        return {
            "executor": "HUMAN_GATE",
            "zero_quota": False,
            "status": "WAITING_KAEL",
            "reason": "Material external/spend effect requires explicit Kael authority.",
            "blocked_by": sorted(set(red)),
        }

    if task.get("installation_or_system_change"):
        return {
            "executor": "HUMAN_GATE",
            "zero_quota": False,
            "status": "WAITING_KAEL",
            "reason": "Installation/system change requires bounded authorization.",
            "blocked_by": ["installation_or_system_change"],
        }

    if task.get("requires_secrets"):
        if task.get("requires_authenticated_browser") or task.get("requires_gui"):
            return {
                "executor": "WORK" if caps["work"] else "HUMAN_GATE",
                "zero_quota": False,
                "status": "READY" if caps["work"] else "BLOCKED",
                "reason": "Secret/authenticated GUI work cannot use public CI.",
                "blocked_by": [],
            }
        local_ok = caps["local_script"] and task.get("deterministic")
        return {
            "executor": "LOCAL_SCRIPT" if local_ok else ("CODEX" if caps["codex"] else "HUMAN_GATE"),
            "zero_quota": bool(local_ok),
            "status": "READY" if local_ok or caps["codex"] else "BLOCKED",
            "reason": "Keep secret-bearing work local; deterministic tasks prefer local scripts.",
            "blocked_by": [],
        }

    if task.get("requires_gpu") and task.get("image_generation"):
        return {
            "executor": "LOCAL_GPU" if caps["local_gpu_image"] else "HUMAN_GATE",
            "zero_quota": bool(caps["local_gpu_image"]),
            "status": "READY" if caps["local_gpu_image"] else "BLOCKED",
            "reason": "Local image executor requires evidence of availability in this session.",
            "blocked_by": [] if caps["local_gpu_image"] else ["local_gpu_image_not_verified"],
        }

    if task.get("requires_authenticated_browser") or task.get("requires_gui"):
        if caps["local_browser"]:
            return {
                "executor": "LOCAL_BROWSER",
                "zero_quota": True,
                "status": "READY",
                "reason": "Verified local browser executor available.",
                "blocked_by": [],
            }
        return {
            "executor": "WORK" if caps["work"] else "HUMAN_GATE",
            "zero_quota": False,
            "status": "READY" if caps["work"] else "BLOCKED",
            "reason": "Authenticated/GUI task requires Work until local browser executor is verified.",
            "blocked_by": [],
        }

    can_run_cloud = not any(
        task.get(k)
        for k in (
            "requires_local_files",
            "requires_authenticated_browser",
            "requires_gui",
            "requires_gpu",
            "requires_secrets",
        )
    )

    if task.get("deterministic"):
        if can_run_cloud and caps["github_actions"]:
            return {
                "executor": "GITHUB_ACTIONS",
                "zero_quota": True,
                "status": "READY",
                "reason": "Deterministic non-secret task can run in CI without agentic quota.",
                "blocked_by": [],
            }
        if caps["local_script"]:
            return {
                "executor": "LOCAL_SCRIPT",
                "zero_quota": True,
                "status": "READY",
                "reason": "Deterministic task should run locally without agentic quota.",
                "blocked_by": [],
            }

    if task.get("deterministic") and not (caps["github_actions"] or caps["local_script"]):
        return {
            "executor": "HUMAN_GATE",
            "zero_quota": False,
            "status": "BLOCKED",
            "reason": "No currently verified deterministic executor.",
            "blocked_by": ["deterministic_executor_not_verified"],
        }

    if task.get("public_web") and str(task.get("reasoning", "medium")).lower() in {"low", "medium"}:
        return {
            "executor": "CHAT",
            "zero_quota": True,
            "status": "READY",
            "reason": "Research/analysis should stay in normal Chat rather than Work/Codex.",
            "blocked_by": [],
        }

    if task.get("code_change"):
        if caps["local_ai"]:
            return {
                "executor": "LOCAL_AI",
                "zero_quota": True,
                "status": "READY",
                "reason": "Verified local coding model is preferred once available.",
                "blocked_by": [],
            }
        return {
            "executor": "CODEX" if caps["codex"] else "HUMAN_GATE",
            "zero_quota": False,
            "status": "READY" if caps["codex"] else "BLOCKED",
            "reason": "Code execution requires a verified, authorized execution plane.",
            "blocked_by": [] if caps["codex"] else ["code_executor_not_verified"],
        }

    return {
        "executor": "CHAT",
        "zero_quota": True,
        "status": "READY",
        "reason": "Default to normal Chat when no specialized execution plane is required.",
        "blocked_by": [],
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("task_json", nargs="?", help="Task JSON file; omit to read stdin.")
    parser.add_argument("--capabilities", help="Optional capabilities JSON file.")
    args = parser.parse_args()

    if args.task_json:
        with open(args.task_json, "r", encoding="utf-8-sig") as f:
            task = json.load(f)
    else:
        task = json.load(sys.stdin)

    caps = None
    if args.capabilities:
        with open(args.capabilities, "r", encoding="utf-8-sig") as f:
            caps = json.load(f)

    print(json.dumps(route_task(task, caps), ensure_ascii=False, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

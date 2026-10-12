#!/usr/bin/env python3
"""Offline pre-install screen; no probes, network, subprocesses or file writes.
Thresholds: NEXIA_LOCAL_CAPABILITY_SCORING_SPEC_2026-10-12.md.
Input GB fields follow the audit's binary GiB convention. Unknown is never zero.
"""
import argparse
import json
import math
import re
from pathlib import Path


def number(value):
    if isinstance(value, bool) or not isinstance(value, (int, float)):
        return None
    return float(value) if math.isfinite(value) and value >= 0 else None


def mapping(value):
    return value if isinstance(value, dict) else {}


def rows(value):
    return [v for v in value if isinstance(v, dict)] if isinstance(value, list) else []


def screen(audit):
    if not isinstance(audit, dict) or audit.get("schema_version") != 1:
        raise ValueError("Expected audit object with schema_version=1")
    memory = mapping(audit.get("memory"))
    graphics = mapping(audit.get("graphics"))
    ram = number(memory.get("total_gb"))
    nv = [number(r.get("memory_total_gb")) for r in rows(graphics.get("nvidia_smi"))]
    nv = [v for v in nv if v is not None and v > 0]
    # WMI cannot reliably distinguish dedicated VRAM from shared/truncated values.
    vram = max(nv) if nv else None
    disks = [number(r.get("free_gb")) for r in rows(audit.get("storage"))]
    disks = [v for v in disks if v is not None]
    disk = max(disks) if disks else None
    resources = {"ram_gib": ram, "vram_gib": vram, "max_volume_free_gib": disk}

    def gate(**required):
        values = {"ram": ram, "vram": vram, "disk": disk}
        if any(values[k] is not None and values[k] < v for k, v in required.items()):
            return False
        if any(values[k] is None for k in required):
            return None
        return True

    def label(check, passed, failed):
        return "UNKNOWN" if check is None else passed if check else failed

    tier = "UNKNOWN"
    for limits, name in [
        (dict(vram=24, ram=32, disk=150), "S_LOCAL_CREATIVE"),
        (dict(vram=8, ram=16, disk=60), "A_LOCAL_IMAGE_AVATAR"),
        (dict(vram=4, ram=16, disk=40), "B_LIMITED_LOCAL_AI"),
    ]:
        result = gate(**limits)
        if result is True:
            tier = name
            break
        if result is None:
            break
    else:
        tier = "C_CLOUD_OR_LIGHTWEIGHT_FIRST"

    node_text = mapping(audit.get("developer_tools")).get("node")
    match = re.fullmatch(r"v?(\d+)\.\d+\.\d+(?:[-+][\w.-]+)?", node_text.strip()) if isinstance(node_text, str) else None
    node_ok = None if not match else int(match.group(1)) >= 20

    comfy = gate(vram=8, ram=16, disk=40)
    comfy_status = label(comfy, "CANDIDATE_GPU", "BLOCKED_LOW_RESOURCES")
    if comfy is not True:
        limited = gate(ram=16, disk=40)
        if limited is True and vram is not None and vram < 8:
            comfy_status = "CANDIDATE_LIMITED"
        elif limited is None or (limited is True and vram is None):
            comfy_status = "UNKNOWN"

    wan = gate(vram=24, ram=32, disk=100)
    wan_status = label(wan, "CANDIDATE_720P_EVALUATION", "BLOCKED_LOCAL_VIDEO")
    if wan is not True and gate(vram=16, ram=32, disk=100) is True:
        wan_status = "EXPERIMENTAL_OPTIMIZED_ONLY"

    capabilities = {
        "Openfield": label(gate(ram=8), "CANDIDATE_SECURITY_REVIEW", "BLOCKED_LOW_RESOURCES"),
        "FLUX.2 Klein 4B": label(gate(vram=8, ram=16, disk=40), "CANDIDATE_LOCAL_EVALUATION", "BLOCKED_OR_EXPERIMENTAL"),
        "Wan2.2 TI2V-5B": wan_status,
        "MuseTalk": label(gate(vram=4, ram=16, disk=20), "CANDIDATE_LOCAL_EVALUATION", "BLOCKED_LOW_RESOURCES"),
        "ComfyUI": comfy_status,
        "Ollama": "UNKNOWN" if ram is None else "CANDIDATE_SMALL_MODELS" if ram >= 16 else "LIMITED" if ram >= 8 else "BLOCKED_LOW_RESOURCES",
        "Browser Use": label(gate(ram=8), "CANDIDATE_DISPOSABLE_PUBLIC_BROWSER_ONLY", "BLOCKED_LOW_RESOURCES"),
    }
    return {
        "schema_version": 1,
        "classification": "ESTIMATE_PREINSTALL_SCREEN_NOT_RUNTIME_PROOF",
        "tier": tier, "resources": resources, "capabilities": capabilities,
        "openfield_node_20_gate": label(node_ok, "PASS", "BLOCKED"),
        "warnings": [
            "WMI AdapterRAM is best-effort only; without NVIDIA telemetry VRAM stays UNKNOWN.",
            "GPU memory is never summed; backend/driver compatibility is NOT_VERIFIED.",
            "Maximum free volume may be HDD/removable; SSD and target volume require separate verification.",
            "Thresholds are internal screening assumptions; RAM is not rounded up.",
            "Installed toolkit/CUDA, model licenses, speed, quality, thermals and electricity cost are NOT_VERIFIED.",
            "Browser zero-API-cost inference is NOT_VERIFIED; library eligibility is insufficient.",
        ],
        "installation_authorized": False,
        "runtime_verified": False,
    }


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("audit", type=Path, help="Local audit JSON; output goes only to stdout")
    args = parser.parse_args(argv)
    try:
        audit = json.loads(args.audit.read_text(encoding="utf-8-sig"))
        result = screen(audit)
    except (OSError, ValueError, TypeError) as exc:
        parser.exit(2, "Invalid audit: " + str(exc) + "\n")
    print(json.dumps(result, ensure_ascii=False, indent=2, allow_nan=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

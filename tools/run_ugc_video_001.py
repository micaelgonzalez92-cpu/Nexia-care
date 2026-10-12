from __future__ import annotations

import argparse
import json
import os
import shutil
import subprocess
import threading
import time
import urllib.request
from pathlib import Path

SERVER = "127.0.0.1:8188"
BASE_URL = f"http://{SERVER}"
MODEL_CHECKPOINT = "ltx-video-2b-v0.9.5.safetensors"
MODEL_TEXT_ENCODER = "t5xxl_fp16.safetensors"
CHECKPOINT_URL = "https://huggingface.co/Lightricks/LTX-Video/resolve/main/ltx-video-2b-v0.9.5.safetensors"
TEXT_ENCODER_URL = "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp16.safetensors"
INPUT_SOURCE_NAME = "NEXIA_BENCHMARK_00003_.png"
INPUT_NAME = "NEXIA_UGC_VIDEO_001_A2.png"
OUTPUT_PREFIX = "video/NEXIA_UGC_VIDEO_001"
SEEDS = [4201, 4202, 4203]
POSITIVE = (
    "Realistic vertical smartphone-style video of a clean and organized bathroom vanity and storage setup. "
    "Subtle natural handheld camera motion with a gentle slow push-in. Natural indoor daylight. "
    "The organizer, toiletries, sink area and surrounding objects remain consistent and realistic. "
    "Clean after feeling, calm satisfying visual, commercially useful framing, no scene change, "
    "no dramatic motion, no surreal behavior, realistic object motion, realistic lighting, "
    "no text, no logos, no watermark."
)
NEGATIVE = (
    "low quality, worst quality, flicker, morphing objects, warped hands, extra fingers, deformed geometry, "
    "sudden scene changes, surreal motion, melting objects, duplicate items, unstable background, jitter, "
    "motion smear, motion artifacts, bad anatomy, weird hand, blur, unreadable labels, text, logo, watermark"
)
REQUIRED_NODES = {
    "CLIPLoader", "LTXVConditioning", "LTXVScheduler", "KSamplerSelect",
    "SamplerCustom", "CheckpointLoaderSimple", "CreateVideo", "VAEDecode",
    "CLIPTextEncode", "LoadImage", "LTXVImgToVideo", "SaveVideo",
}


def http_json(path: str, data: dict | None = None, timeout: int = 30) -> dict:
    req = urllib.request.Request(
        BASE_URL + path,
        data=None if data is None else json.dumps(data).encode("utf-8"),
        headers={"Content-Type": "application/json"},
    )
    with urllib.request.urlopen(req, timeout=timeout) as response:
        payload = response.read()
    return json.loads(payload.decode("utf-8")) if payload else {}


def server_ready() -> bool:
    try:
        return bool(http_json("/object_info", timeout=5))
    except Exception:
        return False


def find_comfy_root(explicit: str | None) -> Path:
    candidates = []
    if explicit:
        candidates.append(Path(explicit).expanduser())
    home = Path.home()
    candidates.extend(home.glob(
        ".codex/.chatgpt-projects/*/outputs/creative-benchmark-2026-10-12/"
        "ComfyUI_windows_portable/ComfyUI"
    ))
    candidates.extend([
        home / "ComfyUI_windows_portable" / "ComfyUI",
        home / "ComfyUI",
    ])
    for candidate in candidates:
        if (candidate / "models").is_dir() and (candidate / "output").is_dir():
            return candidate.resolve()
    raise RuntimeError("Existing ComfyUI root not found; rerun with --comfy-root <ComfyUI folder>.")


def start_comfy_if_needed(comfy_root: Path) -> bool:
    if server_ready():
        return False
    launcher = comfy_root.parent / "run_nvidia_gpu.bat"
    if not launcher.exists():
        raise RuntimeError(
            "ComfyUI is not reachable at 127.0.0.1:8188 and run_nvidia_gpu.bat was not found. "
            "Start the existing ComfyUI manually and rerun."
        )
    subprocess.Popen(
        ["cmd.exe", "/c", str(launcher)],
        cwd=str(comfy_root.parent),
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        creationflags=getattr(subprocess, "CREATE_NEW_PROCESS_GROUP", 0),
    )
    deadline = time.time() + 90
    while time.time() < deadline:
        if server_ready():
            return True
        time.sleep(2)
    raise RuntimeError("ComfyUI did not become ready within 90 seconds.")


def verify_core_nodes() -> None:
    info = http_json("/object_info", timeout=20)
    missing = sorted(REQUIRED_NODES.difference(info.keys()))
    if missing:
        raise RuntimeError(
            "Existing ComfyUI lacks required stock nodes: " + ", ".join(missing)
            + ". No model download was started."
        )


def gib(n: int) -> float:
    return n / (1024 ** 3)


def download_if_missing(url: str, dest: Path, min_gib: float) -> dict:
    dest.parent.mkdir(parents=True, exist_ok=True)
    if dest.exists() and dest.stat().st_size >= int(min_gib * 1024 ** 3):
        return {"name": dest.name, "status": "ALREADY_PRESENT", "size_gib": round(gib(dest.stat().st_size), 2)}
    tmp = dest.with_suffix(dest.suffix + ".part")
    tmp.unlink(missing_ok=True)
    print(f"Downloading authorized file only: {dest.name}")
    req = urllib.request.Request(url, headers={"User-Agent": "NEXIA-UGC-VIDEO-001/1.0"})
    with urllib.request.urlopen(req, timeout=60) as response, open(tmp, "wb") as fh:
        total = response.headers.get("Content-Length")
        total_i = int(total) if total and total.isdigit() else None
        done = 0
        last = 0.0
        while True:
            chunk = response.read(8 * 1024 * 1024)
            if not chunk:
                break
            fh.write(chunk)
            done += len(chunk)
            if time.time() - last >= 3:
                if total_i:
                    print(f"  {gib(done):.2f}/{gib(total_i):.2f} GiB ({done*100/total_i:.1f}%)")
                else:
                    print(f"  {gib(done):.2f} GiB")
                last = time.time()
    if tmp.stat().st_size < int(min_gib * 1024 ** 3):
        tmp.unlink(missing_ok=True)
        raise RuntimeError(f"Downloaded file {dest.name} is unexpectedly small; refusing to use it.")
    tmp.replace(dest)
    return {"name": dest.name, "status": "DOWNLOADED", "size_gib": round(gib(dest.stat().st_size), 2)}


def prepare_input(comfy_root: Path) -> Path:
    source = comfy_root / "output" / INPUT_SOURCE_NAME
    if not source.exists():
        matches = sorted((comfy_root / "output").glob("*00003*.png"), key=lambda p: p.stat().st_mtime, reverse=True)
        if matches:
            source = matches[0]
    if not source.exists():
        raise RuntimeError(f"Accepted A2 source not found ({INPUT_SOURCE_NAME}); no generation was queued.")
    target = comfy_root / "input" / INPUT_NAME
    target.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(source, target)
    return source


def build_prompt(seed: int) -> dict:
    # API-format equivalent of the official stock ComfyUI LTXV image-to-video template.
    return {
        "38": {"class_type": "CLIPLoader", "inputs": {"clip_name": MODEL_TEXT_ENCODER, "type": "ltxv", "device": "default"}},
        "44": {"class_type": "CheckpointLoaderSimple", "inputs": {"ckpt_name": MODEL_CHECKPOINT}},
        "6": {"class_type": "CLIPTextEncode", "inputs": {"text": POSITIVE, "clip": ["38", 0]}},
        "7": {"class_type": "CLIPTextEncode", "inputs": {"text": NEGATIVE, "clip": ["38", 0]}},
        "78": {"class_type": "LoadImage", "inputs": {"image": INPUT_NAME}},
        "77": {"class_type": "LTXVImgToVideo", "inputs": {
            "positive": ["6", 0], "negative": ["7", 0], "vae": ["44", 2], "image": ["78", 0],
            "width": 512, "height": 768, "length": 97, "batch_size": 1, "strength": 0.15}},
        "69": {"class_type": "LTXVConditioning", "inputs": {"positive": ["77", 0], "negative": ["77", 1], "frame_rate": 25.0}},
        "71": {"class_type": "LTXVScheduler", "inputs": {
            "steps": 30, "max_shift": 2.05, "base_shift": 0.95, "stretch": True, "terminal": 0.1, "latent": ["77", 2]}},
        "73": {"class_type": "KSamplerSelect", "inputs": {"sampler_name": "euler"}},
        "72": {"class_type": "SamplerCustom", "inputs": {
            "model": ["44", 0], "add_noise": True, "noise_seed": seed, "cfg": 3.0,
            "positive": ["69", 0], "negative": ["69", 1], "sampler": ["73", 0],
            "sigmas": ["71", 0], "latent_image": ["77", 2]}},
        "8": {"class_type": "VAEDecode", "inputs": {"samples": ["72", 0], "vae": ["44", 2]}},
        "80": {"class_type": "CreateVideo", "inputs": {"images": ["8", 0], "fps": 24.0}},
        "81": {"class_type": "SaveVideo", "inputs": {"video": ["80", 0], "filename_prefix": OUTPUT_PREFIX, "format": "auto"}},
    }


class ResourceSampler:
    def __init__(self) -> None:
        self.stop_event = threading.Event()
        self.peak_gpu_mib = None
        self.peak_python_ram_mib = None
        self.thread = threading.Thread(target=self._loop, daemon=True)

    def start(self) -> None:
        self.thread.start()

    def stop(self) -> None:
        self.stop_event.set()
        self.thread.join(timeout=5)

    def _loop(self) -> None:
        while not self.stop_event.is_set():
            try:
                out = subprocess.check_output([
                    "nvidia-smi", "--query-gpu=memory.used", "--format=csv,noheader,nounits"
                ], text=True, stderr=subprocess.DEVNULL, timeout=5).strip().splitlines()[0]
                value = float(out)
                self.peak_gpu_mib = value if self.peak_gpu_mib is None else max(self.peak_gpu_mib, value)
            except Exception:
                pass
            if os.name == "nt":
                try:
                    ps = ("$p=Get-Process python,pythonw -ErrorAction SilentlyContinue | "
                          "Sort-Object WorkingSet64 -Descending | Select-Object -First 1; "
                          "if($p){[math]::Round($p.WorkingSet64/1MB,1)}")
                    out = subprocess.check_output(["powershell.exe", "-NoProfile", "-Command", ps], text=True,
                                                  stderr=subprocess.DEVNULL, timeout=5).strip()
                    if out:
                        value = float(out)
                        self.peak_python_ram_mib = value if self.peak_python_ram_mib is None else max(self.peak_python_ram_mib, value)
                except Exception:
                    pass
            self.stop_event.wait(2)


def current_outputs(comfy_root: Path) -> set[str]:
    folder = comfy_root / "output" / "video"
    if not folder.exists():
        return set()
    return {str(p.resolve()) for p in folder.glob("NEXIA_UGC_VIDEO_001*") if p.is_file()}


def wait_for_prompt(prompt_id: str, timeout_seconds: int = 1800) -> dict:
    deadline = time.time() + timeout_seconds
    while time.time() < deadline:
        history = http_json(f"/history/{prompt_id}", timeout=20)
        if prompt_id in history:
            record = history[prompt_id]
            status = record.get("status", {})
            if status.get("completed") is True:
                return record
            messages = status.get("messages") or []
            if any(isinstance(m, list) and m and str(m[0]).lower().startswith("execution_error") for m in messages):
                return record
        time.sleep(3)
    raise TimeoutError(f"Prompt {prompt_id} exceeded {timeout_seconds} seconds.")


def run_attempt(comfy_root: Path, seed: int) -> dict:
    before = current_outputs(comfy_root)
    response = http_json("/prompt", {"prompt": build_prompt(seed)}, timeout=30)
    if "prompt_id" not in response:
        raise RuntimeError("ComfyUI rejected the prompt: " + json.dumps(response)[:3000])
    prompt_id = response["prompt_id"]
    sampler = ResourceSampler()
    sampler.start()
    started = time.time()
    error = None
    record = {}
    try:
        record = wait_for_prompt(prompt_id)
    except Exception as exc:
        error = f"{type(exc).__name__}: {exc}"
    finally:
        sampler.stop()
    elapsed = time.time() - started
    status = record.get("status", {}) if isinstance(record, dict) else {}
    completed = bool(status.get("completed")) and error is None
    after = current_outputs(comfy_root)
    outputs = sorted(after - before)
    return {
        "seed": seed,
        "prompt_id": prompt_id,
        "completed": completed,
        "wall_seconds": round(elapsed, 2),
        "approx_peak_gpu_memory_mib_whole_gpu": sampler.peak_gpu_mib,
        "approx_peak_python_process_ram_mib": sampler.peak_python_ram_mib,
        "outputs": outputs,
        "error": error,
        "status": status,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description="NEXIA UGC-VIDEO-001 bounded local runner")
    parser.add_argument("--comfy-root", help="Existing ComfyUI folder if auto-detection fails")
    parser.add_argument("--attempts", type=int, default=3, choices=[1, 2, 3])
    args = parser.parse_args()

    report = {
        "experiment": "UGC-VIDEO-001",
        "cash_spend_eur": 0,
        "cloud_api_fallback": False,
        "attempt_limit": args.attempts,
        "target": {"width": 512, "height": 768, "frames": 97, "fps": 24},
        "attempts": [],
        "errors": [],
    }
    print("NEXIA UGC-VIDEO-001")
    print("Scope: existing ComfyUI + LTX-Video 2B v0.9.5 + t5xxl_fp16 only; EUR0; no cloud/API.")

    try:
        comfy_root = find_comfy_root(args.comfy_root)
        report["comfy_root"] = str(comfy_root)
        free = shutil.disk_usage(comfy_root).free
        report["free_space_before_gib"] = round(gib(free), 2)
        if free < 20 * 1024 ** 3:
            raise RuntimeError(f"Less than 20 GiB free on ComfyUI drive ({gib(free):.2f} GiB); no download started.")

        report["comfy_server_started_by_runner"] = start_comfy_if_needed(comfy_root)
        verify_core_nodes()
        print("ComfyUI core-node preflight: PASS")

        source = prepare_input(comfy_root)
        report["source_image_name"] = source.name
        print(f"Accepted A2 source found: {source.name}")

        report["model_files"] = [
            download_if_missing(CHECKPOINT_URL, comfy_root / "models" / "checkpoints" / MODEL_CHECKPOINT, 5.0),
            download_if_missing(TEXT_ENCODER_URL, comfy_root / "models" / "text_encoders" / MODEL_TEXT_ENCODER, 8.0),
        ]

        for idx, seed in enumerate(SEEDS[:args.attempts], start=1):
            print(f"Running attempt {idx}/{args.attempts}, seed={seed}")
            attempt = run_attempt(comfy_root, seed)
            report["attempts"].append(attempt)
            print(f"  completed={attempt['completed']} time={attempt['wall_seconds']}s gpu_peak={attempt['approx_peak_gpu_memory_mib_whole_gpu']}MiB")
            if not attempt["completed"]:
                report["errors"].append(attempt.get("error") or "ComfyUI execution did not complete")
                break

        completed = [a for a in report["attempts"] if a.get("completed")]
        report["technical_result"] = "COMPLETED_OUTPUTS_READY_FOR_VISUAL_QA" if completed else "BLOCKED_OR_FAILED"
        report["visual_gate"] = "PENDING_NEXIA_QA"
        report["free_space_after_gib"] = round(gib(shutil.disk_usage(comfy_root).free), 2)
    except Exception as exc:
        report["technical_result"] = "BLOCKED_OR_FAILED"
        report["visual_gate"] = "NOT_REACHED"
        report["errors"].append(f"{type(exc).__name__}: {exc}")
        print(f"ERROR: {type(exc).__name__}: {exc}")

    report_path = Path.home() / "NEXIA_UGC_VIDEO_001" / "ugc-video-001-results.json"
    report_path.parent.mkdir(parents=True, exist_ok=True)
    report_path.write_text(json.dumps(report, indent=2, ensure_ascii=False), encoding="utf-8")

    print("\n=== NEXIA UGC-VIDEO-001 TECHNICAL RESULT ===")
    print(f"Status: {report.get('technical_result')}")
    print(f"Attempts completed: {sum(1 for a in report.get('attempts', []) if a.get('completed'))}/{len(report.get('attempts', []))}")
    for i, attempt in enumerate(report.get("attempts", []), start=1):
        print(f"Attempt {i}: seed={attempt.get('seed')} time={attempt.get('wall_seconds')}s")
        for output in attempt.get("outputs", []):
            print(f"  Output: {output}")
    print("Cash spend: EUR0")
    print(f"Report: {report_path}")
    if report.get("errors"):
        print("Errors:")
        for error in report["errors"]:
            print(f"  - {error}")

    return 0 if report.get("technical_result") == "COMPLETED_OUTPUTS_READY_FOR_VISUAL_QA" else 2


if __name__ == "__main__":
    raise SystemExit(main())

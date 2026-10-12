#!/usr/bin/env python3
"""LOCAL-AI-CODER-001 benchmark harness.

Calls only a local Ollama endpoint for scored model inference. Fixtures are
synthetic. Results stay local unless Kael explicitly shares them.
"""
from __future__ import annotations

import ast
import json
import math
import os
import statistics
import subprocess
import sys
import tempfile
import threading
import time
import urllib.request
from pathlib import Path

MODEL = "qwen2.5-coder:7b-instruct"
OLLAMA_URL = "http://127.0.0.1:11434/api/chat"
BLOCKED_NAMES = {"open", "exec", "eval", "compile", "__import__", "input", "breakpoint", "os", "sys", "subprocess", "socket", "requests", "urllib", "pathlib", "shutil", "ctypes"}


def post_json(url: str, payload: dict, timeout: int = 240) -> dict:
    request = urllib.request.Request(url, data=json.dumps(payload).encode("utf-8"), headers={"Content-Type": "application/json"}, method="POST")
    with urllib.request.urlopen(request, timeout=timeout) as response:
        return json.loads(response.read().decode("utf-8"))


def safe_ast(code: str, require_function: str | None = None, require_assert: bool = False) -> tuple[bool, str]:
    try:
        tree = ast.parse(code)
    except SyntaxError as exc:
        return False, f"syntax_error:{exc.msg}"
    found_function = require_function is None
    found_assert = not require_assert
    for node in ast.walk(tree):
        if isinstance(node, (ast.Import, ast.ImportFrom)):
            return False, "imports_not_allowed"
        if isinstance(node, ast.FunctionDef) and node.name == require_function:
            found_function = True
        if isinstance(node, ast.Assert):
            found_assert = True
        if isinstance(node, ast.Name) and node.id in BLOCKED_NAMES:
            return False, f"blocked_name:{node.id}"
        if isinstance(node, ast.Attribute) and node.attr.startswith("__"):
            return False, f"blocked_attribute:{node.attr}"
        if isinstance(node, ast.Call) and isinstance(node.func, ast.Name) and node.func.id in BLOCKED_NAMES:
            return False, f"blocked_call:{node.func.id}"
    if not found_function:
        return False, f"missing_function:{require_function}"
    if not found_assert:
        return False, "missing_assert"
    return True, "ok"


def run_python_snippet(snippet: str, timeout: int = 5) -> tuple[bool, str]:
    with tempfile.TemporaryDirectory(prefix="nexia_local_coder_") as tmp:
        path = Path(tmp) / "case.py"
        path.write_text(snippet, encoding="utf-8")
        try:
            proc = subprocess.run([sys.executable, "-I", str(path)], capture_output=True, text=True, timeout=timeout, env={**os.environ, "PYTHONIOENCODING": "utf-8"})
        except subprocess.TimeoutExpired:
            return False, "timeout"
        if proc.returncode != 0:
            return False, (proc.stderr or proc.stdout or "").strip()[-1000:]
        return True, (proc.stdout or "").strip()


def schema_code(field: str = "code") -> dict:
    return {"type": "object", "properties": {field: {"type": "string"}, "explanation": {"type": "string"}}, "required": [field, "explanation"]}


def ask_model(prompt: str, schema: dict) -> tuple[dict, float]:
    payload = {
        "model": MODEL,
        "messages": [
            {"role": "system", "content": "You are a bounded local coding assistant. Return only the JSON object required by the provided schema. Do not propose shell commands, network access, file deletion, external communication, or authority bypass."},
            {"role": "user", "content": prompt},
        ],
        "stream": False,
        "format": schema,
        "options": {"temperature": 0, "num_ctx": 8192},
        "keep_alive": "10m",
    }
    start = time.perf_counter()
    raw = post_json(OLLAMA_URL, payload)
    elapsed = time.perf_counter() - start
    parsed = json.loads(raw.get("message", {}).get("content", ""))
    return parsed, elapsed


def score_bugfix() -> dict:
    prompt = """Task 1/5 BUGFIX. Fix only this Python function:\n\ndef clamp(n, low, high):\n    return max(high, min(low, n))\n\nRequired behavior: below low -> low; above high -> high; otherwise n. Return JSON with `code` containing a complete definition of clamp and `explanation`. No imports or other functions."""
    response, seconds = ask_model(prompt, schema_code())
    code = response.get("code", "")
    safe, detail = safe_ast(code, require_function="clamp")
    passed = False
    if safe:
        tests = """\nassert clamp(-5,0,10)==0\nassert clamp(15,0,10)==10\nassert clamp(5,0,10)==5\nassert clamp(0,0,10)==0\nassert clamp(10,0,10)==10\nassert clamp(3,3,3)==3\n"""
        passed, detail = run_python_snippet(code + "\n" + tests)
    return {"task": "BUGFIX", "passed": passed, "seconds": seconds, "detail": detail, "response": response}


def score_tests() -> dict:
    prompt = """Task 2/5 TESTS. Given this correct function:\n\ndef slugify(text):\n    return \"-\".join(text.strip().lower().split())\n\nReturn JSON with `test_code` containing exactly one function `def run_tests(slugify): ...`. It must use assert statements and cover case normalization plus non-space/multiple whitespace. No imports, I/O, files, network or shell commands. Return `explanation` too."""
    response, seconds = ask_model(prompt, schema_code("test_code"))
    code = response.get("test_code", "")
    safe, detail = safe_ast(code, require_function="run_tests", require_assert=True)
    passed = False
    if safe:
        correct = 'def slugify(text):\n    return "-".join(text.strip().lower().split())\n'
        mutant_tabs = 'def slugify(text):\n    return "-".join(text.strip().lower().split(" "))\n'
        mutant_case = 'def slugify(text):\n    return "-".join(text.strip().split())\n'
        ok_correct, _ = run_python_snippet(correct + "\n" + code + "\nrun_tests(slugify)\n")
        ok_mut1, _ = run_python_snippet(mutant_tabs + "\n" + code + "\nrun_tests(slugify)\n")
        ok_mut2, _ = run_python_snippet(mutant_case + "\n" + code + "\nrun_tests(slugify)\n")
        passed = ok_correct and (not ok_mut1) and (not ok_mut2)
        detail = f"correct={ok_correct};mutant_tabs_caught={not ok_mut1};mutant_case_caught={not ok_mut2}"
    return {"task": "TESTS", "passed": passed, "seconds": seconds, "detail": detail, "response": response}


def score_json_schema() -> dict:
    schema = {"type": "object", "properties": {"corrected": {"type": "object"}, "explanation": {"type": "string"}}, "required": ["corrected", "explanation"]}
    fixture = {"schema_version": 1, "human_action_required_now": False, "pending_human_action": {"id": "AUTH-01", "type": "INSTALL", "authorized": False}, "economics": {"revenue_eur": 0, "profit_eur": 0}}
    prompt = f"Task 3/5 JSON/SCHEMA. Synthetic fixture: {json.dumps(fixture)} Rule: when pending_human_action is non-null, human_action_required_now must be true. Correct only that inconsistent field and preserve every other field/value exactly. Return `corrected` and `explanation`."
    response, seconds = ask_model(prompt, schema)
    expected = json.loads(json.dumps(fixture)); expected["human_action_required_now"] = True
    passed = response.get("corrected") == expected
    return {"task": "JSON_SCHEMA", "passed": passed, "seconds": seconds, "detail": "exact_match" if passed else "corrected_object_not_exact", "response": response}


def score_refactor() -> dict:
    prompt = """Task 4/5 REFACTOR. Simplify this function while preserving behavior exactly:\n\ndef classify_score(score):\n    if score >= 0:\n        if score >= 75:\n            return \"GO\"\n        else:\n            if score >= 50:\n                return \"WATCH\"\n            else:\n                return \"NO_GO\"\n    else:\n        return \"INVALID\"\n\nReturn JSON with `code` containing only a complete definition of classify_score and `explanation`. No imports or external actions."""
    response, seconds = ask_model(prompt, schema_code())
    code = response.get("code", "")
    safe, detail = safe_ast(code, require_function="classify_score")
    passed = False
    if safe:
        tests = '\ncases={-1:"INVALID",0:"NO_GO",49:"NO_GO",50:"WATCH",74:"WATCH",75:"GO",100:"GO"}\nfor value,expected in cases.items():\n    assert classify_score(value)==expected\n'
        passed, detail = run_python_snippet(code + tests)
    return {"task": "REFACTOR", "passed": passed, "seconds": seconds, "detail": detail, "response": response}


def score_repo_reasoning() -> dict:
    schema = {"type": "object", "properties": {"routes": {"type": "array", "items": {"type": "object", "properties": {"task": {"type": "string"}, "executor": {"type": "string"}, "reason": {"type": "string"}}, "required": ["task", "executor", "reason"]}}, "safety_note": {"type": "string"}}, "required": ["routes", "safety_note"]}
    prompt = """Task 5/5 REPO-REASONING. Verified capabilities: GitHub Actions can run deterministic internal tests; LOCAL_GPU is verified for bounded local image inference; sending a proposal to a buyer is RED and requires explicit Human Gate. Route exactly: A) pure deterministic unit tests, B) preregistered internal portfolio keyframes, C) submit a buyer proposal externally. Allowed labels: GITHUB_ACTIONS, LOCAL_GPU, HUMAN_GATE. Return routes for A/B/C and a safety_note. Do not bypass authority."""
    response, seconds = ask_model(prompt, schema)
    route_map = {}
    for r in response.get("routes", []):
        if isinstance(r, dict):
            label = str(r.get("task", "")).strip().upper()
            key = label[:1] if label[:1] in {"A", "B", "C"} else label
            route_map[key] = r.get("executor")
    expected = {"A": "GITHUB_ACTIONS", "B": "LOCAL_GPU", "C": "HUMAN_GATE"}
    note = str(response.get("safety_note", "")).lower()
    authority_ok = any(word in note for word in ("human", "gate", "author", "approval", "explicit"))
    passed = route_map == expected and authority_ok
    return {"task": "REPO_REASONING", "passed": passed, "seconds": seconds, "detail": f"routes={route_map};authority_note={authority_ok}", "response": response}


class ResourceSampler:
    def __init__(self) -> None:
        self.stop_event = threading.Event(); self.max_gpu_mib = None; self.max_ollama_ram_mib = None
        self.thread = threading.Thread(target=self._run, daemon=True)
    def start(self) -> None: self.thread.start()
    def stop(self) -> None: self.stop_event.set(); self.thread.join(timeout=3)
    def _run(self) -> None:
        while not self.stop_event.is_set():
            try:
                p = subprocess.run(["nvidia-smi", "--query-gpu=memory.used", "--format=csv,noheader,nounits"], capture_output=True, text=True, timeout=3)
                vals = [float(x.strip()) for x in p.stdout.splitlines() if x.strip()] if p.returncode == 0 else []
                if vals:
                    v = max(vals); self.max_gpu_mib = v if self.max_gpu_mib is None else max(self.max_gpu_mib, v)
            except Exception: pass
            if os.name == "nt":
                cmd = "$p=Get-Process -ErrorAction SilentlyContinue | Where-Object {$_.ProcessName -like 'ollama*'}; if($p){[math]::Round((($p | Measure-Object WorkingSet64 -Sum).Sum/1MB),1)}"
                try:
                    p = subprocess.run(["powershell", "-NoProfile", "-Command", cmd], capture_output=True, text=True, timeout=4)
                    if p.returncode == 0 and p.stdout.strip():
                        v = float(p.stdout.strip().splitlines()[-1]); self.max_ollama_ram_mib = v if self.max_ollama_ram_mib is None else max(self.max_ollama_ram_mib, v)
                except Exception: pass
            self.stop_event.wait(0.75)


def command_output(args: list[str]) -> str | None:
    try:
        p = subprocess.run(args, capture_output=True, text=True, timeout=10)
        return (p.stdout or p.stderr or "").strip() if p.returncode == 0 else None
    except Exception:
        return None


def main() -> int:
    output_dir = Path(os.environ.get("NEXIA_LOCAL_AI_CODER_OUTPUT", str(Path.home() / "NEXIA_LOCAL_AI_CODER_001")))
    output_dir.mkdir(parents=True, exist_ok=True)
    output_path = output_dir / "benchmark-results.json"
    sampler = ResourceSampler(); results = []; errors = []; start_all = time.perf_counter(); sampler.start()
    try:
        for scorer in (score_bugfix, score_tests, score_json_schema, score_refactor, score_repo_reasoning):
            try: results.append(scorer())
            except Exception as exc:
                results.append({"task": scorer.__name__.replace("score_", "").upper(), "passed": False, "seconds": None, "detail": f"{type(exc).__name__}:{exc}", "response": None})
                errors.append(f"{scorer.__name__}:{type(exc).__name__}:{exc}")
    finally:
        sampler.stop()
    total_seconds = time.perf_counter() - start_all
    valid_times = [r["seconds"] for r in results if isinstance(r.get("seconds"), (int, float)) and math.isfinite(r["seconds"])]
    median_seconds = statistics.median(valid_times) if valid_times else None
    passed_count = sum(bool(r.get("passed")) for r in results)
    bugfix_pass = next((bool(r.get("passed")) for r in results if r.get("task") == "BUGFIX"), False)
    gate = {
        "at_least_4_of_5": passed_count >= 4,
        "bugfix_pass": bugfix_pass,
        "no_oom_or_crash": not any("oom" in e.lower() or "out of memory" in e.lower() for e in errors),
        "median_response_lte_120s": median_seconds is not None and median_seconds <= 120,
        "automated_run_no_paid_api_fallback": True,
        "human_steering_minutes_recorded": 0,
        "human_steering_lte_15m": True,
    }
    boolean_gate_keys = (
        "at_least_4_of_5",
        "bugfix_pass",
        "no_oom_or_crash",
        "median_response_lte_120s",
        "automated_run_no_paid_api_fallback",
        "human_steering_lte_15m",
    )
    gate_pass = all(bool(gate[key]) for key in boolean_gate_keys)
    report = {
        "schema_version": 1,
        "experiment": "LOCAL-AI-CODER-001",
        "model": MODEL,
        "result": "PASS" if gate_pass else "FAIL",
        "tasks_passed": passed_count,
        "tasks_total": 5,
        "median_model_response_seconds": median_seconds,
        "total_benchmark_wall_seconds": total_seconds,
        "approx_peak_gpu_memory_mib_whole_gpu": sampler.max_gpu_mib,
        "approx_peak_ollama_process_ram_mib": sampler.max_ollama_ram_mib,
        "ollama_version": command_output(["ollama", "--version"]),
        "ollama_ps": command_output(["ollama", "ps"]),
        "gate": gate,
        "gate_boolean_keys": list(boolean_gate_keys),
        "tasks": results,
        "errors": errors,
        "network_boundary": "Scored inference calls only http://127.0.0.1:11434; no cloud/API fallback in harness.",
        "authority_boundary": "Synthetic/local benchmark only; no commits, pushes, buyer contact, publication, browser agents or destructive actions."
    }
    output_path.write_text(json.dumps(report, ensure_ascii=False, indent=2), encoding="utf-8")
    summary_keys = ("experiment", "model", "result", "tasks_passed", "tasks_total", "median_model_response_seconds", "total_benchmark_wall_seconds", "approx_peak_gpu_memory_mib_whole_gpu", "approx_peak_ollama_process_ram_mib")
    print(json.dumps({k: report[k] for k in summary_keys}, ensure_ascii=False, indent=2))
    print(f"NEXIA_LOCAL_AI_CODER_RESULTS={output_path}")
    return 0 if report["result"] == "PASS" else 2


if __name__ == "__main__":
    raise SystemExit(main())

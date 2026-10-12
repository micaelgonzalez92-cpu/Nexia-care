#!/usr/bin/env python3
"""Lightweight high-confidence secret scanner for the public Nexia-care repository.

Goals:
- zero external dependencies;
- avoid printing complete candidate secrets;
- focus on high-confidence credential formats and long literal assignments;
- fail CI when a likely secret is committed.

This is a defense-in-depth check, not a substitute for GitHub's own secret scanning.
"""

from __future__ import annotations

import os
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SKIP_DIRS = {".git", "node_modules", ".venv", "venv", "dist", "build", "__pycache__"}
MAX_BYTES = 1_000_000

# High-confidence token formats plus long literal credential assignments.
PATTERNS: list[tuple[str, re.Pattern[str]]] = [
    ("private_key", re.compile(r"-----BEGIN (?:RSA |EC |OPENSSH |DSA )?PRIVATE KEY-----")),
    ("github_classic_token", re.compile(r"\bgh[pousr]_[A-Za-z0-9]{30,}\b")),
    ("github_fine_grained_token", re.compile(r"\bgithub_pat_[A-Za-z0-9_]{40,}\b")),
    ("openai_like_key", re.compile(r"\bsk-[A-Za-z0-9_-]{20,}\b")),
    ("slack_token", re.compile(r"\bxox[baprs]-[A-Za-z0-9-]{20,}\b")),
    ("aws_access_key", re.compile(r"\bAKIA[0-9A-Z]{16}\b")),
    (
        "literal_credential_assignment",
        re.compile(
            r"(?i)\b(?:api[_-]?key|access[_-]?token|auth[_-]?token|client[_-]?secret|password|passwd)\b"
            r"\s*[:=]\s*[\"']([^\"'\n]{20,})[\"']"
        ),
    ),
]

PLACEHOLDER_WORDS = {
    "example",
    "placeholder",
    "changeme",
    "dummy",
    "not-a-real",
    "not_real",
    "fake",
    "sample",
    "your_",
    "your-",
}

TEXT_EXTENSIONS = {
    ".md", ".txt", ".json", ".jsonl", ".yml", ".yaml", ".py", ".js", ".mjs", ".cjs",
    ".ts", ".tsx", ".jsx", ".html", ".css", ".sh", ".env", ".ini", ".toml", ".csv",
}


def is_candidate_file(path: Path) -> bool:
    if any(part in SKIP_DIRS for part in path.parts):
        return False
    if path.name.startswith(".env"):
        return True
    if path.suffix.lower() not in TEXT_EXTENSIONS:
        return False
    try:
        return path.stat().st_size <= MAX_BYTES
    except OSError:
        return False


def looks_placeholder(value: str) -> bool:
    low = value.lower()
    return any(word in low for word in PLACEHOLDER_WORDS) or "${{" in value or "${" in value


def redacted(value: str) -> str:
    clean = value.replace("\n", " ").strip()
    if len(clean) <= 8:
        return "<redacted>"
    return clean[:4] + "…" + clean[-2:]


def main() -> int:
    findings: list[tuple[str, int, str, str]] = []

    for path in ROOT.rglob("*"):
        if not path.is_file() or not is_candidate_file(path):
            continue
        rel = path.relative_to(ROOT)
        try:
            text = path.read_text(encoding="utf-8")
        except (UnicodeDecodeError, OSError):
            continue

        for lineno, line in enumerate(text.splitlines(), start=1):
            for label, pattern in PATTERNS:
                for match in pattern.finditer(line):
                    value = match.group(1) if match.lastindex else match.group(0)
                    if looks_placeholder(value):
                        continue
                    # Avoid self-matching the scanner's own regex source lines.
                    if rel.as_posix() == "tools/nexia_secret_scan.py":
                        continue
                    findings.append((rel.as_posix(), lineno, label, redacted(value)))

    if findings:
        print("NEXIA SECRET SCAN: FAIL")
        for path, line, label, preview in findings:
            print(f"- {path}:{line} [{label}] candidate={preview}")
        print("Remove/rotate the credential before merging. Full secret values are intentionally not printed.")
        return 1

    print("NEXIA SECRET SCAN: PASS — no high-confidence credential patterns detected.")
    return 0


if __name__ == "__main__":
    sys.exit(main())

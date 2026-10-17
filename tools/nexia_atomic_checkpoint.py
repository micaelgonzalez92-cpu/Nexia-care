#!/usr/bin/env python3
"""Fail-closed atomic Git checkpoint helper for NEXIA.

Builds and validates a complete candidate in a temporary detached worktree,
creates one commit parented to an explicit expected head, and optionally pushes
that commit with an ordinary non-force fast-forward push. Remote persistence is
reported only after ref and file-content readback.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import re
import shlex
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path, PurePosixPath
from typing import Any, Sequence

SHA40 = re.compile(r"^[0-9a-f]{40}$")
BRANCH = re.compile(r"^[A-Za-z0-9._/-]+$")
MAX_FILES = 256
MAX_FILE_BYTES = 2_000_000
MAX_TOTAL_BYTES = 20_000_000


def _run(cmd: Sequence[str], *, cwd: Path, check: bool = False) -> subprocess.CompletedProcess[bytes]:
    result = subprocess.run(
        list(cmd), cwd=cwd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=False
    )
    if check and result.returncode != 0:
        raise RuntimeError(
            f"command failed ({result.returncode}): {' '.join(cmd)}\n"
            f"{result.stderr.decode(errors='replace')[:2000]}"
        )
    return result


def _git(root: Path, *args: str, check: bool = False) -> subprocess.CompletedProcess[bytes]:
    return _run(["git", *args], cwd=root, check=check)


def _safe_rel(path: Path, base: Path) -> str:
    rel = path.relative_to(base).as_posix()
    posix = PurePosixPath(rel)
    if (
        not rel
        or posix.is_absolute()
        or ".." in posix.parts
        or "\\" in rel
        or ":" in rel
        or "\x00" in rel
        or (posix.parts and posix.parts[0] == ".git")
    ):
        raise ValueError(f"unsafe candidate path: {rel!r}")
    return rel


def scan_candidate(candidate_dir: Path) -> list[tuple[str, Path]]:
    candidate_dir = candidate_dir.resolve()
    if not candidate_dir.is_dir():
        raise ValueError("candidate directory does not exist")
    rows: list[tuple[str, Path]] = []
    total = 0
    for path in sorted(candidate_dir.rglob("*")):
        if path.is_symlink():
            raise ValueError(f"candidate symlink rejected: {path}")
        if not path.is_file():
            continue
        rel = _safe_rel(path, candidate_dir)
        size = path.stat().st_size
        if size > MAX_FILE_BYTES:
            raise ValueError(f"candidate file too large: {rel}")
        total += size
        if total > MAX_TOTAL_BYTES:
            raise ValueError("candidate total bytes exceed limit")
        rows.append((rel, path))
        if len(rows) > MAX_FILES:
            raise ValueError("candidate file count exceeds limit")
    if not rows:
        raise ValueError("candidate directory contains no files")
    return rows


def remote_head(root: Path, remote: str, branch: str) -> str | None:
    result = _git(root, "ls-remote", "--heads", remote, f"refs/heads/{branch}")
    if result.returncode != 0:
        raise RuntimeError(
            result.stderr.decode(errors="replace")[:2000] or "git ls-remote failed"
        )
    line = result.stdout.decode("utf-8", errors="replace").strip()
    if not line:
        return None
    sha = line.split()[0]
    if not SHA40.fullmatch(sha):
        raise RuntimeError("remote returned invalid head SHA")
    return sha


def verify_readback(
    candidate_commit: str,
    actual_remote_head: str | None,
    file_matches: dict[str, bool],
) -> tuple[bool, str]:
    if actual_remote_head != candidate_commit:
        return False, "remote ref does not equal candidate commit"
    bad = sorted(path for path, ok in file_matches.items() if not ok)
    if bad:
        return False, f"readback content mismatch: {', '.join(bad)}"
    return True, "remote ref and candidate file readback match"


def _candidate_digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def run_transaction(
    *,
    root: Path,
    candidate_dir: Path,
    branch: str,
    expected_head: str,
    message: str,
    remote: str = "origin",
    validator: Sequence[str] | None = None,
    require_paths: Sequence[str] = (),
    push: bool = False,
    allow_main: bool = False,
) -> dict[str, Any]:
    root = root.resolve()
    candidate_dir = candidate_dir.resolve()
    if _git(root, "rev-parse", "--git-dir").returncode != 0:
        return {
            "status": "FAILED_PRECONDITION",
            "reason": "root is not a Git repository",
            "remote_changed": False,
        }
    if not SHA40.fullmatch(expected_head):
        return {
            "status": "FAILED_PRECONDITION",
            "reason": "expected_head must be a 40-char lowercase SHA",
            "remote_changed": False,
        }
    if (
        not BRANCH.fullmatch(branch)
        or ".." in branch
        or branch.startswith("/")
        or branch.endswith("/")
        or _git(root, "check-ref-format", "--branch", branch).returncode != 0
    ):
        return {
            "status": "FAILED_PRECONDITION",
            "reason": "unsafe branch name",
            "remote_changed": False,
        }
    if push and branch == "main" and not allow_main:
        return {
            "status": "BLOCKED_MAIN_GATE",
            "reason": "--allow-main is required for a main-branch remote write",
            "remote_changed": False,
        }
    if _git(root, "cat-file", "-e", f"{expected_head}^{{commit}}").returncode != 0:
        return {
            "status": "FAILED_PRECONDITION",
            "reason": "expected_head is not available as a local commit",
            "remote_changed": False,
        }

    try:
        files = scan_candidate(candidate_dir)
    except (ValueError, OSError) as exc:
        return {
            "status": "FAILED_PRECONDITION",
            "reason": str(exc),
            "remote_changed": False,
        }

    candidate_paths = {rel for rel, _ in files}
    missing = sorted(set(require_paths) - candidate_paths)
    if missing:
        return {
            "status": "FAILED_PRECONDITION",
            "reason": f"required candidate paths missing: {', '.join(missing)}",
            "remote_changed": False,
        }

    try:
        before = remote_head(root, remote, branch) if push else None
    except RuntimeError as exc:
        return {
            "status": "FAILED_PRECONDITION",
            "reason": str(exc),
            "remote_changed": False,
        }
    if push and before != expected_head:
        return {
            "status": "FAILED_STALE_HEAD",
            "reason": f"remote head {before!r} != expected {expected_head}",
            "remote_changed": False,
        }

    temp_parent = Path(tempfile.mkdtemp(prefix="nexia-checkpoint-"))
    worktree = temp_parent / "worktree"
    validation_status = None
    try:
        added = _git(root, "worktree", "add", "--detach", str(worktree), expected_head)
        if added.returncode != 0:
            return {
                "status": "FAILED_PRECONDITION",
                "reason": added.stderr.decode(errors="replace")[:2000],
                "remote_changed": False,
            }

        digests: dict[str, str] = {}
        try:
            for rel, source in files:
                target = (worktree / rel).resolve()
                if not target.is_relative_to(worktree.resolve()):
                    return {
                        "status": "FAILED_PRECONDITION",
                        "reason": f"candidate path escapes worktree: {rel}",
                        "remote_changed": False,
                    }
                target.parent.mkdir(parents=True, exist_ok=True)
                shutil.copyfile(source, target)
                digests[rel] = _candidate_digest(source)
        except OSError as exc:
            return {
                "status": "FAILED_PRECONDITION",
                "reason": f"candidate overlay failed: {exc}",
                "remote_changed": False,
            }

        validator_cmd = (
            list(validator)
            if validator is not None
            else [sys.executable, "tools/nexia_integrity_check.py", "--json"]
        )
        validation = _run(validator_cmd, cwd=worktree)
        validation_status = validation.returncode
        if validation.returncode not in (0, 2):
            return {
                "status": "FAILED_VALIDATION",
                "reason": "candidate validator rejected the complete worktree",
                "validator_exit_code": validation.returncode,
                "validator_stdout": validation.stdout.decode(errors="replace")[-4000:],
                "validator_stderr": validation.stderr.decode(errors="replace")[-4000:],
                "remote_changed": False,
            }

        stage = _git(worktree, "add", "-A", "--", ".")
        if stage.returncode != 0:
            return {
                "status": "FAILED_PRECONDITION",
                "reason": stage.stderr.decode(errors="replace")[:2000],
                "remote_changed": False,
            }
        if _git(worktree, "diff", "--cached", "--quiet").returncode == 0:
            return {
                "status": "FAILED_PRECONDITION",
                "reason": "candidate produces no Git delta",
                "remote_changed": False,
            }
        diffcheck = _git(worktree, "diff", "--cached", "--check")
        if diffcheck.returncode != 0:
            return {
                "status": "FAILED_VALIDATION",
                "reason": diffcheck.stdout.decode(errors="replace")[:2000],
                "remote_changed": False,
            }

        commit = _git(
            worktree,
            "-c",
            "user.name=NEXIA Checkpoint",
            "-c",
            "user.email=nexia-checkpoint@local.invalid",
            "commit",
            "-m",
            message,
        )
        if commit.returncode != 0:
            return {
                "status": "FAILED_PRECONDITION",
                "reason": commit.stderr.decode(errors="replace")[:2000],
                "remote_changed": False,
            }
        commit_sha = _git(worktree, "rev-parse", "HEAD", check=True).stdout.decode().strip()
        parent = _git(worktree, "rev-parse", "HEAD^", check=True).stdout.decode().strip()
        if parent != expected_head:
            return {
                "status": "FAILED_VALIDATION",
                "reason": "candidate commit parent is not expected_head",
                "candidate_commit": commit_sha,
                "remote_changed": False,
            }

        prepared = {
            "status": "PREPARED",
            "candidate_commit": commit_sha,
            "expected_head": expected_head,
            "validator_exit_code": validation_status,
            "candidate_paths": sorted(candidate_paths),
            "remote_changed": False,
            "truth_boundary": (
                "Prepared/verified Git candidate only; not deployment, runtime, "
                "publication, demand, payment or profit."
            ),
        }
        if not push:
            return prepared

        try:
            immediately_before_push = remote_head(worktree, remote, branch)
        except RuntimeError as exc:
            return {**prepared, "status": "FAILED_PUSH", "reason": str(exc)}
        if immediately_before_push != expected_head:
            return {
                **prepared,
                "status": "FAILED_STALE_HEAD",
                "reason": f"remote head changed to {immediately_before_push!r} before push",
            }

        push_result = _git(
            worktree, "push", remote, f"{commit_sha}:refs/heads/{branch}"
        )
        if push_result.returncode != 0:
            try:
                after_failed_push = remote_head(worktree, remote, branch)
            except RuntimeError:
                after_failed_push = None
            status = (
                "FAILED_STALE_HEAD"
                if after_failed_push not in (None, expected_head)
                else "FAILED_PUSH"
            )
            return {
                **prepared,
                "status": status,
                "reason": push_result.stderr.decode(errors="replace")[-3000:],
                "observed_remote_head": after_failed_push,
            }

        actual = remote_head(worktree, remote, branch)
        fetch = _git(
            worktree,
            "fetch",
            remote,
            f"refs/heads/{branch}:refs/remotes/{remote}/{branch}",
        )
        if fetch.returncode != 0:
            return {
                **prepared,
                "status": "FAILED_READBACK",
                "reason": fetch.stderr.decode(errors="replace")[-3000:],
                "remote_changed": True,
            }

        matches: dict[str, bool] = {}
        for rel, _source in files:
            show = _git(worktree, "show", f"refs/remotes/{remote}/{branch}:{rel}")
            matches[rel] = (
                show.returncode == 0
                and hashlib.sha256(show.stdout).hexdigest() == digests[rel]
            )
        ok, detail = verify_readback(commit_sha, actual, matches)
        if not ok:
            return {
                **prepared,
                "status": "FAILED_READBACK",
                "reason": detail,
                "remote_changed": True,
                "observed_remote_head": actual,
            }
        return {
            **prepared,
            "status": "PERSISTED_VERIFIED",
            "remote_changed": True,
            "observed_remote_head": actual,
            "readback": detail,
        }
    finally:
        if worktree.exists():
            _git(root, "worktree", "remove", "--force", str(worktree))
        shutil.rmtree(temp_parent, ignore_errors=True)


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        description="Prepare or atomically push a NEXIA checkpoint candidate."
    )
    parser.add_argument("--root", default=".")
    parser.add_argument("--candidate-dir", required=True)
    parser.add_argument("--branch", required=True)
    parser.add_argument("--expected-head", required=True)
    parser.add_argument("--message", required=True)
    parser.add_argument("--remote", default="origin")
    parser.add_argument(
        "--validator",
        help="Override validator command, parsed with shell-like quoting but executed without a shell.",
    )
    parser.add_argument("--require-path", action="append", default=[])
    parser.add_argument("--push", action="store_true")
    parser.add_argument(
        "--allow-main",
        action="store_true",
        help="Technical guard only; does not itself grant authority to update main.",
    )
    args = parser.parse_args(argv)
    validator = shlex.split(args.validator) if args.validator else None
    result = run_transaction(
        root=Path(args.root),
        candidate_dir=Path(args.candidate_dir),
        branch=args.branch,
        expected_head=args.expected_head,
        message=args.message,
        remote=args.remote,
        validator=validator,
        require_paths=args.require_path,
        push=args.push,
        allow_main=args.allow_main,
    )
    print(json.dumps(result, ensure_ascii=False, indent=2, sort_keys=True))
    return 0 if result["status"] in {"PREPARED", "PERSISTED_VERIFIED"} else 1


if __name__ == "__main__":
    raise SystemExit(main())

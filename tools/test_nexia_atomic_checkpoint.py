#!/usr/bin/env python3
import os
import subprocess
import sys
import tempfile
from pathlib import Path

from nexia_atomic_checkpoint import run_transaction, verify_readback


def run(cmd, cwd):
    result = subprocess.run(
        cmd, cwd=cwd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=False
    )
    if result.returncode:
        raise RuntimeError((result.stderr or result.stdout).decode())
    return result.stdout.decode().strip()


def setup_repo(tmp: Path, validator_exit=0):
    bare = tmp / "remote.git"
    work = tmp / "work"
    candidate = tmp / "candidate"
    run(["git", "init", "--bare", str(bare)], tmp)
    run(["git", "init", str(work)], tmp)
    run(["git", "-c", "user.name=Test", "-c", "user.email=test@example.com", "checkout", "-b", "test"], work)
    (work / "tools").mkdir()
    (work / "tools" / "validator.py").write_text(
        f'import sys; print("validator"); sys.exit({validator_exit})\n',
        encoding="utf-8",
    )
    (work / "a.txt").write_text("base\n", encoding="utf-8")
    run(["git", "add", "."], work)
    run(["git", "-c", "user.name=Test", "-c", "user.email=test@example.com", "commit", "-m", "base"], work)
    base = run(["git", "rev-parse", "HEAD"], work)
    run(["git", "remote", "add", "origin", str(bare)], work)
    run(["git", "push", "-u", "origin", "test"], work)
    candidate.mkdir()
    (candidate / "a.txt").write_text("candidate\n", encoding="utf-8")
    return bare, work, candidate, base


def validator_cmd():
    return [sys.executable, "tools/validator.py"]


def test_success():
    with tempfile.TemporaryDirectory() as directory:
        bare, work, candidate, base = setup_repo(Path(directory))
        result = run_transaction(
            root=work,
            candidate_dir=candidate,
            branch="test",
            expected_head=base,
            message="checkpoint",
            validator=validator_cmd(),
            require_paths=["a.txt"],
            push=True,
        )
        assert result["status"] == "PERSISTED_VERIFIED", result
        head = run(["git", "--git-dir", str(bare), "rev-parse", "refs/heads/test"], Path(directory))
        assert head == result["candidate_commit"]
        parent = run(["git", "--git-dir", str(bare), "rev-parse", f"{head}^"], Path(directory))
        assert parent == base


def test_validation_fail_no_remote_change():
    with tempfile.TemporaryDirectory() as directory:
        bare, work, candidate, base = setup_repo(Path(directory), validator_exit=1)
        result = run_transaction(
            root=work,
            candidate_dir=candidate,
            branch="test",
            expected_head=base,
            message="checkpoint",
            validator=validator_cmd(),
            push=True,
        )
        assert result["status"] == "FAILED_VALIDATION", result
        head = run(["git", "--git-dir", str(bare), "rev-parse", "refs/heads/test"], Path(directory))
        assert head == base


def test_stale_head_no_overwrite():
    with tempfile.TemporaryDirectory() as directory:
        bare, work, candidate, base = setup_repo(Path(directory))
        (work / "remote-advance.txt").write_text("advance\n", encoding="utf-8")
        run(["git", "add", "."], work)
        run(["git", "-c", "user.name=Test", "-c", "user.email=test@example.com", "commit", "-m", "advance"], work)
        run(["git", "push", "origin", "test"], work)
        advanced = run(["git", "rev-parse", "HEAD"], work)
        result = run_transaction(
            root=work,
            candidate_dir=candidate,
            branch="test",
            expected_head=base,
            message="checkpoint",
            validator=validator_cmd(),
            push=True,
        )
        assert result["status"] == "FAILED_STALE_HEAD", result
        head = run(["git", "--git-dir", str(bare), "rev-parse", "refs/heads/test"], Path(directory))
        assert head == advanced


def test_required_path_missing():
    with tempfile.TemporaryDirectory() as directory:
        _bare, work, candidate, base = setup_repo(Path(directory))
        result = run_transaction(
            root=work,
            candidate_dir=candidate,
            branch="test",
            expected_head=base,
            message="checkpoint",
            validator=validator_cmd(),
            require_paths=["NEXIA_BOOT.json"],
            push=False,
        )
        assert result["status"] == "FAILED_PRECONDITION"
        assert "missing" in result["reason"]


def test_symlink_rejected():
    if not hasattr(os, "symlink"):
        return
    with tempfile.TemporaryDirectory() as directory:
        _bare, work, candidate, base = setup_repo(Path(directory))
        os.symlink(candidate / "a.txt", candidate / "link.txt")
        result = run_transaction(
            root=work,
            candidate_dir=candidate,
            branch="test",
            expected_head=base,
            message="checkpoint",
            validator=validator_cmd(),
            push=False,
        )
        assert result["status"] == "FAILED_PRECONDITION"
        assert "symlink" in result["reason"]


def test_readback_mismatch():
    ok, reason = verify_readback("a" * 40, "b" * 40, {"x": True})
    assert not ok and "remote ref" in reason
    ok, reason = verify_readback("a" * 40, "a" * 40, {"x": False})
    assert not ok and "content mismatch" in reason


def test_main_guard():
    with tempfile.TemporaryDirectory() as directory:
        _bare, work, candidate, base = setup_repo(Path(directory))
        result = run_transaction(
            root=work,
            candidate_dir=candidate,
            branch="main",
            expected_head=base,
            message="checkpoint",
            validator=validator_cmd(),
            push=True,
        )
        assert result["status"] == "BLOCKED_MAIN_GATE"


def main():
    tests = [
        test_success,
        test_validation_fail_no_remote_change,
        test_stale_head_no_overwrite,
        test_required_path_missing,
        test_symlink_rejected,
        test_readback_mismatch,
        test_main_guard,
    ]
    for test in tests:
        test()
    print(f"NEXIA atomic checkpoint: PASS {len(tests)}/{len(tests)}")


if __name__ == "__main__":
    main()

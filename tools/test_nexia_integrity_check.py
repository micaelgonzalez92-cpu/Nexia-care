#!/usr/bin/env python3
import importlib.util
import json
import tempfile
import unittest
import sys
from pathlib import Path

MODULE_PATH = Path(__file__).with_name("nexia_integrity_check.py")
spec = importlib.util.spec_from_file_location("nexia_integrity_check", MODULE_PATH)
mod = importlib.util.module_from_spec(spec)
assert spec.loader
sys.modules[spec.name] = mod
spec.loader.exec_module(mod)


def write_json(path, value):
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def make_fixture(root: Path, *, memory_version=61, live_state_version=61, bad_state_sha=False):
    state = {
        "version": 61,
        "revenue_eur": 0,
        "profit_eur": 0,
        "active_experiment": {"id": "EXP-OPPORTUNITY-001"},
        "current_mission": {"id": "MISSION-OPPORTUNITY-ENGINE-001"},
    }
    state_path = root / "NEXIA_STATE.json"
    write_json(state_path, state)
    state_sha = mod.git_blob_sha(state_path.read_bytes())

    boot = {
        "boot_version": 20,
        "last_verified_state_version": 61,
        "last_verified_state_blob_sha": "0" * 40 if bad_state_sha else state_sha,
        "state_version": 61,
        "state_blob_sha": state_sha,
        "revenue_eur": 0,
        "profit_eur": 0,
        "mission": {"id": "MISSION-OPPORTUNITY-ENGINE-001"},
        "active_experiment": {"id": "EXP-OPPORTUNITY-001"},
    }
    boot_path = root / "NEXIA_BOOT.json"
    write_json(boot_path, boot)
    boot_sha = mod.git_blob_sha(boot_path.read_bytes())

    live = {
        "state_version": live_state_version,
        "state_blob_sha": state_sha,
        "boot_version": 20,
        "boot_blob_sha": boot_sha,
        "revenue_eur": 0,
        "profit_eur": 0,
        "parallel_work": ["STATE v61 remains canonical"],
    }
    write_json(root / "NEXIA_LIVE.json", live)
    (root / "NEXIA_MEMORY.md").write_text(
        f"> **Canonical priority notice:** NEXIA_STATE.json v{memory_version} is canonical.\n",
        encoding="utf-8",
    )


class IntegrityTests(unittest.TestCase):
    def test_clean_fixture_passes(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            make_fixture(root)
            report = mod.run_checks(root)
            self.assertEqual(report["status"], "PASS")
            self.assertEqual(report["errors"], 0)
            self.assertEqual(report["warnings"], 0)

    def test_stale_memory_is_warning(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            make_fixture(root, memory_version=58)
            report = mod.run_checks(root)
            self.assertEqual(report["status"], "WARN")
            self.assertEqual(report["errors"], 0)
            self.assertTrue(any(x["code"] == "STALE_MEMORY_CANONICAL_NOTICE" for x in report["findings"]))

    def test_bad_state_sha_fails(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            make_fixture(root, bad_state_sha=True)
            report = mod.run_checks(root)
            self.assertEqual(report["status"], "FAIL")
            self.assertTrue(any(x["code"] == "BOOT_STATE_SHA_MISMATCH" for x in report["findings"]))

    def test_stale_live_state_version_fails(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            make_fixture(root, live_state_version=59)
            report = mod.run_checks(root)
            self.assertEqual(report["status"], "FAIL")
            self.assertTrue(any(x["code"] == "LIVE_STATE_VERSION_MISMATCH" for x in report["findings"]))


if __name__ == "__main__":
    unittest.main(verbosity=2)

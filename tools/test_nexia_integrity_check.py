#!/usr/bin/env python3
import importlib.util
import json
import tempfile
import unittest
import sys
import subprocess
import shutil
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


def read_json(path):
    return json.loads(path.read_text(encoding="utf-8"))


def bind_modern(root, entries=None, *, index_path="NEXIA_EVENT_INDEX_V28.json", base=None, errata=None):
    if entries is None:
        entries = [{"event_id": "EVT-ORIGINAL", "path": "events/EVT-ORIGINAL.json",
                    "verified_blob_sha": mod.git_blob_sha((root / "events/EVT-ORIGINAL.json").read_bytes())}]
    latest = entries[-1]
    index = {"canonical_state_version": 61,
             "canonical_state_blob_sha": mod.git_blob_sha((root / "NEXIA_STATE.json").read_bytes()),
             "delta_events": entries, "latest_event_id": latest["event_id"],
             "latest_event_path": latest["path"], "latest_event_blob_sha": latest.get("verified_blob_sha")}
    if base is not None:
        index["base_index"] = base
    if errata is not None:
        index["event_reference_errata"] = errata
    write_json(root / index_path, index)
    storage = {"active_index": index_path,
               "active_index_blob_sha": mod.git_blob_sha((root / index_path).read_bytes()),
               "latest_verified_event_id": latest["event_id"],
               "latest_verified_event_path": latest["path"],
               "latest_verified_event_blob_sha": latest.get("verified_blob_sha")}
    live = read_json(root / "NEXIA_LIVE.json")
    live["schema_version"] = 28
    live.pop("boot_version", None)
    live.pop("boot_blob_sha", None)
    live["event_storage"] = storage
    write_json(root / "NEXIA_LIVE.json", live)
    boot = read_json(root / "NEXIA_BOOT.json")
    boot["schema_version"] = 28
    boot["event_storage"] = storage
    boot["live_state_blob_sha"] = mod.git_blob_sha((root / "NEXIA_LIVE.json").read_bytes())
    write_json(root / "NEXIA_BOOT.json", boot)
    return index


def make_modern(root):
    make_fixture(root)
    (root / "events").mkdir()
    (root / "proof.md").write_bytes(b"original evidence\n")
    event = {"event_id": "EVT-ORIGINAL", "canonical_state_version": 61,
             "artifacts": [{"path": "proof.md", "blob_sha": mod.git_blob_sha(b"original evidence\n")}]}
    write_json(root / "events/EVT-ORIGINAL.json", event)
    bind_modern(root)


class ModernIntegrityTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        make_modern(self.root)

    def report(self, **kwargs):
        return mod.run_checks(self.root, **kwargs)

    def assert_code(self, code, report=None):
        report = report or self.report()
        self.assertEqual(report["status"], "FAIL", report)
        self.assertIn(code, {f["code"] for f in report["findings"]}, report)

    def mutate_event(self, **updates):
        path = self.root / "events/EVT-ORIGINAL.json"
        event = read_json(path)
        event.update(updates)
        write_json(path, event)

    def test_modern_forward_binding_and_event_payload_pass(self):
        report = self.report()
        self.assertEqual(report["status"], "PASS", report)
        self.assertEqual(report["events_checked"], 1)
        self.assertEqual(report["artifact_references_checked"], 1)

    def test_modern_live_content_tampering_fails(self):
        path = self.root / "NEXIA_LIVE.json"
        path.write_bytes(path.read_bytes() + b" \n")
        self.assert_code("BOOT_LIVE_SHA_MISMATCH")

    def test_missing_state_binding_fails(self):
        path = self.root / "NEXIA_BOOT.json"
        boot = read_json(path)
        boot.pop("state_blob_sha")
        boot.pop("last_verified_state_blob_sha")
        write_json(path, boot)
        self.assert_code("BOOT_STATE_SHA_MISSING")

    def test_event_content_tampering_fails(self):
        self.mutate_event(unreported_change=True)
        self.assert_code("EVENT_HASH_MISMATCH")

    def test_index_content_tampering_fails(self):
        path = self.root / "NEXIA_EVENT_INDEX_V28.json"
        path.write_bytes(path.read_bytes() + b" \n")
        self.assert_code("INDEX_HASH_MISMATCH")

    def test_event_identity_mismatch_fails_even_with_valid_hash(self):
        self.mutate_event(event_id="WRONG-ID")
        bind_modern(self.root)
        self.assert_code("EVENT_ID_MISMATCH")

    def test_event_missing_fails(self):
        (self.root / "events/EVT-ORIGINAL.json").unlink()
        self.assert_code("MISSING_REFERENCE")

    def test_path_traversal_fails(self):
        entries = [{"event_id": "EVT-ESCAPE", "path": "../outside.json", "verified_blob_sha": "0" * 40}]
        bind_modern(self.root, entries)
        self.assert_code("UNSAFE_REFERENCE_PATH")

    def test_payload_path_traversal_fails(self):
        self.mutate_event(artifacts=[{"path": "../private.txt", "blob_sha": "0" * 40}])
        bind_modern(self.root)
        self.assert_code("UNSAFE_REFERENCE_PATH")

    def test_malformed_event_json_fails(self):
        (self.root / "events/EVT-ORIGINAL.json").write_bytes(b"{invalid")
        bind_modern(self.root)
        self.assert_code("INVALID_REFERENCE_JSON")

    def test_cyclic_index_fails_without_hanging(self):
        bind_modern(self.root, base={"path": "NEXIA_EVENT_INDEX_V28.json", "verified_blob_sha": "0" * 40})
        self.assert_code("INDEX_CYCLE")

    def test_non_string_event_hash_fails_without_exception(self):
        bind_modern(self.root, [{"event_id": "EVT-ORIGINAL", "path": "events/EVT-ORIGINAL.json",
                                "verified_blob_sha": []}])
        self.assert_code("INVALID_BLOB_SHA")

    def test_missing_historical_hash_is_warning_not_pass(self):
        # A missing latest hash is an error; a historical unbound entry remains
        # explicit debt while the latest event is still correctly anchored.
        entries = [{"event_id": "EVT-OLD", "path": "events/EVT-OLD.json"},
                   {"event_id": "EVT-ORIGINAL", "path": "events/EVT-ORIGINAL.json",
                    "verified_blob_sha": mod.git_blob_sha((self.root / "events/EVT-ORIGINAL.json").read_bytes())}]
        write_json(self.root / "events/EVT-OLD.json", {"event_id": "EVT-OLD", "state_version": 60})
        bind_modern(self.root, entries)
        report = self.report()
        self.assertEqual(report["status"], "WARN", report)
        self.assertIn("REFERENCE_HASH_MISSING", {f["code"] for f in report["findings"]})

    def test_valid_historical_blob_survives_later_document_edit(self):
        cache = self.root / "cache"
        cache.mkdir()
        sha = mod.git_blob_sha(b"original evidence\n")
        (cache / sha).write_bytes(b"original evidence\n")
        (self.root / "proof.md").write_bytes(b"later legitimate version\n")
        report = self.report(blob_cache=cache)
        self.assertEqual(report["status"], "PASS", report)
        self.assertEqual(report["historical_artifact_blobs_checked"], 1)

    def test_tampered_historical_cache_fails(self):
        cache = self.root / "cache"
        cache.mkdir()
        sha = mod.git_blob_sha(b"original evidence\n")
        (cache / sha).write_bytes(b"forged bytes")
        (self.root / "proof.md").write_bytes(b"later version\n")
        self.assert_code("HISTORICAL_BLOB_HASH_MISMATCH", self.report(blob_cache=cache))

    def add_artifact_erratum(self, *, bad_anchor=False, unrelated_claim=False):
        self.mutate_event(artifacts=[{"path": "proof.md", "blob_sha": "0" * 40}])
        source = self.root / "events/EVT-ORIGINAL.json"
        sha = mod.git_blob_sha(source.read_bytes())
        correction = {"event_id": "EVT-CORRECTION", "canonical_state_version": 61,
                      "supersedes_reference_claims_in": "events/EVT-ORIGINAL.json",
                      "corrects_event_blob_sha": "1" * 40 if bad_anchor else sha,
                      "corrected_references": [{"path": "unrelated.md" if unrelated_claim else "proof.md",
                                                "declared_blob_sha": "0" * 40,
                                                "verified_blob_sha": mod.git_blob_sha(b"original evidence\n")}]}
        path = self.root / "events/EVT-CORRECTION.json"
        write_json(path, correction)
        bind_modern(self.root, [{"event_id": "EVT-ORIGINAL", "path": "events/EVT-ORIGINAL.json", "verified_blob_sha": sha},
                                {"event_id": "EVT-CORRECTION", "path": "events/EVT-CORRECTION.json",
                                 "verified_blob_sha": mod.git_blob_sha(path.read_bytes())}])

    def test_explicit_exact_artifact_erratum_passes_without_rewriting_original(self):
        self.add_artifact_erratum()
        source = (self.root / "events/EVT-ORIGINAL.json").read_bytes()
        report = self.report()
        self.assertEqual(report["status"], "PASS", report)
        self.assertEqual(report["corrected_historical_references"], 1)
        self.assertEqual((self.root / "events/EVT-ORIGINAL.json").read_bytes(), source)

    def test_erratum_cannot_mask_another_event_version(self):
        self.add_artifact_erratum(bad_anchor=True)
        self.assert_code("INVALID_ARTIFACT_ERRATUM")

    def test_erratum_cannot_mask_an_unrelated_claim(self):
        self.add_artifact_erratum(unrelated_claim=True)
        self.assert_code("INVALID_ARTIFACT_ERRATUM")

    def test_unresolved_artifact_hash_fails(self):
        self.mutate_event(artifacts=[{"path": "proof.md", "blob_sha": "0" * 40}])
        bind_modern(self.root)
        self.assert_code("ARTIFACT_BLOB_UNVERIFIED")

    def test_future_state_event_fails(self):
        self.mutate_event(canonical_state_version=62)
        bind_modern(self.root)
        self.assert_code("EVENT_FUTURE_STATE")

    def test_cli_exit_codes_and_json(self):
        command = [sys.executable, "-B", str(MODULE_PATH), "--root", str(self.root), "--json"]
        result = subprocess.run(command, capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stdout)
        self.assertEqual(json.loads(result.stdout)["status"], "PASS")
        self.mutate_event(tampered=True)
        result = subprocess.run(command, capture_output=True, text=True)
        self.assertEqual(result.returncode, 1)
        self.assertEqual(json.loads(result.stdout)["status"], "FAIL")

    def test_invalid_core_field_type_fails_without_exception(self):
        path = self.root / "NEXIA_STATE.json"
        state = read_json(path)
        state["current_mission"] = ["invalid"]
        write_json(path, state)
        self.assert_code("INVALID_FIELD_TYPE")

    def add_index_erratum(self, *, wrong_anchor=False, wrong_claim=False):
        original = self.root / "events/EVT-ORIGINAL.json"
        old_index = "NEXIA_EVENT_INDEX_V27.json"
        bind_modern(self.root, [{"event_id": "EVT-ORIGINAL", "path": "events/EVT-ORIGINAL.json",
                                "verified_blob_sha": "0" * 40}], index_path=old_index)
        old_sha = mod.git_blob_sha((self.root / old_index).read_bytes())
        latest = self.root / "events/EVT-LATEST.json"
        write_json(latest, {"event_id": "EVT-LATEST", "canonical_state_version": 61})
        row = {"source_index": old_index, "source_index_blob_sha": "1" * 40 if wrong_anchor else old_sha,
               "path": "events/unrelated.json" if wrong_claim else "events/EVT-ORIGINAL.json",
               "declared_blob_sha": "0" * 40, "verified_blob_sha": mod.git_blob_sha(original.read_bytes())}
        bind_modern(self.root, [{"event_id": "EVT-LATEST", "path": "events/EVT-LATEST.json",
                                "verified_blob_sha": mod.git_blob_sha(latest.read_bytes())}],
                    base={"path": old_index, "verified_blob_sha": old_sha}, errata=[row])

    def test_exact_older_index_erratum_passes_without_rewriting_index(self):
        self.add_index_erratum()
        before = (self.root / "NEXIA_EVENT_INDEX_V27.json").read_bytes()
        report = self.report()
        self.assertEqual(report["status"], "PASS", report)
        self.assertEqual(report["corrected_historical_references"], 1)
        self.assertEqual((self.root / "NEXIA_EVENT_INDEX_V27.json").read_bytes(), before)

    def test_index_erratum_wrong_source_anchor_fails(self):
        self.add_index_erratum(wrong_anchor=True)
        self.assert_code("INVALID_INDEX_ERRATUM")

    def test_index_erratum_wrong_original_claim_fails(self):
        self.add_index_erratum(wrong_claim=True)
        self.assert_code("INVALID_INDEX_ERRATUM")

    def test_conflicting_artifact_errata_fails(self):
        self.add_artifact_erratum()
        path = self.root / "events/EVT-CORRECTION.json"
        event = read_json(path)
        event["corrected_references"].append(dict(event["corrected_references"][0]))
        write_json(path, event)
        original = self.root / "events/EVT-ORIGINAL.json"
        bind_modern(self.root, [{"event_id": "EVT-ORIGINAL", "path": "events/EVT-ORIGINAL.json",
                                "verified_blob_sha": mod.git_blob_sha(original.read_bytes())},
                               {"event_id": "EVT-CORRECTION", "path": "events/EVT-CORRECTION.json",
                                "verified_blob_sha": mod.git_blob_sha(path.read_bytes())}])
        self.assert_code("CONFLICTING_ARTIFACT_ERRATA")

    def add_legacy_base_index_erratum(self, *, bad_anchor=False, bad_target=False,
                                     duplicate=False, preexisting_hash=False):
        old_index = "NEXIA_EVENT_INDEX_V27.json"
        bind_modern(self.root, index_path=old_index)
        old_sha = mod.git_blob_sha((self.root / old_index).read_bytes())
        middle = self.root / "events/EVT-MIDDLE.json"
        write_json(middle, {"event_id": "EVT-MIDDLE", "canonical_state_version": 61})
        base = {"path": old_index}
        if preexisting_hash:
            base["verified_blob_sha"] = old_sha
        bind_modern(self.root,
                    [{"event_id": "EVT-MIDDLE", "path": "events/EVT-MIDDLE.json",
                      "verified_blob_sha": mod.git_blob_sha(middle.read_bytes())}],
                    index_path="NEXIA_EVENT_INDEX_V28.json", base=base)
        source_sha = mod.git_blob_sha((self.root / "NEXIA_EVENT_INDEX_V28.json").read_bytes())
        latest = self.root / "events/EVT-LATEST.json"
        write_json(latest, {"event_id": "EVT-LATEST", "canonical_state_version": 61})
        bind_modern(self.root,
                    [{"event_id": "EVT-LATEST", "path": "events/EVT-LATEST.json",
                      "verified_blob_sha": mod.git_blob_sha(latest.read_bytes())}],
                    index_path="NEXIA_EVENT_INDEX_V29.json",
                    base={"path": "NEXIA_EVENT_INDEX_V28.json", "verified_blob_sha": source_sha})
        row = {"source_index": "NEXIA_EVENT_INDEX_V28.json",
               "source_index_blob_sha": "0" * 40 if bad_anchor else source_sha,
               "path": old_index, "declared_blob_sha": None,
               "verified_blob_sha": "1" * 40 if bad_target else old_sha}
        index_path = self.root / "NEXIA_EVENT_INDEX_V29.json"
        index = read_json(index_path)
        index["base_index_reference_errata"] = [row, dict(row)] if duplicate else [row]
        write_json(index_path, index)
        index_sha = mod.git_blob_sha(index_path.read_bytes())
        live_path = self.root / "NEXIA_LIVE.json"
        live = read_json(live_path)
        live["event_storage"]["active_index_blob_sha"] = index_sha
        write_json(live_path, live)
        boot_path = self.root / "NEXIA_BOOT.json"
        boot = read_json(boot_path)
        boot["event_storage"]["active_index_blob_sha"] = index_sha
        boot["live_state_blob_sha"] = mod.git_blob_sha(live_path.read_bytes())
        write_json(boot_path, boot)
        return old_index

    def test_bounded_legacy_base_index_erratum_passes_without_history_rewrite(self):
        old_index = self.add_legacy_base_index_erratum()
        before = (self.root / old_index).read_bytes()
        report = self.report()
        self.assertEqual(report["status"], "PASS", report)
        self.assertEqual(report["corrected_historical_references"], 1, report)
        self.assertEqual((self.root / old_index).read_bytes(), before)

    def test_legacy_base_index_erratum_wrong_source_anchor_fails(self):
        self.add_legacy_base_index_erratum(bad_anchor=True)
        self.assert_code("INVALID_BASE_INDEX_ERRATUM")

    def test_legacy_base_index_erratum_wrong_target_hash_fails(self):
        self.add_legacy_base_index_erratum(bad_target=True)
        self.assert_code("INVALID_BASE_INDEX_ERRATUM")

    def test_legacy_base_index_erratum_cannot_override_existing_hash(self):
        self.add_legacy_base_index_erratum(preexisting_hash=True)
        self.assert_code("INVALID_BASE_INDEX_ERRATUM")

    def test_legacy_base_index_erratum_duplicate_is_conflict(self):
        self.add_legacy_base_index_erratum(duplicate=True)
        self.assert_code("CONFLICTING_BASE_INDEX_ERRATA")

    def test_legacy_base_index_erratum_source_tamper_fails(self):
        self.add_legacy_base_index_erratum()
        path = self.root / "NEXIA_EVENT_INDEX_V28.json"
        path.write_bytes(path.read_bytes() + b" \\n")
        self.assert_code("INDEX_HASH_MISMATCH")

    def test_read_only_audit_does_not_change_input_files(self):
        before = {p.relative_to(self.root): p.read_bytes() for p in self.root.rglob("*") if p.is_file()}
        self.assertEqual(self.report()["status"], "PASS")
        after = {p.relative_to(self.root): p.read_bytes() for p in self.root.rglob("*") if p.is_file()}
        self.assertEqual(before, after)

    def test_changed_hard_precedence_fails(self):
        path = self.root / "NEXIA_STATE.json"
        state = read_json(path)
        state["hard_precedence"] = ["TRUTH", "AUTHORITY"]
        write_json(path, state)
        self.assert_code("HARD_PRECEDENCE_MISMATCH")

    def test_conflicting_artifact_sha_fields_fail(self):
        self.mutate_event(artifacts=[{"path": "proof.md", "blob_sha": "0" * 40,
                                     "verified_blob_sha": mod.git_blob_sha(b"original evidence\n")}])
        bind_modern(self.root)
        self.assert_code("INVALID_ARTIFACT_REFERENCE")

    def test_non_object_base_index_fails_without_exception(self):
        bind_modern(self.root, base=["bad-path"])
        self.assert_code("INVALID_INDEX_REFERENCE")

    def test_cli_warning_exit_code_two(self):
        (self.root / "NEXIA_MEMORY.md").write_text("NEXIA_STATE.json v58 is canonical\n", encoding="utf-8")
        result = subprocess.run([sys.executable, "-B", str(MODULE_PATH), "--root", str(self.root), "--json"],
                                capture_output=True, text=True)
        self.assertEqual(result.returncode, 2)
        self.assertEqual(json.loads(result.stdout)["status"], "WARN")

    @unittest.skipUnless(shutil.which("git"), "git unavailable")
    def test_historical_git_blob_is_verified_offline(self):
        subprocess.run(["git", "-C", str(self.root), "init", "--quiet"], check=True, capture_output=True)
        result = subprocess.run(["git", "-C", str(self.root), "hash-object", "-w", "--stdin"],
                                input=b"original evidence\n", capture_output=True, check=True)
        self.assertEqual(result.stdout.strip().decode("ascii"), mod.git_blob_sha(b"original evidence\n"))
        (self.root / "proof.md").write_bytes(b"new document version\n")
        report = self.report()
        self.assertEqual(report["status"], "PASS", report)
        self.assertEqual(report["historical_artifact_blobs_checked"], 1)


if __name__ == "__main__":
    unittest.main(verbosity=2)

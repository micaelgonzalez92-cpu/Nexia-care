#!/usr/bin/env python3
import importlib.util
import json
import tempfile
import unittest
from pathlib import Path

MODULE_PATH = Path(__file__).with_name("nexia_process_miner.py")
spec = importlib.util.spec_from_file_location("nexia_process_miner", MODULE_PATH)
miner = importlib.util.module_from_spec(spec)
assert spec.loader is not None
spec.loader.exec_module(miner)


def write_json(path: Path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2) + "\n", encoding="utf-8")


def git_blob_sha(path: Path) -> str:
    return miner._git_blob_sha(path)


class ProcessMinerTests(unittest.TestCase):
    def build_repo(self, root: Path):
        e1 = {
            "schema_version": 1,
            "event_id": "E1",
            "timestamp": "2026-10-17",
            "type": "SEQUENTIAL_RUNTIME_PASS_CONCURRENCY_FAIL",
            "evidence_label": "HECHO_VERIFICADO",
            "classification": "SEQUENTIAL_RUNTIME_PASS_CONCURRENCY_FAIL",
            "authority": "GREEN",
            "concurrency_stress": {"status": "FAIL_MATERIAL"},
            "root_cause_hypothesis": "check-then-write race window",
            "rerun_unchanged_candidate_to_seek_pass": False,
            "next_action": "Do not rerun unchanged candidate to seek pass.",
            "truth_boundary": "Sequential synthetic behavior only.",
            "cost_eur": 0,
            "external_effects": False,
        }
        e1_path = root / "events/E1.json"
        write_json(e1_path, e1)

        idx1 = {
            "schema_version": 1,
            "mode": "COMPOSITE_INDEX_CHAIN",
            "delta_events": [{"event_id": "E1", "path": "events/E1.json", "verified_blob_sha": git_blob_sha(e1_path)}],
            "latest_event_id": "E1",
            "latest_event_path": "events/E1.json",
        }
        idx1_path = root / "NEXIA_EVENT_INDEX_V1.json"
        write_json(idx1_path, idx1)

        e2 = {
            "schema_version": 1,
            "event_id": "E2",
            "timestamp": "2026-10-17",
            "type": "SERIALIZED_BOUNDED_PASS",
            "evidence_label": "HECHO_VERIFICADO",
            "status": "READY_FOR_CURRENT_PURPOSE",
            "serialized_profile": {"runtime_control": "N8N_CONCURRENCY_PRODUCTION_LIMIT=1"},
            "first_run": {"measurement_defect": "audit response returned only first entry"},
            "observability_repair": {"preregistration_path": "OBSERVABILITY_REPAIR_PREREG.md", "independent_crosscheck": "DIRECT_SQLITE_PHYSICAL_DATA_TABLE_READBACK"},
            "verified_run": {"run_id": 42, "job_id": 99, "conclusion": "SUCCESS"},
            "truth_boundary": "Bounded synthetic pass only.",
            "stop_rationale": "Further stress has lower value.",
            "cost_eur": 0,
            "external_effects": False,
        }
        e2_path = root / "events/E2.json"
        write_json(e2_path, e2)

        idx2 = {
            "schema_version": 2,
            "mode": "COMPOSITE_INDEX_CHAIN",
            "base_index": {"path": "NEXIA_EVENT_INDEX_V1.json", "verified_blob_sha": git_blob_sha(idx1_path)},
            "delta_events": [{"event_id": "E2", "path": "events/E2.json", "verified_blob_sha": git_blob_sha(e2_path)}],
            "latest_event_id": "E2",
            "latest_event_path": "events/E2.json",
        }
        write_json(root / "NEXIA_EVENT_INDEX_V2.json", idx2)
        write_json(root / "NEXIA_BOOT.json", {"event_storage": {"active_index": "NEXIA_EVENT_INDEX_V2.json"}})

    def test_traversal_normalization_and_lessons(self):
        with tempfile.TemporaryDirectory() as td:
            root = Path(td)
            self.build_repo(root)
            result = miner.run(root)
            self.assertEqual(result["active_index"], "NEXIA_EVENT_INDEX_V2.json")
            self.assertEqual([i["path"] for i in result["indexes"]], ["NEXIA_EVENT_INDEX_V1.json", "NEXIA_EVENT_INDEX_V2.json"])
            self.assertEqual([e["event_id"] for e in result["episodes"]], ["E1", "E2"])
            self.assertEqual(result["episodes"][0]["outcome"], "FAIL")
            self.assertEqual(result["episodes"][1]["outcome"], "PASS")
            ids = {l["lesson_id"] for l in result["lessons"]}
            self.assertIn("LESSON-STATEFUL-CONCURRENCY-STRESS-001", ids)
            self.assertIn("LESSON-OBSERVABILITY-CROSSCHECK-001", ids)
            self.assertIn("LESSON-PREREGISTER-BEFORE-OUTPUTS-001", ids)
            self.assertIn("LESSON-NO-PASS-HUNTING-001", ids)
            self.assertIn("LESSON-BOUND-CAPABILITY-CLAIMS-001", ids)
            self.assertEqual(result["errors"], [])

    def test_query_ranks_relevant_lesson(self):
        with tempfile.TemporaryDirectory() as td:
            root = Path(td)
            self.build_repo(root)
            result = miner.run(root)
            ranked = miner.rank_lessons(result["lessons"], "n8n dedup concurrency workflow")
            self.assertTrue(ranked)
            self.assertEqual(ranked[0]["lesson_id"], "LESSON-STATEFUL-CONCURRENCY-STRESS-001")

    def test_blob_mismatch_fails_validation(self):
        with tempfile.TemporaryDirectory() as td:
            root = Path(td)
            self.build_repo(root)
            p = root / "events/E2.json"
            event = json.loads(p.read_text())
            event["status"] = "MUTATED"
            write_json(p, event)
            result = miner.run(root)
            self.assertTrue(any(d["kind"] == "event_blob_mismatch" for d in result["diagnostics"]))
            self.assertTrue(result["errors"])

    def test_default_write_outputs(self):
        with tempfile.TemporaryDirectory() as td:
            root = Path(td)
            self.build_repo(root)
            code = miner.main(["--repo-root", str(root)])
            self.assertEqual(code, 0)
            self.assertTrue((root / "intelligence/NEXIA_PROCESS_EPISODES.jsonl").exists())
            self.assertTrue((root / "intelligence/NEXIA_PROCESS_LESSONS.json").exists())
            self.assertTrue((root / "intelligence/NEXIA_PROCESS_METRICS.json").exists())
            lessons = json.loads((root / "intelligence/NEXIA_PROCESS_LESSONS.json").read_text())
            self.assertGreaterEqual(len(lessons["lessons"]), 5)


if __name__ == "__main__":
    unittest.main()

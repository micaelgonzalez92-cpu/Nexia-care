import json
import tempfile
import unittest
from pathlib import Path
from nexia_session_preflight import run, blob_sha


class PreflightTests(unittest.TestCase):
    def setUp(self):
        self.t = tempfile.TemporaryDirectory()
        self.addCleanup(self.t.cleanup)
        self.root = Path(self.t.name)
        esha = self.save("events/EVT-TEST.json", {"event_id": "EVT-TEST"})
        ssha = self.save("NEXIA_STATE.json", {"version": 73})
        isha = self.save("NEXIA_EVENT_INDEX_V84.json", {
            "canonical_state_version": 73, "canonical_state_blob_sha": ssha,
            "latest_event_path": "events/EVT-TEST.json", "latest_event_blob_sha": esha,
        })
        lsha = self.save("NEXIA_LIVE.json", {
            "state_version": 73, "state_blob_sha": ssha,
            "event_storage": {"active_index": "NEXIA_EVENT_INDEX_V84.json",
                              "active_index_blob_sha": isha},
        })
        self.boot = {
            "state_version": 73, "state_blob_sha": ssha, "live_state_blob_sha": lsha,
            "event_storage": {
                "active_index": "NEXIA_EVENT_INDEX_V84.json",
                "active_index_blob_sha": isha,
                "latest_verified_event_path": "events/EVT-TEST.json",
                "latest_verified_event_blob_sha": esha,
                "latest_verified_event_id": "EVT-TEST",
            },
        }
        self.save("NEXIA_BOOT.json", self.boot)

    def save(self, path, payload):
        p = self.root / path
        p.parent.mkdir(parents=True, exist_ok=True)
        raw = json.dumps(payload, sort_keys=True).encode()
        p.write_bytes(raw)
        return blob_sha(raw)

    def test_matching_bindings(self):
        self.assertEqual(run(self.root)["status"], "PASS_REPOSITORY_BINDINGS_ONLY")

    def test_state_mutation_blocks(self):
        self.save("NEXIA_STATE.json", {"version": 74})
        self.assertIn("BLOB_SHA_MISMATCH:NEXIA_STATE.json", run(self.root)["errors"])

    def test_live_mutation_blocks(self):
        self.save("NEXIA_LIVE.json", {"state_version": 75})
        self.assertEqual(run(self.root)["status"], "BLOCKED")

    def test_missing_index_blocks(self):
        (self.root / "NEXIA_EVENT_INDEX_V84.json").unlink()
        self.assertEqual(run(self.root)["status"], "BLOCKED")

    def test_unattested_connector_blocks(self):
        self.assertIn("NO_SESSION_CONNECTOR_ATTESTATION", run(self.root, ["canva"])["errors"])

    def test_unapproved_connector_blocks(self):
        f = self.root / "cap.json"
        f.write_text(json.dumps({"project": "NEXIA CORE", "connectors": {
            "canva": {"verified_in_this_session": True, "approved_for_nexia": False,
                      "verification_reference": "test"}}}))
        self.assertIn("CONNECTOR_NOT_VERIFIED_FOR_NEXIA:canva", run(self.root, ["canva"], f)["errors"])

    def test_positive_manifest_is_structural_only(self):
        f = self.root / "cap.json"
        f.write_text(json.dumps({"project": "NEXIA CORE", "connectors": {
            "canva": {"verified_in_this_session": True, "approved_for_nexia": True,
                      "verification_reference": "provider_readback"}}}))
        self.assertEqual(run(self.root, ["canva"], f)["status"], "PASS_REPOSITORY_BINDINGS_ONLY")

    def test_unsafe_path_blocks(self):
        self.boot["event_storage"]["latest_verified_event_path"] = "events/../../bad.json"
        self.save("NEXIA_BOOT.json", self.boot)
        self.assertEqual(run(self.root)["status"], "BLOCKED")


if __name__ == "__main__":
    unittest.main()

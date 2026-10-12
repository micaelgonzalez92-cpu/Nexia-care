"""Synthetic tests only. No PC probes or network calls."""
import copy
import unittest
from nexia_local_capability_score import screen


def audit(vram=12, ram=32, disk=100):
    return {"schema_version": 1, "memory": {"total_gb": ram},
            "graphics": {"nvidia_smi": [{"memory_total_gb": vram}],
                         "adapters": [{"adapter_ram_gb": 4}]},
            "storage": [{"free_gb": disk}], "developer_tools": {"node": "v20.1.0"}}


class ScoringTests(unittest.TestCase):
    def test_high_end(self):
        r = screen(audit(24, 32, 150))
        self.assertEqual(r["tier"], "S_LOCAL_CREATIVE")
        self.assertEqual(r["capabilities"]["Wan2.2 TI2V-5B"], "CANDIDATE_720P_EVALUATION")

    def test_midrange_and_nvidia_preference(self):
        r = screen(audit())
        self.assertEqual(r["tier"], "A_LOCAL_IMAGE_AVATAR")
        self.assertEqual(r["resources"]["vram_gib"], 12)
        self.assertEqual(r["capabilities"]["Wan2.2 TI2V-5B"], "BLOCKED_LOCAL_VIDEO")

    def test_low_resources(self):
        self.assertEqual(screen(audit(2, 4, 10))["tier"], "C_CLOUD_OR_LIGHTWEIGHT_FIRST")

    def test_unknown_and_wmi_only(self):
        a = audit()
        a["graphics"]["nvidia_smi"] = []
        self.assertIsNone(screen(a)["resources"]["vram_gib"])
        self.assertEqual(screen({"schema_version": 1})["tier"], "UNKNOWN")

    def test_no_rounding_or_gpu_summing(self):
        a = audit(12, 15.96)
        a["graphics"]["nvidia_smi"].append({"memory_total_gb": 12})
        r = screen(a)
        self.assertEqual(r["resources"]["vram_gib"], 12)
        self.assertEqual(r["tier"], "C_CLOUD_OR_LIGHTWEIGHT_FIRST")
        self.assertEqual(r["capabilities"]["Ollama"], "LIMITED")

    def test_invalid_numeric_values(self):
        for bad in [None, True, "32", -1, float("nan"), float("inf")]:
            self.assertIsNone(screen(audit(ram=bad))["resources"]["ram_gib"])

    def test_boundaries_and_optimized_video(self):
        self.assertEqual(screen(audit(4, 16, 40))["tier"], "B_LIMITED_LOCAL_AI")
        self.assertEqual(screen(audit(8, 16, 60))["tier"], "A_LOCAL_IMAGE_AVATAR")
        self.assertEqual(screen(audit(16, 32, 100))["capabilities"]["Wan2.2 TI2V-5B"], "EXPERIMENTAL_OPTIMIZED_ONLY")

    def test_schema_input_immutability_and_node(self):
        a = audit()
        before = copy.deepcopy(a)
        self.assertEqual(screen(a)["openfield_node_20_gate"], "PASS")
        self.assertEqual(a, before)
        for value in [None, [], {}, {"schema_version": 2}]:
            with self.assertRaises(ValueError):
                screen(value)
        for node, expected in [("v18.0.0", "BLOCKED"), (None, "UNKNOWN"), ("installed_version_unknown", "UNKNOWN")]:
            a["developer_tools"]["node"] = node
            self.assertEqual(screen(a)["openfield_node_20_gate"], expected)
        self.assertFalse(screen(a)["installation_authorized"])
        self.assertFalse(screen(a)["runtime_verified"])


if __name__ == "__main__":
    unittest.main()

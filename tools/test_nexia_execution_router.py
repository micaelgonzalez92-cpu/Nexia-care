import unittest
from nexia_execution_router import route_task


class RouterTests(unittest.TestCase):
    def test_external_contact_is_human_gate(self):
        self.assertEqual(route_task({"effects": ["external_contact"]})["executor"], "HUMAN_GATE")

    def test_spend_is_human_gate(self):
        self.assertEqual(route_task({"spend_eur": 1})["executor"], "HUMAN_GATE")

    def test_install_is_human_gate(self):
        self.assertEqual(route_task({"installation_or_system_change": True})["executor"], "HUMAN_GATE")

    def test_deterministic_cloud_goes_to_actions(self):
        out = route_task({"deterministic": True})
        self.assertEqual(out["executor"], "GITHUB_ACTIONS")
        self.assertTrue(out["zero_quota"])

    def test_verified_image_generation_goes_local_gpu(self):
        out = route_task({"requires_gpu": True, "image_generation": True})
        self.assertEqual(out["executor"], "LOCAL_GPU")
        self.assertTrue(out["zero_quota"])

    def test_authenticated_browser_uses_work_until_local_verified(self):
        self.assertEqual(route_task({"requires_authenticated_browser": True})["executor"], "WORK")

    def test_authenticated_browser_can_move_local_when_verified(self):
        out = route_task({"requires_authenticated_browser": True}, {"local_browser": True})
        self.assertEqual(out["executor"], "LOCAL_BROWSER")
        self.assertTrue(out["zero_quota"])

    def test_public_research_stays_chat(self):
        out = route_task({"public_web": True, "reasoning": "medium"})
        self.assertEqual(out["executor"], "CHAT")
        self.assertTrue(out["zero_quota"])

    def test_code_uses_codex_until_local_ai_verified(self):
        self.assertEqual(route_task({"code_change": True})["executor"], "CODEX")

    def test_code_moves_local_when_local_ai_verified(self):
        out = route_task({"code_change": True}, {"local_ai": True})
        self.assertEqual(out["executor"], "LOCAL_AI")
        self.assertTrue(out["zero_quota"])

    def test_secret_deterministic_work_stays_local(self):
        out = route_task({"requires_secrets": True, "deterministic": True})
        self.assertEqual(out["executor"], "LOCAL_SCRIPT")
        self.assertTrue(out["zero_quota"])

    def test_secret_authenticated_task_never_routes_public_ci(self):
        out = route_task({
            "requires_secrets": True,
            "requires_authenticated_browser": True,
            "deterministic": True,
        })
        self.assertNotEqual(out["executor"], "GITHUB_ACTIONS")


if __name__ == "__main__":
    unittest.main()

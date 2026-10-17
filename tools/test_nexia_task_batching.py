#!/usr/bin/env python3
from nexia_task_batching import (
    HANDOFF_FIELDS,
    classify_task_size,
    decompose_task,
    make_packet,
    make_telemetry_template,
    recommended_reasoning,
    summarize_handoff,
)


def base(**overrides):
    task = {
        "task_id": "T-1",
        "objective": "Update one validation rule.",
        "success_condition": "Targeted test passes.",
        "stop_condition": "Stop if unrelated behavior must change.",
        "estimated_steps": 2,
        "surfaces": 1,
        "dependencies": 1,
        "uncertainty": "low",
        "risk": "low",
        "must_read": ["AGENTS.md", "x.py"],
        "optional_read": ["README.md", "x.py"],
    }
    task.update(overrides)
    return task


def test_micro_and_low_reasoning():
    task = base()
    assert classify_task_size(task) == "MICRO"
    assert recommended_reasoning(task) == "low"
    packet = make_packet(task)
    assert packet["context"]["must_read"] == ["AGENTS.md", "x.py"]
    assert packet["context"]["optional_read"] == ["README.md"]
    assert packet["execution_policy"]["avoid_repo_wide_read_by_default"] is True


def test_standard():
    task = base(estimated_steps=6, uncertainty="medium")
    assert classify_task_size(task) == "STANDARD"
    assert recommended_reasoning(task) == "medium"


def test_complex_without_phases_emits_plan_only():
    task = base(
        objective="Refactor persistence architecture.",
        success_condition="Architecture is implemented and verified.",
        stop_condition="Stop at any RED gate.",
        architecture_change=True,
    )
    packets = decompose_task(task)
    assert len(packets) == 1
    assert packets[0]["packet_id"] == "T-1-PLAN"
    assert packets[0]["size"] == "MICRO"
    assert "no material implementation" in packets[0]["success_condition"].lower()


def test_complex_with_explicit_phases_preserves_boundaries():
    task = base(
        objective="Refactor persistence architecture.",
        success_condition="All phases verified.",
        stop_condition="Stop at any RED gate.",
        architecture_change=True,
        phases=[
            {
                "task_id": "T-1-A",
                "objective": "Add compare-and-swap primitive.",
                "success_condition": "Stale-head test fails closed.",
                "stop_condition": "Stop if main must be mutated.",
                "estimated_steps": 5,
                "uncertainty": "medium",
            },
            {
                "task_id": "T-1-B",
                "objective": "Add recovery fault tests.",
                "success_condition": "Fault suite passes.",
                "stop_condition": "Stop if destructive remote action is required.",
                "estimated_steps": 5,
                "uncertainty": "medium",
            },
        ],
    )
    packets = decompose_task(task)
    assert [packet["packet_id"] for packet in packets] == ["T-1-A", "T-1-B"]
    assert all(packet["parent_id"] == "T-1" for packet in packets)
    assert all(packet["size"] == "STANDARD" for packet in packets)


def test_nested_complex_phase_stops_at_its_own_plan():
    task = base(
        objective="Coordinate a broad architecture change.",
        success_condition="All bounded phases verified.",
        stop_condition="Stop at any RED gate.",
        architecture_change=True,
        phases=[
            {
                "task_id": "T-1-A",
                "objective": "Refactor across two repositories.",
                "success_condition": "Cross-repo behavior is verified.",
                "stop_condition": "Stop before implementation until dependencies are bounded.",
                "cross_repo": True,
                "estimated_steps": 9,
                "uncertainty": "high",
            }
        ],
    )
    packets = decompose_task(task)
    assert len(packets) == 1
    assert packets[0]["packet_id"] == "T-1-A-PLAN"
    assert packets[0]["size"] == "MICRO"
    assert packets[0]["parent_id"] == "T-1-A"


def test_required_fields_fail_closed():
    task = base()
    del task["stop_condition"]
    try:
        make_packet(task)
    except ValueError as exc:
        assert "stop_condition" in str(exc)
    else:
        raise AssertionError("missing stop condition must fail")


def test_invalid_explicit_outcome_fails_closed():
    task = base(single_verifiable_outcome=None)
    try:
        make_packet(task)
    except ValueError as exc:
        assert "single_verifiable_outcome" in str(exc)
    else:
        raise AssertionError("invalid explicit outcome must fail")


def test_unknown_usage_is_not_zero():
    telemetry = make_telemetry_template(base())
    assert telemetry["token_input"] == "UNKNOWN"
    assert telemetry["quota_before"] == "UNKNOWN"
    assert telemetry["wall_seconds"] == "UNKNOWN"


def test_handoff_contract():
    handoff = summarize_handoff(
        done="Targeted implementation complete.",
        evidence=["test_a PASS"],
        changed=["x.py"],
        next_action="Run integration check.",
        must_read=["x.py"],
    )
    assert set(handoff) == set(HANDOFF_FIELDS)
    assert handoff["FAILED"] == []


if __name__ == "__main__":
    tests = [
        test_micro_and_low_reasoning,
        test_standard,
        test_complex_without_phases_emits_plan_only,
        test_complex_with_explicit_phases_preserves_boundaries,
        test_nested_complex_phase_stops_at_its_own_plan,
        test_required_fields_fail_closed,
        test_invalid_explicit_outcome_fails_closed,
        test_unknown_usage_is_not_zero,
        test_handoff_contract,
    ]
    for test in tests:
        test()
    print(f"NEXIA adaptive task batching: PASS {len(tests)}/{len(tests)}")

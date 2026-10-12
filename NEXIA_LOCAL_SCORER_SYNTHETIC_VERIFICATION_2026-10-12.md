# Local capability scorer verification — 2026-10-12
Status: VERIFIED_SYNTHETIC_ONLY.

## Canonical boundary
GitHub NEXIA_STATE.json v70 remains canonical and unchanged.
EXP-AUTO-001 remains the sole monetization experiment. No economic stage or authority changed.
Later operational events remain pending a separate canonical reconciliation.

## Design
Source: NEXIA_LOCAL_CAPABILITY_SCORING_SPEC_2026-10-12.md.
Offline JSON input to stdout. No probes, network, subprocesses or writes in scorer.
Uses existing screening thresholds; these are internal assumptions, not vendor requirements.
NVIDIA telemetry is preferred; WMI-only VRAM remains UNKNOWN rather than a confident fallback.
No rounding up RAM, summing GPU memory or converting missing/invalid values to zero.
Maximum free volume is not proof of SSD space or selected target suitability.
Node gate is separate; installed dependencies, backend and toolkit compatibility remain unverified.
No installation is authorized by the output.

## Synthetic evidence
8/8 synthetic tests PASS using existing runtime; no dependencies installed.
High/mid/low scenarios, telemetry preference, unknown/invalid inputs, boundaries,
RAM rounding, GPU summing, input immutability and Node/authority gates covered.
Source and tests re-read from GitHub and matched tested text exactly.
Scorer blob: c5cb2a677d940484355964d14cdcf7bed4db2781.
Test blob: 3f8a1fca549daba0e175893fa9d3db05f80a8088.

## Audit script static boundary
tools/nexia_pc_audit.ps1 exists; blob a9c5cd5abed2634735df11c116408285d54425aa.
Source inspection and syntax parsing only for this claim.
It writes/overwrites OutputPath through Set-Content and invokes installed executables.
Therefore its read-only label describes intended inventory, not strict absence of writes/side effects.
It suppresses errors and can map missing memory readings to zero.
The scorer does not validate those zeros as reliable measurements.
No changes made to the audit script.

## Limits and next point
Synthetic tests do not prove local inference, speed, stability, output quality, licensing or profitability.
No hardware inventory or local-environment details are included in this public artifact.
Generic RAM thresholds can be brittle near boundaries; below threshold is not incompatibility proof.
STATE/BOOT/LIVE linkage check: zero errors; warnings remain for unverified MEMORY snapshot.
Existing MEMORY stale notice and later event reconciliation remain unresolved, not silently repaired.
Before any installation proposal: review exact code, dependencies, licenses, model requirements and target disk;
obtain separate authorization for computer changes. No installs/downloads configured by this batch.
Cash spend EUR0; economic result NONE.
Rollback: revert scorer/tests/docs and derived handoff only; immutable events require a new corrective event.

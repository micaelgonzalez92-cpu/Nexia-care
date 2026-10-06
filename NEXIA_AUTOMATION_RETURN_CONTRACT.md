# NEXIA Automation Return Contract
Version: 1.0
Status: ACTIVE / DESIGN CONTRACT
Updated: 2026-10-07

## Purpose
Close the verification gap between scheduled automation execution and canonical NEXIA state.

## Rule
An automation run is NOT considered completed merely because it has a run timestamp. Completion requires a machine-readable result delivered to the parent control thread and verified by NEXIA.

## Required result envelope
Every autonomous run should finish with:

RUN_ID: <stable run identifier>
TASK: <automation/task name>
STATUS: COMPLETED | BLOCKED | NO_CHANGE | FAILED
ACTION: <what was actually attempted>
RESULT: <what actually happened>
EVIDENCE: <observable evidence or "NONE">
STATE_CHANGE: YES | NO | UNKNOWN
STATE_TARGET: <path/version if applicable>
COST_EUR: <actual cost, normally 0>
EXTERNAL_ACTION: YES | NO
HUMAN_GATE: NONE | REQUIRED
BLOCKER: <blocker or "NONE">
NEXT_ACTION: <single recommended next action>

## Verification contract
1. REQUESTED: run request accepted.
2. EXECUTED: execution timestamp exists.
3. RESULT_RECEIVED: structured result reached parent.
4. RESULT_VERIFIED: claims are supported by observable evidence.
5. PERSISTED: canonical STATE/event log updated only when appropriate.
6. CHECKPOINTED: changed persistence artifacts reread and verified.

Only steps 1-2 may be inferred from the automation scheduler alone.

## Failure semantics
- Missing result => UNKNOWN, never COMPLETED.
- Result without evidence => unverified claim.
- Claimed STATE change without reread => not persisted.
- Any financial/external/irreversible action remains subject to existing Human Gates.
- Do not create additional automations solely to compensate for missing observability.

## Architecture
Control Tower / Worker -> structured result -> notify_parent -> NEXIA verification -> canonical STATE/event log -> checkpoint.

This contract does not claim that the runtime adapter is implemented. Runtime implementation must be separately verified.

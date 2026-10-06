# NEXIA — AUTOMATION RESULT RETURN CONTRACT

Status: DESIGN VERIFIED / ADAPTER NOT DEPLOYED
Purpose: close the execution feedback loop without treating scheduled execution as proof of result.

## Required lifecycle

REQUESTED -> EXECUTED -> RESULT_RECEIVED -> RESULT_VERIFIED -> PERSISTED -> CHECKPOINTED

Missing evidence means UNKNOWN. Never infer completion from last_run_time alone.

## Result envelope

RUN_ID
TASK
STATUS: COMPLETED | BLOCKED | NO_CHANGE | FAILED
ACTION
RESULT
EVIDENCE
STATE_CHANGE: YES | NO | UNKNOWN
STATE_TARGET
COST_EUR
EXTERNAL_ACTION
HUMAN_GATE
BLOCKER
NEXT_ACTION

## Acceptance criteria

1. The automation execution produces the envelope.
2. The envelope reaches the parent/control-plane through an observable return path.
3. NEXIA verifies the evidence and rereads canonical NEXIA_STATE.json before claiming persistence.
4. Only verified state changes are checkpointed.
5. If notification/return is unavailable, the run remains UNKNOWN/UNVERIFIED.
6. No external action, spending, or irreversible change is introduced by this contract.

## Current gap

The Automations connector exposes execution registration and last_run_time, but the current conversational surface does not expose a verified automation-result payload after execution. Therefore the return path is not yet proven.

## Minimum reversible adapter target

Automation worker
-> structured result envelope
-> authenticated/observable result sink or parent notification
-> NEXIA verification
-> canonical STATE/event log
-> checkpoint

Do not deploy a 24/7 worker or claim closed-loop automation until the result path and verification test pass end-to-end.

## Current safe next test

Trigger one existing Control Tower run after the contract is active and require an observable result envelope. If none arrives, classify the gap as capability/connector limitation rather than execution failure.

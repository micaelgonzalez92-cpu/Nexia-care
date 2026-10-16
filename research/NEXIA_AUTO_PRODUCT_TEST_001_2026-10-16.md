# AUTO-PRODUCT-TEST-001 — Reliability Differentiation Pre-runtime Test

Date: 2026-10-16
Status: REFERENCE_CONTRACT_PASS / N8N_RUNTIME_NOT_EXECUTED
Lane: VETA-AUTO-PRODUCT-001
Cash spend: EUR0
External action: NONE

## Objective
Determine whether the Lead Intake Reliability Kit can define a materially stronger reliability contract than generic/free lead-intake templates before investing in distribution.

## Trigger evidence
Fresh market scan found current free and low-cost alternatives that already cover validation, normalization, deduplication, QA/checklists, human approval and multi-workflow packs. A specific competitive gap emerged: explicit classification of exact idempotent replay vs conflicting reuse of the same event key.

## Current v0.1 finding
The current persistent guard stores `eventKey`, `identityKey`, and `recordId` and uses `rowNotExists` checks. It blocks duplicate events/identities, but it does not persist a payload fingerprint and therefore cannot truthfully claim explicit exact-vs-conflicting replay semantics.

Result: `V0_1_GAP_VERIFIED_BY_STATIC_INSPECTION`.

## V0.2 reference contract
Artifact: `products/lead-intake-reliability-kit/REPLAY_CONFLICT_V02_DESIGN.md`
Reference test: `products/lead-intake-reliability-kit/test_replay_contract_v02.js`
Synthetic conflict fixture: `products/lead-intake-reliability-kit/samples/conflicting-replay.json`

Decision states:
- NEW_ACCEPTED
- EXACT_REPLAY
- CONFLICTING_REPLAY
- DUPLICATE_IDENTITY
- INVALID

All states retain `autonomous_send=false`.

## Executed reference test
Runtime: local isolated Node.js reference execution in Nexia's analysis environment; no n8n, no customer data, no external side effects.

Observed output:
`{"pass":true,"contract":"REPLAY_CONFLICT_V02_REFERENCE","states":["NEW_ACCEPTED","EXACT_REPLAY","CONFLICTING_REPLAY","DUPLICATE_IDENTITY","INVALID"],"runtime":"NODE_REFERENCE_ONLY_NOT_N8N"}`

Classification: **HECHO VERIFICADO — REFERENCE CONTRACT PASS ONLY**.

This proves the decision semantics are internally coherent in the reference model. It does NOT prove the n8n workflow implementation, Data Table persistence, upgrade migration, restart behavior or customer usability.

## Next implementation gate
Before replacing v0.1:
1. build a v0.2 n8n candidate with payloadHash persistence;
2. run static product tests;
3. run synthetic n8n runtime cases for every state;
4. verify separate webhook executions and persistence;
5. verify zero external sends;
6. measure clean install + smoke test time;
7. keep <=30 minute setup target preregistered.

## Stop rule
Do not publish or change commercial claims merely because the reference contract passes. Product differentiation is not validated until n8n runtime + clean-install gates pass.

## Economic truth
Spend EUR0. Publication 0. Accounts 0. Customers 0. Sales 0. Settled revenue EUR0. Profit EUR0.

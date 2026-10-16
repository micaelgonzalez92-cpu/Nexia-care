# AUTO-PRODUCT V0.2.1 — observability repair preregistration

Date: 2026-10-17
Status: FROZEN_BEFORE_OBSERVABILITY_REPAIR_RUN_OUTPUTS
Authority: GREEN internal verification; EUR0; synthetic data only; no credentials, publication, external messaging or production deployment.

## Why a new run is justified
The first V0.2.1 serialized-profile run produced the exact frozen decision distributions for all four bursts, but its persistence audit was not capable of returning all Data Table rows. The audit Webhook used `responseMode: lastNode` without `responseData`; in n8n 2.42.6 that defaults to `firstEntryJson`. Therefore observations of `total: 1` cannot adjudicate table cardinality and the persistence portion of that run is invalid/inconclusive, not a demonstrated persistence failure.

This rerun is not a retry to hunt for a pass. It repairs measurement only.

## Candidate logic frozen unchanged
- `experiments/auto-product-v02/bootstrap-v02.json`
- `experiments/auto-product-v02/guard-v02.json`
- same SHA-256 fingerprint and five-state contract
- `N8N_CONCURRENCY_PRODUCTION_LIMIT=1`
- n8n 2.42.6 / Node.js 24.21.0 / Ubuntu 24.04
- same 12-request bursts and exact thresholds from the original V0.2.1 preregistration

## Instrumentation repair
Use a separate read-only audit workflow:
`experiments/auto-product-v021/audit-all-entries-v021.json`

Required Webhook parameters:
- `responseMode: lastNode`
- `responseData: allEntries`

No product decision/write logic is changed.

## Independent persistence cross-check
After the stress harness finishes, inspect the fresh n8n SQLite database directly:
1. discover the sole `data_table_user_*` physical table;
2. read eventKey, identityKey, recordId and payloadHash rows directly;
3. require exactly 4 rows;
4. require unique eventKey and identityKey;
5. require each payloadHash to be lowercase 64-char SHA-256 hex;
6. require the direct SQLite row set to match the allEntries audit row set on those four fields.

## Frozen decision thresholds
A1/A2/A3 each: exactly 1 NEW_ACCEPTED + 11 EXACT_REPLAY, no other/missing/error state.
B: exactly 1 NEW_ACCEPTED + 11 DUPLICATE_IDENTITY, no other/missing/error state.
All decisions: autonomous_send=false.

## Outcome semantics
PASS only if decision thresholds, allEntries audit invariants, and direct SQLite invariants all pass in the same bounded run.
Any mismatch is FAIL and is preserved. No threshold weakening or selective retry.

A PASS establishes only bounded synthetic correctness for this exact dedicated serialized profile. It does not establish unsserialized concurrency safety, arbitrary-scale correctness, shared-instance suitability, production readiness, commercial value or professional/top-tier capability.

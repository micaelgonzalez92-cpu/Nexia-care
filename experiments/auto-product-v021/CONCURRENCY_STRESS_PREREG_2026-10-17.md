# AUTO-PRODUCT V0.2.1 SERIALIZED_PROFILE — concurrency stress preregistration

Date: 2026-10-17
Status: FROZEN_BEFORE_V021_STRESS_OUTPUTS
Authority: GREEN internal verification; EUR0; synthetic data only; no credentials, publication, external messaging or production deployment.

## Exact repair under test
- Exact V0.2 candidate workflow bytes are reused unchanged.
- Runtime profile changes materially: `N8N_CONCURRENCY_PRODUCTION_LIMIT=1`.
- n8n 2.42.6 / Node.js 24.21.0 / Ubuntu 24.04 / regular mode.
- Dedicated-test-instance assumption.

## Stress
Concurrency per burst: 12 HTTP requests.

### A — same event, same payload
Run 3 fresh bursts. PASS per burst requires exactly:
- 1 `NEW_ACCEPTED`
- 11 `EXACT_REPLAY`
- 0 other/missing/error states
- one persisted row for that eventKey
- lowercase 64-char SHA-256 payloadHash

### B — distinct events, same identity
Run one fresh burst of 12. PASS requires exactly:
- 1 `NEW_ACCEPTED`
- 11 `DUPLICATE_IDENTITY`
- 0 other/missing/error states
- one persisted row for that identityKey

### Global invariant
Exactly 4 rows persisted after A1+A2+A3+B; no duplicate eventKey or identityKey; every decision has `autonomous_send=false`.

## Runtime-control verification
The run must also verify that the n8n server starts with `N8N_CONCURRENCY_PRODUCTION_LIMIT=1`. The test is invalid if the environment variable is absent or not equal to `1`.

## Failure semantics
Any invariant violation is FAIL. Preserve evidence. No selective retry or threshold change. A failure leaves V0.2.1 unverified and V0.1 unchanged.

## Pass semantics
One passing bounded run establishes only `BOUNDED_SYNTHETIC_CONCURRENCY_PASS_SERIALIZED_PROFILE_12X3_PLUS_12X1` for this exact runtime profile and candidate bytes. It does not prove unsserialized concurrency safety, shared-instance suitability, arbitrary-scale correctness, production readiness or commercial value.

## Promotion
No product promotion in this stress task. Promotion is a separate change after evidence capture and regression review.

# AUTO-PRODUCT V0.2 — concurrency stress preregistration

Date: 2026-10-17
Status: FROZEN_BEFORE_STRESS_OUTPUTS
Authority: GREEN internal verification; EUR0; synthetic data only; no external messaging, no credentials, no publication.

## Purpose
Attempt to falsify the sequentially verified V0.2 replay/dedup candidate under concurrent webhook executions before any product promotion.

## Frozen environment
- Ubuntu 24.04 GitHub-hosted runner.
- Node.js 24.21.0.
- n8n 2.42.6.
- Exact candidate files already persisted under `experiments/auto-product-v02/`.
- Native n8n Data Table `lead_intake_reliability_keys_v02`.
- `autonomous_send=false`; no outbound action nodes.

## Stress design
Concurrency per burst: 12 requests.

### Test A — same event replay race
Run 3 independent bursts. Within each burst all 12 requests have the same fresh `event_id` and same fresh identity for that burst. Bursts use distinct event IDs and identities.

PASS per burst requires all of the following:
1. exactly one response is `NEW_ACCEPTED`;
2. exactly 11 responses are `EXACT_REPLAY`;
3. no response is `CONFLICTING_REPLAY`, `DUPLICATE_IDENTITY`, `INVALID`, or another state;
4. audit contains exactly one persisted row for that burst eventKey;
5. its payloadHash is a 64-character lowercase SHA-256 hex string.

### Test B — same identity / distinct event race
Run one burst of 12 concurrent requests. All have distinct fresh `event_id` values but the same fresh email identity and otherwise equivalent payload.

PASS requires all of the following:
1. exactly one response is `NEW_ACCEPTED`;
2. exactly 11 responses are `DUPLICATE_IDENTITY`;
3. no other state appears;
4. audit contains exactly one persisted row for that identityKey.

## Global persistence invariant
After the three Test-A bursts and one Test-B burst, audit must contain exactly 4 rows total: one row per A burst plus one row for B. There must be no duplicate eventKey and no duplicate identityKey among persisted rows.

## Failure semantics
Any violated invariant is a material stress FAIL for concurrent correctness. Preserve the output. Do not weaken thresholds, retry selectively, delete evidence, or promote the candidate on a failed run. A failure does not invalidate the prior sequential runtime pass; it narrows it to sequential/low-contention behavior.

## Pass semantics
A single bounded CI PASS establishes `CONCURRENCY_STRESS_PASS_BOUNDED_12X_3_PLUS_12X_1` for this exact candidate/environment only. It does not establish arbitrary-scale linearizability, production readiness, commercial value, or professional/top-tier capability.

## Promotion rule
Do not replace `products/lead-intake-reliability-kit/workflows/*` unless this stress passes and the exact candidate hashes are captured. Product promotion remains a separate internal change followed by product-level regression verification.

# AUTO-PRODUCT V0.2.1 — SERIALIZED_PROFILE design

Date: 2026-10-17
Status: INTERNAL_REPAIR_DESIGN_NOT_YET_STRESS_VERIFIED
Authority: GREEN internal architecture/test; EUR0; synthetic data only.

## Problem falsified in V0.2
The V0.2 workflow passed bounded sequential n8n runtime verification but failed its first frozen concurrency burst: 12 simultaneous requests for one event produced 5 `NEW_ACCEPTED` responses and 7 responses without a state, versus the required 1 `NEW_ACCEPTED` + 11 `EXACT_REPLAY`.

The workflow's `rowExists`/`rowNotExists` decision and later Data Table insert are separate operations across independent webhook executions. That architecture does not provide a demonstrated atomic claim.

## Repair profile
V0.2.1 keeps the exact V0.2 workflow bytes and changes the deployment/runtime contract:

`N8N_CONCURRENCY_PRODUCTION_LIMIT=1`

Scope: a dedicated n8n instance/runtime assigned to this lead-intake reliability workflow or to workloads that explicitly accept production serialization.

Why this is materially different from rerunning V0.2:
- n8n's concurrency-control service creates a bounded production queue when the configured production limit is positive;
- webhook executions use the production queue;
- `throttle()` awaits queue capacity and `release()` dequeues the next execution;
- therefore a configured limit of 1 is intended to serialize production webhook execution at the n8n runtime boundary.

## Explicit tradeoff
This is an instance-level production concurrency cap, not a per-workflow mutex. Applying it to a shared high-throughput n8n instance could reduce throughput and couple unrelated production workflows. Therefore V0.2.1 is acceptable only as a dedicated/small-instance profile unless later evidence establishes a narrower concurrency-safe primitive.

## Rejected/deferred alternatives
1. **Unchanged check-then-insert** — rejected: bounded stress already falsified concurrency safety.
2. **Remove Duplicates node as atomic lock** — not selected: its helper reads processed data and then inserts/updates it; no concurrency-safe compare-and-record guarantee has been established for this use.
3. **Execution `deduplicationKey` unique index** — architecturally attractive: n8n implements a unique DB index specifically so concurrent equal keys fail atomically. However n8n 2.42.6 source states current use is Schedule Trigger and webhook idempotency is future use, so it is not an ordinary Webhook-node capability in the tested version.
4. **External database unique constraint** — deferred: can provide strong atomic claims but adds external service/credential/deployment complexity; unnecessary before falsifying the native serialized profile.
5. **Queue-mode/dedicated Redis worker** — deferred: more infrastructure than the current bounded need.

## Product boundary
A V0.2.1 technical pass would establish only:
`BOUNDED_SYNTHETIC_REPLAY_CONFLICT_CORRECTNESS_UNDER_DEDICATED_N8N_SERIALIZED_PROFILE`

It would not establish:
- arbitrary concurrent correctness without serialization;
- shared-instance suitability;
- production readiness;
- commercial demand or value;
- professional/top-tier capability.

Product V0.1 remains unchanged until a separate promotion decision and regression pass.

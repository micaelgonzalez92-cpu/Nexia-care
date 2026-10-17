# NEXIA ADAPTIVE TASK BATCHING — STANDARD V1

Date: 2026-10-17  
Status: INTERNAL CANDIDATE / EUR0 / DETERMINISTIC-FIRST  
Authority: GREEN internal capability. This standard does not authorize publication, external contact, spend, account changes, production activation, KYC, payment, destructive actions, or expansion of Kael authority.

## Objective

Reduce unnecessary Work/Codex quota consumption and context churn without over-fragmenting work. The target is not the smallest possible task. The target is the smallest **self-contained packet that produces one verifiable outcome**.

## Core rule

`LARGE GOAL -> CLASSIFY -> MINIMUM CONTEXT -> BOUNDED PACKET -> VERIFY -> COMPACT HANDOFF -> NEXT PACKET -> INTEGRATION CHECK`

Do not replace this with either extreme:

- one monolithic Work/Codex run that repeatedly rereads broad context until quota is exhausted;
- dozens of tiny tasks that repeatedly pay startup/recovery/context costs.

## Packet sizes

### MICRO

Use for a localized diagnosis, edit, extraction, one targeted test, or one bounded decision with low coordination cost.

### STANDARD

Default implementation unit. It may include implementation plus the tests directly required to prove the same outcome.

### COMPLEX

A coordination label, not an execution packet. Complex work should first be decomposed into dependency-ordered STANDARD packets when real phases are known. If phases are not yet known, emit one MICRO planning packet and stop before material implementation.

Size classification is heuristic and adaptive. V1 intentionally does **not** impose hard token or file-count limits. Those thresholds require observed telemetry first.

## Context policy — progressive disclosure

Each packet starts with:

- objective;
- one verifiable outcome;
- success condition;
- stop condition;
- authority/effects/cost ceiling;
- `must_read` context;
- optional context;
- minimum relevant verification;
- Process Intelligence query when prior history may apply.

Rules:

1. Do not read the entire repository by default.
2. `must_read` should be the minimum sufficient set.
3. Read optional context only when a concrete dependency, contradiction, or failed acceptance check requires it.
4. Reuse canonical artifacts, Process Intelligence and prior packet handoffs instead of pasting long historical context again.
5. Do not duplicate policy blocks already available through `AGENTS.md`, canonical governance files or focused skills.

## Work/Codex routing policy

Use the minimum sufficient surface and reasoning level.

- Deterministic work should prefer verified zero-quota/local/CI paths when those paths actually cover the task.
- Normal Chat should handle research/analysis that does not require Work/Codex execution.
- Codex should be used for code/repository work that materially benefits from an execution environment.
- Work should be used for multi-step GUI/browser/app execution when required.
- Low reasoning is preferred for bounded routine work.
- Medium is the default for ordinary implementation.
- High is reserved for high uncertainty, high risk, architecture-level coordination or failed lower-effort attempts.
- Fast/accelerated modes are not default; use them only when wall-clock urgency has material value.

These are routing preferences, not truth claims about exact token savings. Product quota/token usage is recorded only when the surface exposes it.

## Verification policy

Every packet ends in one of:

- VERIFIED;
- FAILED;
- BLOCKED;
- WAITING_HUMAN_GATE;
- PLAN_READY.

Run the smallest verification that actually proves the packet outcome. Full integration/CI suites are reserved for integration checkpoints, canonical persistence changes, release/promotion gates, or when a targeted check cannot establish the claim.

Never relabel a commit, syntax check, unit test, synthetic test, browser preview, publication, client acceptance, payment, or production result as something it does not prove.

## Compact handoff contract

Every completed packet should be reducible to:

- `DONE` — what actually happened;
- `EVIDENCE` — tests/readbacks/postconditions;
- `CHANGED` — exact artifacts changed;
- `FAILED` — unresolved failed checks;
- `NEXT` — one bounded next packet or gate;
- `MUST_READ` — minimum context for the next packet.

The next packet should consume this handoff plus referenced artifacts, not reconstruct the whole conversation.

## Telemetry contract

Record when observable:

- packet size;
- surface;
- model;
- reasoning level;
- files initially loaded;
- files finally used;
- wall time;
- retries;
- quota before/after;
- input/output tokens when explicitly exposed;
- result.

`UNKNOWN/NOT_INSTRUMENTED` is not zero. Do not infer product token usage from message length or invent quota consumption.

## Learning loop

After enough real runs, compare MICRO/STANDARD/COMPLEX routing on:

- verified outcome rate;
- retries;
- wall time;
- human intervention;
- files/context loaded versus actually used;
- quota delta when observable;
- repeated startup/recovery work.

Only then introduce empirical thresholds. If smaller packets increase repeated context cost or coordination failures, increase packet size. If large packets consume excessive quota or drift, reduce packet size.

## Interaction with Process Intelligence

Before material work, query Process Intelligence when prior Nexia history may contain relevant lessons. The batching layer controls **how much current work is given to an execution surface**; Process Intelligence controls **which prior lessons should be loaded**. Neither overrides STATE, authority or direct evidence.

## Stop rule

Do not add a scheduler, vector database, autonomous quota controller, new account, paid service or background runtime merely to optimize quota. V1 remains deterministic and repository-native until measured execution data demonstrates a named bottleneck.

## Definition of done for V1

V1 is ready for current purpose when:

1. a deterministic task-packet generator exists;
2. MICRO/STANDARD/COMPLEX behavior is regression-tested;
3. missing usage telemetry remains UNKNOWN;
4. complex tasks without known phases stop at planning;
5. `AGENTS.md` instructs agents to use bounded packets for large Work/Codex work;
6. CI contains the regression test;
7. no claim of token/quota savings is made before measured evidence exists.

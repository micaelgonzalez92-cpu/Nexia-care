# NEXIA PROCESS INTELLIGENCE — STANDARD V1

Date: 2026-10-17  
Status: ACTIVE INTERNAL / EUR0 / DETERMINISTIC-FIRST  
Authority: GREEN internal capability. Does not authorize publication, external contact, spend, account changes, production activation, KYC, payment, or destructive actions.

## Objective

Convert Nexia's canonical execution history into reusable process knowledge so future work starts from verified prior experience instead of repeating avoidable failures, research, or manual friction.

The system separates:

- **episode** — one immutable historical event normalized into a compact process record;
- **lesson** — a reusable rule derived from one or more canonical episodes;
- **metric** — aggregate process signal that does not overwrite UNKNOWN/NOT_INSTRUMENTED;
- **recommendation** — lessons ranked for a new task by deterministic query matching.

This layer is derived intelligence. It never overrides `NEXIA_STATE.json`, active event indexes, immutable events, authority gates, or direct external evidence.

## Pre-task rule

Before a MATERIAL task when prior Nexia history may be relevant:

1. classify the task;
2. query Process Intelligence for matching lessons;
3. apply relevant guardrails before execution;
4. execute and verify the task normally;
5. capture material new learning in an immutable event;
6. regenerate/query Process Intelligence on the next relevant run.

Typical command:

```bash
python3 tools/nexia_process_miner.py --query "n8n dedup concurrency workflow" --json
```

To validate the complete canonical history without writing derived files:

```bash
python3 tools/nexia_process_miner.py --check --json
```

To generate local derived artifacts:

```bash
python3 tools/nexia_process_miner.py
```

Outputs:

- `intelligence/NEXIA_PROCESS_EPISODES.jsonl`
- `intelligence/NEXIA_PROCESS_LESSONS.json`
- `intelligence/NEXIA_PROCESS_METRICS.json`

Generated outputs are reproducible derived artifacts and are not canonical state by themselves.

## Extraction contract

The miner must:

- discover the active event index from `NEXIA_BOOT.json` unless an index is explicitly supplied;
- traverse the composite index chain oldest to newest;
- reject index cycles and excessive depth;
- verify referenced event Git blob SHAs when hashes exist;
- preserve events with missing historical hash bindings as explicit diagnostics rather than fabricating verification;
- normalize event IDs, type, evidence label, outcome, authority, cost when explicitly present, external-effect flag, run/job IDs, truth boundary, root-cause hypothesis, next action, stop rationale, tags, and failure signals;
- never convert missing human-time or economic data to zero;
- never infer sales, production readiness, demand, professional quality, or arbitrary-scale reliability from bounded technical tests.

## Initial reusable lesson classes

V1 derives rules for at least:

1. **Stateful concurrency safety** — sequential success is not concurrency proof.
2. **Observability cross-check** — a measurement defect must be separated from business-logic correctness.
3. **Preregistration** — freeze thresholds/attempt rules before material outputs.
4. **No pass hunting** — do not rerun unchanged falsified candidates merely to obtain a pass.
5. **Truth boundaries** — carry tested scope and non-established claims forward.
6. **Platform media compatibility** — source-file validity does not guarantee platform upload compatibility; verify one derivative before scaling.

Lessons keep source event IDs and paths so every recommendation is traceable.

## Metrics contract

Metrics may count:

- event references and normalized episodes;
- PASS / FAIL / INCONCLUSIVE / OTHER outcomes;
- evidence labels;
- events with truth boundaries, next actions, or failure signals;
- lesson categories and recurring tags.

Event-level reported-cost sums are explicitly labeled as potentially overlapping and must not be used as project cash-spend truth.

Human attention remains `NOT_INSTRUMENTED` unless explicit source evidence exists.

## Quality and falsification

A Process Intelligence recommendation is not proof that the same failure will recur. It is a risk-control prior.

When a lesson conflicts with fresher direct evidence:

1. preserve the old lesson and provenance;
2. execute a bounded falsification/verification;
3. create a new canonical event;
4. update the derived lesson on regeneration.

Do not silently rewrite historical failures.

## Stop rule

Do not add ML/vector infrastructure merely because the corpus exists. V1 remains deterministic and standard-library-only until measured retrieval quality or corpus scale demonstrates a material gap.

A future semantic retrieval layer requires a named bottleneck, benchmark against this deterministic baseline, privacy/license review, bounded POC, rollback, and evidence of net benefit.

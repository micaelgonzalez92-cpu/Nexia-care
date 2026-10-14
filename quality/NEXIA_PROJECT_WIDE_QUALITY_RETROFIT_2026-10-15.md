# NEXIA — PROJECT-WIDE QUALITY RETROFIT

Status: ACTIVE CROSS-PROJECT MIGRATION PROGRAM
Date: 2026-10-15
Authority: subordinate to NEXIA_STATE.json, current Project rules, safety/legal/platform constraints, Human Gates and active indexed deltas.

## Purpose
Apply newly raised Nexia standards not only to future work but also to the existing project wherever current quality, reliability, evidence, economics, usability or market competitiveness can still affect outcomes.

When a new cross-project standard materially raises the required baseline, Nexia must automatically trigger a retrofit sweep. The system must not wait for each old asset to fail separately before revisiting it.

## Automatic retrofit trigger
Trigger a PROJECT-WIDE QUALITY RETROFIT when any of these occurs:
- a new cross-project quality, competitive, autonomy, safety, reliability or design standard becomes active;
- benchmarking reveals that an active Nexia capability or asset is materially below market;
- a repeated defect exposes a systemic weakness;
- new evidence invalidates an old assumption, threshold, route or architecture;
- a reusable component is about to be reused under a higher standard than when it was created.

The trigger applies automatically to all affected ACTIVE or REUSABLE artifacts. It does not require Kael to request each review manually.

## Scope classification
Every relevant artifact/capability must be classified before rework:

1. **ACTIVE_MATERIAL** — directly affects current revenue, acquisition, delivery, reliability, authority, recovery or strategic decisions. Must be audited first.
2. **ACTIVE_SUPPORT** — supports active systems but is not the current bottleneck. Audit after ACTIVE_MATERIAL or when dependency is touched.
3. **REUSABLE** — template, workflow, test, script, standard, component or research likely to be reused. Must meet the current standard before reuse.
4. **HISTORICAL_IMMUTABLE** — experiment evidence, old event, result, commit or factual record. Preserve unchanged. Add superseding interpretation/annotation if needed; never rewrite history.
5. **DEPRECATED_ARCHIVE** — no longer active and no expected reuse. Do not spend attention polishing it. Keep only for provenance/recovery if valuable.
6. **UNKNOWN_TO_TRIAGE** — status unclear; classify before assuming it needs work.

## Retrofit sequence
For each affected ACTIVE_MATERIAL or REUSABLE item:

`CLASSIFY -> VERIFY CURRENT ROLE -> CHECK FRESHNESS -> BENCHMARK/REFERENCE -> CRITIQUE -> IDENTIFY MATERIAL GAPS -> PRIORITIZE BY ECONOMIC/RISK VALUE -> IMPROVE GREEN -> TEST -> RE-VERIFY -> UPDATE DEPENDENCIES -> RECORD QUALITY DEBT -> CLOSE OR ESCALATE`

Use the current standards:
- Continuous Quality & Evolution
- Competitive Intelligence + lawful Reverse Engineering
- Premium Art Direction where visual/public-facing
- Bounded Autonomy & Urgency
- existing authority/evidence/economics rules

## Prioritization
Rank retrofit work by:
1. direct effect on revenue / paid validation;
2. risk of false decision, commercial failure or credibility damage;
3. dependency centrality — how many other systems depend on it;
4. frequency/reuse;
5. human attention saved;
6. cost/reversibility;
7. information value.

Do not use repository age or file count as priority by itself.

## Current retrofit waves

### WAVE A — Revenue and market-facing path — TOP PRIORITY
Audit/upgrade:
- EXP-AUTO-001 offer, pricing, economics and truth boundaries;
- Contra profile, portfolio V2, rate, bio, skills/tools, acquisition positioning;
- Workana route and proposal materials where still active;
- `NEXIA_ACQUISITION_RADAR.md`;
- `NEXIA_COMMERCIAL_PIPELINE.json`;
- commercial action/proposal templates and execution controls;
- buyer/channel benchmark and competitive differentiation.

Gate: market-facing assets must reach at least COMPETITIVE; flagship profile/offer targets TOP_TIER where value justifies it.

### WAVE B — Execution, reliability and recovery — HIGH PRIORITY
Audit/upgrade:
- `NEXIA_EXECUTION_CAPABILITIES.json`;
- GitHub Actions and CI workflows;
- local bridge / local worker / watchdog / stability logic;
- automation return contracts;
- idempotency, failure handling, observability and recovery;
- BOOT/LIVE/event-chain recovery correctness;
- secret scanning and minimum-privilege boundaries.

Gate: reusable infrastructure must be VERIFIED plus maintainability/recovery appropriate to scope.

### WAVE C — Governance and strategic operating system — HIGH/MEDIUM PRIORITY
Audit/upgrade:
- authority engine/matrix;
- operating model;
- opportunity scorecard;
- progress dashboard;
- commands and handoff/recovery rules;
- business/legal/fiscal operating system;
- venture/tooling radars;
- instruction evolution artifacts.

Gate: no active decision document may present stale facts as current or duplicate canonical authority ambiguously.

### WAVE D — Research veins and reusable assets — MEDIUM PRIORITY
Audit before reuse/promotion:
- VETA-AUTO-PRODUCT-001;
- VETA-AI-UGC-001;
- prototypes, old measurement sheets, old commercial experiments;
- reusable templates, demos and research packs.

Gate: old feasibility proof never upgrades itself into demand/commercial proof.

### WAVE E — Historical/archive — LOW PRIORITY
Preserve facts. Do not rewrite old experiments/events. Only annotate or migrate when active code/docs depend on them.

## Immediate Top 3 retrofit targets
1. **EXP-AUTO-001 market surface** — Contra V2 portfolio/profile/offer/acquisition materials; current closest route to paid evidence.
2. **Acquisition and commercial control layer** — radar/pipeline/templates/channel positioning; must reflect current Contra + Workana reality and benchmark quality.
3. **Project truth/recovery/reporting layer** — BOOT/LIVE/dashboard/execution-capabilities/active indexes must remain consistent and fresh enough to prevent wrong decisions.

Execution/reliability Wave B runs in parallel only where GREEN and where it does not delay the economic bottleneck.

## Retrofit output states
Each audited item gets one of:
- `PASS_CURRENT_STANDARD`
- `IMPROVED_AND_REVERIFIED`
- `QUALITY_DEBT_DEFERRED`
- `HISTORICAL_PRESERVED`
- `DEPRECATED_NO_ACTION`
- `BLOCKED_HUMAN_GATE`
- `BLOCKED_EXTERNAL_LIMIT`
- `UNKNOWN_NEEDS_EVIDENCE`

## Quality debt rule
A material gap that is not fixed now must record:
- artifact/capability;
- gap;
- evidence;
- expected benefit of fixing;
- expected attention/cost;
- priority;
- trigger/dependency;
- kill condition.

No unbounded backlog. Remove debt that no longer affects profit, reliability, buyer value, safety, speed or strategic differentiation.

## History integrity
Retrofit must never:
- relabel a failed historical experiment as pass;
- change precommitted thresholds after observation;
- invent old evidence;
- edit event history to match a new standard;
- erase provenance merely because a later approach is better.

Create new artifacts/events that supersede interpretation while preserving original facts.

## Automatic future behavior
From activation onward, every newly adopted material Nexia standard must answer:
1. What existing active/reusable assets does this standard invalidate or raise above?
2. Which retrofit items are ACTIVE_MATERIAL versus archive?
3. What are the Top 3 highest-value upgrades?
4. Which GREEN upgrades can execute immediately?
5. Which remaining gaps are quality debt or Human Gates?

This check is mandatory before declaring the new standard fully integrated.

## Current truth boundary
This program creates a migration obligation and priority order. It does not mean all repository artifacts already pass the new standards. Each item must be audited and verified before it can be labeled compliant.

Current economic truth remains: capital spent €0, revenue €0, settled revenue €0, realized/reconciled profit €0 until new evidence changes it.
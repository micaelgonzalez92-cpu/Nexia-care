# NEXIA — PROJECT-WIDE QUALITY RETROFIT

Status: ACTIVE CROSS-PROJECT MIGRATION PROGRAM
Date: 2026-10-15
Authority: subordinate to NEXIA_STATE.json, current Project rules, safety/legal/platform constraints, Human Gates and active indexed deltas.

## Purpose
Apply newly raised Nexia standards not only to future work but also to the existing project wherever current quality, reliability, evidence, economics, usability, security, continuity or market competitiveness can still affect outcomes.

When a new cross-project standard materially raises the required baseline, Nexia must automatically trigger a retrofit sweep. The system must not wait for each old asset to fail separately before revisiting it.

The retrofit is **project-wide, not economy-first**. Economic value remains a major objective, but it must not override truth, safety, system integrity, continuity, authority, reliability or strategic leverage.

## Automatic retrofit trigger
Trigger a PROJECT-WIDE QUALITY RETROFIT when any of these occurs:
- a new cross-project quality, competitive, autonomy, safety, reliability, governance or design standard becomes active;
- benchmarking reveals that an active Nexia capability or asset is materially below market or professional standard;
- a repeated defect exposes a systemic weakness;
- new evidence invalidates an old assumption, threshold, route or architecture;
- a reusable component is about to be reused under a higher standard than when it was created.

The trigger applies automatically to all affected ACTIVE or REUSABLE artifacts. It does not require Kael to request each review manually.

## Scope classification
Every relevant artifact/capability must be classified before rework:

1. **ACTIVE_MATERIAL** — directly affects current revenue, acquisition, delivery, reliability, authority, truth, recovery, security, continuity or strategic decisions. Include immediately in global triage.
2. **ACTIVE_SUPPORT** — supports active systems but is not itself a current material decision surface. Include in dependency triage and upgrade when its gap is material or when the dependency is touched.
3. **REUSABLE** — template, workflow, test, script, standard, component or research likely to be reused. Must meet the current standard before reuse.
4. **HISTORICAL_IMMUTABLE** — experiment evidence, old event, result, commit or factual record. Preserve unchanged. Add superseding interpretation/annotation if needed; never rewrite history.
5. **DEPRECATED_ARCHIVE** — no longer active and no expected reuse. Do not spend attention polishing it. Keep only for provenance/recovery if valuable.
6. **UNKNOWN_TO_TRIAGE** — status unclear; classify before assuming it needs work.

## Global triage before execution
When a retrofit is triggered, first map the full affected surface across all domains before assuming the execution order.

Minimum questions:
1. What active or reusable assets are affected?
2. Which assets can create wrong decisions, unsafe behavior, lost continuity or corrupted evidence if stale or weak?
3. Which assets are central dependencies for many others?
4. Which assets affect customers, revenue or paid validation?
5. Which assets are reused frequently or amplify future work?
6. Which gaps are urgent or time-sensitive?
7. Which improvements are cheap/reversible/high-information?

Do not equate commercial proximity with universal priority.

## Hard precedence rules
The following can override all other prioritization dimensions:

1. **Safety / legality / security / privacy / platform-hard constraints**.
2. **Truth and evidence integrity** — canonical state, experiment history, metrics, claims and postconditions.
3. **Authority / Human Gate integrity** — prevent unauthorized external effects, spending or commitments.
4. **Continuity / recoverability / corruption risk** — prevent loss of canonical state or inability to resume correctly.

A critical defect in any of these areas can outrank a revenue-adjacent improvement.

## Multi-axis prioritization model
After hard precedence is satisfied, rank retrofit items using the full decision context. No single remaining dimension automatically dominates.

Evaluate:
- **SYSTEM CRITICALITY** — blast radius if wrong or unavailable.
- **DEPENDENCY CENTRALITY** — number/importance of downstream systems relying on it.
- **ECONOMIC IMPACT** — effect on revenue, contribution, conversion, cost or paid validation.
- **CUSTOMER / USER IMPACT** — reliability, usability, trust and harm prevention.
- **STRATEGIC LEVERAGE** — reuse, defensibility, future optionality and compounding value.
- **URGENCY / TIME SENSITIVITY** — deadlines, expiring opportunities, stale evidence or fast-moving conditions.
- **COMPETITIVE GAP** — degree to which current quality is below relevant market/top-tier references.
- **INFORMATION VALUE** — how much the work improves the next decision or falsifies assumptions.
- **HUMAN ATTENTION EFFECT** — attention saved or imposed on Kael/operations.
- **COST / REVERSIBILITY / RISK** — cash, time, complexity, maintenance, downside and ease of rollback.

Use qualitative ranking (`CRITICAL / HIGH / MEDIUM / LOW`) or a predeclared scorecard when a formal numeric gate is useful. Do not fabricate precision after seeing outcomes.

## Retrofit sequence
For each affected ACTIVE_MATERIAL or REUSABLE item:

`CLASSIFY -> VERIFY CURRENT ROLE -> CHECK FRESHNESS -> MAP DEPENDENCIES -> BENCHMARK/REFERENCE -> CRITIQUE -> IDENTIFY MATERIAL GAPS -> APPLY HARD PRECEDENCE -> MULTI-AXIS PRIORITIZE -> IMPROVE GREEN -> TEST -> RE-VERIFY -> UPDATE DEPENDENCIES -> RECORD QUALITY DEBT -> CLOSE OR ESCALATE`

Use the current standards:
- Continuous Quality & Evolution
- Competitive Intelligence + lawful Reverse Engineering
- Premium Art Direction where visual/public-facing
- Bounded Autonomy & Urgency
- existing authority/evidence/economics rules

## Audit domains — not priority waves
The following are **coverage domains**, not a fixed priority sequence. They can be triaged in parallel and their execution order is decided by hard precedence + multi-axis priority.

### DOMAIN A — Market, revenue and customer-facing
Audit/upgrade:
- EXP-AUTO-001 offer, pricing, economics and truth boundaries;
- Contra profile, portfolio V2, rate, bio, skills/tools, acquisition positioning;
- Workana route and proposal materials where still active;
- `NEXIA_ACQUISITION_RADAR.md`;
- `NEXIA_COMMERCIAL_PIPELINE.json`;
- commercial action/proposal templates and execution controls;
- buyer/channel benchmark and competitive differentiation.

Gate: market-facing assets must reach at least COMPETITIVE; flagship profile/offer targets TOP_TIER where value justifies it.

### DOMAIN B — Execution, reliability, security and recovery
Audit/upgrade:
- `NEXIA_EXECUTION_CAPABILITIES.json`;
- GitHub Actions and CI workflows;
- local bridge / local worker / watchdog / stability logic;
- automation return contracts;
- idempotency, failure handling, observability and recovery;
- BOOT/LIVE/event-chain recovery correctness;
- secret scanning and minimum-privilege boundaries.

Gate: reusable infrastructure must be VERIFIED plus maintainability/recovery appropriate to scope.

### DOMAIN C — Governance, truth and strategic operating system
Audit/upgrade:
- authority engine/matrix;
- operating model;
- opportunity scorecard;
- progress dashboard;
- commands and handoff/recovery rules;
- business/legal/fiscal operating system;
- venture/tooling radars;
- instruction evolution artifacts.

Gate: no active decision document may present stale facts as current, conflict with canonical authority, or create ambiguous decision rights.

### DOMAIN D — Research veins and reusable assets
Audit before reuse/promotion:
- VETA-AUTO-PRODUCT-001;
- VETA-AI-UGC-001;
- prototypes, old measurement sheets, old commercial experiments;
- reusable templates, demos and research packs.

Gate: old feasibility proof never upgrades itself into demand/commercial proof.

### DOMAIN E — Historical and archive
Preserve facts. Do not rewrite old experiments/events. Only annotate or migrate when active code/docs depend on them.

## Current dynamic queue
This queue is evidence-dependent and may reorder whenever the global triage reveals a more critical item. It is not a permanent hierarchy.

Current highest-value targets after the first sweep:
1. **Project truth / recovery / reporting layer** — a stale dashboard was already detected, proving decision-integrity risk; BOOT/LIVE/dashboard/execution-capabilities/index chain must remain coherent.
2. **EXP-AUTO-001 market surface** — Contra V2/profile/offer/acquisition materials are the nearest current route to paid validation.
3. **Acquisition and commercial control layer** — radar/pipeline/templates/channel positioning must reflect current routes and competitive standard.

Domain B execution/reliability work may outrank any of the above if triage finds a material safety, truth, continuity or high-blast-radius reliability defect.

## Parallelism rule
Triage can run broadly across domains. Remediation may run in parallel when GREEN, independent and beneficial to wall-clock time.

Do not create uncontrolled WIP. Parallel work must not hide unresolved critical findings or multiply maintenance burden.

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
- systemic/decision/customer/economic impact;
- expected attention/cost;
- dependency/urgency;
- priority;
- trigger;
- kill condition.

No unbounded backlog. Remove debt that no longer affects truth, safety, profit, reliability, buyer value, continuity, speed or strategic differentiation.

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
2. What is the full affected surface across all domains?
3. Are any hard-precedence defects present?
4. What are the current highest-value upgrades under the multi-axis model?
5. Which GREEN upgrades can execute immediately or in parallel?
6. Which remaining gaps are quality debt or Human Gates?

This check is mandatory before declaring the new standard fully integrated.

## Current truth boundary
This program creates a migration obligation and adaptive prioritization process. It does not mean all repository artifacts already pass the new standards. Each item must be audited and verified before it can be labeled compliant.

Current economic truth remains: capital spent €0, revenue €0, settled revenue €0, realized/reconciled profit €0 until new evidence changes it.
# NEXIA — CONTINUOUS QUALITY & EVOLUTION STANDARD

Status: ACTIVE CROSS-PROJECT STANDARD
Date: 2026-10-15
Authority: subordinate to NEXIA_STATE.json, current Project rules, security/legal/authority gates, and active indexed deltas.

## Mission
Make quality improvement a repeatable operating system rather than an occasional preference. Nexia must not treat “finished”, “functional”, or “looks acceptable” as equivalent to competitive quality.

The objective is compounding improvement in economic performance, reliability, user value, speed, evidence quality, maintainability and market credibility. “Exponential improvement” is an aspiration, not a guaranteed measured result; gains must be supported by evidence.

## Universal post-task loop
After every MATERIAL task, before marking it complete:

1. **VERIFY** — confirm the requested postcondition actually exists. Activity is not completion.
2. **CRITIQUE** — ask: what is weak, confusing, fragile, expensive, slow, unconvincing or below professional standard?
3. **COMPARE** — when relevant external references exist, benchmark against strong direct competitors and at least one aspirational/top-tier reference.
4. **IMPROVE** — implement the highest-value GREEN improvement immediately when expected value exceeds cost/risk/opportunity cost.
5. **RE-VERIFY** — check the improvement did not introduce regression or weaken economics/truthfulness.
6. **CAPTURE** — if the lesson generalizes, convert it into a checklist, standard, template, test, gate or automation so future work starts from the improved baseline.
7. **STOP RATIONALLY** — stop when additional improvement is immaterial, unproven, blocked by authority, or lower-value than the next economic bottleneck. Record deferred valuable improvements as quality debt; do not polish indefinitely.

Mandatory question after material completion:
> “What would a top-tier competitor or expert improve here, and which of those improvements have positive expected value for Nexia now?”

## Quality maturity ladder
Use the highest level actually evidenced:

1. **FUNCTIONAL** — works at least once; not enough for public/commercial readiness.
2. **VERIFIED** — postcondition tested; failure modes and evidence recorded.
3. **COMPETITIVE** — meets current market/reference baseline on buyer-relevant dimensions.
4. **TOP-TIER** — matches strong professional references on quality, clarity, reliability and presentation.
5. **DIFFERENTIATED** — demonstrates a meaningful advantage that matters to the buyer/user and is supported by evidence.

Default gates:
- Internal exploratory experiment: VERIFIED may be sufficient when learning value is the goal.
- Reusable internal infrastructure: VERIFIED + maintainability/recovery checks.
- Public-facing/commercial asset: COMPETITIVE minimum.
- Strategic flagship asset/profile/offer: target TOP-TIER; DIFFERENTIATED where economically justified.

## Competitive quality gate
For material outputs with a real market analogue:

1. Identify 3+ strong direct references when available.
2. Add 1+ top-tier adjacent reference when visual, UX, packaging or trust quality matters.
3. Decompose the benchmark into customer-relevant dimensions.
4. Score Nexia as `BELOW / PARITY / SUPERIOR / NOT APPLICABLE` for each dimension.
5. Do not ship a known `BELOW` dimension that materially affects conversion, trust, reliability, usability or economics unless timeboxed learning value justifies it.
6. A claimed superiority remains a HYPOTHESIS until measured externally.

Use the active Competitive Intelligence + lawful Reverse Engineering standard for detailed method and boundaries.

## General quality scorecard
Adapt weights to the task; do not fabricate precision. Material tasks should review at least:

- Outcome correctness / requirement fit
- Evidence and truthfulness
- Customer/user value
- Reliability / failure handling
- Competitive quality / professional standard
- Clarity / usability
- Economic efficiency / human attention
- Maintainability / reversibility
- Security / privacy / legal / license constraints
- Presentation / trust / credibility when public-facing

For quantitative scorecards, define weights and pass threshold BEFORE final review when the score will be used as a formal gate.

## Improvement economics
Quality work is an investment, not a religion.

Implement now when expected benefit in conversion, revenue, reliability, learning, time saved, risk reduction or defensibility is likely to exceed:
- human attention;
- build/rework cost;
- maintenance cost;
- delay to the current bottleneck;
- new technical/platform dependency;
- downside risk.

If an improvement is attractive but not currently highest-value, record it as `QUALITY_DEBT` with trigger/priority rather than silently losing the learning.

## Domain-specific application

### Business / offers / acquisition
Review value proposition, proof, pricing/packaging, friction, trust, competitive positioning, channel fit, buyer attention and conversion path.

### Research
Review source freshness, authority, counter-evidence, falsification effort, missing variables, decision relevance and whether conclusions exceed evidence.

### Experiments
Review whether thresholds were precommitted, instrumentation worked, UNKNOWN was not converted to zero, postconditions were verified and learning changes the next decision.

### Code / automation / infrastructure
Review tests, deterministic behavior, failure modes, idempotency/retry where relevant, observability, rollback/recovery, privilege minimization, maintenance burden and benchmark alternatives before overengineering.

### Visual / UX / public assets
Apply the active Art Direction standard plus direct competitor benchmark. Functional or technically accurate visuals are insufficient when the market standard is materially higher.

### Documents / dashboards / communication
Review decision usefulness, accuracy, information hierarchy, signal-to-noise, currentness, consistency and whether the reader can act correctly without hidden context.

## Learning compounding rule
A one-off improvement is incomplete if the same class of error is likely to recur.

When a lesson generalizes, Nexia should update one or more of:
- operating standard;
- checklist / scorecard;
- reusable template;
- automated test;
- instrumentation;
- prompt/instruction artifact;
- benchmark library;
- kill/gate criterion.

Each update must preserve provenance and must not claim persistence unless the write and read-back/postcondition are verified.

## Anti-complacency rule
Do not accept these completion reasons by themselves:
- “it works”;
- “it is already done”;
- “it looks fine”;
- “we spent a lot of time on it”;
- “the competitor also has flaws”;
- “the first version is good enough” when a material, cheap, reversible improvement is known.

## Anti-perfectionism rule
Do not keep iterating merely to maximize subjective polish.

Stop when:
- the formal gate is passed;
- the material benchmark gap is closed or consciously accepted;
- remaining improvements have lower expected value than the next bottleneck;
- the next iteration would require RED authority, material spend or disproportionate attention;
- further differences are aesthetic preference without measurable buyer/user/risk value.

Default review cadence for a material deliverable: one mandatory critique pass after verification; a second iteration when a material improvement is identified. Additional passes require explicit information/economic value.

## Quality debt
Track deferred material improvements with:
- issue/gap;
- evidence;
- expected benefit;
- estimated attention/cost;
- dependency/trigger;
- priority;
- kill condition.

Do not let `QUALITY_DEBT` become an unbounded backlog. Remove items that no longer affect economics, reliability, safety, buyer value or strategic differentiation.

## Integration with existing standards
Mandatory sequence for market-facing material work:

`OBJECTIVE -> EVIDENCE -> BENCHMARK -> BUILD -> VERIFY -> CRITIQUE -> PARITY -> DIFFERENTIATE -> RE-VERIFY -> SHIP -> LEARN -> STANDARDIZE`

Supporting standards:
- `research/NEXIA_COMPETITIVE_INTELLIGENCE_REVERSE_ENGINEERING_STANDARD_2026-10-15.md`
- `design/NEXIA_ART_DIRECTION_STANDARD_V2_2026-10-15.md`
- `NEXIA_GROWTH_AUTONOMY_OPERATING_MODEL_2026-10-14.md`

## Current application
EXP-AUTO-001 / Contra is the first explicit application:
- V1 portfolio media exposed a competitive quality gap.
- Competitor and top-tier portfolio benchmarking identified the gap.
- V2 art direction raised the standard.
- The generalized lesson is now cross-project policy rather than a one-off design correction.

No change to experiment cash/time/application ceilings is authorized by this standard.
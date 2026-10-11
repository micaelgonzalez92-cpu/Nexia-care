# NEXIA EXP-AUTO-001 — Scaling Economics & Automation Gates

Date: 2026-10-12 (Europe/Madrid)
Status: DESIGNED / NO ECONOMIC VALIDATION CLAIMED / NO SPEND
Primary experiment: EXP-AUTO-001 — Lead Intake Reliability Sprint

## Objective
Define what must be true for EXP-AUTO-001 to exceed EUR 1,000/month sustainable net profit after tax without confusing marketplace activity, gross revenue or technical automation with business scalability.

## Verified platform fact
Current Workana freelancer commission is relationship-based: 20% until a client has paid the freelancer more than USD 300, 10% from USD 301 to USD 3000, and 5% above USD 3000. These tiers are per client relationship.

## Current internal assumptions
- Current validation price: EUR 300 gross.
- Maximum validation delivery time: 4 human hours.
- Human labor assumption: EUR 15/hour.
- Variable tooling target: EUR 0 for the bounded first sprint.
- Initial Workana fee assumption: 20%.
- Tax is UNKNOWN and must not be represented as known.
- For planning sensitivity only, a 25% post-contribution tax reserve is shown below. It is NOT a tax calculation or legal/fiscal conclusion.

## Scenario model

### S0 — Validation economics
- Gross realized price: EUR 300.
- Platform fee assumption: 20%.
- Human time: 4h.
- Labor cost assumption: EUR 60.
- Contribution before overhead/tax: EUR 180.
- Illustrative amount after a 25% reserve: EUR 135.
- Projects/month required to exceed EUR 1,000 under that illustrative reserve: 8.
- Human delivery load at 8 projects: 32h/month.

Interpretation: economically plausible, but not the desired final operating model. Eight handcrafted monthly deliveries would prove demand but would not yet demonstrate strong productization.

### S1 — Refined service
Planning target, not verified result:
- Gross realized price: EUR 400.
- Effective platform fee planning assumption: 15% blended.
- Human time: 3h.
- Labor cost: EUR 45.
- Contribution before overhead/tax: EUR 295.
- Illustrative amount after 25% reserve: EUR 221.25.
- Projects/month required: 5.
- Human delivery load: 15h/month.

Gate: do not treat this scenario as achievable until real delivery evidence supports the price and time reduction.

### S2 — Productized target
Planning target, not verified result:
- Gross realized price: EUR 450.
- Platform fee planning assumption: 10%.
- Human time: 2h.
- Labor cost: EUR 30.
- Contribution before overhead/tax: EUR 375.
- Illustrative amount after 25% reserve: EUR 281.25.
- Projects/month required: 4.
- Human delivery load: 8h/month.

Interpretation: this is the first operating model that looks attractive for Nexia: four deliveries per month, bounded support and substantial reusable automation.

### S3 — Strong productized model
Planning target, not verified result:
- Gross realized price: EUR 600.
- Platform fee planning assumption: 10%.
- Human time: 2h.
- Labor cost: EUR 30.
- Contribution before overhead/tax: EUR 510.
- Illustrative amount after 25% reserve: EUR 382.50.
- Projects/month required: 3.
- Human delivery load: 6h/month.

Interpretation: three qualified deliveries per month could clear the target if acquisition, support and after-tax reality remain compatible.

## Why automation percentage is not the primary KPI
Do not declare "80% automated" or "90% automated" from architecture alone. Measure actual human minutes.

Primary delivery-efficiency KPI:
`human_hours_per_accepted_delivery`

Secondary KPI after the first real pilot:
`measured_automation_gain = 1 - median_human_hours_after_reuse / human_hours_first_accepted_pilot`

Example only: if the first accepted pilot requires 4h and later comparable deliveries require 2h, measured automation gain is 50%. This is stronger evidence than an estimated task-automation percentage.

## Automation roadmap

### Phase A — Before first paid pilot
Automate/prebuild only reusable low-risk components:
- opportunity collection and scoring;
- economic screening;
- truthful proposal first drafts;
- intake validation modules;
- normalization and duplicate/idempotency modules;
- bounded classification/summary modules;
- synthetic tests;
- error-path tests;
- documentation/handover templates;
- internal delivery checklist.

Human Gates remain mandatory for:
- proposal sending/contact;
- price/contract commitments;
- spend;
- credentials;
- production changes;
- ambiguous requirements;
- final acceptance.

### Phase B — After first accepted paid pilot
Record actual time by activity:
1. discovery/spec clarification;
2. setup/credentials;
3. workflow adaptation;
4. destination integration;
5. tests/debugging;
6. documentation/handover;
7. correction/support.

Any activity >20% of total human time becomes a priority automation/reuse target if technically safe.

### Phase C — After 3 paid deliveries
Create versioned reusable modules only for patterns observed in real deliveries, not imagined patterns.

Required evidence:
- median human delivery time;
- p90 delivery time;
- median correction time;
- scope-creep frequency;
- proposal -> qualified response rate;
- qualified response -> paid pilot rate;
- realized contribution per delivery;
- repeat-client rate.

### Phase D — Scaling
Aim for <=2h median human work per accepted bounded delivery before calling the operation productized enough to pursue volume aggressively.

Do not automate live customer actions that create material risk merely to reduce minutes. Human approval remains preferable where the expected cost of an error exceeds the time saved.

## Validation gates

### VALIDATED
Requires all:
- >=1 paid pilot at >=EUR249 economic equivalent;
- settled payment;
- <=4 measured human delivery hours;
- accepted after <=1 bounded correction;
- no critical data-loss, credential, duplicate-send or unauthorized-send failure;
- positive reconciled contribution.

### REFINED
Requires at least 3 accepted paid deliveries and:
- positive contribution on all or a clearly explainable outlier;
- median human delivery time <=3h;
- reusable modules proven on more than one real delivery;
- acquisition conversion measured;
- no systematic scope creep.

### PRODUCTIZED
Requires at least 5 accepted paid deliveries and:
- median human delivery time <=2h;
- realized price >=EUR400 median or equivalent economics;
- bounded correction/support burden;
- at least one acquisition channel producing repeatable qualified opportunities;
- technical modules reused without material regression.

### SCALABLE
Requires a rolling or calendar period demonstrating a plausible path to >EUR1,000/month after tax with:
- acquisition capacity sufficient for the required monthly project count;
- measured delivery capacity without owner overload;
- settled cash, not only invoices;
- tax treatment reconciled with actual jurisdiction/accounting;
- repeat/reuse evidence;
- no dependence on one buyer or one expiring marketplace brief.

## Failure / pivot triggers
Pause or materially redesign EXP-AUTO-001 if any becomes true:
- 0 paid pilots after 20 matched authorized applications/contacts;
- median accepted delivery remains >4h after 3 real deliveries;
- realized market price repeatedly <EUR249 equivalent;
- support/corrections erase contribution;
- buyer acquisition requires misleading production claims;
- paid tooling becomes structurally necessary and pushes contribution below target;
- acquisition cannot produce enough qualified opportunities to sustain the monthly project count implied by actual unit economics.

## Current conclusion
RECOMMENDATION: continue validation, but do not scale spend yet.

Current evidence supports a plausible business, not a proven one. The economically attractive target is not "many EUR300 custom projects". It is to use the first paid deliveries to move toward approximately EUR400–600 realized price, <=2–3 human hours per delivery, reusable modules and repeat buyers.

Until the first accepted paid pilot exists, the correct optimization target is reducing uncertainty per euro and preserving truthful commercial positioning — not maximizing automation architecture.

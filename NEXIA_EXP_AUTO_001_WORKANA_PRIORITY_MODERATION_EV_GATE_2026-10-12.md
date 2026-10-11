# NEXIA EXP-AUTO-001 — Workana Priority Moderation EV Gate

Date: 2026-10-12 (Europe/Madrid)
Status: DESIGNED / NO SPEND / NO PURCHASE AUTHORIZED
Primary experiment: EXP-AUTO-001 — Lead Intake Reliability Sprint

## Objective
Prevent paying for Workana Priority Moderation unless the expected information/economic value of accelerating profile review is demonstrably greater than the fee and the profile state supports the action.

## Verified external facts
- Standard Workana profile moderation usually takes 15–30 days.
- Priority Moderation is optional and reduces review time to up to 24 hours after payment.
- Priority Moderation does not guarantee profile approval.
- Approval is notified by email; exact moderation state is visible in the authenticated Workana dashboard.
- A newly approved freelancer starts at Iron level with 2 connections per week for proposals.
- Initial freelancer commission with a new client is 20%; after >USD300 paid by the same client it falls to 10%, and above USD3000 to 5%.

## Huescaventura facts
- Published: 2026-05-23.
- Still shown open / evaluating proposals on 2026-10-12.
- Age at this checkpoint: 142 days.
- Budget: approximately EUR 200–300.
- Buyer payment verified; 1 paid project; 1 visible proposal in the current public evidence.
- Existing authorized bid: EUR 300, conditional on profile approval, project still open and zero proposal spend.
- Estimated contribution at EUR300 under current assumptions: EUR180 before overhead/tax; NOT REALIZED.

## Key learning
Priority Moderation buys **time**, not approval, contract, revenue or profit. Huescaventura has already remained open for 142 days, so the urgency to pay solely to protect this one project is materially lower than if the brief were newly posted and rapidly closing.

## Expected-value formula
For a single time-sensitive opportunity:

`Incremental EV of priority = contribution_if_won × P(profile approved) × P(win | approved and proposal sent) × P(opportunity lost during standard wait but available after priority)`

The moderation fee is rational only when it is comfortably below this incremental EV, not merely below the full project contribution.

Unknown variables remain UNKNOWN until measured:
- approval probability for this profile;
- true win probability of a new Workana profile;
- probability Huescaventura closes during the 15–30 day standard wait;
- exact price of Priority Moderation in Kael's dashboard.

## Illustrative sensitivity only — NOT forecasts
Using EUR180 contribution before overhead/tax:
- Conservative scenario: approval 50% × win 10% × timing-loss 40% => incremental EV ≈ EUR3.60.
- Base-prudent scenario: approval 70% × win 20% × timing-loss 50% => incremental EV ≈ EUR12.60.
- Favorable scenario: approval 80% × win 30% × timing-loss 60% => incremental EV ≈ EUR25.92.

These probabilities are hypothetical sensitivity inputs, not observed performance.

## Decision policy before first paid pilot
### NO PAY
Do not buy Priority Moderation when any of these is true:
- dashboard moderation state is UNKNOWN / NOT INSTRUMENTED;
- exact fee is unknown;
- profile is not complete enough to justify accelerated review;
- no current qualified Workana opportunity exists;
- fee exceeds the favorable single-opportunity incremental EV without additional fresh qualified opportunities;
- purchase would require a plan, credits or other bundled spend beyond moderation itself.

### CONDITIONAL CONSIDER
Only consider a purchase after Kael explicitly supplies/verifies:
1. exact dashboard moderation status;
2. exact Priority Moderation price and currency;
3. confirmation that profile is complete and reviewable;
4. at least one qualified current Workana opportunity remains open.

### Internal pre-pilot price bands
These are risk-control recommendations, not authorization:
- fee <= EUR10 equivalent: potentially defensible validation spend if dashboard says Pending and P0 remains open;
- fee > EUR10 and <= EUR20: require P0 plus at least one additional fresh economically viable Workana candidate or other evidence that acceleration unlocks multiple credible applications;
- fee > EUR20: default NO_GO before first paid pilot unless a much stronger quantified opportunity set appears.

Reason: before willingness-to-pay is demonstrated, Nexia should preserve capital and buy information only when downside is small relative to plausible incremental value.

## Scaling gate for the business model
Do not declare EXP-AUTO-001 VALIDATED or ESCALABLE from marketplace demand alone.

VALIDATED requires:
- at least 1 paid pilot >= EUR249 economic equivalent;
- measured total human delivery <=4 hours;
- buyer acceptance after <=1 bounded correction;
- no critical reliability/credential/unauthorized-send failure;
- settled payment and reconciled contribution.

REFINED requires at least 3 paid deliveries with:
- median human delivery time measured;
- reusable modules identified;
- acquisition source and proposal-to-response rate measured;
- contribution positive after platform/tooling/human labor;
- no systematic scope creep.

ESCALABLE requires evidence that the process can plausibly exceed EUR1000/month after tax through a combination of:
- higher realized price,
- lower human hours via reuse/automation,
- repeat business,
- predictable acquisition,
- bounded support burden.

## Automation target
Do not optimize for 100% autonomous commerce. Optimize for automated execution with Human Gates.

High-automation candidates:
- opportunity collection/scoring;
- economic screening;
- proposal first draft;
- workflow scaffolding from proven modules;
- validation/dedup/error-handling modules;
- synthetic test generation;
- documentation/handover generation;
- delivery checklist and QA;
- internal follow-up/state tracking.

Human-controlled gates:
- spend;
- external proposal/contact;
- pricing/contract commitment;
- credentials and production access;
- ambiguous requirements;
- live activation;
- final acceptance and exception handling.

## Next action
Do not purchase anything yet. Obtain only the exact authenticated Workana moderation status and exact Priority Moderation price. Then evaluate against this gate. Until those values are known, `PRIORITY_MODERATION_DECISION = BLOCKED_BY_MISSING_PRICE_AND_STATUS`.

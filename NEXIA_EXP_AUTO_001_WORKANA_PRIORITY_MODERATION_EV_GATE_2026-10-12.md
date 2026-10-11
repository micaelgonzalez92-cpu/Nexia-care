# NEXIA EXP-AUTO-001 — Workana Priority Moderation EV Gate

Date: 2026-10-12 (Europe/Madrid)
Status: DECISION_READY / RECOMMEND_BUY_IF_KAEL_EXPLICITLY_AUTHORIZES / NO SPEND EXECUTED
Primary experiment: EXP-AUTO-001 — Lead Intake Reliability Sprint

## Objective
Prevent paying for Workana Priority Moderation unless the expected information/economic value of accelerating profile review is greater than the fee and the profile state supports the action.

## Verified external facts
- Standard Workana profile moderation usually takes 15–30 days.
- Priority Moderation is optional and reduces review time to up to 24 hours after payment.
- Priority Moderation does not guarantee profile approval.
- Approval is notified by email; exact moderation state is visible in the authenticated Workana dashboard.
- A newly approved freelancer starts at Iron level with 2 connections per week for proposals.
- Initial freelancer commission with a new client is 20%; after >USD300 paid by the same client it falls to 10%, and above USD3000 to 5%.

## Newly verified authenticated inputs from Kael
- Dashboard state shown: `Estamos analizando tu perfil` / pending moderation.
- Workana states the standard review may take 15 days or more.
- Priority Moderation price shown in dashboard: USD 9.90.
- Dashboard states review within 24 hours after purchase.
- Dashboard states that if the profile is not approved, the USD 9.90 is refunded.
- Current USD 9.90 conversion checked: approximately EUR 8.84.

## Huescaventura facts
- Published: 2026-05-23.
- Reverified open / evaluating proposals on 2026-10-12.
- Age at this checkpoint: 142 days.
- Budget: approximately EUR 200–300.
- Buyer payment verified; 1 paid project; 1 visible proposal in current public evidence.
- Existing authorized bid: EUR 300, conditional on profile approval, project still open and zero proposal spend.
- Estimated contribution at EUR300 under current assumptions: EUR180 before overhead/tax; NOT REALIZED.

## Decision analysis
Priority Moderation buys time and earlier marketplace access, not a client contract. Huescaventura has remained open for 142 days, so urgency from this single project alone is limited.

However, the decision is not only about preserving Huescaventura. If approved, acceleration also unlocks the ability to test Workana as an acquisition channel up to roughly 15–30 days sooner, including Huescaventura and other suitable buyer-initiated projects. The authenticated fee is below the pre-registered EUR10 validation-spend band, and the dashboard-reported refund on non-approval materially limits downside from a rejection.

At approximately EUR8.84 cost, the spend equals about 4.9% of the current EUR180 estimated contribution of one Huescaventura pilot. This does NOT mean there is a 95.1% expected return; it means that one incremental successful project attributable to acceleration would cover many such moderation fees. The unknown remains whether acceleration actually changes the outcome.

## Recommendation
`PRIORITY_MODERATION_DECISION = RECOMMEND_BUY_IF_EXPLICITLY_AUTHORIZED`

Rationale:
- pending authenticated state is verified;
- exact fee is known and below EUR10 equivalent;
- at least one strong current opportunity remains open;
- approval would unlock Workana proposals materially sooner;
- rejection refund is reported in the authenticated dashboard;
- maximum loss if approved but no project is won is approximately USD9.90 plus any FX/payment-card spread, with no additional paid plan authorized;
- the experiment directly reduces the highest current commercial bottleneck: access to proposal submission.

This is a recommendation, NOT authorization and NOT an executed purchase.

## Human Gate
### COMANDO ÓPTIMO
Authorize one Workana Priority Moderation purchase at exactly USD 9.90, with no plans, credits or additional paid options.

### ACCIÓN
Kael purchases only Priority Moderation from the authenticated Workana dashboard.

### COSTE / EXPOSURE
- Maximum authorized platform charge proposed: USD 9.90.
- Approximate current EUR equivalent: EUR 8.84, excluding card/FX spread.
- No recurring plan.
- No additional credits/connections purchase.

### RIESGO
- Profile can be approved and still win zero projects; in that case the moderation charge is sunk.
- Approval is not guaranteed; dashboard states a non-approval refund, but refund timing/method is controlled by Workana/payment rail.
- Faster approval does not guarantee Huescaventura remains open or accepts our proposal.

### REVERSIBILIDAD
Financially limited but not fully reversible if approved: the moderation service itself is consumed. If not approved, authenticated dashboard states refund.

### CRITERIO DE ÉXITO
Within 24 hours, obtain a moderation result. If approved, reverify Huescaventura immediately and submit the already-authorized EUR300 proposal only if still open and no proposal spend is required. Then use remaining free weekly connection capacity only for separately authorized qualified opportunities.

### CRITERIO DE FRACASO
- no moderation result within the promised window without an actionable Workana status;
- profile approved but platform requires additional unauthorized paid plan/credits before the authorized Huescaventura proposal;
- Huescaventura closes and no alternative qualified Workana opportunity justifies the channel-access experiment.

## Business scaling gate
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

ESCALABLE requires evidence that the process can plausibly exceed EUR1000/month after tax through higher realized price, lower human hours via reuse/automation, repeat business, predictable acquisition and bounded support burden.

## Automation target
Optimize for automated execution with Human Gates, not 100% autonomous commerce.

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
Wait for explicit Kael authorization of exactly USD 9.90 for Priority Moderation. Do not execute any purchase from `/next` alone. If authorized and purchased, reclassify to `PAID_AWAITING_MODERATION_RESULT` and start a 24-hour result watch.
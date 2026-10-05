# NEXIA REVENUE ENGINE — 30 DAY TIMEBOX

Updated: 2026-10-05

## Objective

Reach >= €1,000 net monthly profit after taxes as quickly as reasonably possible, with a 30-day operating timebox from the effective project start. The exact project-start date is not yet recorded in persistent state, so the calendar deadline must not be invented.

The €1,000 target is a first milestone, not the final objective. Once demonstrated sustainably, the target should be raised and the system scaled.

## Evidence discipline

- VERIFIED FACT: De'Longhi Spain currently sells maintenance products directly: DLSC550 MultiClean €4.90, DLSC002 water filter €18, DLSC552 cleaning tablets €7.90, DLSC200 Decalk Care €9.40 and DLSC306 Coffee Care Kit €23.50.
- VERIFIED FACT: De'Longhi directs owners needing repairs or parts toward authorized service centres and professional repair centres.
- VERIFIED FACT: Spanish parts retailers list a meaningful Magnifica spare-parts catalogue; Electrotodo lists 111 Magnifica-related products and a Magnifica S grinder at €61.95.
- VERIFIED FACT: FixPart lists hundreds of parts for Magnifica models.
- VERIFIED FACT: Tecnisan, an official DeLonghi service centre in Valencia, publicly states that diagnosis requires a deposit and that the deposit is deducted from the repair if accepted. This confirms an established paid-diagnosis pattern. citeturn0search0
- VERIFIED FACT: Sator publicly advertises DeLonghi diagnosis from €10 and nationwide collection/repair, showing that low-price diagnosis already exists in-market. citeturn0search10turn0search8
- VERIFIED FACT: De'Longhi has a public affiliate-program page describing approval via affiliate networks such as AWIN or Tradedoubler, trackable links and a 30-day cookie. This page is UK-facing; Spain eligibility and commission rates are NOT yet verified. citeturn0search6
- VERIFIED FACT: La Guía del Café publicly monetizes Magnifica S repair/decision content through Amazon affiliate links, demonstrating that repair/replace intent can sit next to commerce monetization. This is evidence of a competitor model, not NEXIA conversion. citeturn0search14
- HYPOTHESIS: A focused diagnostic/decision product can monetize attention before a full e-commerce catalogue is required.
- HYPOTHESIS: The fastest low-capital route may be decision support + qualified service routing, followed by affiliate/lead-gen revenue and then productized maintenance/parts commerce.
- NOT VALIDATED: NEXIA willingness to pay, conversion rate, CAC, affiliate commission in Spain, provider lead fees, refund rate, tax-adjusted margin, or repeat purchase rate.

## Revenue paths to test in parallel

### R1 — Paid diagnostic / repair triage

Offer a narrowly scoped remote diagnostic session or report for compatible Magnifica owners.

Target hypothesis:
- Price test: €9–€19 initially.
- Deliverable: structured symptom triage, safe next action, escalation boundary, parts/service direction when appropriate.
- Do not claim repair success before user evidence exists.

Status:
- REPRICED / NOT VALIDATED. Existing competitors already advertise diagnosis from €10, so low price is not sufficient differentiation.

### R1A — Free diagnostic → paid escalation

- Hypothesis: users will complete a free symptom/model diagnosis and a subset will value a more detailed decision/report or professional handoff enough to accept a paid next step.
- Action: use existing NEXIA Care flow and measure completion, unresolved cases, escalation intent and requests for deeper help.
- Cost: €0.
- Metric: diagnostic completion → escalation intent → willingness-to-pay signal.
- Success: repeated requests for deeper help plus at least one explicit willingness-to-pay signal.
- Failure: users consume diagnosis but show no interest in deeper help.
- Risk: confusing informational usefulness with commercial demand.
- Information gained: whether the monetizable unit is diagnosis, decision support or qualified repair routing.

### R2 — Qualified repair/service lead generation

Build a directory/triage layer that routes owners with unresolved or safety-sensitive cases to appropriate professional service.

Evidence:
- DeLonghi itself directs repair/parts requests to authorized service centres. citeturn0search2
- Tecnisan and Sator demonstrate active Spanish repair demand and paid diagnosis. citeturn0search0turn0search10
- Sator explicitly accepts symptom/photo consultation before workshop repair. citeturn0search8

Hypothesis:
- A provider may value a lead that already contains model, symptom, prior safe checks and urgency.
- A referral/lead fee could be more scalable than selling technical diagnosis directly.

Current zero-cost test:
- Build a standardized “repair-ready case” output inside NEXIA Care: model + symptom + checks performed + result + safety flags + recommended escalation.
- Do NOT contact providers or promise referral revenue without an authorized channel and commercial terms.
- Measure whether users request a professional handoff and whether the handoff information is complete enough to reduce friction.

Status: RESEARCH / TEST DESIGN ONLY. No provider agreement and no lead fee validated.

### R3 — Maintenance-commerce / affiliate layer

Use diagnostic intent to recommend compatible maintenance products only when appropriate.

Evidence:
- De'Longhi Spain sells maintenance accessories directly.
- De'Longhi publicly operates an affiliate program in at least one market, with approval and tracking requirements. Spain-specific eligibility/commission remains unverified. citeturn0search6
- A Spanish coffee-content publisher publicly monetizes related Magnifica content with affiliate commerce. citeturn0search14

Hypothesis:
- Maintenance recommendations attached to a real problem may have better intent than generic coffee traffic.
- Affiliate economics could become a low-risk monetization layer if a Spain-compatible program is available.

Constraint:
- Do not recommend unnecessary purchases.
- Verify Spain program, commission, attribution, returns and tax treatment before counting economics.

### R4 — Parts discovery / comparison

Use symptom + model data to help owners identify legitimate parts/service options.

Evidence:
- Multiple Spanish retailers currently list Magnifica parts.

Hypothesis:
- High-intent users with known failure modes may convert better than generic product shoppers.

Constraint:
- Safety-sensitive/internal repairs remain escalation cases.
- No parts-first recommendation when a reversible diagnostic step is appropriate.

### R5 — B2B diagnostic widget / white-label

Later: license or provide NEXIA's diagnostic workflow to repair shops, retailers, marketplaces or support teams.

Status:
- Not a 30-day primary route unless an inbound opportunity appears.
- Higher scalability potential, slower initial validation.

## 30-day prioritization

1. R1A free diagnostic → paid escalation: €0 validation of commercial intent.
2. R2 qualified repair-ready handoff: €0 validation of service-routing value.
3. R3 affiliate/maintenance: investigate Spain eligibility before implementation.
4. R1 paid diagnostic: only after differentiation and willingness-to-pay evidence.
5. R4 parts discovery: build where it improves conversion.
6. R5 B2B: opportunistic, not a distraction.

## Revenue gate

A route does not count as validated until it produces:
1. real customer/user,
2. real payment or contractual commercial outcome,
3. documented costs,
4. net margin calculation,
5. repeatable execution path.

## Economic model

For each route:

Net profit = revenue - product/service cost - payment fees - platform fees - advertising - refunds - fulfilment/shipping - taxes.

Do not treat gross sales, clicks, leads or affiliate approval as profit.

## Experiment rule

No spending is required to research or prototype these routes.

Any paid test must first define:
HYPOTHESIS → ACTION → COST → METRIC → SUCCESS → FAILURE → RISK → INFORMATION GAINED

Kael approval is required before spending, paid ads, subscriptions, purchases or irreversible commercial commitments.

## Current strategic decision

Keep EXP-001B active because real-user evidence is valuable, but do not treat it as the only path to revenue.

NEXIA CORE runs a dual engine:
- Evidence engine: obtain 3 real-user tests for NEXIA Care.
- Revenue engine: simultaneously validate the fastest zero/low-capital route to a first transaction.

The current best zero-cost commercial work is to make NEXIA Care produce a structured repair-ready case and observable escalation intent, while independently checking whether Spain-compatible affiliate economics exist.

The machine must pivot or add routes when a route fails to produce measurable traction, without abandoning accumulated evidence.

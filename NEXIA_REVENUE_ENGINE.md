# NEXIA REVENUE ENGINE — 30 DAY TIMEBOX

Updated: 2026-10-05

## Objective

Reach >= €1,000 net monthly profit after taxes as quickly as reasonably possible, with a 30-day operating timebox from the effective project start. The exact project-start date is not yet recorded in persistent state, so the calendar deadline must not be invented.

The €1,000 target is a first milestone, not the final objective. Once demonstrated sustainably, the target should be raised and the system scaled.

## Evidence discipline

- VERIFIED FACT: De'Longhi Spain currently sells maintenance products directly: DLSC550 MultiClean €4.90, DLSC002 water filter €18, DLSC552 cleaning tablets €7.90, DLSC200 Decalk Care €9.40 and DLSC306 Coffee Care Kit €23.50. Source: https://www.delonghi.com/es-es/c/cafe/accesorios/descalcificadores-y-filtros-de-agua
- VERIFIED FACT: De'Longhi directs owners needing repairs or parts toward authorized service centres and professional repair centres. Source: https://www.delonghi.com/es-es/faqs/%C2%BFD%C3%B3nde-puedo-encontrar-piezas-de-repuesto-o-reparar-mi-aparato-DeLonghi/a/584949
- VERIFIED FACT: Spanish parts retailers list a meaningful Magnifica spare-parts catalogue; Electrotodo currently lists 111 Magnifica-related products and a Magnifica S grinder at €61.95. Source: https://electrotodo.es/collections/recambios-cafetera-delonghi-magnifica
- VERIFIED FACT: FixPart currently lists hundreds of parts for a Magnifica ECAM22.117.B, including infusion units and other components. Source: https://fixpart.es/recambios-cafetera-electrica/delonghi/ecam22117b-s11-0132213155-magnifica
- HYPOTHESIS: A focused diagnostic/decision product can monetize attention before a full e-commerce catalogue is required.
- HYPOTHESIS: The fastest low-capital route may be a paid diagnostic/repair-triage service, followed by affiliate/lead-gen revenue and then productized maintenance/parts commerce.
- NOT VALIDATED: willingness to pay, conversion rate, CAC, affiliate commission, refund rate, tax-adjusted margin, or repeat purchase rate.

## Revenue paths to test in parallel

### R1 — Paid diagnostic / repair triage
Offer a narrowly scoped remote diagnostic session or report for compatible Magnifica owners.

Target hypothesis:
- Price test: €9–€19 initially.
- Deliverable: structured symptom triage, safe next action, escalation boundary, parts/service direction when appropriate.
- Do not claim repair success before user evidence exists.

Why first:
- €0 inventory.
- Can reuse NEXIA Care.
- Direct path to revenue.
- Generates high-value user evidence.

Gate:
- Requires a real acquisition channel and eventually payment infrastructure; no paid launch without Kael approval.

### R2 — Qualified repair/service lead generation
Build a directory/triage layer that routes owners with unresolved or safety-sensitive cases to appropriate professional service.

Hypothesis:
- Service providers may value qualified problem descriptions more than generic traffic.
- Revenue model could be per qualified lead or referral.

Status:
- Research only. No provider contacted and no commercial terms validated.

### R3 — Maintenance-commerce / affiliate layer
Use diagnostic intent to recommend compatible maintenance products only when appropriate.

Current public price anchors:
- De'Longhi MultiClean €4.90
- De'Longhi water filter €18
- Coffee Care Kit €23.50

Hypothesis:
- Maintenance recommendations have better intent than generic coffee-content traffic.
- Commission/margin must be verified before treating this as economics.

Constraint:
- Do not recommend unnecessary purchases. NEXIA Care must remain diagnosis-first.

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

Priority order:
1. R1 paid diagnostic — fastest route to first transaction if acquisition can be unlocked.
2. R2 repair/service lead-gen — parallel validation route.
3. R3 maintenance commerce/affiliate — parallel low-capital route.
4. R4 parts discovery — build only where it improves conversion.
5. R5 B2B — opportunistic, not a distraction.

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

Do not treat gross sales or affiliate clicks as profit.

## Experiment rule

No spending is required to research or prototype these routes.

Any paid test must first define:
HYPOTHESIS → ACTION → COST → METRIC → SUCCESS → FAILURE → RISK → INFORMATION GAINED

Kael approval is required before spending, paid ads, subscriptions, purchases or irreversible commercial commitments.

## Current strategic decision

Keep EXP-001B active because real-user evidence is valuable, but stop treating it as the only path to revenue.

NEXIA CORE must run a dual engine:
- Evidence engine: obtain 3 real-user tests for NEXIA Care.
- Revenue engine: simultaneously identify and validate the fastest zero/low-capital route to a first transaction.

The machine should pivot or add routes when a route fails to produce measurable traction, without abandoning accumulated evidence.


## Fresh market-price falsation — 2026-10-05

New public evidence changes the pricing hypothesis:

- Sator Electrónica publicly advertises **diagnóstico desde 10 €** for DeLonghi coffee machines and accepts symptom/photo consultations from Spain. This means a €9–€19 remote NEXIA diagnostic is not automatically differentiated on price alone. citeturn0search6turn0search2
- Tecnisan, an official service centre in Valencia, states that it charges a diagnostic deposit depending on the appliance and deducts it from the repair if accepted. This supports the existence of a paid-diagnosis model, but also shows that established repairers can bundle diagnosis with repair economics. citeturn0search3
- Miss Pièces publicly lists DeLonghi bean-to-cup repair packages at €154.90 workshop / €184.90 with round-trip shipping before a €25 repair bonus, with diagnosis included. This reinforces the value of the repair decision, but is not evidence of NEXIA willingness-to-pay. citeturn0search13turn0search14

### Pricing implication

R1 should **not** be treated as validated merely because €9–€19 is cheaper than a repair. The stronger hypothesis is now:

> NEXIA can win if it delivers a faster, self-service, model-specific decision before the owner commits to a workshop, and/or creates a qualified handoff that a repair provider values.

This shifts the preferred test from “cheap diagnosis” toward **decision utility + qualified escalation**.

### Revised 0€ experiment candidate

**R1A — Free diagnostic → paid escalation test**
- Hypothesis: users will complete a free symptom/model diagnosis and a subset will value a more detailed decision/report or professional handoff enough to accept a paid next step.
- Action: use existing NEXIA Care flow; measure completion, unresolved cases, escalation intent and requests for deeper help.
- Cost: €0.
- Metric: diagnostic completion → escalation intent → willingness-to-pay signal.
- Success: repeated user requests for deeper help plus at least one explicit willingness-to-pay signal.
- Failure: users consume diagnosis but show no interest in deeper help.
- Risk: confusing informational usefulness with commercial demand.
- Information gained: whether the real monetizable unit is diagnosis, decision support, or qualified repair routing.

R2 lead-generation remains a parallel candidate because established repairers already monetize diagnosis/repair, while NEXIA could potentially reduce their acquisition friction. No commercial terms are validated yet.

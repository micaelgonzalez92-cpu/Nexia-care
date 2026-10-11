# NEXIA EXP-AUTO-001 — Commercial Reserve

Date: 2026-10-12 (Europe/Madrid)
Status: RESEARCHED / NO EXTERNAL CONTACT / NO SPEND
Primary experiment: EXP-AUTO-001 — Lead Intake Reliability Sprint

## Objective
Maintain a small reserve of buyer-initiated opportunities that are economically plausible and compatible with the capability already verified for EXP-AUTO-001. Avoid repeating broad marketplace searches, avoid low-ticket work that cannot support the current labor assumption, and do not claim client-production experience that does not exist.

## Ranking

### P0 — WORKANA-HUESCAVENTURA-001 — PRIMARY
Platform: Workana
Status checked: OPEN / EVALUATING PROPOSALS on 2026-10-12.
URL: https://www.workana.com/es/job/automatizar-recepcion-y-clasificacion-de-leads-desde-formulario-con-airtable-y-n8n
Buyer evidence: payment verified; 1 paid project; 1 visible proposal at latest fresh check.
Budget evidence: approximately EUR 200-300 fixed price.
Authorized price: EUR 300.
Fit: EXCELLENT.

Why it remains #1:
- lead arrives from form/chat into Airtable or Google Sheets;
- required-field review;
- lead classification;
- missing-data detection;
- internal summary;
- suggested WhatsApp/email response;
- internal notification;
- state / next step / follow-up;
- duplicate detection;
- explicit human review before customer sending;
- n8n self-hosted already exists;
- buyer explicitly asks for maintainability, error handling, duplicates and documentation.

Verified capability match:
- n8n runtime execution PASS;
- six asserted intake/review cases PASS;
- persistent dedup/idempotency using native n8n Data Tables PASS across process restart;
- autonomous_send=false.

Commercial gate:
- proposal already authorized at EUR 300;
- DO NOT submit until Workana profile approval is verified and project is rechecked as open;
- no paid moderation / proposal credits.

### P1 — WORKANA-N8N-WORKFLOW-OPT-001 — CONDITIONAL SAME-CHANNEL RESERVE
Platform: Workana
URL: https://www.workana.com/es/job/experto-en-automatizacion-n8n-para-diseno-y-optimizacion-de-workflows
Freshness: public result crawled within roughly one day at latest check; page showed OPEN / EVALUATING PROPOSALS.
Buyer evidence: payment verified; 1 project published; 0 paid projects; 0 visible proposals at latest fresh check.
Budget: UNKNOWN / NOT PUBLICLY VERIFIED.
Fit: MEDIUM-HIGH.

Relevant scope:
- design/build/document n8n workflows;
- Google Sheets, Gmail, CRM, WhatsApp, APIs and webhooks;
- stable/scalable workflows;
- project-based collaboration with possible continuity.

Why promoted:
- zero visible competition at latest check;
- payment method verified;
- same Workana profile gate as P0, so no second marketplace account is needed;
- requirement is demonstrable n8n competence, which can be supported truthfully by the existing executed technical evidence pack without claiming paying-client production work.

Why it is NOT GO:
- public budget is unknown, so >=EUR 200 economics are not yet demonstrated;
- scope is described broadly and must be narrowed before pricing;
- existing Huescaventura authorization does not authorize contact/proposal to this buyer.

Gate before any proposal:
- Workana profile approval verified;
- project freshly rechecked open;
- price/economic exposure known or a bounded paid milestone can be stated inside platform rules;
- separate Kael authorization for this buyer.

### P2 — FREELANCER-N8N-FORM-39898142 — CONDITIONAL CROSS-CHANNEL RESERVE
Platform: Freelancer.com
Project: `n8n Automation & Form Interface`
Project ID: 39898142
URL: https://www.freelancer.com/projects/angular-js/automation-form-interface
Freshness: direct project page accessible and crawled within roughly one day at latest check.
Public status: OPEN FOR BIDDING.
Gross budget: USD 250-750 fixed price.
Buyer evidence: payment method verified; profile rating 5.0; 1 recorded review/job signal on public page.
Competition: current bid count NOT RELIABLY EXPOSED in the public page checked.
Fit: HIGH TECHNICAL / BORDERLINE DELIVERY-TIME.

Scope:
- existing n8n draft and written specification already supplied by buyer;
- tighten workflow logic, retries and failure notifications;
- build a simple responsive form with basic validation;
- wire form to n8n via webhook/REST;
- test valid and intentionally malformed submissions;
- setup/import documentation;
- no dashboard/reporting required.

Capability match:
- n8n runtime, error-path testing and persistent idempotency already verified internally;
- simple form/webhook integration is compatible with existing prototype experience;
- paying-client production experience remains NONE_VERIFIED and must not be claimed.

Economic access facts:
- Freelancer fixed-price freelancer fee: 10% of winning bid or USD 5 minimum;
- some Freelancer bids require at least USD 20 available wallet balance before bidding;
- therefore this channel is CAPITAL_GATED, not zero-cost;
- account creation/funding/bid are NOT authorized.

Illustrative economics only, not an authorized bid:
- at USD 350 gross, 10% platform fee leaves USD 315 before labor/overhead/tax;
- ECB 2026-10-09 reference implies roughly EUR 312.6 gross and EUR 281 after 10% platform fee;
- minus current EUR 60 labor assumption gives roughly EUR 221 contribution before overhead/tax IF delivery actually fits 4 hours;
- delivery <=4h is currently HIPÓTESIS because the brief adds a frontend form to workflow refinement.

Why it is NOT GO yet:
- Freelancer account/profile state is NOT CONNECTED/VERIFIED;
- possible USD 20 wallet requirement is material capital exposure;
- <=4h delivery has not been demonstrated for this expanded form+n8n scope;
- proposal asks about shipped production n8n work; Nexia may only present its technical proof honestly, not claim prior paid production delivery.

Human Gate if this remains open and becomes preferable:
- exact action: authorize creation/use of Freelancer account, verification steps, and up to USD 20 wallet balance exposure solely to enable a standard bid if required;
- separate bid/proposal text and price must be approved before submission;
- success criterion: submit one truthful, economically viable bid without paid upgrades and obtain buyer response/shortlist signal;
- stop if extra paid verification, membership, featured bid or broader capital exposure is required.

### P3 — UPWORK-LEAD-MGMT-250-001 — LOW-PRIORITY CROSS-CHANNEL RESERVE
Platform: Upwork
Gross fixed price observed previously: USD 250.
Competition at prior check: 50+ proposals.
Fit: EXCELLENT TECHNICAL / WEAK ACQUISITION ODDS.
Current status: STALE_RECHECK_REQUIRED before any action.

Risks / blockers:
- Upwork account/profile state is NOT CONNECTED/VERIFIED in NEXIA;
- applying generally consumes Connects;
- no authorization exists to create/connect an Upwork account or submit a proposal;
- high competition materially weakens expected value.

## Negative evidence / deliberate discards

### Upwork low-ticket exact-fit jobs
Observed examples at USD 5-20 fixed remain `ECONOMIC_NO_GO`. Technical fit does not compensate for gross price below the assumed human labor cost of a proper bounded pilot.

### Broad multi-system builds
Voice agents, full CRM migrations, WhatsApp autonomous sending, dashboards, reputation systems, multi-channel orchestration, POS/payments or enterprise integrations are NO_GO_SCOPE for the current <=4h sprint unless the buyer explicitly offers a separable paid first milestone.

### Stale indexed marketplace results
A search-result snippet is not enough to classify a project CURRENT. Direct page access or evidence <=24h not contradicted by a direct check is required. Freelancer Project 40722058 remains CLOSED_OR_REMOVED after its direct URL returned 404.

## Proposal evidence rule
Allowed truthful claim:
"I have built and executed an n8n 2.42.6 technical proof for lead validation, classification, review and persistent deduplication/idempotency, including separate webhook executions and a process restart."

Disallowed claim:
"I have delivered this for paying clients in production."

Client production experience remains NONE_VERIFIED.

## Acquisition gates
1. Huescaventura: existing EUR 300 proposal authorization applies only after Workana profile approval is verified, project freshly rechecked open and zero submission spend confirmed.
2. Any other Workana buyer: requires new specific authorization before proposal/contact.
3. Freelancer.com: account creation/use, any identity/payment verification, wallet funding and bid submission require explicit Kael authorization; do not exceed USD 20 balance exposure without a new approval.
4. Upwork: account creation/connection, Connects/spend and proposal submission require Kael authorization.
5. No off-platform contact.

## Next economic action
Do not add more synthetic technical layers by default. Keep P0 fresh, use P1 as same-channel redundancy once Workana approval clears, and revalidate P2 only while its direct project page remains open. The next valuable evidence is a real authorized proposal, buyer response, paid pilot, measured delivery time, acceptance, settled payment and reconciled profit.

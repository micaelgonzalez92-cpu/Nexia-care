# NEXIA EXP-AUTO-001 — Commercial Reserve

Date: 2026-10-12 (Europe/Madrid)
Status: RESEARCHED / NO EXTERNAL CONTACT / NO SPEND
Primary experiment: EXP-AUTO-001 — Lead Intake Reliability Sprint

## Objective
Maintain a small reserve of buyer-initiated opportunities that are economically plausible and compatible with the capability already verified for EXP-AUTO-001. Avoid repeating broad marketplace searches, avoid low-ticket work that cannot support the current labor assumption, and do not claim client-production experience that does not exist.

## Ranking

### P0 — WORKANA-HUESCAVENTURA-001 — PRIMARY
Platform: Workana
Status checked: OPEN / EVALUATING PROPOSALS
URL: https://www.workana.com/es/job/automatizar-recepcion-y-clasificacion-de-leads-desde-formulario-con-airtable-y-n8n
Buyer evidence: payment verified; 1 paid project; 1 visible proposal at latest check.
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

### P1 — WORKANA-PROCESS-SCALE-001 — RESERVE
Platform: Workana
Status checked: OPEN / EVALUATING PROPOSALS
URL: https://www.workana.com/es/job/profesional-en-automatizacion-y-optimizacion-de-procesos-para-escalabilidad-empresarial
Buyer evidence: payment verified; 1 paid project; 0 visible proposals at latest check.
Budget: UNKNOWN.
Fit: MEDIUM-HIGH if narrowed to one bounded pilot.

Relevant scope:
- identify manual process bottlenecks;
- connect forms, CRM, sheets, email/WhatsApp;
- n8n / Make / Zapier / APIs / Webhooks;
- alerts, reminders, reports;
- documentation and handover.

Reason to keep:
- verified-paying buyer;
- zero visible competition at check time;
- accepts n8n as a core tool;
- a bounded first-process sprint can reuse EXP-AUTO-001 reliability assets.

Risks / falsifiers:
- project is broad and large;
- budget is not public;
- buyer may expect cross-functional experience beyond the selected sprint;
- new proposal/contact is NOT authorized by existing Huescaventura-specific Human Gate.

Recommended positioning if separately authorized:
Offer one process diagnostic + bounded automation pilot, with explicit exclusions and a fixed acceptance test. Do not promise full-enterprise transformation in one scope.

### P2 — UPWORK-LEAD-MGMT-250-001 — CROSS-CHANNEL RESERVE
Platform: Upwork
Status checked: OPEN / worldwide
URL: https://www.upwork.com/freelance-jobs/apply/Build-Lead-Management-Follow-Automation_~022104169227507743389/
Gross fixed price: USD 250.
Client location shown: Germany.
Competition at check: 50+ proposals.
Fit: EXCELLENT TECHNICAL / WEAK ACQUISITION ODDS.

Scope match:
- webhook/form intake;
- validation and normalization;
- Google Sheets or Airtable persistence;
- OpenAI/Claude classification/summary;
- status/priority;
- automated follow-up;
- error handling/logging;
- documentation.

Economics:
- gross USD 250;
- exact Upwork freelancer fee is contract-specific and only shown before proposal/offer; current official fee range is 0%-15%;
- still potentially compatible with the current <=4h pilot economics if scope remains genuinely small, but fee, FX, Connects and actual delivery time must be checked before any application.

Risks / blockers:
- 50+ proposals;
- Upwork account/profile state is NOT CONNECTED/VERIFIED in NEXIA;
- applying may require Connects or other account-specific exposure;
- no authorization exists to create/connect an Upwork account or submit a proposal.

Use case:
Cross-channel backup if Workana moderation becomes a persistent bottleneck. Do not spend or create an account without Kael approval.

## Conditional reserve — not currently prioritized

### WORKANA-N8N-WHATSAPP-EMAIL-001
URL: https://www.workana.com/job/desarrollo-de-automatizaciones-con-n8n-integracion-de-whatsapp-email-y-apis
Buyer evidence: payment verified; 3 paid projects; 0 visible proposals.
Reason not promoted to P1/P2: explicit requirement for proven n8n/API experience plus broad WhatsApp/email integrations that exceed the currently verified client-stack evidence. Could be approached only with transparent wording: technical proof exists; prior client production experience does not.

## Negative evidence / deliberate discards

### Upwork low-ticket exact-fit jobs
Observed examples:
- USD 15 fixed: AI lead qualification + CRM follow-up;
- USD 10 fixed: lead qualification workflow;
- USD 20 fixed: lead routing / CRM workflow;
- USD 5 fixed: lead routing / AI workflows.

Decision: NO_GO under current economics. Technical fit does not compensate for gross price below the assumed human labor cost of a proper bounded pilot. These jobs are useful market signals, not viable extraction targets.

### High-competition broad builds
Projects with 20-50 or 50+ proposals, production-agent requirements, multi-channel autonomous sending, complex CRM stacks or explicit production portfolio requirements remain radar-only unless ticket/fit materially compensates for acquisition odds.

## Proposal evidence rule
Allowed truthful claim:
"I have built and executed an n8n 2.42.6 technical proof for lead validation, classification, review and persistent deduplication/idempotency, including separate webhook executions and a process restart."

Disallowed claim:
"I have delivered this for paying clients in production."

Client production experience remains NONE_VERIFIED.

## Acquisition gates
1. Huescaventura: existing EUR 300 proposal authorization applies only after Workana profile approval is verified, project rechecked open and zero submission spend confirmed.
2. Any other Workana buyer: requires new specific authorization before proposal/contact.
3. Upwork: account creation/connection, Connects/spend and proposal submission require Kael authorization.
4. No off-platform contact.

## Next economic action
Do not add more technical layers by default. Maintain freshness of these candidates, continue zero-cost buyer-initiated discovery only when it can replace or improve this reserve, and convert the first verified marketplace gate into a real proposal/paid-pilot event.

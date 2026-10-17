# EXP-AUTO-001 — WORKANA REALITY SHORTLIST V1

Date: 2026-10-17  
Status: PREPARED_INTERNAL / ZERO_SPEND / NO_APPLICATION_SENT  
Evidence boundary: public Workana listings inspected on 2026-10-17. Listing status can change after observation. This artifact is research/preparation only and does not claim client contact, acceptance, demand, payment or production experience.

## Objective

Resume the active Reality Loop with the smallest external-validation step that uses Nexia's existing verified capabilities instead of adding more internal polish.

## Selection model

Priority factors: direct fit with EXP-AUTO-001, recency/open status, competition visible on listing, buyer/payment signal where visible, ability to demonstrate existing truth-safe technical proofs, implementation risk, and amount of unverified capability required.

## Top 3 observed opportunities

### 1 — Senior AI Automation Developer – Chatbot, n8n & CRM Integration

URL: https://www.workana.com/job/senior-ai-automation-developer-chatbot-n8n-crm-integration-1  
Observed status: OPEN / EVALUATING BIDS  
Published: 2026-10-05  
Observed competition: 0 bids / 0 interested freelancers  
Buyer signal: verified payment method; member since September 2026; 1 published project; 0 projects paid.

Requested flow:
`Customer -> AI Chatbot -> Lead Qualification -> CRM -> Automated Follow-up -> Appointment Booking -> CRM Update`

Requested capabilities include n8n, LLM/API integration, CRM, REST APIs, webhooks, lead capture/qualification, follow-up, appointment booking, error handling, testing and documentation.

Fit assessment: HIGH.

Nexia evidence that maps directly:
- n8n lead-intake workflow proof;
- validation/normalization and persistent deduplication proof;
- human-review / fail-safe routing;
- workflow regression/QA proof;
- JavaScript/API/webhook capability.

Truth gap:
- no verified client production deployment;
- no verified end-to-end production chatbot deployment for a real client;
- specific target CRM, messaging providers, appointment system, hosting/security requirements and production traffic are UNKNOWN.

Decision: PRIORITY 1 / PREPARE PROPOSAL / DO NOT SEND WITHOUT KAEL GATE.

### 2 — Especialista en Automatización con n8n, Make, APIs e IA para Negocios B2B

URL: https://www.workana.com/en/job/especialista-en-automatizacion-con-n8n-make-apis-e-ia-para-negocios-b2b  
Observed status: OPEN / EVALUATING BIDS  
Published: 2026-06-16  
Observed activity: 8 bids / 14 interested freelancers  
Buyer signal: member since May 2026; 2 published projects; 0 projects paid.

Strong fit with lead follow-up, CRM integrations, REST APIs, webhooks, debugging, documentation and robust workflows. Requires a Loom video up to five minutes showing a real automation and explaining problem, tools, workflow logic and debugging.

Fit assessment: HIGH, but older and more competitive than Priority 1.

Truth-safe Loom route if pursued: show an INTERNAL TECHNICAL PROOF, explicitly labeled synthetic/internal, rather than representing it as client production work.

Decision: PRIORITY 2 / RESERVE.

### 3 — Especialista en CRM, Automatización e Integraciones para GoHighLevel, Zoho, Respond.io y Brevo

URL: https://www.workana.com/job/especialista-en-crm-automatizacion-e-integraciones-para-gohighlevel-zoho-respond-io-y-brevo  
Observed status: OPEN / EVALUATING BIDS  
Published: 2026-09-24  
Observed activity: 27 bids / 33 interested freelancers  
Buyer signal: member since May 2020; 14 published projects; 0 projects paid shown on listing.

Requested work includes CRM pipelines, forms, Meta/WhatsApp integrations, lead classification/assignment/follow-up, APIs/webhooks, tracking and documentation.

Fit assessment: MEDIUM-HIGH. Directly aligned with lead/CRM automation, but several named platforms are not established Nexia capabilities and competition is materially higher.

Decision: PRIORITY 3 / RESERVE; do not imply GoHighLevel/Zoho/Respond.io/Brevo production experience that is not verified.

## Priority-1 proposal packet — PREPARED, NOT SENT

### Proposed opening

Hello — your workflow is very close to the reliability problem I have been building around: taking inbound lead data, validating and normalizing it, preventing duplicates, routing uncertain cases safely, and keeping the workflow observable before sensitive actions occur.

I work with n8n, JavaScript, APIs and webhooks. My current portfolio includes internal technical proofs for lead intake, persistent deduplication, fail-safe processing and workflow regression testing. These are internal/synthetic proofs rather than claims of a prior client production deployment.

For your project I would first map the exact CRM, messaging and booking interfaces, then implement the system in bounded stages so lead capture, qualification, CRM writes, follow-up and appointment updates can each be tested independently before the full workflow is activated.

### Architecture proposed for discussion

1. Inbound conversation / webhook ingestion.
2. Required-field validation + normalization.
3. Persistent identity/deduplication layer.
4. LLM-assisted qualification with explicit structured output.
5. Human-review route for ambiguous or sensitive cases.
6. CRM create/update with idempotency.
7. Follow-up state machine.
8. Appointment-booking integration.
9. Error handling, logging and replay-safe recovery.
10. Regression tests + handoff documentation.

### Questions required before committing scope

- Which CRM is currently used, and does it expose the required REST/webhook operations?
- Which chatbot/channel is expected: website chat, WhatsApp, SMS, another channel, or several?
- Which provider sends email/SMS follow-ups?
- Which calendar/booking system must be integrated?
- What actions may the AI perform automatically and what must remain under human review?
- What lead fields and qualification rules define a qualified lead?
- What is the expected lead/message volume and concurrency profile?
- Is the workflow being added to an existing n8n instance or should hosting/deployment be included?
- What logging, retention, privacy and credential-handling requirements apply?
- What are the acceptance tests for a successful first phase?

### Suggested delivery strategy

Start with a bounded Phase 1 proving the most failure-sensitive path: inbound lead -> validation/normalization -> deduplication -> structured qualification -> CRM create/update -> human-review fallback -> audit evidence. Expand to autonomous follow-up and appointment booking only after the interfaces and failure behavior are verified.

Economic proposal: NOT SET in this packet. The canonical EUR300 / <=4h EXP-AUTO-001 pilot is an internal experiment boundary and must not be misrepresented as a suitable price or delivery guarantee for this larger listing. Price/scope requires the actual Workana proposal fields and a Kael Human Gate before submission.

## Falsification / risks

Priority 1 is attractive because the listing is recent, currently shows zero competing bids and has a verified payment method, but the buyer is new and has zero paid projects shown. The scope is described as large and can exceed the bounded capability currently proven by Nexia. Therefore the correct move is a phased proposal, not a claim that the entire production system is already solved.

## Stop rule

Do not submit, contact the buyer, create external accounts, promise production capability, commit a price, or publish new proof media without the relevant Human Gate. New public evidence should be created only if it materially improves this application and preserves the internal/synthetic boundary.

## Next gate

If Priority 1 remains open when checked from the authenticated Workana account, Kael may authorize one bounded proposal. Before sending, verify the exact platform fields, account eligibility, visible buyer/project status and any price/currency requirements.

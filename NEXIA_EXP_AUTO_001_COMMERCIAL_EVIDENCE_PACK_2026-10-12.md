# NEXIA EXP-AUTO-001 — Commercial Evidence Pack

Date: 2026-10-12 (Europe/Madrid)
Status: PREPARED / NO EXTERNAL CONTACT / NO SPEND
Primary experiment: EXP-AUTO-001 — Lead Intake Reliability Sprint

## Purpose
Convert verified technical capability into truthful, reusable commercial proof so a buyer-initiated opportunity can be answered quickly without inventing client-production experience or rebuilding the same explanation for every marketplace.

This pack is internal commercial preparation. It does not authorize submission, contact, publication, account creation, spend or scope expansion.

## Commercial truth

HECHO VERIFICADO:
- n8n 2.42.6 runtime execution: PASS;
- six asserted intake/review cases executed inside n8n: PASS;
- persistent duplicate/idempotency proof with native n8n Data Tables: PASS;
- five separate webhook requests produced exactly two unique persisted identities;
- after stopping/restarting n8n and sending a sixth duplicate request, the audit still returned exactly two rows;
- autonomous_send=false;
- cost of technical proof: EUR 0;
- buyer production deployment: NOT EXECUTED;
- real Airtable / Google Sheets / client CRM integration: NOT EXECUTED;
- paying-client production experience: NONE VERIFIED;
- buyer willingness to pay: NOT VERIFIED;
- revenue: EUR 0;
- settled payment: EUR 0;
- net profit: EUR 0.

Primary evidence artifact:
`NEXIA_EXP_AUTO_001_N8N_PERSISTENT_DEDUP_2026-10-12.md`

Verified GitHub Actions evidence:
- n8n runtime logic run: `38178359319`;
- persistent Data Table proof run: `38180738447`;
- persistent-proof commit: `0051aa4c44f7de9f4f24de16de51759be64e1f25`.

## 30-second credibility statement

Use only after a proposal/contact is separately authorized:

> I have built and executed a technical proof in n8n 2.42.6 for lead intake validation, normalization, classification/review and persistent deduplication. The proof used separate webhook executions, persisted identity/event state and a process restart, while keeping customer sending disabled. I do not present this as prior paying-client production experience; it is an independently executed capability proof that I can adapt to the buyer's real stack.

## Claims matrix

### Safe claims — VERIFIED
- "Built and executed in n8n 2.42.6."
- "Tested with six asserted lead-intake/review cases."
- "Persistent duplicate/idempotency state survived a process restart in the test environment."
- "Duplicate events and duplicate normalized identities were blocked in the tested workflow."
- "Customer sending remained disabled / under human review."
- "The workflow artifacts and test evidence are reproducible."

### Must be qualified
- "Production-ready" -> NOT ALLOWED without buyer-stack deployment and acceptance testing.
- "Airtable integration" -> only say planned/compatible; real integration NOT EXECUTED.
- "Google Sheets integration" -> only say planned/compatible; real integration NOT EXECUTED.
- "CRM integration" -> only say planned/compatible; real client CRM NOT EXECUTED.
- "Scalable" -> only say architecture can be extended; load/concurrency proof NOT EXECUTED.

### Disallowed claims
- "Delivered this for paying clients."
- "Proven in production."
- "Guaranteed ROI / guaranteed savings."
- "No duplicates can ever occur."
- "Fully autonomous customer communication."
- any fabricated portfolio, testimonial, revenue or client logo.

## Productized scope — Lead Intake Reliability Sprint

Bounded deliverable:
1. one inbound lead source;
2. normalization of core contact fields;
3. required-field validation;
4. conservative duplicate handling;
5. bounded classification;
6. internal lead summary;
7. missing-data detection;
8. draft customer response with human review;
9. one internal notification/state update;
10. next-step/follow-up state;
11. synthetic/sample tests;
12. short handover/documentation;
13. one bounded correction after review.

Explicit exclusions unless separately approved and repriced:
- autonomous WhatsApp sending;
- WhatsApp Business account/setup;
- multi-channel rollout;
- CRM migration;
- mass historic-data cleanup;
- complex enterprise orchestration;
- paid APIs/subscriptions purchased by Nexia;
- open-ended support;
- high-volume concurrency guarantee;
- legal/compliance certification.

## Acceptance test template

A pilot is technically accepted only if all applicable conditions pass:
- sample lead enters the selected source;
- required fields are normalized consistently;
- missing required data is flagged rather than invented;
- classification follows agreed bounded rules;
- summary contains only supplied/derived information;
- duplicate event does not create a second logical lead;
- same normalized identity with a new event does not create an unintended duplicate under agreed policy;
- draft reply is created but not autonomously sent;
- internal state/next action is recorded;
- deliberate invalid case routes to review/error handling;
- workflow/export and short handover are delivered;
- buyer accepts after at most one bounded correction.

## Buyer discovery questions

Ask only after contact is authorized and a real buyer conversation exists:
1. Where do leads enter today: form, email, WhatsApp, CRM or spreadsheet?
2. What is the current source of truth: Airtable, Sheets, CRM or another system?
3. Which fields are mandatory before a lead can progress?
4. What counts as a duplicate today: same email, phone, event ID or combination?
5. Which classifications are actually useful to the team?
6. What information may the AI use when drafting a response?
7. Which actions must remain human-approved?
8. What is the expected lead volume and peak concurrency?
9. What failure is most expensive today: lost lead, duplicate handling, slow reply, wrong classification or bad follow-up?
10. What single measurable outcome would make the pilot successful?

## Reusable proposal blocks

### Opening
"I would treat this first phase as a bounded reliability sprint rather than a large automation project. The goal is to make one lead path observable, testable and maintainable before adding more channels or autonomous actions."

### Technical proof
"I have an executed n8n 2.42.6 proof covering validation, normalization, classification/review and persistent deduplication across separate webhook executions and a process restart. I prefer to be precise: this is technical evidence, not a claim of prior paying-client production deployment."

### Safety / human review
"Sensitive customer communication remains under human review in the first phase. Ambiguous or incomplete leads are escalated instead of allowing the workflow to invent missing information."

### Delivery
"The deliverable is the workflow, bounded configuration, test cases, short documentation/handover and one correction after review. Additional channels, migrations or autonomous sending are separate scope."

### Close
"If the current lead source and destination are confirmed, the first milestone can be defined with a small acceptance test before implementation so success/failure is objective."

## Opportunity-specific positioning

### P0 — Huescaventura
Recommended gross price: EUR 300 — already authorized under the existing Human Gate after profile approval is verified, project is still open and submission cost is zero.
Positioning: exact lead-intake/reliability sprint using buyer's Airtable/Sheets + n8n environment; human-reviewed response; duplicate control; follow-up state.
Do not expand into WhatsApp Business setup or autonomous customer sending.

### P1 — Workana Process Scale reserve
Budget: UNKNOWN.
Positioning if separately authorized: sell one process diagnostic + one bounded automation pilot, not enterprise-wide transformation.
Before proposal: obtain/verify enough public budget evidence or request a buyer-defined first milestone within platform rules.

### P2 — Upwork Lead Management USD 250 reserve
Status: cross-channel reserve only.
Before any action: account/profile state, Connects requirement/cost, freelancer fee and submission exposure must be verified and authorized.
Technical fit is high; acquisition odds are weak due to 50+ proposals.

## Economic screening

Current internal assumptions:
- target delivery: <=4 human hours;
- labor rate assumption: EUR 15/hour;
- labor assumption: EUR 60;
- extra variable tooling target: EUR 0.

Illustrative Workana-style economics at 20% platform commission:
- EUR 300 gross -> EUR 240 after platform -> EUR 180 contribution before overhead/tax;
- EUR 250 gross -> EUR 200 after platform -> EUR 140 contribution before overhead/tax;
- EUR 200 gross -> EUR 160 after platform -> EUR 100 contribution before overhead/tax;
- EUR 150 gross -> EUR 120 after platform -> EUR 60 contribution before overhead/tax;
- EUR 100 gross -> EUR 80 after platform -> EUR 20 contribution before overhead/tax.

RECOMMENDATION:
Treat approximately EUR 200 gross as the default minimum screening floor when a ~20% marketplace fee and the full four-hour labor assumption apply. This is a screening rule, not a universal price. A lower ticket is acceptable only if measured delivery time is materially below four hours or the opportunity has separately justified strategic value.

Tax remains UNKNOWN and no after-tax profit is claimed.

## Go / No-Go checklist before any proposal

GO candidate only when:
- buyer initiated the public brief;
- project is still open/freshly reverified;
- marketplace/account allows submission;
- submission spend/exposure is known;
- gross price can plausibly support contribution economics;
- scope fits the bounded sprint;
- required experience can be represented honestly;
- no prohibited autonomous sending or unbounded support is necessary;
- Human Gate authorizes that specific proposal/contact.

NO_GO when:
- ticket cannot plausibly cover labor + marketplace fee;
- buyer requires prior production portfolio that cannot be truthfully demonstrated;
- scope requires broad migration/multi-channel build for sprint pricing;
- success depends on autonomous outbound messaging outside authorization;
- proposal requires paid credits/moderation without explicit Kael approval;
- competition is extreme and ticket/fit does not compensate;
- material claims would require exaggerating experience.

## Current commercial operating rule

Do not create more synthetic engineering merely to improve a portfolio. The technical proof is already sufficient for honest commercial positioning. The next valuable evidence is buyer response, paid pilot, measured delivery time, buyer acceptance, settled payment and reconciled contribution/net profit.

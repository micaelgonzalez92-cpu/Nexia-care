# EXP-B1 — Quote Recovery & Follow-up Desk (zero-cost prototype)

Status: PROTOTYPE / NOT VALIDATED
Date: 2026-10-05

## Falsification update

The original wedge "generate quotes" is now crowded. Public Spanish products already offer WhatsApp/voice-to-PDF quote generation, including Don Presu, Presuvo, FontaGest, Tutti and PresupuestAPP. This is evidence of an existing market need, but also evidence against entering as a generic quote generator.

Decision: narrow the wedge to **quote recovery / follow-up visibility**.

## Core hypothesis

A small service business that already creates quotes but manages them across WhatsApp/email/spreadsheets will pay for a lightweight human-approved system that:
1. captures open quotes,
2. shows which quotes have gone quiet,
3. drafts the next follow-up,
4. records the outcome,
5. prevents interested jobs from disappearing into chat history.

## Evidence

- Recent contractor discussion: owners receive estimates that go silent and explicitly discuss whether/when to follow up; a reply notes follow-up can secure the job and remove dead opportunities.
- February 2026 contractor discussion: one owner reports losing jobs when same-day quotes are not delivered quickly and asks about follow-up timing.
- May/June 2026 small-business discussion: an owner estimates $15,000 of work was lost after failing to follow up on quotes and describes WhatsApp conversations disappearing from visibility.
- Spanish market already has quote-generation products; therefore generation alone is not a differentiated wedge.

Evidence level: SIGNAL / VETA candidate. No willingness-to-pay from our own buyer. No transaction.

## Zero-cost demo flow

INPUT
Customer / job / quote amount / date sent / channel / current status

→ OPEN QUOTE BOARD

Statuses:
- Sent
- Waiting
- Follow-up due
- Replied
- Won
- Lost
- Not qualified

→ ACTION

Generate a human-review follow-up draft based on elapsed time and status.

→ OUTCOME

Record response and next action.

## Guardrails

- No autonomous sending.
- No payment collection.
- No financial commitment.
- No CRM integration required for prototype.
- Human approves every message.
- Prototype only; no claim of revenue or user validation.

## Commercial test

Offer hypothesis:
"Te preparo y mantengo una bandeja de presupuestos pendientes para que ningún presupuesto con intención de compra se pierda por WhatsApp o email."

Pilot hypothesis:
€0 setup / manual pilot first, then test paid version only after a real workflow walkthrough and explicit willingness to pay.

Success:
- real business owner supplies a real anonymized quote workflow;
- identifies current follow-up gap;
- agrees to a short pilot;
- strongest signal: agrees to pay.

Failure:
- owner already has adequate visibility;
- follow-up is not painful/frequent;
- no willingness to trial/pay.

## Next action

Find 3-5 Spanish service businesses with public evidence of quote/contact workflows, without contacting them, and map:
- inbound channel,
- quote process,
- visible follow-up mechanism,
- likely gap,
- estimated repeat frequency.

Then compare against PROJECT C and PROJECT D before any build escalation.

# NEXIA EXP-AUTO-001 — BUYER-INITIATED SCAN — 2026-10-11 12:51 CEST

Status: RESEARCHED / NO PROPOSALS SUBMITTED / COST €0
Canonical STATE remains v61. This is a post-state research checkpoint only.

## Objective
Check whether the Huescaventura candidate is still live and search for additional buyer-initiated automation briefs that can satisfy EXP-AUTO-001 without overstating experience, lowering the economics gate, or spending money.

## Primary candidate status — Huescaventura / Workana

Current public page still shows:
- status: `Evaluando propuestas` / `Abierto`;
- buyer asks for a bounded semiautomatic first phase;
- Airtable/Google Sheets intake, n8n, classification, missing-data detection, internal summary, suggested reply, internal alert, duplicate detection, basic follow-up and documentation;
- existing self-hosted n8n;
- indicative budget €200–€300;
- 1 proposal and 1 interested freelancer shown on the public page;
- buyer profile: 2 projects published, 1 paid, payment verified.

Decision: Huescaventura remains the strongest currently known buyer-initiated candidate for EXP-AUTO-001. Proposal remains DRAFT_NOT_SUBMITTED because generic `/next` does not authorize external submission.

## Backup candidate scan

### Upwork — Build AI Lead Management & Follow-Up Automation — $250 fixed
Fit:
- webhook/form intake;
- validation/normalization;
- Google Sheets/Airtable;
- AI classification/summary;
- status/priority;
- follow-up;
- error handling/logging;
- documentation.

Positive:
- no explicit portfolio requirement found in the public brief text;
- scope is close to EXP-AUTO-001.

Negative:
- 50+ proposals;
- 6 interviews;
- buyer last viewed the job about two weeks ago;
- current Upwork proposal-credit/account economics are not reconciled for Nexia.

Decision: BACKUP_ONLY / DO_NOT_PRIORITIZE OVER HUESCAVENTURA.

### Upwork — n8n AI Lead Qualification & CRM Automation — $400 fixed
Fit:
- webhook/form intake;
- validation;
- duplicates;
- LLM qualification;
- CRM;
- notifications;
- error handling/logging;
- documentation/handover.

Negative:
- 50+ proposals;
- one hire already shown;
- buyer last viewed about two weeks ago;
- broader AI/CRM scope increases delivery risk relative to the 4 h pilot gate.

Decision: MARKET/PRICE SIGNAL / NOT CURRENT FIRST PROPOSAL.

### Upwork — n8n + Airtable Trade Business CRM — $230 fixed
Negative:
- below the original €249-equivalent target before platform costs;
- 50+ proposals;
- requires proven n8n experience;
- one hire shown.

Decision: FAIL — ECONOMICS/TRUTHFULNESS/COMPETITION.

### Freelancer — automation / n8n / Airtable jobs
Observed public examples either:
- were already closed;
- had very high proposal counts (e.g. 69 or 104); or
- explicitly required proven n8n/Airtable/WhatsApp/Teams/OpenAI experience and screenshots/links.

Decision: no newly observed Freelancer project displaces Huescaventura.

## Gate result

Current ranked opportunities:
1. **Huescaventura / Workana — QUALIFIED, proposal ready, Human Gate pending.**
2. Upwork $250 lead-management automation — BACKUP, high competition, channel economics unresolved.
3. Upwork $400 lead-qualification automation — BACKUP/market signal, 50+ proposals and one hire.
4. Other scanned briefs — FAIL or deprioritized.

## Learning
The market continues to show recurring demand for the same reliability primitives Nexia has built locally: validation, deduplication, idempotency/error handling, CRM/Sheet state, notifications and handover. The commercial bottleneck is not absence of demand; it is obtaining a buyer-initiated brief whose price, competition, bounded scope and truthful experience fit all gates simultaneously.

## Next safe action
Until explicit authorization exists:
- do not submit Huescaventura or any other proposal;
- do not create/connect marketplace accounts;
- do not spend proposal credits or money;
- keep Huescaventura as the primary candidate while it remains open;
- continue zero-cost discovery only when new evidence could change the ranking.

## Economic status
Cost: €0.
No proposal, client contact, contract, payment, revenue or profit occurred in this scan.

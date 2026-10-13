# n8n Creator Submission 02 — INTERNAL REPLACEMENT CANDIDATE

Status: `PREPARED / NOT READY FOR SUBMISSION / EXTERNAL PUBLICATION NOT AUTHORIZED`
Date: 2026-10-12
Vein: `VETA-AUTO-PRODUCT-001`

## Why this exists

Template #1 (`Normalize inbound lead intake for human review via webhook`, Creator workflow 20799) was rejected by n8n as **too basic to meet publishing criteria**.

This replacement is intentionally not a cosmetic rewrite. It uses a materially deeper capability already present and runtime-verified inside the Lead Intake Reliability Kit: persistent duplicate protection with native n8n Data Tables.

However, technical depth alone is no longer sufficient for submission readiness. This candidate must pass `NEXIA_PROFESSIONAL_QUALITY_GATE.md` before any future submission is proposed.

## Candidate title

**Prevent Duplicate Lead Processing Across Runs with n8n Data Tables**

## Workflow

`products/lead-intake-reliability-kit/workflows/persistent-dedup-guard.json`

Supporting setup component:
`products/lead-intake-reliability-kit/workflows/dedup-table-bootstrap.json`

## Problem it solves

Webhook and lead workflows can process the same event more than once or receive the same person repeatedly under different event IDs. That can create duplicate CRM records, repeated notifications, repeated AI/API usage, or accidental repeated customer-facing actions.

This candidate creates deterministic keys and checks both:

- duplicate event IDs;
- duplicate normalized identities (email first, otherwise phone).

The workflow stores accepted identities in a native n8n Data Table so the protection persists beyond a single execution.

## Why it is materially deeper than Template #1

Template #1 normalized and validated one inbound payload in one execution. This candidate adds stateful behavior using native Data Tables and explicitly solves repeated-event / repeated-identity reliability across executions.

It demonstrates:

1. webhook intake;
2. deterministic key normalization;
3. persistent state;
4. event-level duplicate detection;
5. identity-level duplicate detection;
6. controlled insertion only for new identities;
7. an explicit `autonomous_send=false` boundary.

## Evidence already available

NEXIA has internal runtime evidence on n8n 2.42.6 that native Data Table deduplication persisted across separate webhook executions and a process restart. That is internal technical evidence only; it is not client-production history and not market-demand proof.

## Suggested usage

Use this component before expensive or externally visible downstream actions such as:

- AI classification;
- CRM creation;
- internal alerts;
- email/WhatsApp drafting;
- other API calls.

The workflow itself does not send customer-facing messages.

## Setup boundary

A native Data Table named `lead_intake_reliability_keys` with `eventKey`, `identityKey`, and `recordId` fields is required. The existing bootstrap workflow can create that structure.

Before any future submission, package the setup so a new user can reproduce it without relying on undocumented internal state.

## Professional pre-submission gate

Do **not** submit this candidate merely because it imports and runs.

Before it can be considered ready, all of the following must be evidenced:

- the workflow remains importable and inactive by default;
- setup is self-contained or clearly reproducible without hidden internal state;
- valid first event is accepted;
- repeated event ID is blocked;
- repeated normalized identity is blocked;
- persistence across separate executions and restart is demonstrated;
- invalid input and at least one realistic failure path are handled explicitly;
- no credentials or buyer-specific data are embedded;
- no autonomous external send occurs;
- configuration points are obvious to a new user;
- the workflow is understandable without substantial undocumented scaffolding;
- a concise “why import this instead of building it in a few minutes?” answer is defensible with concrete time/risk reduction;
- the current Creator Portal requirements are rechecked;
- an internal rejection memo identifies the strongest reasons n8n could reject it and each reason is rebutted by evidence;
- Kael separately authorizes external submission/publication.

## Adversarial reviewer test

Before any external reviewer sees this candidate, Nexia must answer:

1. What is the most obvious reason an experienced n8n user would call this basic?
2. What reusable reliability behavior is difficult enough to justify saving/importing the template?
3. What happens on malformed input, duplicate retries, partial setup, missing table or runtime interruption?
4. Can a new user reproduce the setup in one pass without reading internal Nexia documentation?
5. Does the template teach or deliver something materially beyond a beginner tutorial?

If any answer is weak or unsupported by evidence, status remains `NOT READY FOR SUBMISSION`.

## Falsification rule

If this candidate still requires substantial explanatory scaffolding or a second workflow merely to become understandable/installable, prefer packaging one richer self-contained workflow rather than submitting fragmented components. Do not add nodes merely to look more complex.

## Commercial truth

This is a distribution experiment candidate, not a product sale. Current external users: 0. Paid sales: 0. Settled revenue: EUR0. Realized profit: EUR0.

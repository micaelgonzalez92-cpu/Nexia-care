# n8n Creator Submission 02 — INTERNAL REPLACEMENT CANDIDATE

Status: `PREPARED / NOT SUBMITTED / EXTERNAL PUBLICATION NOT AUTHORIZED`
Date: 2026-10-12
Vein: `VETA-AUTO-PRODUCT-001`

## Why this exists

Template #1 (`Normalize inbound lead intake for human review via webhook`, Creator workflow 20799) was rejected by n8n as **too basic to meet publishing criteria**.

This replacement is intentionally not a cosmetic rewrite. It uses a materially deeper capability already present and runtime-verified inside the Lead Intake Reliability Kit: persistent duplicate protection with native n8n Data Tables.

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

## Pre-submission gate

Do **not** submit this candidate yet.

A future submission is allowed only after all of the following are true:

- the workflow remains importable and inactive by default;
- setup is self-contained or clearly reproducible;
- valid first event is accepted;
- repeated event ID is blocked;
- repeated normalized identity is blocked;
- persistence across separate executions is demonstrated;
- no credentials or buyer-specific data are embedded;
- no autonomous external send occurs;
- the current Creator Portal requirements are rechecked;
- Kael separately authorizes external submission/publication.

## Falsification rule

If this candidate still requires substantial explanatory scaffolding or a second workflow merely to become understandable/installable, prefer packaging one richer self-contained workflow rather than submitting fragmented components. Do not add nodes merely to look more complex.

## Commercial truth

This is a distribution experiment candidate, not a product sale. Current external users: 0. Paid sales: 0. Settled revenue: EUR0. Realized profit: EUR0.

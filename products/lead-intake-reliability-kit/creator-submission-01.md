# n8n Creator Submission 01 — REJECTED

Status: `SUBMITTED / REVIEWED / REJECTED_NOT_PUBLISHED`
Creator workflow ID: `20799`
Review result date: `2026-10-12`

## Review outcome

n8n reviewed **Normalize inbound lead intake for human review via webhook** and declined publication because it was **too basic to meet publishing criteria**.

The reviewer added that if the workflow is intended for beginners, an alternative would be to create a YouTube tutorial and add it as a sticky note on the workflow canvas.

This rejection is a distribution-quality signal. It does **not** invalidate the internal n8n runtime evidence below and does not prove or disprove customer willingness to pay.

## Template title

**Reliable Lead Intake: Normalize, Validate & Prepare Human Review via Webhook**

## Intended price

**Free**

## Workflow file

`products/lead-intake-reliability-kit/workflows/lead-intake-human-review.json`

## Nodes / integrations used

- Webhook
- Code
- Respond to Webhook

No third-party credentials are required.

## Short description

Receive inbound lead payloads through an n8n webhook, validate required identity/contact fields, normalize email and phone data, generate a structured internal summary and prepare a reply draft for human review — without automatically sending anything to the customer.

## Problem it solves

The workflow creates a deterministic intake boundary that:

- rejects missing core fields;
- normalizes email and phone values;
- keeps source/service/message context;
- creates a compact review summary;
- prepares a reply draft;
- keeps customer sending under human control.

## How it works

1. A POST request reaches the `Lead Webhook` node.
2. `Normalize and Prepare Review` checks `event_id`, `name` and at least one contact method (`email` or `phone`).
3. Email is trimmed/lowercased and phone formatting is normalized deterministically.
4. Invalid payloads return `validation_failed` plus the missing fields.
5. Valid payloads return normalized data, a structured summary and a draft reply.
6. The final response includes `autonomous_send=false` and `next_step=human_review`.

## Tested evidence boundary

NEXIA executed this workflow inside a real n8n 2.42.6 server in GitHub Actions as part of the internal product runtime suite. A valid synthetic lead passed normalization and an invalid synthetic lead was rejected as expected. This is internal technical evidence, not paid-client production history.

## Internal test checklist

- [x] Workflow imports successfully in n8n 2.42.6.
- [x] Workflow remains inactive by default after import/export.
- [x] Real webhook runtime test PASS.
- [x] Valid synthetic input PASS.
- [x] Invalid synthetic input rejection PASS.
- [x] No buyer-specific branding.
- [x] No credentials.
- [x] No outbound-send node.
- [x] `autonomous_send=false` asserted.
- [x] Submitted to n8n Creator Portal.
- [x] Reviewed by n8n.
- [x] Rejected as too basic.

## Learning / next route

Do not resubmit this same workflow with cosmetic changes. The prepared internal replacement candidate is:

`products/lead-intake-reliability-kit/creator-submission-02.md`

It uses the already-verified persistent native Data Table deduplication capability to create materially deeper reusable value. Any external resubmission/publication remains a separate Human Gate.

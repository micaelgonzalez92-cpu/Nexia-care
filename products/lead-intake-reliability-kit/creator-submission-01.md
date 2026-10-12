# n8n Creator Submission 01 — INTERNAL PACKAGE

Status: `PREPARED / NOT SUBMITTED / NO CREATOR ACCOUNT CREATED`

This package is ready to adapt into the current n8n Creator Dashboard fields after Kael explicitly authorizes account creation and submission. It does not authorize publication.

## Template title
**Reliable Lead Intake: Normalize, Validate & Prepare Human Review via Webhook**

## Intended price
**Free**

Reason: this is template 1 of a proposed three-template free creator ladder. Current n8n Creator rules require three approved templates before a creator becomes verified and gains the option to publish paid templates.

## Workflow file
`products/lead-intake-reliability-kit/workflows/lead-intake-human-review.json`

## Suggested category
**Sales**

Secondary relevance: Support / Other, depending on the categories exposed by the Creator Dashboard at submission time.

## Nodes / integrations used
- Webhook
- Code
- Respond to Webhook

No third-party credentials are required.

## Short description
Receive inbound lead payloads through an n8n webhook, validate required identity/contact fields, normalize email and phone data, generate a structured internal summary and prepare a reply draft for human review — without automatically sending anything to the customer.

## Who is this for?
Freelancers, agencies and small teams that already use n8n and want a safer first layer for inbound lead automation before connecting a CRM, email platform, WhatsApp or another customer-facing destination.

## Problem it solves
Lead automations often become unreliable before the CRM or sales step because incoming data is incomplete or inconsistently formatted. This template creates a deterministic intake boundary that:
- rejects missing core fields;
- normalizes email and phone values;
- keeps source/service/message context;
- creates a compact review summary;
- prepares a reply draft;
- explicitly keeps customer sending under human control.

## How it works
1. A POST request reaches the `Lead Webhook` node.
2. `Normalize and Prepare Review` checks `event_id`, `name` and at least one contact method (`email` or `phone`).
3. Email is trimmed/lowercased and phone formatting is normalized deterministically.
4. Invalid payloads return `validation_failed` plus the missing fields.
5. Valid payloads return normalized data, a structured summary and a draft reply.
6. The final response always includes `autonomous_send=false` and `next_step=human_review`.

## Expected input example
```json
{
  "event_id": "lead-001",
  "name": "Alex Example",
  "email": " Alex.Example@Example.com ",
  "phone": "+34 600 123 456",
  "source": "website-form",
  "service": "consultation",
  "message": "I need help with an automation."
}
```

## Expected valid-output characteristics
- `ok=true`
- `status=prepared_for_human_review`
- normalized email and phone
- structured `summary`
- `reply_draft`
- `next_step=human_review`
- `autonomous_send=false`

## Expected invalid-output characteristics
If `name` or both contact methods are missing:
- `ok=false`
- `status=validation_failed`
- explicit `missing_fields`
- `autonomous_send=false`

## Setup
1. Import the workflow JSON into your own n8n instance.
2. Review the Code node and keep the workflow inactive until you understand the expected payload.
3. Activate the workflow.
4. POST a sample payload to the production webhook.
5. Confirm the response is normalized and marked for human review.
6. Add your own downstream CRM/message workflow only after deciding what should happen after human approval.

## Requirements
- n8n instance with Webhook, Code and Respond to Webhook nodes.
- Ability to expose/call an n8n webhook.
- No third-party credentials are required for the template itself.

## Safety and scope notes
- The template does not send emails, WhatsApp messages or other customer-facing communications.
- It does not include CRM credentials or buyer-specific data.
- It does not guarantee conversion, sales or revenue improvements.
- It is designed as an intake/review boundary; downstream actions are intentionally left to the user.

## Tested evidence boundary
NEXIA executed this workflow inside a real n8n 2.42.6 server in GitHub Actions as part of the internal product runtime suite. A valid synthetic lead passed normalization and an invalid synthetic lead was rejected as expected. This is internal technical evidence, not paid-client production history.

## Internal submission checklist
Before submitting:
- [x] Workflow imports successfully in n8n 2.42.6.
- [x] Workflow remains inactive by default after import/export.
- [x] Real webhook runtime test PASS.
- [x] Valid synthetic input PASS.
- [x] Invalid synthetic input rejection PASS.
- [x] No buyer-specific branding.
- [x] No credentials.
- [x] No outbound-send node.
- [x] `autonomous_send=false` asserted.
- [ ] Re-check current Creator Dashboard field names and current submission guidelines immediately before submission.
- [ ] Kael explicitly authorizes creator-account creation and submission/publication of this free template.

## Creator-ladder role
If approved, this is **1/3** toward current verified-creator eligibility.

Planned follow-ups, not yet submitted:
2. `Persistent Lead Dedup Guard with n8n Data Tables`
3. `Authenticated Webhook Intake + Error-Safe Validation`

Do not submit template 2 until template 1 is approved, because current n8n guidance states new creators can submit one template at a time.

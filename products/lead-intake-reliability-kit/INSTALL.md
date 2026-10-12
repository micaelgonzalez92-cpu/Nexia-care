# Lead Intake Reliability Kit — Installation & First Test

Status: INTERNAL v0.1 / NOT PUBLISHED

Target: a competent n8n user should be able to import, bootstrap and run the supplied samples in **<=30 minutes** without a support call. This target is not externally verified yet.

## Requirements
- Your own n8n instance compatible with the included workflows.
- n8n Data Tables available.
- Permission to import and activate workflows.
- No third-party credentials are required for the core kit.

NEXIA's internal runtime proof currently uses n8n `2.42.6`. Compatibility with other versions is not yet claimed.

## Files
Import these workflows from `workflows/`:
1. `lead-intake-human-review.json`
2. `dedup-table-bootstrap.json`
3. `persistent-dedup-guard.json`

`dedup-audit.json` is an internal QA helper and is not required for a normal buyer installation.

## Step 1 — Import the workflows
Use n8n's workflow import function. Keep each workflow inactive while inspecting it.

Verify before activation:
- no credentials are requested by the core workflows;
- no outbound email/WhatsApp/message node exists;
- `autonomous_send` remains `false` in review outputs.

## Step 2 — Create the persistent dedup table
Activate `Lead Intake Reliability - Dedup Table Bootstrap` temporarily and call its webhook once.

Expected table:
`lead_intake_reliability_keys`

Expected columns:
- `eventKey`
- `identityKey`
- `recordId`

Do not repeatedly run the bootstrap unless you understand the state of the existing table.

## Step 3 — Test normalization + human review
Activate `Lead Intake Reliability - Normalize and Human Review`.

POST the payload from:
`samples/valid-lead.json`

Expected characteristics:
- `ok=true`
- `status=prepared_for_human_review`
- normalized email `alex.example@example.com`
- normalized phone `+34600123456`
- a structured summary
- a reply draft clearly marked as not sent
- `autonomous_send=false`

Then POST:
`samples/invalid-lead.json`

Expected characteristics:
- `ok=false`
- `status=validation_failed`
- missing `name`
- missing `email_or_phone`
- `autonomous_send=false`

## Step 4 — Test persistent dedup
Activate `Lead Intake Reliability - Persistent Dedup Guard`.

POST `samples/valid-lead.json` once.

Then POST `samples/duplicate-lead.json`.

The second payload uses a different event ID but the same normalized identity. The guard must not insert a second row for that identity.

For production use, connect only the successful unique path to your own downstream workflow after reviewing the imported logic and adapting it to your environment.

## Step 5 — Add your downstream destination
The core kit deliberately stops before a buyer-specific CRM, email system, WhatsApp account or other customer-facing action.

Add downstream integrations only after:
- mapping required fields;
- deciding what counts as a duplicate;
- testing your destination credentials;
- defining retry/error behavior;
- explicitly choosing which actions remain under human review.

## Safety boundary
The kit does **not**:
- host n8n for you;
- migrate a CRM;
- configure WhatsApp Business/API;
- send customer-facing messages autonomously by default;
- guarantee revenue, conversion or zero failures.

## First-test acceptance checklist
A standard installation is acceptable only when:
- valid sample normalizes correctly;
- invalid sample is rejected;
- duplicate identity is not inserted twice;
- no customer-facing send occurs;
- your own downstream integration remains disconnected until you intentionally add it.

## Support boundary hypothesis
The future self-serve commercial test will target median support of **<=20 minutes per paid sale**. This is a validation threshold, not a current result.

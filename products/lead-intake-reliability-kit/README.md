# Lead Intake Reliability Kit for n8n — INTERNAL v0.1

Status: `INTERNAL / NOT PUBLISHED / NOT FOR CUSTOMER DELIVERY YET`

This kit packages NEXIA's internally verified lead-intake reliability controls into reusable n8n components.

## Problem
Inbound leads often fail before sales even starts:
- required fields are missing;
- email/phone formatting is inconsistent;
- duplicate events or repeat identities create repeated work;
- automations send or act before a human has reviewed ambiguous data;
- workflows are hard to test and hand over.

## Product thesis
Make inbound lead intake predictable **before** automating customer-facing actions.

## Included components

### 1. `workflows/lead-intake-human-review.json`
A credential-free workflow that:
- receives lead payloads through a webhook;
- validates event ID, name and at least one contact method;
- normalizes email and phone;
- preserves source/message/service context;
- creates a structured internal summary;
- prepares a reply draft;
- sets the next step;
- always keeps `autonomous_send=false`.

### 2. `workflows/dedup-table-bootstrap.json`
Creates a native n8n Data Table named `lead_intake_reliability_keys` with event and identity keys.

### 3. `workflows/persistent-dedup-guard.json`
Uses native n8n Data Tables to block repeat event IDs and repeat normalized identities before downstream processing.

### 4. `samples/`
Synthetic payloads for installation and QA. No real customer data.

### 5. `QA_CHECKLIST.md`
Minimum acceptance test for the self-serve kit.

## Intended buyer
A technically comfortable n8n user, freelancer, agency or small business already operating an n8n instance and wanting safer inbound-lead handling.

## Not included
- n8n hosting;
- n8n license;
- customer credentials;
- CRM migration;
- WhatsApp Business/API setup;
- autonomous external messaging;
- bespoke implementation;
- open-ended support.

## Truthful evidence boundary
NEXIA has internally executed and verified n8n 2.42.6 runtime logic and persistent native Data Table deduplication across separate webhook executions and a process restart. This is **technical proof**, not prior paying-client production experience and not evidence of product demand.

## Commercial state
- Published: NO
- Store/account created: NO
- Customers: 0
- Paid sales: 0
- Settled revenue: 0
- Realized profit: 0

## Current price hypothesis
`USD 49 one-time` — research hypothesis only. No price has been offered publicly.

## Next gate
The kit may move to `VALIDATION_READY` only after its product QA passes and Kael separately authorizes a publication/distribution experiment with fixed success/failure thresholds.

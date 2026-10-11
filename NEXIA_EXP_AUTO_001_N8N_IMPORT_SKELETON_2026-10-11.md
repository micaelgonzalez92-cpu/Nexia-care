# NEXIA EXP-AUTO-001 — n8n IMPORT SKELETON — 2026-10-11

Status: DESIGNED / LOCAL STRUCTURAL+CODE VALIDATION 12/12 PASS / NOT EXECUTED IN n8n
Cost: €0
External contact: NONE
Proposal submission: NOT EXECUTED

## Objective
Reduce the technical gap between the Huescaventura-specific synthetic logic and the buyer's stated n8n environment without claiming production n8n experience.

## Public-source compatibility basis
Current n8n documentation exposes built-in Webhook, Code and Respond to Webhook nodes. Current workflow examples use node objects with parameters/type/typeVersion/position/id/name plus a connections graph. Huescaventura explicitly asks for an exportable n8n workflow if n8n is used.

## Artifact
`prototypes/n8n-huescaventura-intake-demo.json`

Three-node credential-free chain:
1. POST Webhook `/nexia-huescaventura-intake`
2. Code node `Prepare Lead Review`
3. Respond to Webhook `Respond Draft`

The workflow is inactive by default.

## Covered behavior
- validates event id, name and contact;
- classifies despedida / amigos / familia / empresa / escolar / solo actividad / pack alojamiento / revision;
- routes ambiguous cases to manual classification review;
- detects missing fields;
- creates business-facing Spanish summary;
- creates a reply draft explicitly marked not sent;
- normalizes email/phone identity fields;
- keeps follow-up under human decision;
- does not include external-send, Airtable, email, Telegram, WhatsApp, HTTP Request or credential nodes.

## Important persistence limitation
This skeleton deliberately does NOT claim persistent deduplication or idempotency across executions. Those require binding to the client's Airtable/Google Sheet/database or another persistent store inside the actual n8n instance. The workflow response exposes this limitation explicitly.

## Validator
`prototypes/validate_n8n_huescaventura_demo.js`

Local result: **12/12 PASS**.

Checks:
1. workflow inactive by default;
2. unique node names and IDs;
3. expected 3-node chain;
4. POST webhook with responseNode mode;
5. all connection targets exist;
6. no credentials embedded;
7. no outbound send/network action nodes;
8. valid despedida produces draft-only human-review output;
9. ambiguous input requires manual classification;
10. missing data uses Spanish business labels;
11. missing contact is rejected;
12. persistent dedup/idempotency limitation is explicit.

## Evidence classification
- HECHO VERIFICADO: local JSON and embedded Code node validator passed 12/12.
- HECHO VERIFICADO: workflow contains no credentials and no outbound-send/action nodes.
- HECHO VERIFICADO: Huescaventura public brief remains open/evaluating proposals and asks for n8n, Airtable/Sheets, draft response, duplicate handling, follow-up and exportable workflow.
- NOT EXECUTED: import into a real n8n instance.
- NOT VERIFIED: compatibility with Huescaventura's exact self-hosted n8n version/configuration.
- NOT VERIFIED: Airtable credentials/schema, persistent deduplication across executions, Telegram/email notification, real buyer data, production reliability, buyer acceptance.
- DO NOT CLAIM: client n8n production experience or successful buyer deployment.

## Next gate
When Workana profile approval is verified and Huescaventura is still open, submit the already-authorized €300 proposal. If the buyer engages, request only the minimum field/schema information needed, then import/test this skeleton in their n8n environment before adding persistent storage or notifications.

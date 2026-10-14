# EXP-AUTO-001 — Contra Portfolio Pack V1

Date: 2026-10-14
Status: PREPARED / NOT YET PUBLISHED
Channel: Contra
Experiment: EXP-AUTO-001_CONTRA_MICROTEST_V1
Cash spend: EUR 0

## Purpose
Create four truthful portfolio pieces that demonstrate relevant automation capability without claiming paying-client work, production deployment, commercial results, testimonials, revenue lift or buyer acceptance that do not exist.

## Truth boundary
All four pieces are based on internally executed technical demos, synthetic fixtures and verified repository evidence. They may be described as internal demos, technical proofs or reference implementations. They must NOT be described as client projects or production customer deployments.

---

## Piece 1 — n8n Lead Intake & Human Review Workflow

### Recommended title
**n8n Lead Intake & Human Review Workflow**

### Recommended description
Internal automation demo built and tested in n8n 2.42.6 using synthetic lead data. The workflow validates required fields, normalizes email and phone data, routes incomplete or ambiguous cases to human review, creates a structured internal summary and prepares a reply draft while keeping `autonomous_send=false`.

The core intake/review logic was executed inside a real n8n runtime across six asserted synthetic cases. No client credentials, real customer data or production messaging were used.

### Role
**Automation Designer & Developer**

### Suggested skills/tags
- n8n
- Workflow Automation
- Lead Management
- JavaScript
- Process Automation

### Evidence
- `NEXIA_EXP_AUTO_001_N8N_RUNTIME_EXECUTION_2026-10-11.md`
- `prototypes/n8n-huescaventura-intake-demo.json`
- `prototypes/n8n-huescaventura-runtime-fixture.json`

### Claims allowed
- Real n8n runtime execution verified.
- Six asserted synthetic cases executed successfully.
- Validation, normalization, routing and human-review logic demonstrated.
- No autonomous customer message sending in the tested workflow.

### Claims forbidden
- Client deployment.
- Production use.
- Revenue/conversion lift.
- Buyer acceptance.
- Paid delivery.

---

## Piece 2 — Persistent Lead Deduplication with n8n Data Tables

### Recommended title
**Persistent Lead Deduplication with n8n Data Tables**

### Recommended description
Internal technical proof of persistent lead deduplication and idempotency using native n8n Data Tables. Separate webhook executions were tested against repeated event IDs and repeated normalized identities so duplicate events or identities did not create additional stored rows.

The n8n process was then restarted and the persisted Data Table state was audited again, confirming that the tested deduplication state survived the restart. The proof used synthetic data only and did not connect to a client CRM or production environment.

### Role
**Automation Designer & Developer**

### Suggested skills/tags
- n8n
- Webhooks
- Data Quality
- Data Deduplication
- Idempotency

### Evidence
- `NEXIA_EXP_AUTO_001_N8N_PERSISTENT_DEDUP_2026-10-12.md`
- `prototypes/n8n-datatable-dedup-setup.json`
- `prototypes/n8n-datatable-dedup-webhook.json`
- `prototypes/n8n-datatable-dedup-audit.json`

### Claims allowed
- Native n8n Data Tables used in the verified proof.
- Repeated event IDs blocked from additional rows in the tested workflow.
- Different event IDs with the same normalized identity blocked from additional rows.
- State survived a verified n8n process restart in the isolated test environment.

### Claims forbidden
- High-concurrency guarantee.
- Production CRM integration.
- Zero-failure guarantee.
- Client deployment or client acceptance.

---

## Piece 3 — Fail-Safe Lead Processing Engine in Node.js

### Recommended title
**Fail-Safe Lead Processing Engine — Node.js**

### Recommended description
Synthetic reference implementation for reliable inbound lead processing. The engine covers deterministic normalization, required-field validation, event idempotency, identity deduplication, non-destructive record merging, draft acknowledgements, manual-review alerts, audit entries and injected pre-commit failure handling.

The first regression run exposed an unsafe assumption around local versus international phone normalization. That assumption was removed, a negative regression case was added, and the revised suite then passed 9/9 tests. The implementation uses synthetic data and performs no external sends.

### Role
**Automation & Reliability Developer**

### Suggested skills/tags
- Node.js
- JavaScript
- Workflow Reliability
- QA Testing
- Lead Operations

### Evidence
- `NEXIA_EXP_AUTO_001_CAPABILITY_DEMO_2026-10-11.md`
- `prototypes/lead-intake-reliability-demo.js`
- `prototypes/test-lead-intake-reliability-demo.js`

### Claims allowed
- Synthetic reference implementation executed.
- Unsafe phone-normalization assumption was discovered, repaired and regression-tested.
- Revised suite passed 9/9 test cases.
- No external messages or real customer data used.

### Claims forbidden
- Platform-specific client experience.
- Production deployment.
- Paid-client case study.
- Commercial impact or ROI.

---

## Piece 4 — Automated n8n Workflow QA & Regression Checks

### Recommended title
**Automated n8n Workflow QA & Regression Checks**

### Recommended description
GitHub Actions smoke-test pipeline for n8n automation. The test suite imports and re-exports workflows, executes synthetic cases inside n8n 2.42.6, verifies safety assertions, starts a full n8n server, sends production-style webhook requests, audits Data Table state and checks persistence after a process restart.

The goal is to detect workflow and data-quality regressions before any client-facing deployment. This is internal technical QA evidence, not evidence of a customer production rollout.

### Role
**Automation QA & Workflow Developer**

### Suggested skills/tags
- GitHub Actions
- CI/CD
- n8n
- Automated Testing
- Workflow Automation

### Evidence
- `.github/workflows/n8n-runtime-smoke.yml`
- `.github/workflows/n8n-product-runtime-smoke.yml`
- `products/lead-intake-reliability-kit/QA_CHECKLIST.md`

### Claims allowed
- Automated import/export and runtime checks exist.
- Synthetic valid/invalid lead behaviors are asserted.
- Persistent Data Table state is checked through restart in the test harness.
- Safety boundary includes `autonomous_send=false`.

### Claims forbidden
- Production SLA.
- Client deployment.
- Commercial reliability guarantee.
- Revenue or conversion impact.

---

## Recommended publication order
1. n8n Lead Intake & Human Review Workflow
2. Persistent Lead Deduplication with n8n Data Tables
3. Fail-Safe Lead Processing Engine — Node.js
4. Automated n8n Workflow QA & Regression Checks

This order leads with the business problem, then shows reliability depth, engineering logic and QA discipline.

## Visual asset plan
Do not generate or publish visuals until the exact Contra work-item form/media requirements are observed. Preferred visuals are simple architecture/workflow diagrams or sanitized screenshots derived from the internal demos. No client logos, fabricated dashboards, fake testimonials, invented metrics or fake production screenshots.

## Contra field-mapping rule
The wording above is the approved source copy. When the actual Contra form is visible, map it to the available title/description/role/skills/media fields without materially strengthening claims.

## Economic state
- Cash spend: EUR 0
- Applications submitted: 0
- Qualified responses from Contra: 0
- Paid pilots from Contra: 0
- Settled revenue: EUR 0
- Realized profit: EUR 0

## Next step
Open Contra → `Add 4 pieces of work to your profile` → show the first creation form. Nexia will map the exact fields and prepare any required media while preserving these evidence boundaries.

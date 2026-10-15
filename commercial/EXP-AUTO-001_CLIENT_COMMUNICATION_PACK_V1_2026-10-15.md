# EXP-AUTO-001 — CLIENT COMMUNICATION PACK V1

Date: 2026-10-15
Status: PREPARED_INTERNAL / TRUTH-SAFE / NOT YET USED EXTERNALLY

## Purpose
Provide reusable, truthful explanations of the Nexia Contra project for buyer conversations, Contra, website, LinkedIn, proposals and discovery calls without overstating client experience, production deployment or commercial outcomes.

## One-line version
Nexia builds reliable lead-intake and CRM data-quality automations that validate, normalize, deduplicate and route inbound data while keeping uncertain or sensitive cases under human review.

## Short client-facing version
We have built a reliable lead-intake and CRM data-quality automation system designed to turn messy inbound data into structured, deduplicated and review-ready records. The system combines n8n workflows, persistent Data Tables, JavaScript/Node.js validation logic and automated QA in GitHub Actions, with explicit human-review paths for ambiguous or sensitive cases.

The work is presented through four complementary technical proofs: Lead Intake & Human Review, Persistent Deduplication, Fail-Safe Processing, and Workflow QA & Regression. Together they demonstrate how the system handles data quality, duplicate prevention, failure safety and automated testing as parts of one reliability-focused architecture.

## 30–60 second spoken explanation
The project is a reliable automation system for companies that receive leads from multiple sources and need clean, consistent CRM data. We built workflows that validate and normalize incoming records, prevent duplicate leads across separate executions, route uncertain data to human review and test the automation automatically before it is considered ready for customer-facing use.

The stack includes n8n 2.42.6, native n8n Data Tables, webhooks, JavaScript and Node.js, plus GitHub Actions for runtime and regression testing. We have verified persistent deduplication across executions and process restart, and a Node.js reliability engine that passed 9 out of 9 regression tests after an unsafe phone-normalization assumption was detected and corrected. The current portfolio is internal technical proof using synthetic data, not a claim of client production deployment or ROI.

## Technical version
The architecture addresses four reliability layers:

1. **Lead Intake & Human Review** — inbound data is validated, normalized and classified; incomplete or ambiguous cases are routed to human review and sensitive external sending remains disabled in the tested workflow.
2. **Persistent Deduplication** — repeated event IDs and repeated normalized identities are checked against native n8n Data Tables so duplicate records are not added in the verified synthetic workflow; persisted state was audited again after process restart.
3. **Fail-Safe Processing** — a Node.js reference engine implements deterministic normalization, validation, event idempotency, identity deduplication, non-destructive record merging, audit entries and failure handling. A phone-normalization defect was discovered, corrected and preserved as regression coverage; the revised suite passed 9/9 tests.
4. **Workflow QA & Regression** — GitHub Actions exercises import/export, n8n runtime behavior, webhook requests, synthetic valid/invalid cases, Data Table state and restart persistence to catch workflow regressions before any production claim is made.

Core tools: n8n 2.42.6, native n8n Data Tables, webhooks, JavaScript, Node.js and GitHub Actions.

## Buyer problem
Businesses often receive inbound leads from forms, ads, email, spreadsheets or other systems in inconsistent formats. Common risks include missing fields, malformed values, duplicate records, unsafe automatic actions and workflows that appear correct in an editor but fail at runtime.

## What the system is designed to do
- validate required fields;
- normalize key data consistently;
- prevent duplicate records in the tested flows;
- classify and structure inbound information;
- route uncertain or invalid cases for human review;
- prepare downstream actions without forcing unsafe autonomous sending;
- preserve auditability and explicit failure behavior;
- run automated tests around runtime behavior and persistent state.

## Evidence available
HECHO VERIFICADO:
- n8n 2.42.6 runtime execution completed across six asserted synthetic cases with `autonomous_send=false`;
- persistent deduplication with native n8n Data Tables was verified across separate webhook executions and a process restart;
- Node.js reliability reference engine passed 9/9 synthetic regression tests after a phone-normalization defect was identified and fixed;
- GitHub Actions QA assets exist for n8n runtime, webhook and persistence checks;
- no real customer data was required for the technical proofs.

## Truth boundary
Do not claim:
- client production deployment;
- paying-client delivery;
- customer logo or testimonial;
- conversion/revenue/ROI improvement;
- production SLA;
- zero-failure guarantee;
- market acceptance already proven.

The four Contra works are complementary internal technical proofs within one Nexia specialization, not four separate customer engagements.

## Positioning
Preferred positioning:
`Reliable Lead Intake & CRM Data Quality Automation`

Supporting phrase:
`Automation that validates, deduplicates, fails safely and keeps humans in control where it matters.`

## When speaking with a prospect
Start from the buyer's workflow problem, not the tools. Ask where leads enter, which fields are unreliable, how duplicates happen, which actions must remain human-controlled and what failures are most expensive. Only then map the relevant parts of the Nexia proof system to their use case.

## Commercial boundary
The current bounded experimental offer is the `Lead Intake Reliability Sprint`, with an authorized pilot reference price of EUR300 and a target of <=4 measured delivery hours. This price and duration are experiment boundaries, not validated market guarantees.

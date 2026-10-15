# EXP-AUTO-001 — Contra Portfolio V2

Date: 2026-10-15
Status: PREPARED_INTERNAL / NOT_PUBLISHED / MEDIA_NOT_YET_GENERATED
Channel: Contra
Experiment: EXP-AUTO-001_CONTRA_MICROTEST_V1
Cash spend: EUR 0
Canonical source boundary: NEXIA_STATE v72 + current indexed events

## 1. Objective

Raise the four existing EXP-AUTO-001 portfolio pieces from technically credible documentation to a competitive buyer-facing case-study standard without inventing clients, production deployments, testimonials, revenue impact, ROI, adoption, verified earnings or other external proof that does not exist.

V2 changes packaging and narrative, not the underlying evidence.

## 2. Truth boundary

HECHO VERIFICADO:
- The underlying n8n and Node.js demonstrations use internal/synthetic evidence.
- n8n runtime execution, persistent deduplication, Node.js regression tests and GitHub Actions QA have repository evidence.
- Contra profile completion was last visible at 89%.
- Identity verification and payout setup are not complete.
- Applications submitted: 0.
- Qualified responses: 0.
- Revenue / settled revenue / realized profit from Contra: EUR 0.

UNKNOWN / NOT RECONCILED:
- Current number of Contra work pieces actually published after later profile edits.
- Exact current Contra case-study creation fields in the authenticated account.
- Current media upload postconditions for this account.

FORBIDDEN CLAIMS:
- client project / client deployment;
- production rollout;
- testimonial or customer logo;
- revenue, conversion or ROI lift;
- paid delivery;
- SLA or zero-failure guarantee;
- verified market acceptance.

Every public-facing piece must visibly retain `Internal demo` or `Technical proof` until external evidence legitimately changes that classification.

## 3. Competitive benchmark — 2026-10-15

### Sources reviewed
- Contra Help Center — `How to optimize your case studies on Contra` (2026-01-15).
- Contra Help Center — `How we feature work on Contra’s homepage` (2026-01-15).
- Contra Help Center — `How to build a case study from scratch` (2026-01-14).
- Lucas Lauer — Automation Engineer / n8n-oriented Contra profile and case work.
- Manuel Navarro — Top Independent AI automation / SaaS profile on Contra.
- Gabriele Mannino — Automation Architect / n8n & Make case-study work.
- Pavlo Hozhynskyi — AI Automation / n8n, APIs, Python portfolio work.

### Transferable principles
1. Lead with the buyer problem or outcome, not the stack.
2. Use a strong centered cover with minimal copy and a clear focal idea.
3. Show multiple high-quality visuals when useful; captions should explain the decision or proof.
4. Keep descriptions specific, structured and easy to scan.
5. Show role, implementation logic and evidence without forcing the buyer to infer relevance.
6. Quality beats quantity; four strong pieces are sufficient for this bounded test.
7. Verified earnings, reviews and client proof materially increase trust — Nexia currently does not possess these signals and must not simulate them.

### Parity matrix

| Dimension | V1 current | V2 target | Decision |
|---|---|---|---|
| Buyer-outcome clarity | BELOW | PARITY | Rewrite opening and cover copy around buyer tension/outcome. |
| Technical specificity | PARITY | PARITY+ | Preserve verified implementation detail; simplify presentation. |
| Evidence integrity | STRONG | STRONG | Keep explicit internal-demo boundaries and test evidence. |
| Visual case-study quality | BELOW | COMPETITIVE target | Build 1600×1200 outcome-first hero media and supporting frames. |
| Mobile/thumbnail impact | BELOW | COMPETITIVE target | One message, large type, strong focal idea, minimal detail. |
| Social proof / reviews / earnings | BELOW | BELOW | Cannot be solved internally; accept honestly until Reality Loop produces evidence. |
| Reliability / safe-failure story | UNDEREXPOSED | DIFFERENTIATION HYPOTHESIS | Make QA, dedup, human review and fail-safe behavior visible. |
| Case-study narrative | BELOW | PARITY | Problem → system → proof → boundary → relevance. |

`DIFFERENTIATION HYPOTHESIS` is not a measured superiority claim. It must be tested through real market response.

## 4. Portfolio system

### Shared design rules
- Recommended hero canvas: 1600 × 1200 px.
- Cover copy: 3–10 words.
- One dominant message per cover.
- Buyer outcome/tension first; technology subordinate.
- No fake dashboards, fake customer records, fake logos, fake charts or invented metrics.
- Synthetic/demo interfaces must be visibly labelled.
- V1 technical diagrams remain supporting evidence, not hero covers.
- Maintain one coherent visual family while giving each case a distinct focal metaphor.

### Shared case-study sequence
1. COVER — outcome / tension.
2. PROBLEM — what fails in a normal workflow.
3. SYSTEM — simplified architecture.
4. PROOF — tests / assertions / constraints.
5. DETAIL — implementation decisions.
6. BOUNDARY — internal demo vs production.
7. RELEVANCE — what type of buyer problem this capability addresses.

---

# PIECE 1 — Lead Intake & Human Review

## Cover
**FROM RAW LEADS TO REVIEW-READY DATA**

Support line: `n8n lead intake, validation and human-review workflow`
Badge: `Internal demo`

## Buyer problem
Inbound leads often arrive incomplete, inconsistent or ambiguous. If the workflow treats every record as clean, bad data moves downstream and automated replies can become unsafe.

## V2 description
I built an internal n8n lead-intake workflow designed to turn messy inbound records into structured, review-ready data before any customer-facing send.

The workflow validates required fields, normalizes email and phone values, separates incomplete or ambiguous cases for human review, creates a structured internal summary and prepares a reply draft while keeping `autonomous_send=false`.

The core path was executed in n8n 2.42.6 against six asserted synthetic cases. The goal of this proof is not maximum automation; it is controlled automation that knows when to stop and ask for review.

**Evidence:** real n8n runtime execution; six asserted synthetic cases; no real customer data; no autonomous external send.

**Boundary:** internal technical demonstration, not a client deployment or production case study.

## Role
Automation Designer & Developer

## Skills
n8n · Workflow Automation · Lead Management · JavaScript · Process Automation

## Media storyboard
1. Hero: chaotic raw lead cards entering a clean review-ready queue; no fake customer UI.
2. Problem: three visible failure classes — missing data, malformed data, ambiguous data.
3. System: Intake → Validate → Normalize → Route → Human Review / Draft.
4. Proof: `6 asserted synthetic cases` + `autonomous_send=false` + n8n 2.42.6.
5. Boundary: `Internal demo — synthetic data only`.

---

# PIECE 2 — Persistent Deduplication

## Cover
**ONE LEAD. ONE RECORD. NO DUPLICATE NOISE.**

Support line: `Persistent deduplication with native n8n Data Tables`
Badge: `Technical proof`

## Buyer problem
Retries, duplicate webhooks and repeated identities can create duplicate records, duplicated work and unsafe downstream actions. A workflow that only deduplicates in memory can lose that protection after restart.

## V2 description
I built a technical proof for persistent lead deduplication and idempotency using native n8n Data Tables.

Separate webhook executions were tested against repeated event IDs and repeated normalized identities. In the tested workflow, duplicate events or identities did not create additional stored rows. The n8n process was then restarted and the persisted Data Table state was audited again.

This proof focuses on a reliability property that is easy to overlook in automation: duplicate protection must survive separate executions and process restarts, not just a single happy-path run.

**Evidence:** native n8n Data Tables; duplicate event-ID checks; normalized-identity checks; persistence audited after process restart.

**Boundary:** isolated synthetic test environment; no production CRM integration and no high-concurrency guarantee.

## Role
Automation Designer & Developer

## Skills
n8n · Webhooks · Data Quality · Data Deduplication · Idempotency

## Media storyboard
1. Hero: multiple duplicate signals collapsing into one canonical record.
2. Problem: webhook retry / repeated identity → duplicate noise.
3. System: Normalize → Event ID check → Identity check → Data Table → one record.
4. Proof: before/after row-count concept plus `state survived verified restart`.
5. Boundary: `Technical proof — isolated synthetic environment`.

---

# PIECE 3 — Fail-Safe Lead Processing

## Cover
**AUTOMATION THAT FAILS SAFELY**

Support line: `Node.js reliability engine for inbound lead processing`
Badge: `Internal reference implementation`

## Buyer problem
Automation failures are most expensive when they silently corrupt data or trigger the wrong action. Reliability requires negative tests, explicit review paths and failure behavior — not only successful runs.

## V2 description
I built a synthetic Node.js reference implementation for reliable inbound lead processing with deterministic normalization, required-field validation, event idempotency, identity deduplication, non-destructive record merging, draft acknowledgements, manual-review alerts, audit entries and injected pre-commit failure handling.

The first regression run exposed an unsafe assumption in local-versus-international phone normalization. Instead of hiding the failure, I removed the assumption, added a negative regression case and reran the suite. The revised implementation passed 9/9 tests.

The important result is the engineering loop: expose a failure mode, repair the assumption and preserve the lesson as a regression test.

**Evidence:** executed synthetic reference implementation; discovered and repaired phone-normalization defect; revised suite 9/9.

**Boundary:** no external sends, no real customer data and no production deployment.

## Role
Automation & Reliability Developer

## Skills
Node.js · JavaScript · Workflow Reliability · QA Testing · Lead Operations

## Media storyboard
1. Hero: automation path reaching a guarded stop instead of an unsafe send.
2. Problem: hidden assumption → wrong normalization → downstream risk.
3. System: Normalize → Validate → Dedup → Merge → Draft / Review → Commit.
4. Proof: `Regression found → assumption removed → 9/9 pass`.
5. Boundary: `Internal reference implementation — synthetic data`.

---

# PIECE 4 — Workflow QA & Regression

## Cover
**TEST BEFORE IT TOUCHES PRODUCTION**

Support line: `Automated QA for n8n workflows with GitHub Actions`
Badge: `Technical QA proof`

## Buyer problem
A workflow can look correct in the editor and still fail after import/export, on invalid inputs, after a server restart or when persistent state changes. Visual inspection is not enough for reliable automation.

## V2 description
I built a GitHub Actions smoke-test pipeline for n8n automation that exercises workflow behavior rather than only checking files.

The QA path imports and re-exports workflows, executes synthetic cases inside n8n 2.42.6, checks safety assertions, starts a full n8n server, sends production-style webhook requests, audits Data Table state and verifies persistence after a process restart.

The purpose is to detect workflow and data-quality regressions before a customer-facing deployment is considered — especially around validation, deduplication, persistence and send-safety boundaries.

**Evidence:** automated runtime checks; valid/invalid synthetic behavior assertions; restart/persistence checks; `autonomous_send=false` safety boundary.

**Boundary:** internal QA evidence, not a production SLA or customer rollout.

## Role
Automation QA & Workflow Developer

## Skills
GitHub Actions · CI/CD · n8n · Automated Testing · Workflow Automation

## Media storyboard
1. Hero: workflow moving through a visible test gate before a production boundary.
2. Problem: editor-valid ≠ runtime-safe.
3. System: Import → Runtime test → Webhook test → State audit → Restart → Re-audit.
4. Proof: safety assertions + persistent-state verification.
5. Boundary: `Technical QA proof — no production SLA claimed`.

---

## 5. Publication order
1. FROM RAW LEADS TO REVIEW-READY DATA
2. ONE LEAD. ONE RECORD. NO DUPLICATE NOISE.
3. AUTOMATION THAT FAILS SAFELY
4. TEST BEFORE IT TOUCHES PRODUCTION

Reason: lead with business relevance, then prove data reliability, fail-safe engineering and QA depth.

## 6. Pre-publication quality gate

Each hero must score >=80/100 under `NEXIA_ART_DIRECTION_STANDARD_V2_2026-10-15.md` and have no truth-integrity failure.

Score dimensions:
- Buyer outcome clarity: 20
- Thumbnail/mobile impact: 15
- Art direction originality: 15
- Hierarchy/typography: 10
- Composition/negative space: 10
- Credibility/proof integrity: 10
- Competitive parity: 10
- Cross-portfolio coherence: 5
- Technical relevance: 5

Do not assign a pass score before the actual media exists and is visually reviewed.

## 7. Current readiness

### HECHO VERIFICADO
- V2 source copy and media storyboards are now defined in this artifact.
- Underlying technical evidence remains the V1 evidence set; no evidence was upgraded by rewriting copy.

### NOT YET VERIFIED
- V2 hero media generated.
- Visual QA >=80/100.
- Exact mapping into current Contra case-study fields.
- Publication of any V2 piece.
- Market response.

## 8. Next GREEN action

Create the V2 hero media one piece at a time, beginning with Piece 1, then run the visual QA scorecard and competitive glance test before preparing the remaining three. Preserve the same evidence boundary.

Publication, profile/account changes, identity verification, payout setup and applications/proposals remain separate Human Gates unless already explicitly authorized elsewhere.
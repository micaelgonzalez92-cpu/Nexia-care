# NEXIA — REAL PROGRESS DASHBOARD

Status: ACTIVE / EVIDENCE-GATED
Version: 2.0
Updated: 2026-10-14
Canonical operational source: `NEXIA_STATE.json` v71 plus `NEXIA_LIVE.json` and indexed post-STATE deltas.
Purpose: separate technical activity from verified economic progress and measure whether Nexia is becoming more profitable, repeatable and less dependent on human attention. This is a reporting view, never an independent source of truth.

## Reading rules

- **VERIFIED** = backed by observable evidence in the stated source.
- **PENDING** = a known gate or measurement is incomplete.
- **NOT INSTRUMENTED** = no reliable measurement exists; never display as zero.
- **NOT ACHIEVED** = a target is not supported by current evidence.
- **NOT APPLICABLE** = the metric does not fit the current business model or stage.
- A commit proves persistence only. A technical PASS does not prove demand, sale, cash receipt, profit, customer acceptance or scale.
- Primary progress = sustainable after-tax net profit supported by real demand and repeatability. Automation, files, followers, messages and task counts are supporting signals only.

## A. Current business position

| Indicator | Current reading | Status | Evidence / limitation |
|---|---:|---|---|
| Canonical STATE | v71 | VERIFIED | BOOT/LIVE recover STATE v71 plus indexed deltas |
| Active experiment | EXP-AUTO-001 — Lead Intake Reliability Sprint | VERIFIED | Primary monetization experiment |
| Stage | VETA / pre-validación comercial | VERIFIED | Own willingness-to-pay evidence still absent |
| Current commercial opportunity | Huescaventura / Workana | VERIFIED AS LAST REVALIDATED | Proposal internally ready; public state can change |
| Authorized gross price | €300 | VERIFIED | Proposal not submitted |
| Current commercial gate | Explicit Workana profile approval | BLOCKED | Profile reported 100%; approval itself unverified |
| Capital spent | €0 | VERIFIED | Canonical economics |
| Revenue | €0 | VERIFIED | No realized sale |
| Settled revenue | €0 | VERIFIED | No settled payment |
| Reconciled net profit | €0 | VERIFIED AS RECORDED | No economic extraction yet |
| Completed extractions | 0 | VERIFIED | No economic result yet |
| Reproducible extractions | 0 | VERIFIED | No repeated economic cycle yet |
| Own willingness-to-pay evidence | None | NOT ACHIEVED | Public buyer demand is signal, not Nexia payment evidence |

## B. Current economics

Current proposal economics are estimates, not realized results:

- Gross offer: €300.
- Workana initial commission assumption: 20%.
- Estimated amount after platform: €240.
- Labor assumption: 4 h maximum × €15/h = €60.
- Estimated contribution before overhead and tax: €180.
- Tax / after-tax profit: UNKNOWN until real accounting treatment and transaction data exist.

O1 is not achieved until a pilot of at least €249 economic equivalent is accepted/paid, completed in <=4 measured human hours and produces positive contribution.

## C. Revenue intelligence — model-conditional metrics

Do not force the same KPI set onto every business model.

| Metric | Current status | Activation rule |
|---|---|---|
| MRR / ARR | NOT APPLICABLE / NOT INSTRUMENTED | Activate only when a real recurring revenue model exists |
| Churn / retention / NRR | NOT APPLICABLE | Activate with paying recurring cohorts |
| CAC | NOT COMPUTABLE | Requires attributable acquisition cost and acquired customers; €0 cash spend alone is not validated CAC |
| LTV | NOT COMPUTABLE | Requires actual customer value/retention evidence; do not invent from price alone |
| Conversion rate | NOT INSTRUMENTED | Activate for a defined funnel with denominator and timestamp |
| Refund / defect / failure rate | NOT INSTRUMENTED FOR REAL CLIENTS | Technical synthetic failures are separate from customer outcomes |
| Sell-through | NOT APPLICABLE TO EXP-AUTO-001 | Use only for inventory/commerce cohorts |
| Audience reach → lead → buyer → contribution | NOT APPLICABLE CURRENTLY | Activate only when a content/audience engine is materially active |
| Revenue concentration | NOT COMPUTABLE | No realized revenue yet |
| Current acquisition-channel dependency | HIGH QUALITATIVE | Workana is current primary commercial route; this is dependency, not realized revenue concentration |

## D. Human dependency and attention-light metrics

Nexia should optimize for profitable **attention-light** systems, not assume that recurring or digital automatically means passive.

| Metric | Current reading | Status |
|---|---:|---|
| Human Attention Hours / week | Unknown | NOT INSTRUMENTED |
| Human Actions / real transaction | Unknown | NOT INSTRUMENTED — no real transaction yet |
| EXP-AUTO delivery human-time ceiling | <=4 h | PRECOMMITTED GATE |
| Revenue per Human Attention Hour | Not computable | Requires settled revenue/contribution plus measured human attention |
| Verified automation success rate | Model-specific | Measure only executed workflows with telemetry |
| Automation exception rate | Unknown | NOT INSTRUMENTED across real business operations |
| Human approval required for sensitive external actions | Yes | VERIFIED GOVERNANCE |

Human actions should eventually be classified as: identity/legal requirement, authorization, strategic decision, exception handling, automatable-but-not-yet-automated, or unnecessary friction. Reduce only the last two automatically; preserve real Human Gates.

## E. Portfolio / WIP

Primary monetization:
- **EXP-AUTO-001** — Lead Intake Reliability Sprint. Current priority.

Parallel research veins — maximum two:
- **VETA-AUTO-PRODUCT-001** — Lead Intake Reliability Kit for n8n. Internal runtime evidence exists; external users, sales and willingness-to-pay remain unverified. Template 01 rejected; Template 02 not ready/submitted.
- **VETA-AI-UGC-001** — local image capability exists; prior video technical result failed professional-quality gate for anatomy/hands and is not promoted as a commercial capability.

No third material vein may be activated unless one is closed/promoted/replaced under the portfolio rule.

## F. Automation / execution capability

- n8n full-runtime and persistent native-data-table dedup evidence: VERIFIED in bounded technical tests.
- Local authenticated Workana browser read-only path: VERIFIED within bounded scope.
- One-shot local bridge automatic start + sanitized result return: VERIFIED within bounded scope.
- Local Worker 24 h stability trial: RUNNING / PENDING FINAL RECONCILIATION as of this dashboard update.
- Persistent 24x7 worker: NOT AUTHORIZED / NOT VERIFIED.
- Authenticated Workana write/submission through the local bridge: NOT AUTHORIZED / NOT VERIFIED.
- Client production deployment: NOT EXECUTED.

## G. Progress ladder

RUMOR → SEÑAL → VETA → VALIDADA → EXTRACCIÓN → REFINADA → ESCALABLE.

Current economic position: **VETA / EVIDENCE_TO_VALIDATION**.

- Technical proofs can strengthen feasibility but cannot advance economic stage alone.
- VALIDADA requires real market validation under the experiment gate.
- EXTRACCIÓN requires real economic result, not proposal price or projected margin.
- REFINADA requires measured repeatability and improved economics/attention burden.
- ESCALABLE requires sustainable reconciled after-tax net profit, capacity and controlled risk. >€1,000/month is the first demonstrated scalable-engine milestone, not Nexia's final ceiling.

## H. Current bottlenecks — ordered

1. **Commercial:** explicit Workana approval remains unverified, so the already-prepared €300 Huescaventura proposal cannot yet be submitted under the existing conditional authorization.
2. **Economic evidence:** no own paid pilot / settled payment / realized contribution exists yet.
3. **Execution capability:** the bounded Local Worker stability trial still requires final reconciliation before any durability claim; persistent 24x7 remains unauthorized.

## I. Next economic measurement chain

`Workana approval verified → Huescaventura still open + submission cost €0 → authorized proposal submitted → qualified response → paid pilot >=€249 → measured delivery/support time → buyer acceptance → settled payment → realized contribution → tax/overhead reconciliation → repeatability`.

Do not skip intermediate evidence states.

## J. Measurement contract

Every metric must record: purpose, formula/unit, period, evidence source/date, status, owner/blocker, uncertainty and exclusions.

Core formulas:
- Contribution = realized net proceeds − platform/payment fees − variable tooling − delivery/support labor − other attributable variable costs.
- After-tax net profit = recognized revenue − all attributable/fixed deductible costs − applicable taxes, reconciled to actual treatment.
- Revenue per Human Attention Hour = realized contribution or net revenue (state which) ÷ measured human attention hours for the same scope/period.
- Automation success rate = verified successful executions ÷ attempted executions over a defined period.
- Human Dependency Ratio = human-required operational actions ÷ total meaningful workflow actions, only when instrumentation exists.

## K. Decision policy

Choose next work by: authority/safety → current bottleneck → real economic impact / information value → cost/downside → human attention → repeatability → scalability.

Recurring revenue is valuable only when continuing customer value supports it; do not force subscriptions onto one-time problems. Digital products and content have low replication cost but still require buyer demand, distribution, support/maintenance and platform-risk analysis. Automate only after the process is measured, standardized and tested; keep human approval around sensitive external effects until the specific path is authorized and verified.

Current verified economic truth: **capital €0, revenue €0, settled revenue €0, reconciled net profit €0; technical capability has advanced but O1 is not yet demonstrated.**

# NEXIA — REAL PROGRESS DASHBOARD

Status: ACTIVE / EVIDENCE-GATED
Version: 1.0
Updated: 2026-10-09
Canonical operational source: `NEXIA_STATE.json`
Purpose: separate technical activity from verified business outcomes. This document is a reporting view, not an independent source of truth.

## Reading rules

- **VERIFIED**: backed by observable evidence in the stated source.
- **PENDING**: a known task or gate has not completed.
- **NOT INSTRUMENTED**: no connected data source or reliable measurement exists; do not display as zero.
- **NOT ACHIEVED**: a target has not been met by available evidence.
- A repository commit proves persistence of that repository change only. It does not prove deployment, functioning automation, demand, a sale, cash receipt or profit.
- Do not aggregate technical activity into an economic-progress score. Show the two dimensions separately.

## A. Business outcomes — primary scorecard

| Indicator | Current reading | Status | Evidence / limitation |
|---|---:|---|---|
| Capital spent | €0 | VERIFIED | STATE v48; no pilot payment recorded |
| Revenue received | €0 | VERIFIED | Canonical STATE; no sale or receipt recorded |
| Profit after tax | €0 recorded | VERIFIED AS RECORDED, NOT A PROFITABILITY PROOF | No trading results; actual tax-adjusted unit economics not yet measured |
| Completed extractions | 0 | VERIFIED | Canonical STATE |
| Reproducible extractions | 0 | VERIFIED | Canonical STATE |
| Real customer transactions | 0 recorded | VERIFIED AS RECORDED | No transaction evidence recorded |
| Demand validation | Not yet validated for this operation | NOT ACHIEVED | Public demand signals exist; own sell-through remains unknown |
| Unit economics | Not validated | PENDING | Pilot contribution threshold inconsistency recorded in `NEXIA_EXP_RESALE_001A_UNIT_ECONOMICS_FALSIFICATION_2026-10-09.md` |
| Sellable inventory from pilot | Unknown / not received | PENDING | No purchase executed; do not fabricate SKU/intake records |
| Repeatable sourcing | Not validated | NOT ACHIEVED | Supplier consistency, sell-through, time per item and returns remain unknown |

## B. Operational throughput — supporting scorecard

| Indicator | Current reading | Status | Evidence / limitation |
|---|---|---|---|
| Canonical STATE | v48 | VERIFIED | STATE blob SHA is checked against BOOT |
| Rules R1–R5 | Persisted | VERIFIED | `NEXIA_OPERATIONAL_RULES.md`, linked from STATE |
| Experiment execution | Pilot approved; purchase not executed | PENDING HUMAN ACTION | EXP-RESALE-001A, checkout €61.30 delivered; payment pending Kael |
| External contact / customer recruitment | Not connected for authorized execution | BLOCKED | Current capability matrix / external ops state |
| Automation actually running | No production automation verified by this dashboard | NOT VERIFIED | Documentation or inventory entries are not runtime evidence |
| Hours/minutes of human work saved | Unknown | NOT INSTRUMENTED | No baseline, timer, telemetry or before/after measurement connected |
| Active real users / participants | No verified pilot participants recorded | NOT ACHIEVED / NOT INSTRUMENTED | Do not count repository activity as users |
| Deployment / public application health | Not verified here | NOT INSTRUMENTED | GitHub commit/readback alone does not establish runtime health |

## C. Required measurement contract

Every metric record should include:
1. Name and business purpose.
2. Numerator/denominator or precise formula and unit.
3. Current value, target and reporting period.
4. Evidence source and last verified timestamp.
5. Status: VERIFIED, PENDING, NOT ACHIEVED, NOT INSTRUMENTED or BLOCKED.
6. Owner and next action when blocked.
7. Known exclusions, uncertainty and revision history.

### Core economic formulas

- **Net sales** = cash/settled sales attributable to completed orders, less cancellations/refunds as defined by the accounting policy.
- **Contribution per sold unit** = realized net sale proceeds − allocated acquisition cost − platform/payment fees − packaging/shipping borne by seller − expected/actual return/defect costs − other variable costs.
- **After-tax net profit** = recognized revenue − all deductible business costs − applicable taxes, reconciled to the actual tax/accounting treatment. Do not estimate it as verified profit.
- **Sell-through** = units sold in a defined cohort/time window ÷ units made available for sale in that cohort.
- **Human time saved** = measured baseline time for a fixed workload − measured assisted time for the same workload; disclose sample size and measurement method.
- **Automation success rate** = successful verified executions ÷ attempted executions over a defined period; a designed or connected integration without execution telemetry is NOT INSTRUMENTED.
- **Reproducibility** = repeated successful runs under recorded conditions, with the same success criteria; one isolated result does not count.

## D. Current bottleneck and next measurement action

**Bottleneck:** the approved pilot has not been paid for or received, so own sell-through, sellable rate, preparation time, realized price, fees, returns and contribution cannot yet be measured.

**Next action:** no new purchase or external contact. Prepare the zero-cost intake/measurement sheet and a comparable-sourcing matrix while preserving the existing pilot approval. Once inventory is physically received, record item-level intake evidence and timestamps before listing.

**Current economics:** checkout €61.30 delivered for 10 items; payment not executed; spend €0, revenue €0, profit €0 recorded. The €15 average realized-price target and €10 contribution target remain unresolved as documented; do not change the gate without Kael's explicit decision.

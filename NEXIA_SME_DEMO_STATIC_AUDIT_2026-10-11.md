# NEXIA SME Intake Demo — Static Audit & Synthetic Test Contract
Date: 2026-10-11
Status: STATIC SOURCE AUDIT PASSED; BROWSER/FUNCTIONAL TEST NOT RUN
Cost: €0
Scope: synthetic data and repository source only. No customer data, external contact, accounts, publication, or purchases.

## 1. Evidence inspected
- Prototype: `prototypes/sme-intake-demo.html`
- Prototype blob SHA at audit: `1ee3ff93e7fb9760d36eafa248e974be1e5f56c1`
- Canonical state remains `NEXIA_STATE.json` v58, blob SHA `1aaa6cc50782a47072db1ed453d018d4163c6dd5`.
- The prototype is a static HTML page with three predefined cases (urgent request, quote request, information request), deterministic JavaScript mapping, and no connected AI model.

## 2. Static source assertions
A script evaluated eight source-level assertions against the fetched HTML. Result: **8/8 PASS**.
1. Spanish language declaration and responsive viewport present.
2. Three predefined case keys (urgent, quote, info) present.
3. Urgent case explicitly marked for immediate human review.
4. All three response drafts state they have not been sent.
5. Unknown business hours/location are deferred until verified by the business.
6. Rendered result uses `textContent`, not `innerHTML`.
7. No `fetch`, `XMLHttpRequest`, `WebSocket`, or `EventSource` references.
8. No `localStorage`, `sessionStorage`, `indexedDB`, or `sendBeacon` references.

These checks establish only source-level properties. They do **not** prove the page renders correctly or that clicking the button works in a browser. No browser run, timing trial, user study, or commercial validation occurred.

## 3. Current limitations found
- Input is a fixed dropdown of three cases; no arbitrary request text can be entered.
- No timestamps or stopwatch exist, so manual handling time, assisted handling time, and correction time are NOT INSTRUMENTED.
- No automated runtime tests or expected-output assertions are bundled with the demo.
- No persistence or external integration exists (appropriate for this safe prototype, but not a production workflow).
- The current three cases do not cover contradictory facts, missing context, urgent language without an explicit reason, or out-of-scope requests.

## 4. Synthetic test contract for the next measurement pass
Do not change thresholds after observing results. For each case, record:
- Manual handling time (seconds) using a fixed written procedure.
- Assisted handling time (seconds), including human review and corrections.
- Expected class/action and observed class/action.
- Number and type of corrections; any invented fact; whether urgency was safely escalated.
- Outcome quality score (predefined rubric) and notes.

| ID | Synthetic case | Expected safe behavior | Critical failure |
|---|---|---|---|
| T01 | Equipment stopped; appointment in one hour | High priority, immediate human review; no promise of availability | Fails to escalate or promises service without checking |
| T02 | Quote request for next week; model unspecified | Normal quote flow; ask for model/service details | Invents quote or assumes missing details |
| T03 | Asks for opening hours/address | Information request; require business-verified facts | Fabricates hours/address |
| T04 | Vague “it is broken” | Ask clarifying questions; do not infer equipment/fault | Invents diagnosis |
| T05 | Says “urgent” without explaining why | Flag for human review and clarify urgency | Treats as confirmed emergency or ignores it |
| T06 | Fault plus explicit budget limit | Preserve both facts; human review before recommendation | Drops budget or invents a solution |
| T07 | Empty or incoherent request | Ask user to clarify; no invented facts | Produces a confident substantive answer |
| T08 | Request outside the defined service scope | State limitation and route to human | Claims unsupported capability |

Important: T04–T08 are **designed cases only**; the current UI cannot enter them. They cannot be considered passed until the prototype or a test harness actually supports and runs them.

## 5. Predeclared decision gates (provisional)
- Safety: zero critical failures involving invented facts, false promises, or unreviewed urgent cases.
- Quality: no material quality degradation versus the manual baseline, judged with the same rubric.
- Time: median end-to-end time reduction of at least 20%, including review/corrections, before considering operational usefulness.
- If any safety gate fails, stop and redesign; do not average away a critical failure.
- These are provisional experiment criteria, not results. Baseline times, assisted times, quality scores, correction rates, and demand are all UNKNOWN / NOT INSTRUMENTED.

## 6. Next safe action
Implement a minimal synthetic-only test harness with expected-output checks and a visible timing protocol, then run it in a real browser before reporting functional test results. No real customer data or external pilot until Kael explicitly authorizes the exact scope and exposure.

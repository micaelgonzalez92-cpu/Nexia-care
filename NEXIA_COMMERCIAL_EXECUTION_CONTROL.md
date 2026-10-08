# NEXIA CORE — Commercial Execution Control
Status: IMPLEMENTED AS DOCUMENTED POLICY / NOT CONNECTED TO LIVE COMMERCE
Effective: 2026-10-09
Cost: €0
Owner / material decision authority: Kael

## 1. Purpose
Define a safe path from research and preparation to controlled execution of e-commerce operations: account setup, product listing, inventory purchasing, order handling and performance optimization. This document is an execution contract, not proof that any platform integration, worker, account, payment method or live automation exists.

## 2. Capability truth labels
Every capability must carry exactly one current evidence state:
- DESIGNED: documented or specified only.
- AVAILABLE: tool/connector exists in the current environment, but the specific workflow has not passed a test.
- CONNECTED: required authorization and integration are configured.
- TESTED: a bounded test completed with evidence.
- VERIFIED: postcondition and evidence were independently checked.
- BLOCKED / NOT_CONNECTED / NOT_INSTRUMENTED: unavailable or unknown; never infer success or treat unknown telemetry as zero.

A repository commit proves persistence only. It does not prove deployment, integration, publication, purchase, sale, settlement or profit.

## 3. Default authority matrix
### GREEN — may execute without another approval
- Public research and falsification.
- Drafting product records, titles, descriptions, pricing proposals and image-to-SKU mappings.
- Unit-economics calculations with assumptions and unknowns labelled.
- Creating local/repository documentation, tests, checklists and reversible internal structures.
- Reading permitted account/catalog data through an already-authorized connector, within its granted scope.
- Preparing but not submitting external forms or transactions.

### YELLOW — prepare, then stop at the material boundary
- Account setup drafts, business profile data and platform onboarding.
- Product listings and marketplace-specific content.
- Supplier comparison, cart/order preparation, reorder proposals, returns workflows and price changes.
- Connecting an integration, granting permissions, installing apps, or changing operational configuration.
- Any action with uncertain platform terms, data handling, compliance or material reputational impact.

### RED — do not execute without a specific, explicit Human Gate
- Creating/submitting an account or accepting terms on behalf of Kael.
- Identity, tax, bank, payment, legal-entity or KYC/KYB submissions.
- Publishing, relisting, bulk uploading, sending external messages or contacting suppliers/customers.
- Purchases, paid subscriptions, advertising, refunds, payouts, contracts or any financial commitment.
- Deleting live listings/data, making irreversible changes, or expanding spend/risk limits.
- Circumventing platform controls, anti-bot restrictions, rate limits, account limits or access controls.

A broad instruction to “implement”, “continue” or “automate” authorizes safe internal implementation; it does not silently authorize external publication, spending, account creation, acceptance of terms or commitments.

## 4. Human Gate contract
Before a RED action, present:
1. Exact action and target platform/vendor.
2. Scope: SKU/listing/order/account/quantity and duration.
3. Maximum total exposure in EUR, including shipping, VAT, fees and contingency where applicable.
4. Expected unit economics and unknowns; distinguish revenue, contribution, cash flow and net profit after tax.
5. Success metric, failure/stop criteria, risks and reversibility.
6. Data/permissions required and the proposed evidence of completion.
7. A direct approval from Kael that matches the action, scope and cost.

Approval is not transferable to a different vendor, quantity, price, platform or purpose. No response is not approval. The €100/week project budget is a ceiling, not permission to spend.

## 5. Execution state machine
Every external action must be tracked as:
REQUESTED → IN_PROGRESS → EXECUTED → VERIFIED
or BLOCKED / FAILED / CANCELLED.

- REQUESTED: prepared with an action contract.
- IN_PROGRESS: started only after required authorization and capability checks.
- EXECUTED: platform/tool reports completion; this alone is not final verification.
- VERIFIED: inspect the actual postcondition (e.g. listing visible, order receipt present, account status confirmed) and save timestamped evidence.
- FAILED/BLOCKED: record the error, preserve evidence and do not silently retry if a duplicate or financial effect is possible.
- CANCELLED: stop before execution or record a verified cancellation/refund where applicable.

Use idempotency keys or preflight duplicate checks wherever possible. Never report an action as VERIFIED from a success toast or commit alone.

## 6. Platform policy and compliance
- Prefer official APIs, authorized connectors and documented platform workflows.
- Check current terms before automating each platform. If automation is prohibited or permission is unclear, keep the workflow manual/assisted and do not evade the restriction.
- Current project research records Vinted terms restricting external bots/scraping/crawlers unless authorized. Therefore, do not automate direct Vinted UI actions, scraping, bulk listing or relisting absent explicit platform authorization. Nexia may prepare drafts and analyze user-provided/exported data through permitted methods.
- Marketplace rules, professional-seller status, consumer returns, VAT, product descriptions, intellectual property and data-protection obligations must be checked for the relevant jurisdiction and sales channel.
- Never request raw passwords, authentication codes, payment-card data or secrets in chat. Use official OAuth/authorization flows where available. Do not store secrets in repository files, logs or prompts.
- Respect least privilege, secure token handling, audit trails, revocation and recovery. If a connector cannot prove safe authorization, mark it NOT_CONNECTED.

## 7. Commercial workflow
1. SOURCE: research demand, suppliers and channel requirements without contacting externally.
2. MODEL: calculate landed cost per sellable unit, sellable yield, realized proceeds excluding VAT collected, platform/payment fees, packaging, seller-paid shipping, returns/defects, discounts, ads and measured labor × explicit hourly-rate assumption. Reconcile overhead and income tax separately; avoid double-counting VAT.
3. PREPARE: normalize SKU, source, cost basis, condition, size, measurements, photo references, listing copy and proposed price.
4. HUMAN REVIEW: Kael approves the exact external action if it is RED.
5. EXECUTE: use an authorized, tested integration or manual assisted workflow.
6. VERIFY: inspect actual platform state, receipt/settlement and relevant evidence.
7. RECONCILE: record actual costs, proceeds, returns, time and contribution; do not call an order a sale until it is completed, and do not call a sale profit until costs/tax are reconciled.
8. LEARN: compare outcome to preregistered success/failure criteria; update assumptions, not gates silently.

## 8. Inventory purchase gate
No inventory purchase is triggered by a sourcing recommendation or by this policy. Before each purchase, require a separate Human Gate for the specific supplier, items/quantity, total delivered cost, payment timing and stop conditions. Verify product quality/yield and contribution potential; if the economics cannot meet the currently approved thresholds, recommend not buying. No auto-reorder until repeated, reconciled transactions establish a reliable reorder rule and Kael explicitly approves its spend ceiling.

## 9. Initial rollout
Phase A — internal preparation (authorized now; €0):
- Create product/SKU intake templates and draft listing workflow.
- Build platform fee/unit-economics comparison with unknowns explicit.
- Inventory actual connectors and platform restrictions.
- Create preflight, postcondition and audit checklist.

Phase B — assisted pilot (requires suitable platform access and per-action approval):
- Prepare a small number of listings from verified photos and product data.
- Present final preview, platform, price, shipping/returns settings and policy checks.
- Stop before submitting/publishing until the exact action is approved.

Phase C — limited automation (requires integration-specific authorization and successful end-to-end tests):
- Automate only supported, permitted steps.
- Run in dry-run mode first; add rate limits, duplicate protection, failure alerts, rollback/recovery and a tested stop mechanism.
- Enable live actions only for individually approved scope and caps.

Phase D — scaling:
- Require reconciled settled transactions, measured contribution/net profit, repeatability and failure-rate evidence before expanding scope or capital.

## 10. Required audit record for every live action
Record: action_id; timestamp; actor/tool; platform; target SKU/order/account; approval reference and scope; preflight result; capability status; expected cost; actual cost; before/after state; evidence link/reference; final status; error/rollback; human time; economic outcome. Redact personal data and never log credentials.

## 11. Current known state at creation
- This policy is documented in the repository; live commerce execution is not thereby connected.
- Current canonical STATE says external operations are designed but not connected; CRM, analytics and payments are not connected.
- No account creation, listing publication, supplier contact, subscription or inventory purchase is authorized by this document alone.
- The existing resale pilot remains unpurchased unless Kael separately confirms the exact purchase after reviewing the current economics and gate.
- Canonical STATE is not changed by this document. Persistence synchronization remains partial; do not claim full checkpoint consistency.

## 12. Definition of done
This module is operational only when each enabled workflow has: documented platform permission; least-privilege authorization; a bounded end-to-end test; evidence of the actual postcondition; duplicate/failure handling; a tested stop/rollback path appropriate to the action; an audit record; and an economic measurement plan. Until then, label it DESIGNED, NOT_CONNECTED or NOT_INSTRUMENTED as appropriate.

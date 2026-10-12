# NEXIA — VETA-AUTO-PRODUCT-001 Market Falsification

Date: 2026-10-12 (Europe/Madrid)
Status: RESEARCHED / INTERNAL SKU PREPARATION / NO PUBLICATION / NO SPEND
Vein: `VETA-AUTO-PRODUCT-001`

## Hypothesis
A specialized n8n reliability kit can sell as a digital product because buyers pay for ready-to-import workflows, but generic template bundles are commoditized. NEXIA should differentiate on reliability, QA, idempotency/deduplication, sample tests, human-review controls and operator documentation rather than workflow count.

## Verified market facts
- n8n currently exposes more than 12,000 community workflow templates, so generic workflow supply is abundant.
- Official n8n pages contain paid workflow templates at observed prices including USD 5, 22, 25, 29, 39, 49, 59 and 79.
- External Gumroad products observed in this scan include n8n packs at USD 29, 49 and 97, with one large free/discounted library showing 267 sales.
- A 16-product observed paid-price sample used for screening had a median of approximately USD 34; this is descriptive, not a market-wide statistic.
- n8n Creator Hub permits anyone to submit templates. New creators can submit one at a time. After 3 approved templates, creators become verified and can publish paid templates.
- n8n's current help documentation states that consulting/building workflows for clients can be commercial under the Sustainable Use License, while hosting/configurable n8n as a customer-facing service can require a commercial license. NEXIA's current product concept is downloadable workflow files for use in the buyer's own n8n environment, not hosted n8n-as-a-service.

## Competitive evidence
### Commodity zone
Observed generic bundles cluster around USD 29-49 and compete on quantity:
- 5 workflows / USD 29;
- 25 mixed workflows / USD 29;
- 2,000+ workflow libraries / approximately USD 29-49;
- 227 workflow Make+n8n pack / USD 97.

This makes `large workflow bundle` a NO_GO positioning for NEXIA.

### Specialized-value zone
Observed specialized workflows include:
- paid official n8n templates at USD 25-79;
- vertical seller-lead workflow at USD 59;
- digital-product delivery workflow at USD 79;
- niche workflow products around USD 49;
- vertical contractor automation products externally priced at USD 97-297.

The price signal supports testing a focused reliability product above commodity-bundle pricing, but sales volume for NEXIA remains UNKNOWN.

## Selected product thesis
Working name: **Lead Intake Reliability Kit for n8n**

Target buyer:
- freelancers/agencies/SMBs already using n8n;
- one inbound lead source;
- one destination or downstream workflow;
- needs fewer lost/duplicate/invalid leads and safer human review.

Core promise:
`Make inbound lead intake predictable before you automate customer-facing actions.`

Internal v0.1 components:
1. Generic Lead Intake Normalizer + Human Review workflow.
2. Native n8n Data Table persistent dedup/idempotency bootstrap.
3. Native n8n Data Table dedup guard.
4. Sample valid/invalid/duplicate payloads.
5. QA and handover checklist.
6. Truthful technical evidence notes based only on NEXIA's executed internal proof.

Explicit exclusions:
- no autonomous customer send by default;
- no CRM migration;
- no WhatsApp setup;
- no hosted n8n service;
- no claim of prior paid-client production usage;
- no guarantee of revenue or conversion lift.

## Pricing hypothesis
Launch hypothesis: **USD 49 one-time**.

Reasoning:
- above generic USD 29 bundle zone;
- inside observed specialized workflow range;
- low enough for a self-serve first validation;
- allows later vertical packs or implementation upsell only after demand evidence.

Illustrative platform economics, not realized:
- Gumroad direct sale at USD 49: current fee structure of 10% + USD0.50 plus card processing 2.9% + USD0.30 implies roughly USD41.88 before tax/refunds.
- Lemon Squeezy base ecommerce fee at USD49: 5% + USD0.50 implies roughly USD46.05 before possible additional international/payment-method fees and tax effects.
- With an illustrative 25% tax reserve, the simple arithmetic path to EUR/USD-equivalent 1,000 after-tax monthly profit would require roughly 29-32 sales/month at USD49 before support/refund/FX differences. This is a screening estimate, not a forecast.

## Distribution route
### Route A — n8n Creator Hub
Potentially strongest native-distribution path, but gated:
1. Prepare first free template.
2. Submit and obtain approval.
3. Repeat until 3 approved templates.
4. Become verified creator.
5. Gain option to publish paid templates.

No creator account creation or publication is authorized yet.

Proposed three free entry templates:
- `Reliable Lead Intake — Normalize + Human Review`;
- `Persistent Lead Dedup Guard with n8n Data Tables`;
- `Authenticated Webhook Intake + Error-Safe Validation`.

Paid product then combines these controls plus fixtures, QA and setup documentation.

### Route B — direct storefront
Gumroad/Lemon Squeezy can provide direct digital delivery, but traffic acquisition remains UNKNOWN. Do not open/store/publish until a specific validation experiment is authorized.

## Falsifiers
Pause or kill this vein if any of the following becomes true:
- buyers overwhelmingly choose free n8n templates and specialized paid reliability products show no demand signal;
- support burden makes self-serve economics unattractive;
- product cannot be installed/tested by a competent n8n user from docs in <=30 minutes;
- product requires hosted n8n or licensing exposure inconsistent with the selected distribution model;
- three free-template creator path produces negligible discovery and no paid-intent signal;
- truthful positioning without client-production claims is insufficient to sell.

## Gates
### PREPARED_INTERNAL_SKU
Requires:
- importable product files prepared;
- product QA suite PASS;
- no buyer-specific branding/data;
- no external sends enabled;
- setup docs and samples complete.

### VALIDATION_READY
Requires PREPARED_INTERNAL_SKU plus:
- distribution experiment defined;
- price fixed before test;
- success/failure thresholds fixed before publication;
- publication/account Human Gate approved by Kael.

### VALIDATED
Requires real settled sales, not downloads or page views. Initial gate:
- >=5 settled paid sales at >=USD39 equivalent;
- refund rate <=10%;
- median support <=20 minutes/sale during first cohort;
- positive contribution after platform fees, support labor and tax reserve.

### SCALABLE
Requires a measured path to >EUR1,000/month after tax, including traffic/acquisition and support burden.

## Current decision
`VETA-AUTO-PRODUCT-001 = PROMOTE_TO_INTERNAL_SKU_BUILD`

This is not a commercial validation. Revenue, sales, WTP and profit remain zero.

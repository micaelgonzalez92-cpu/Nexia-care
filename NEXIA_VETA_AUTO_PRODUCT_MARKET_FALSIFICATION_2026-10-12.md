# NEXIA — VETA-AUTO-PRODUCT-001 Market Falsification

Date: 2026-10-12 (Europe/Madrid)
Status: PREPARED_INTERNAL_SKU / NO PUBLICATION / NO SPEND / NO SALES
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
4. Internal dedup audit workflow.
5. Synthetic valid/invalid/duplicate payloads.
6. Automated static QA test.
7. Self-serve installation guide and QA checklist.
8. Truthful technical evidence boundary based only on NEXIA's executed internal proof.

Explicit exclusions:
- no autonomous customer send by default;
- no CRM migration;
- no WhatsApp setup;
- no hosted n8n service;
- no claim of prior paid-client production usage;
- no guarantee of revenue or conversion lift.

## Verified product runtime — re-verified 2026-10-12

Dedicated workflow: `.github/workflows/n8n-product-runtime-smoke.yml`.
Final verified GitHub Actions run: [38235228044](https://github.com/micaelgonzalez92-cpu/Nexia-care/actions/runs/38235228044).
Job: `114764135662`.
Tested commit: `ca54ddbc626520a13450aecda6c550d165a42300`.
Runtime: n8n `2.42.6`, full server process.
Conclusion: **SUCCESS**.

Earlier run38232599031 and later green run38233861773 did not sufficiently prove process restart: killing the npx launcher left server processes alive. Their restart claim is superseded; immutable history is retained. A corrected lifecycle exposed a genuine post-restart404 in run38234612479; waiting for /healthz/readiness resolved the startup race.

Verified final outcomes:
- all four workflows imported/exported, inactive by default;
- four production webhook registrations and successful actual runtime calls;
- valid input normalized; invalid input functionally rejected;
- two event IDs with the same normalized email left exactly one Data Table row;
- direct server PID3443 exited, /healthz went down and TCP5678 closed;
- a new direct PID3540 reached readiness;
- the new process returned the original row before any new write;
- one new phone identity raised the persisted total to exactly two rows;
- final process exited and the port closed;
- autonomous_send=false in asserted outputs;
- zero audit404 retries and zero orphan n8n start processes in final cleanup.

Reproducible evidence, failed attempts, source explanation and limitations:
[NEXIA_VETA_AUTO_PRODUCT_RUNTIME_REVERIFICATION_2026-10-12.md](NEXIA_VETA_AUTO_PRODUCT_RUNTIME_REVERIFICATION_2026-10-12.md).

This is isolated internal CI proof. External-user installation, concurrent dedup, production compatibility, demand, willingness-to-pay, support burden and economic results remain unverified.

## Pricing hypothesis
Launch hypothesis: **USD 49 one-time**.

Reasoning:
- above generic USD 29 bundle zone;
- inside observed specialized workflow range;
- low enough for a self-serve first validation;
- allows later vertical packs or implementation upsell only after demand evidence.

Illustrative platform economics, not realized:
- Gumroad direct sale at USD 49: current fee structure of 10% + USD0.50 plus card processing 2.9% + USD0.30 implies roughly USD41.88 before tax/refunds;
- Lemon Squeezy base ecommerce fee at USD49: 5% + USD0.50 implies roughly USD46.05 before possible additional international/payment-method fees and tax effects;
- dozens of monthly sales would likely be needed to exceed EUR1,000/month after tax at this price unless average order value rises or the product drives implementation revenue. Exact requirement remains UNKNOWN until realized fees, FX, support and taxes exist.

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
### PREPARED_INTERNAL_SKU — PASSED INTERNALLY
Passed because:
- importable product files are prepared;
- static product QA passes in CI;
- dedicated full n8n 2.42.6 runtime smoke passes;
- no buyer-specific branding/data is present in product workflows/samples;
- no external customer send is enabled;
- setup docs, samples and QA checklist exist.

### VALIDATION_READY — PAID EXECUTION NOT READY / EXTERNAL ACTION NOT AUTHORIZED
The technical prerequisite has passed and the first free Creator package is prepared. Paid-experiment measurement/economic definitions remain incomplete as qualified below.
Remaining gates:
- preregister measurement windows/definitions, support labor rate and applicable tax-reserve method before paid execution;
- obtain an explicit WIP/priority decision before activating a second paid monetization experiment;
- obtain Kael authorization for the specific creator/store account and first submission/publication action, including public exposure. A free channel test is not paid validation.

### VALIDATED
Requires real settled sales, not downloads or page views. Initial gate:
- >=5 settled paid sales at >=USD39 equivalent;
- refund rate <=10%;
- median support <=20 minutes/sale during first cohort;
- positive contribution after platform fees, support labor and tax reserve.

### SCALABLE
Requires a measured path to >EUR1,000/month after tax, including traffic/acquisition and support burden.

## Current decision
`VETA-AUTO-PRODUCT-001 = PREPARED_INTERNAL_SKU`

Next material test is distribution/willingness-to-pay, not more synthetic engineering. No publication/account creation has been executed.

This is not commercial validation. Registered external users, sales, settled revenue and realized profit remain zero. NEXIA willingness-to-pay evidence is absent; market demand for this SKU remains UNKNOWN.

## Commercial execution-readiness qualification — 2026-10-12

The technical SKU gate passes. Commercial measurement design still needs the observation/refund windows, qualified-visit definition, support labor rate and applicable tax-reserve method described in the validation experiment. The pre-tax contribution gate and the additional tax-reserve statement must not be silently conflated. Existing paid validation thresholds remain unchanged. Creator free-template acceptance is channel evidence, not willingness-to-pay. Paid validation also requires an explicit decision respecting the one-active-monetization-experiment limit.

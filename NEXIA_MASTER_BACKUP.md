# NEXIA MASTER BACKUP — CURRENT RECOVERY SNAPSHOT

Updated: 2026-10-12
Status: **STATE v70 CANONICAL / AUTO-PRODUCT PREPARED INTERNAL SKU / CREATOR SUBMISSION #1 PREPARED / STANDARD WORKANA MODERATION / AI-UGC WATCH / EVENT STORAGE v2 OPERATIONAL / MEMORY DERIVED STALE**
Checkpoint: `CP-2026-10-12-AUTOPROD-002`

Historical snapshots remain recoverable from Git history and never override canonical STATE.

## Canonical recovery map
- STATE v70: `e8d2e158cfb086c5f5c15fb9bd6ade5b58fe2e0a`
- BOOT v45: `c4c465412b5e53387e8fbe4ecb6e1b54ee7b740c`
- LIVE: `8a04e38f5ff027c3d9b4589f7be634d9706c012a`
- MEMORY last verified: `443137fd25747baa2c25a403b4ca47a38b6dee7a` — derived ledger remains stale at v63; STATE v70 overrides it.
- Commercial pipeline: `92e53d402bf53987275b6d56e17586847a8907e2`
- Event index: `ec2420cc3ffdd26c2536ffa0f4eb31f00c824796`
- Latest verified event: `events/EVT-2026-10-12-AUTOPROD-002.json`, blob `5663a6d54f593b6bab97090c44b91b2b8d4ea496`
- Persistence protocol v2: `69f18157e693fb71739fa1230286acdf5134b370`
- Legacy JSONL boundary: `84db0ce6ccd1878be9ff48a770bb8b6f1e433d72`, READ-ONLY.

## Mission and portfolio architecture
Mission: `MISSION-OPPORTUNITY-ENGINE-001` — build a repeatable engine that discovers, falsifies, validates, monetizes and replicates independent businesses until sustainable after-tax net profit exceeds EUR1000/month.

One monetization experiment remains active: `EXP-AUTO-001 — Lead Intake Reliability Sprint`.

Parallel-vein limit remains two:
1. `VETA-AUTO-PRODUCT-001` — **PREPARED_INTERNAL_SKU**.
2. `VETA-AI-UGC-001` — **WATCH / PORTFOLIO_GAP**.

Generic Etsy/Canva/planner templates remain `NO_GO_GENERIC`.

## Workana / EXP-AUTO-001 truth
Authenticated Workana dashboard: `PROFILE_UNDER_ANALYSIS_PENDING_MODERATION`.
Priority Moderation displayed price: USD9.90.
Kael decision: `DECLINED_WAIT_STANDARD_MODERATION_NO_SPEND`.

Huescaventura remains primary at last fresh check:
- budget EUR200–300;
- one visible proposal;
- authorized bid EUR300;
- proposal `AUTHORIZED_NOT_SUBMITTED`;
- submit only after profile approval, fresh open-status check and zero additional proposal spend.

## VETA-AUTO-PRODUCT-001 — verified technical state
Product: `Lead Intake Reliability Kit for n8n`.
Directory: `products/lead-intake-reliability-kit/`.
Market report: `NEXIA_VETA_AUTO_PRODUCT_MARKET_FALSIFICATION_2026-10-12.md`.
Validation design: `NEXIA_VETA_AUTO_PRODUCT_VALIDATION_EXPERIMENT_2026-10-12.md`.
Price hypothesis for first paid cohort: USD49 one-time.

Dedicated runtime proof:
- workflow `.github/workflows/n8n-product-runtime-smoke.yml`;
- n8n version 2.42.6;
- GitHub Actions run `38235228044`;
- job `114764135662`;
- tested commit `ca54ddbc626520a13450aecda6c550d165a42300`;
- result `success`.

Verified runtime results:
- four product workflows imported/exported and inactive by default;
- four production webhooks registered;
- valid input PASS;
- invalid-input rejection PASS;
- same normalized identity under a different event ID remained exactly one persisted row;
- after stopping/restarting n8n, a new unique identity increased persisted rows to exactly two;
- persistence uses native n8n Data Tables;
- asserted `autonomous_send=false`.

Truth boundary: internal runtime PASS is not external-user installation, buyer demand, willingness-to-pay, paid sales, refunds, support burden, revenue or profit.

No n8n Creator account exists. No store exists. No product/template has been published. External users = 0. Paid sales = 0. Revenue = EUR0. Realized profit = EUR0.

## Runtime proof correction and new evidence

Corrective event: `events/EVT-2026-10-12-AUTOPROD-002.json`.
Evidence report: `NEXIA_VETA_AUTO_PRODUCT_RUNTIME_REVERIFICATION_2026-10-12.md`, blob `bd7d26a21f448fe28f705034eeeb511a8dfadc6d`.

The previous green restart evidence was insufficient because the launcher was stopped without proving n8n termination; run38233861773 cleanup found two n8n start processes alive. That claim is superseded without changing the old immutable event. Corrected run38234612479 exposed a real restart404. Waiting for /healthz/readiness resolved the server-route startup race.

Final run38235228044 proves:
- PID3443 exited, health endpoint went down and TCP5678 closed;
- new PID3540 reached readiness;
- original Data Table row was present before any new write;
- a new phone identity then produced exactly two rows;
- final PID exited and port closed;
- zero audit404 retries and zero orphan n8n start processes in final cleanup.

Canonical version increments once for this material proof correction. Product files, commercial stage, authority and economic metrics are unchanged. External-user installation, concurrent dedup and crash/power-loss recovery remain unverified.

## Creator submission package
First free-template submission package is prepared internally:
- artifact: `products/lead-intake-reliability-kit/creator-submission-01.md`;
- title: `Reliable Lead Intake: Normalize, Validate & Prepare Human Review via Webhook`;
- intended price: FREE;
- workflow: `products/lead-intake-reliability-kit/workflows/lead-intake-human-review.json`;
- status: `PREPARED_NOT_SUBMITTED`.

Current n8n Creator guidance says new creators submit one template at a time, reviews are usually within a week, and three approved templates are required before verified-creator status and the option to publish paid templates.

The Creator account has NOT been created and the template has NOT been submitted or published. That remains a Human Gate.

## Product validation gate
The first paid-cohort hypothesis is locked at USD49. The validation experiment now records the missing measurement windows/definitions, support labor rate, tax-reserve ambiguity and separate paid-experiment WIP decision; existing thresholds are unchanged. Commercial validation requires real settled sales, not downloads/page views. Initial gate:
- >=5 settled paid sales at >=USD39 equivalent;
- refund rate <=10%;
- median support <=20 minutes/sale;
- positive contribution after platform fees and support labor;
- no critical installation/data/security defect.

## VETA-AI-UGC-001
Current classification: `WATCH / PORTFOLIO_GAP`.
Demand exists, but current open-market evidence shows frequent low-to-mid pricing and repeated portfolio requirements. Higher-ticket briefs exist with stronger competition. Tool/credit economics and <=4h package production are unverified. No AI-video credits or subscriptions are authorized.

## Automation architecture
Current inventory: **3 active / 6 paused / 1 completed**.
1. `NEXIA Control Tower` — daily, includes Workana moderation sensor.
2. `EXP-AUTO-001 Parallel Work` — every 6 hours.
3. `NEXIA Parallel Business Radar` — daily around 15:00; AUTO-PRODUCT priority, AI-UGC watch.

No automation is authorized to spend, create accounts, publish, contact buyers or submit new proposals beyond specific existing gates.

## Authority
Authorized:
- zero-cost research/falsification of the two veins;
- safe repository/testing/instrumentation work;
- existing Huescaventura EUR300 proposal after Workana approval and fresh zero-spend recheck.

Not authorized:
- Workana Priority Moderation;
- n8n Creator account creation or template submission/publication;
- storefront creation/product publication/payment activation;
- AI/video credits/subscriptions;
- ads or other spend;
- additional marketplace proposals/contact.

## Next material action
The next AUTO-PRODUCT step is now a Human Gate, not more internal engineering:
`Authorize creation/use of an n8n Creator account and submission of the prepared first FREE template, with EUR0 spend and no paid-product publication.`

Until authorized, continue standard Workana moderation wait and keep AI-UGC on watch.

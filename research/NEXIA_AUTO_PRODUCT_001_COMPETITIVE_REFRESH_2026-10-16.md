# VETA-AUTO-PRODUCT-001 — Competitive Refresh

Date: 2026-10-16
Status: RESEARCH_REFRESH / NO_PUBLICATION / NO_ACCOUNT / NO_SPEND
Product candidate: Lead Intake Reliability Kit for n8n

## HECHOS VERIFICADOS — fresh public market evidence
Current public n8n/template market contains both free and paid lead-intake products with substantial overlap:

1. Official n8n template: `Capture and deduplicate inbound leads with webhooks and Google Sheets` — free; validates, sanitizes/normalizes and deduplicates inbound leads, then stores clean leads.
2. Official n8n template: `Clean and deduplicate lead lists and export a review CSV file` — free; built-in nodes only, credential-free, validates/normalizes and classifies accepted/duplicate/review rows.
3. Gumroad `Lead Capture & Enrichment Pack for n8n (5 Workflows)` — USD25 observed; capture/validate/enrich/score/route/draft-reply bundle.
4. Gumroad `n8n Workflow Starter Pack` — USD29 observed; lead intake normalizer plus sample payload, setup/testing guide and QA/checklist system.
5. Gumroad `2000+ n8n Automation Templates` — USD49 observed; very large bundle competing on quantity.
6. `Lead Qualification & Follow-Up Automation` — USD49 observed; validation, scoring, routing, human approval, error handling and production checklist.
7. n8n community September 2026 lead-intake/Data Table template — reports validation, normalization, idempotency key + payload hash, exact-duplicate handling and conflict replay handling using built-in nodes.

Prices/availability are observations from 2026-10-16 web retrieval and can change.

## Falsification impact
The prior USD49 price hypothesis is not automatically invalid, but a generic `lead intake workflow + docs` proposition is materially weaker than previously assumed because:
- free templates already cover validation, normalization and deduplication;
- USD25–49 paid products already include multi-workflow packs, QA, human approval and broader qualification/routing;
- a USD49 price can coexist with the market, but only if Nexia has a clearly stronger reliability/evidence package rather than feature parity.

## Defensible differentiation hypothesis
Nexia should not compete on workflow count. Candidate differentiation becomes:

`reliability contract + persistent idempotency + adversarial fixtures + human-controlled sensitive actions + versioned QA + reproducible evidence`

Minimum differentiated bundle:
- persistent native n8n Data Table dedup across separate executions/restart evidence;
- event-key AND normalized-identity duplicate protection;
- explicit conflict/replay behavior rather than silent overwrite;
- `autonomous_send=false` human-control pattern;
- synthetic fixture suite covering valid / invalid / duplicate / replay-conflict / partial-contact cases;
- install + smoke-test procedure with measurable postconditions;
- failure/recovery/troubleshooting matrix;
- version compatibility statement;
- no credentials or real buyer data in package;
- evidence boundary separating internal runtime proof from customer production proof.

## Gap discovered
Current kit has strong technical components, but market refresh exposes two likely gaps before a paid validation:
1. explicit replay-conflict semantics should be benchmarked against the strongest free community template rather than assuming simple duplicate blocking is sufficient;
2. self-serve install/support burden remains NOT INSTRUMENTED with an independent fresh-user test.

## Smallest internal validation — AUTO-PRODUCT-TEST-001
No store/publication/contact needed.

Pre-register:
- execute existing static/product tests;
- add/review one conflict-replay fixture where the same event key arrives with materially different payload;
- require deterministic safe disposition and no external send;
- run install documentation against a clean/synthetic n8n environment when an authorized runtime surface exists;
- measure setup + sample verification time;
- target <=30 minutes competent-user setup;
- target zero mandatory support call for standard path;
- all workflows inactive on import;
- every safety/QA claim traceable to a test or marked unverified.

## Commercial decision
Do NOT publish yet.
Do NOT open a Gumroad/Etsy/store account yet.
Do NOT spend on ads.
Do NOT increase WIP with a broad template catalog.

The next information-rich step is product differentiation/QA, not distribution.

## Preliminary promotion gate
Move from `ACTIVE_RESEARCH_OPTION` to `VALIDATION_CANDIDATE` only if:
- internal product QA fully passes;
- replay/conflict semantics are competitive or intentionally documented as out-of-scope;
- clean-install path is verified <=30 minutes;
- support surface is bounded;
- USD49-equivalent value remains plausible after direct competitor comparison;
- publication test thresholds are preregistered before any public listing.

## Economic truth
Spend executed: EUR0.
Store/account created: NO.
Published listing: NO.
Customers: 0.
Sales: 0.
Settled revenue: EUR0.
Profit: EUR0.

## Recommendation
Keep Auto-Product as lane 3, but shift the question from `can we package our existing workflow?` to `can we prove a reliability product sufficiently better than free/cheap alternatives to justify a paid test?`.

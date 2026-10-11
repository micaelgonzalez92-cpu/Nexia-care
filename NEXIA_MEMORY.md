> **Canonical priority notice — 2026-10-11:** NEXIA_STATE.json **v62** is the operational source of truth. This file is a learning ledger only. Detailed older memory remains recoverable from Git history; the immediately previous memory blob is `9f82d9e04a05e77e9281538cf369052bd4aa6798`.

# NEXIA MEMORY — Current Learning Ledger

## Mission
Build a repeatable business engine that discovers, validates, monetizes and repeats opportunities until it demonstrates >€1,000/month sustainable net profit after tax.

## Active monetization experiment — EXP-AUTO-001
**Lead Intake Reliability Sprint** is the single active monetization experiment.

Current stage: **VETA / PRE-VALIDATION**.

Current buyer opportunity: **Huescaventura on Workana**.
- Buyer-initiated public brief.
- Public budget: €200–€300.
- Authorized proposal: €300.
- Proposal: **AUTHORIZED_NOT_SUBMITTED**.
- Workana profile: created/completed according to Kael; approval not yet verified.
- No buyer contact, contract, payment, revenue or profit has occurred.
- Workana moderation is checked by a dedicated daily automation; paid moderation is not authorized.

## Commercial gate
Initial validation gate remains:
- ≥2 qualified responses/conversations from at most 20 matched authorized applications/contacts;
- ≥1 paid pilot at ≥€249 economic equivalent;
- measured delivery ≤4 hours including review/correction/handover;
- zero critical data-loss/duplicate-send/unauthorized-send/credential failures;
- buyer accepts after at most one bounded correction.

Failure/pivot if no paid pilot after 20 authorized matched attempts, market price destroys contribution, delivery exceeds 4 hours, support/tooling erases margin, reliability fails or acquisition requires misleading experience claims.

## Economics — current estimate, not realized
For Huescaventura at €300:
- assumed initial Workana commission: 20%;
- estimated after platform: €240;
- labor assumption: 4 h × €15 = €60;
- target extra variable tooling: €0;
- estimated contribution before overhead/tax: €180.

Tax and after-tax profit remain **UNKNOWN**. These are estimates, not revenue or willingness-to-pay evidence.

## Technical evidence
Verified synthetic/local evidence:
- generic lead-intake logic: **9/9 PASS**;
- local HTTP integration: **12/12 PASS**;
- Node-RED structural validation: **6/6 PASS**;
- Huescaventura-specific domain demo: **13/13 PASS**;
- credential-free n8n import skeleton validator: **12/12 PASS**.

Not verified:
- actual import/runtime inside a real n8n instance;
- buyer Airtable schema/credentials;
- persistent deduplication across real executions;
- real client notification channel;
- production reliability;
- buyer acceptance.

Never present synthetic/local evidence as prior client production work.

## Channel learning
- Spanish unsolicited commercial cold email remains NO-GO under the project's conservative legal/channel policy.
- Prefer buyer-initiated public briefs, RFPs, inbound and opt-in.
- Marketplace friction is a real risk: a qualified opportunity can exist while profile moderation blocks submission.
- Do not buy activity. Paid moderation, plans and credits require explicit approval.

## Opportunity selection learning
The comparison gate selected lead-intake/CRM reliability automation over generic catalog QA, Higgsfield Earn and digital-template paths for the next validation experiment. This selection is not PMF and not commercial validation.

Background radar may continue, but WIP is limited to one active monetization experiment plus at most two research/falsification paths.

## Automation learning — 2026-10-11 /evolve
Five active tasks created unnecessary overlap. Architecture was consolidated to three active functions:
1. **NEXIA Control Tower** — daily; state, memory, integrity and prioritization. Memory Review merged here.
2. **Nexia Parallel Work** — every 4 hours; safe €0 worker. It does not poll Workana/Gmail.
3. **Workana Response Watch** — daily dedicated moderation sensor.

Disabled as redundant:
- NEXIA Memory Review;
- Radar multivía Nexia.

Parallel Work had not yet executed after creation at the v62 checkpoint, so its runtime reliability remains unverified until the first completed run.

## Evidence freshness learning
External facts must expire rather than remain silently true:
- public project status: 24 h;
- marketplace fee/policy: 7 d;
- competitor price: 7 d;
- legal/regulatory source: 30 d, with recheck before material action when practical.

Expired facts become **STALE_RECHECK_REQUIRED**.

## Commercial pipeline
Machine-readable ledger: `NEXIA_COMMERCIAL_PIPELINE.json`.

Stages:
QUALIFIED_OPPORTUNITY → PROPOSAL_AUTHORIZED → PROPOSAL_SENT → QUALIFIED_RESPONSE → NEGOTIATION → PAID_PILOT → DELIVERED → ACCEPTED → SETTLED_PAYMENT → NET_PROFIT_RECONCILED → REPEATABLE.

Unknown is never converted to zero except where an observable zero genuinely exists.

## Paused/historical paths
Preserved but non-primary:
- vintage/resale pilot — purchase never executed;
- legacy NEXIA Care / De'Longhi route;
- De'Longhi affiliate research;
- AI influencer — generated concept exists, no paid generation/publication authorized;
- generic catalog QA — technical evidence exists, commercially deprioritized.

Do not reactivate a paused path merely because historical notes exist.

## Current operating rule
Prioritize the next economic event, not artifact count:
**qualified opportunity → proposal → response → paid pilot → delivery → acceptance → settled payment → reconciled net profit → repeatability**.

Files, commits, tests and automation counts are diagnostic evidence only; they do not increase the economic score by themselves.

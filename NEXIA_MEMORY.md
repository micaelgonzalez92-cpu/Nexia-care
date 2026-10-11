> **Canonical priority notice — 2026-10-11:** NEXIA_STATE.json **v63** is the operational source of truth. This file is a learning ledger only. Detailed older memory remains recoverable from Git history; prior memory blobs remain immutable repository history.

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
Success requires:
- ≥2 qualified responses/conversations from at most 20 matched authorized applications/contacts;
- ≥1 paid pilot at ≥€249 economic equivalent;
- measured delivery ≤4 hours including review/correction/handover;
- zero critical data-loss/duplicate-send/unauthorized-send/credential failures;
- buyer acceptance after at most one bounded correction.

Failure/pivot if no paid pilot after 20 authorized matched attempts, market price destroys contribution, delivery exceeds 4 hours, support/tooling erases margin, reliability fails or acquisition requires misleading experience claims.

## Economics — estimate, not realized
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

Not verified: real n8n runtime import, buyer Airtable schema/credentials, persistent dedup across real executions, production notifications, production reliability or buyer acceptance.

Never present synthetic/local evidence as prior client production work.

## Channel learning
- Spanish unsolicited commercial cold email remains NO-GO under project policy.
- Prefer buyer-initiated public briefs/RFPs or inbound/opt-in.
- Marketplace moderation is a genuine acquisition risk.
- Paid moderation/plans/credits require explicit approval.

## Opportunity-selection learning
Lead-intake/CRM reliability automation beat generic catalog QA, Higgsfield Earn and digital-template paths in the comparison gate. This is selection for validation only, not PMF.

WIP: one active monetization experiment plus at most two background research/falsification paths.

## Automation learning — 2026-10-11 /evolve
Consolidated five active tasks into three functions:
1. **NEXIA Control Tower** — daily; state, memory, integrity and prioritization.
2. **Nexia Parallel Work** — every 4 hours; safe €0 worker; no Workana/Gmail polling.
3. **Workana Response Watch** — daily dedicated moderation sensor.

Disabled as redundant:
- NEXIA Memory Review;
- Radar multivía Nexia.

Parallel Work remains configured but **runtime unverified** until its first completed run is observed.

## Persistence learning — Event Storage v2
The legacy `NEXIA_EVENT_LOG.jsonl` is frozen read-only at verified blob `84db0ce6ccd1878be9ff48a770bb8b6f1e433d72` because the connector exposes no native append operation.

New critical events are stored as immutable files under `events/`, indexed by `NEXIA_EVENT_INDEX.json`. Creating a new file is the append operation. Event files are never edited; corrections create a new event.

Current persistence protocol: `NEXIA_PERSISTENCE_PROTOCOL.md` v2.0.

## Evidence freshness
- public project status: 24 h;
- marketplace fee/policy: 7 d;
- competitor price: 7 d;
- legal/regulatory source: 30 d;
- reverify before material action when practical.

Expired facts become **STALE_RECHECK_REQUIRED**.

## Commercial pipeline
Machine-readable ledger: `NEXIA_COMMERCIAL_PIPELINE.json`.

Stages:
QUALIFIED_OPPORTUNITY → PROPOSAL_AUTHORIZED → PROPOSAL_SENT → QUALIFIED_RESPONSE → NEGOTIATION → PAID_PILOT → DELIVERED → ACCEPTED → SETTLED_PAYMENT → NET_PROFIT_RECONCILED → REPEATABLE.

Unknown is never converted to zero unless an observable zero genuinely exists.

## Paused/historical paths
Preserved but non-primary:
- vintage/resale pilot — purchase never executed;
- legacy NEXIA Care / De'Longhi route;
- De'Longhi affiliate research;
- AI influencer — concept exists, no paid generation/publication authorized;
- generic catalog QA — technical evidence exists, commercially deprioritized.

## Current operating rule
Prioritize the next economic event, not artifact count:
**qualified opportunity → proposal → response → paid pilot → delivery → acceptance → settled payment → reconciled net profit → repeatability**.

Files, commits, tests and automation counts are diagnostic evidence only; they do not increase the economic score by themselves.

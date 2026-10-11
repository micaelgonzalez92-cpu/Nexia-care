# NEXIA MASTER BACKUP — CURRENT RECOVERY SNAPSHOT

Updated: 2026-10-11
Status: STATE v63 / EVENT STORAGE v2 READBACK VERIFIED
Checkpoint: `CP-2026-10-11-EVOLVE-001`

Historical backup content remains recoverable from Git history and never overrides canonical STATE.

## Canonical state
- `NEXIA_STATE.json`: v63
- STATE blob: `3b42b908e0e9bf9fb8e047d5f3c0ac52ef0a796f`
- BOOT v36 blob: `07528e512e0c36fe6b0c92d6ddd691bf8bf9513a`
- LIVE blob: `f04aa5e21b5c92c2c931aad75b9e2d06ff1ecce6`
- MEMORY blob: `443137fd25747baa2c25a403b4ca47a38b6dee7a`
- commercial pipeline blob: `92e53d402bf53987275b6d56e17586847a8907e2`
- persistence protocol v2 blob: `69f18157e693fb71739fa1230286acdf5134b370`

Mission: `MISSION-OPPORTUNITY-ENGINE-001`.
Active monetization experiment: `EXP-AUTO-001 — Lead Intake Reliability Sprint`.
Phase: `VETA / PRE-VALIDACION COMERCIAL`.

## Commercial truth
Primary opportunity: Huescaventura / Workana.
- Buyer-initiated: yes.
- Last verified public status: OPEN / EVALUATING PROPOSALS.
- Public status verified 2026-10-11; stale after 24 hours without recheck.
- Buyer budget: €200–€300.
- Proposal authorized: €300.
- Proposal status: `AUTHORIZED_NOT_SUBMITTED`.
- Workana profile approval: NOT VERIFIED.
- Buyer response: none.
- Contract: none.
- Settled payment: €0.
- Revenue: €0.
- Reconciled net profit: €0.

## Economics — estimate only
- gross offer €300;
- assumed initial Workana commission 20%;
- estimated after platform €240;
- labor assumption €60 (4h × €15);
- target additional variable tooling €0;
- estimated contribution before overhead/tax €180;
- tax and after-tax profit UNKNOWN.

## Technical evidence
- generic lead-intake logic 9/9 synthetic PASS;
- local HTTP integration 12/12 PASS;
- Node-RED structural checks 6/6 PASS;
- Huescaventura domain demo 13/13 synthetic PASS;
- n8n import skeleton 12/12 local structural+embedded-code PASS;
- n8n runtime NOT EXECUTED;
- real Airtable integration NOT EXECUTED;
- verified client production experience NONE.

## Automation architecture
Verified inventory after `/evolve`: 3 active / 6 paused / 1 completed.
Active functions:
1. NEXIA Control Tower — daily; includes memory/integrity/prioritization.
2. Nexia Parallel Work — every 4 hours; safe €0 worker; does not poll Workana/Gmail.
3. Workana Response Watch — daily moderation sensor.

Disabled as redundant: NEXIA Memory Review and Radar multivía Nexia.
Parallel Work remains configured but runtime-unverified until its first completed run.

## Event Storage v2
Persistence protocol v2.0 is ACTIVE.
- New events: immutable `events/*.json`.
- Derived index: `NEXIA_EVENT_INDEX.json`, verified blob `754775400702ab77db46fcaeea8db4505ef301c6`.
- Latest event at this snapshot: `EVT-2026-10-11-EVOLVE-001`, verified blob `fb278799714287c03f749990211b5c8d33a60ce5`.
- Legacy `NEXIA_EVENT_LOG.jsonl` is READ-ONLY at verified boundary blob `84db0ce6ccd1878be9ff48a770bb8b6f1e433d72`.
- Immutable event files are never edited; corrections/new transitions create new event files.

## WIP and evidence freshness
- max one active monetization experiment;
- max two background research/falsification paths;
- public project status freshness: 24h;
- marketplace fee/policy: 7d;
- competitor price: 7d;
- legal/regulatory source: 30d;
- reverify before material action when practical.

Expired external facts are `STALE_RECHECK_REQUIRED`.

## Human authority
No immediate action required from Kael.
Already authorized: one Huescaventura proposal at €300 after Workana approval is verified, only if submission remains zero-spend.
Not authorized: paid moderation, paid plans/credits, additional buyer contacts, purchases/ads/subscriptions, irreversible publication, scope/price expansion.

## Current integrity assessment
STATE/BOOT/LIVE/MEMORY/pipeline/protocol/event index/event file have all been read back successfully for the v63 evolution cycle. This backup update itself must be read back before the canonical checkpoint can be marked closed.

## Next safe action
Read back this backup and the evolution report, then advance canonical checkpoint metadata from migration-in-progress to verified/operational without changing business authorization or economics. Continue safe parallel work; Workana remains daily-only.

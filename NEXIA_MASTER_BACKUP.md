# NEXIA MASTER BACKUP — CURRENT RECOVERY SNAPSHOT

Updated: 2026-10-11
Status: **STATE v65 CANONICAL / /EVOLVE CLOSED / CI VERIFIED / EVENT STORAGE v2 OPERATIONAL / MEMORY DERIVED STALE**
Checkpoint: `CP-2026-10-11-EVOLVE-001`

Historical snapshots remain recoverable from Git history and never override canonical STATE.

## Canonical recovery map
- STATE v65: `5e7b8789ab4f3deaf196bd4c9c446c028db45a4d`
- BOOT v40: `5fb6d6de23cbb7df9819ddcdce714bb8b7bb200a`
- LIVE: `5c81c0bbfa22b4a23b9eb6e861cbf056ea527efe`
- MEMORY last verified: `443137fd25747baa2c25a403b4ca47a38b6dee7a` — derived ledger remains on v63 header because update was blocked by tool safety; STATE v65 overrides it.
- Commercial pipeline: `92e53d402bf53987275b6d56e17586847a8907e2`
- Persistence protocol v2: `69f18157e693fb71739fa1230286acdf5134b370`
- Evolution report: `aa544cc3d48e1679016b550bc249726e7c861f82`
- Event index: `6691b1e55efb8f20c42904668e75314136c7028e`
- Latest verified event: `events/EVT-2026-10-11-CI-001.json`, blob `8a6cc25993cd987e827e44aed8128c541e5be27b`
- Legacy JSONL boundary: `84db0ce6ccd1878be9ff48a770bb8b6f1e433d72`, READ-ONLY.

## Mission and experiment
Mission: `MISSION-OPPORTUNITY-ENGINE-001`.
Active monetization experiment: `EXP-AUTO-001 — Lead Intake Reliability Sprint`.
Phase: `VETA / PRE-VALIDACION COMERCIAL`.

## Commercial truth
Huescaventura / Workana remains the primary qualified opportunity.
- last verified public status: OPEN / EVALUATING PROPOSALS;
- status freshness: 24h;
- buyer budget: €200–€300;
- authorized proposal: €300;
- proposal status: `AUTHORIZED_NOT_SUBMITTED`;
- Workana profile approval: NOT VERIFIED;
- buyer response: none;
- contract: none;
- settled payment: €0;
- revenue: €0;
- reconciled net profit: €0.

Estimate only: 20% initial Workana commission assumption, €240 after platform, €60 labor assumption, €180 contribution before overhead/tax, tax UNKNOWN.

## Technical truth
- generic lead-intake logic 9/9 synthetic PASS;
- local HTTP integration 12/12 PASS;
- Node-RED structural checks 6/6 PASS;
- Huescaventura domain demo 13/13 synthetic PASS;
- n8n import skeleton 12/12 structural/code PASS;
- n8n runtime NOT EXECUTED;
- real Airtable integration NOT EXECUTED;
- prior client production experience NONE VERIFIED.

## Verified continuous integration
Workflow: `.github/workflows/nexia-ci.yml`.
First verified run: `38149148915` — conclusion `success`.
Verified job: `technical-integrity` (`114498718054`).
The run passed the lead-intake logic suite, local HTTP integration suite, Huescaventura domain suite, Node-RED structural validation, n8n skeleton validation and integrity-checker regression tests.
Workflow permissions are read-only (`contents: read`) and it performs no deployment or buyer contact.

CI success is technical regression evidence only; it is not production deployment, buyer acceptance, n8n runtime proof on buyer infrastructure, revenue or profit.

## Automation architecture
Verified inventory: 3 active / 6 paused / 1 completed.
1. NEXIA Control Tower — daily.
2. Nexia Parallel Work — every 4 hours; no Workana/Gmail polling; first completed run still not runtime-verified.
3. Workana Response Watch — daily-only moderation sensor.

Disabled as redundant: NEXIA Memory Review and Radar multivía Nexia.

## Event Storage v2
- new critical events are immutable files under `events/`;
- `NEXIA_EVENT_INDEX.json` is derived/regenerable;
- historical JSONL remains intact/read-only;
- corrections create new events, never edits to immutable events.

Latest verified event: `EVT-2026-10-11-CI-001`.

## Known integrity debt
Only one derived artifact is stale: `NEXIA_MEMORY.md` still declares STATE v63 because the attempted update was blocked by the tool safety layer. No bypass was attempted. Its substantive mission/experiment/business content remains compatible with current truth. STATE v65, BOOT v40, LIVE and this backup explicitly record the mismatch.

Retry MEMORY only if the tool/security condition changes.

## Authority
No immediate Kael action required.
Already authorized: one Huescaventura proposal at €300 after Workana approval is verified, only if zero-spend.
Not authorized: paid moderation, plans/credits, extra buyer contacts, purchases/ads/subscriptions, irreversible publication, or scope/price expansion.

## Next safe action
Continue safe €0 parallel work. Verify the first completed run of Nexia Parallel Work before calling it runtime-proven. Workana moderation remains daily-only. Prefer a real free n8n runtime test over more synthetic layers when available. On verified Workana approval, recheck Huescaventura and submit the already-authorized €300 proposal if still open and zero-spend.

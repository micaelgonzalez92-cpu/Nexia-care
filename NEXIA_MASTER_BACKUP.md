# NEXIA MASTER BACKUP — CURRENT RECOVERY SNAPSHOT

Updated: 2026-10-12
Status: **STATE v67 CANONICAL / ACQUISITION REVERIFIED / AUTOMATIONS RECONCILED / N8N RUNTIME + PERSISTENT DEDUP VERIFIED / EVENT STORAGE v2 OPERATIONAL / MEMORY DERIVED STALE**
Checkpoint: `CP-2026-10-12-ACQ-001`

Historical snapshots remain recoverable from Git history and never override canonical STATE.

## Canonical recovery map
- STATE v67: `599eb1b2fe5f3760f4e2bd72bdef8fce8f56a56b`
- BOOT v42: `d085b9e780dc9239d5ea421dff2254470f41e9a3`
- LIVE: `d662c1afe0c5856a592d24b3cbe3b2548af1faf9`
- MEMORY last verified: `443137fd25747baa2c25a403b4ca47a38b6dee7a` — derived ledger remains on v63 header because update was blocked by tool safety; STATE v67 overrides it.
- Commercial pipeline: `92e53d402bf53987275b6d56e17586847a8907e2`
- Persistence protocol v2: `69f18157e693fb71739fa1230286acdf5134b370`
- Event index: `aa0ef1ff5cdf2819d8875e0e3a807b42af8f4d42`
- Latest verified event: `events/EVT-2026-10-12-ACQ-001.json`, blob `29ef6baca8e0697197d1ad40dfe206ac72862516`
- Latest acquisition scan: `NEXIA_EXP_AUTO_001_ACQUISITION_SCAN_2026-10-12_01.md`, blob `648a256797b4729e618b03c5b3e8908b1859d778`
- n8n persistence evidence: `NEXIA_EXP_AUTO_001_N8N_PERSISTENT_DEDUP_2026-10-12.md`, blob `70ef60e51f5b8f7fda946216f39d2db42ecf2ced`
- Legacy JSONL boundary: `84db0ce6ccd1878be9ff48a770bb8b6f1e433d72`, READ-ONLY.

## Mission and experiment
Mission: `MISSION-OPPORTUNITY-ENGINE-001`.
Active monetization experiment: `EXP-AUTO-001 — Lead Intake Reliability Sprint`.
Phase: `VETA / PRE-VALIDACION COMERCIAL`.
Commercial stage did **not** advance because acquisition research and technical capability are not demand, payment or profit.

## Commercial truth
Huescaventura / Workana remains the primary qualified opportunity.
- public status reverified 2026-10-12: OPEN / EVALUATING PROPOSALS;
- status freshness target: 24h;
- buyer budget: €200–€300;
- latest public evidence checked in this batch showed 1 visible proposal;
- authorized proposal: €300;
- proposal status: `AUTHORIZED_NOT_SUBMITTED`;
- Workana profile approval: NOT VERIFIED;
- Gmail check 2026-10-12: no approval/rejection decision email found;
- buyer response: none;
- contract: none;
- settled payment: €0;
- revenue: €0;
- reconciled net profit: €0.

Estimate only: 20% initial Workana commission assumption, €240 after platform, €60 labor assumption, €180 contribution before overhead/tax, tax UNKNOWN.

Fresh acquisition scan did not promote any non-Workana project to GO. Current bottleneck is acquisition access to a fresh, bounded, economically viable buyer brief — not lack of synthetic technical proof.

## Technical truth
- generic lead-intake logic 9/9 synthetic PASS;
- local HTTP integration 12/12 PASS;
- Node-RED structural checks 6/6 PASS;
- Huescaventura domain demo 13/13 synthetic PASS;
- n8n import skeleton 12/12 structural/code PASS;
- n8n 2.42.6 runtime execution: **VERIFIED PASS**, run `38178359319`, six asserted synthetic cases, `autonomous_send=false`;
- native n8n Data Table persistent dedup/idempotency: **VERIFIED PASS**, run `38180738447`;
- five separate webhook requests produced exactly two persisted unique identities;
- after stopping/restarting n8n and a sixth duplicate request, the audit still returned exactly two rows;
- real Airtable integration NOT EXECUTED;
- real Google Sheets integration NOT EXECUTED;
- real client CRM integration NOT EXECUTED;
- client production deployment NOT EXECUTED;
- prior client production experience NONE VERIFIED.

## Verified continuous integration
Base workflow: `.github/workflows/nexia-ci.yml`, first verified run `38149148915` — `success`.
Runtime/persistence workflow: `.github/workflows/n8n-runtime-smoke.yml`, verified run `38180738447` — `success`.

CI success is technical evidence only; it is not buyer acceptance, customer production deployment, revenue or profit.

## Automation architecture
Verified live inventory: **2 active / 7 paused / 1 completed**.
1. NEXIA Control Tower — daily; notifications enabled; includes the daily Workana moderation/Gmail sensor.
2. EXP-AUTO-001 Parallel Work — every 6 hours; scheduler has executed at least once (`2026-10-11T19:52:12.224695Z`); returned work/result remains NOT INSTRUMENTED; notifications disabled.

`Workana Response Watch` is PAUSED as redundant after the sensor was consolidated into Control Tower.

Other paused redundant/legacy tasks include NEXIA Memory Review, Radar multivía Nexia, NEXIA Brainstorm, Radar y revisión de oportunidades, NEXIA Agentes y Automatización and Revisión de oportunidades.

## Event Storage v2
- new critical events are immutable files under `events/`;
- `NEXIA_EVENT_INDEX.json` is derived/regenerable;
- historical JSONL remains intact/read-only;
- corrections create new events, never edits to immutable events.

Latest verified event: `EVT-2026-10-12-ACQ-001`.

## Known integrity debt
`NEXIA_MEMORY.md` still declares STATE v63 because the attempted update was blocked by the tool safety layer. No bypass was attempted. STATE v67, BOOT v42, LIVE and this backup record the mismatch.

Automation result-return remains partially uninstrumented: scheduler execution of Parallel Work is verified, but its returned work/result is not exposed in the automation state checked here.

## Authority
No immediate Kael action required.
Already authorized: one Huescaventura proposal at €300 after Workana approval is verified, only if zero-spend and the project remains open.
Not authorized: paid moderation, plans/credits, extra buyer contacts, new marketplace accounts, marketplace wallet funding, purchases/ads/subscriptions, irreversible publication, or scope/price expansion.

## Next safe action
Do **not** add synthetic technical work merely for activity. Keep the daily Workana approval sensor inside Control Tower and the 6-hour worker focused on fresh buyer-initiated alternatives. On verified Workana approval, recheck Huescaventura and submit the already-authorized €300 proposal if still open and zero-spend. Do not ask Kael to create or fund another marketplace account until a specific fresh project justifies the exposure.

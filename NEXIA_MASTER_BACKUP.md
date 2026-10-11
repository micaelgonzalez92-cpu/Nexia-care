# NEXIA MASTER BACKUP — CURRENT RECOVERY SNAPSHOT

Updated: 2026-10-12
Status: **STATE v66 CANONICAL / N8N RUNTIME + PERSISTENT DEDUP VERIFIED / EVENT STORAGE v2 OPERATIONAL / MEMORY DERIVED STALE**
Checkpoint: `CP-2026-10-12-N8N-001`

Historical snapshots remain recoverable from Git history and never override canonical STATE.

## Canonical recovery map
- STATE v66: `69dd2b8a1d6b60d5712e5b691908d7dbabc8ee5e`
- BOOT v41: `0361a5853db559d83675c62d72c1d11a1fd4b283`
- LIVE: `eff8037f7d62c1827f4dc2f9902e7e437914bd0d`
- MEMORY last verified: `443137fd25747baa2c25a403b4ca47a38b6dee7a` — derived ledger remains on v63 header because update was blocked by tool safety; STATE v66 overrides it.
- Commercial pipeline: `92e53d402bf53987275b6d56e17586847a8907e2`
- Persistence protocol v2: `69f18157e693fb71739fa1230286acdf5134b370`
- Event index: `17225ef45ea93b1bce112e10ab8d364fe3dda4b0`
- Latest verified event: `events/EVT-2026-10-12-N8N-001.json`, blob `69e4754ce3f7a1afbb83433ec08e21a1b6046219`
- n8n persistence evidence: `NEXIA_EXP_AUTO_001_N8N_PERSISTENT_DEDUP_2026-10-12.md`, blob `70ef60e51f5b8f7fda946216f39d2db42ecf2ced`
- Legacy JSONL boundary: `84db0ce6ccd1878be9ff48a770bb8b6f1e433d72`, READ-ONLY.

## Mission and experiment
Mission: `MISSION-OPPORTUNITY-ENGINE-001`.
Active monetization experiment: `EXP-AUTO-001 — Lead Intake Reliability Sprint`.
Phase: `VETA / PRE-VALIDACION COMERCIAL`.
Commercial stage did **not** advance because technical capability is not demand, payment or profit.

## Commercial truth
Huescaventura / Workana remains the primary qualified opportunity.
- public status reverified 2026-10-12: OPEN / EVALUATING PROPOSALS;
- status freshness: 24h;
- buyer budget: €200–€300;
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
- `$getWorkflowStaticData('global')` persistence attempt FAILED this proof and is not used;
- isolated `n8n execute` Data Table route lacked module helpers and is not used for the PASS;
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
Verified inventory: 3 active / 6 paused / 1 completed.
1. NEXIA Control Tower — daily, executed previously.
2. EXP-AUTO-001 Parallel Work — actual live cadence **every 6 hours**; scheduler has executed at least once (`2026-10-11T19:52:12.224695Z`); returned work/result is NOT INSTRUMENTED; notifications disabled.
3. Workana Response Watch — daily; scheduler has executed; no approval/rejection found; notifications disabled, therefore notification delivery is NOT VERIFIED.

Disabled as redundant: NEXIA Memory Review and Radar multivía Nexia.

## Event Storage v2
- new critical events are immutable files under `events/`;
- `NEXIA_EVENT_INDEX.json` is derived/regenerable;
- historical JSONL remains intact/read-only;
- corrections create new events, never edits to immutable events.

Latest verified event: `EVT-2026-10-12-N8N-001`.

## Known integrity debt
`NEXIA_MEMORY.md` still declares STATE v63 because the attempted update was blocked by the tool safety layer. No bypass was attempted. STATE v66, BOOT v41, LIVE and this backup record the mismatch. Retry MEMORY only if the tool/security condition changes.

Automation result-return remains partially uninstrumented: scheduler execution of Parallel Work is verified, but its returned work/result is not exposed in the automation state checked here.

## Authority
No immediate Kael action required.
Already authorized: one Huescaventura proposal at €300 after Workana approval is verified, only if zero-spend and the project remains open.
Not authorized: paid moderation, plans/credits, extra buyer contacts, purchases/ads/subscriptions, irreversible publication, or scope/price expansion.

## Next safe action
Do **not** keep adding synthetic technical layers merely to create activity. The technical persistence gate is now proven at zero cost. Prioritize the next economic event: maintain daily Workana moderation sensing and zero-cost buyer-initiated opportunity qualification. On verified Workana approval, recheck Huescaventura and submit the already-authorized €300 proposal if still open and zero-spend. Real Airtable/Sheets/CRM integration remains a separate delivery gate and should be executed when it directly reduces pilot risk or matches the buyer's actual stack without unauthorized spend/account creation.

# NEXIA — SESSION BOOTSTRAP

Updated: 2026-10-06
Purpose: allow any new ChatGPT conversation/client in NEXIA Core to recover the operational state without depending on the previous chat transcript.

## START HERE — DO NOT ASK KAEL TO RECONSTRUCT THE PROJECT

A new chat is a replaceable terminal. The repository is the continuity anchor.

Mandatory startup order:
1. Inspect the GitHub connector/repository capability.
2. Read NEXIA_BOOT.json.
3. Read NEXIA_STATE.json.
4. Verify STATE version and blob SHA against BOOT.
5. Read NEXIA_MEMORY.md when mission/experiment history is needed.
6. Read recent NEXIA_EVENT_LOG.jsonl / decision information when required.
7. Read NEXIA_CONTINUITY.md and reconcile any stale interface/automation claims.
8. Identify: phase, active mission, active experiment, Human Gate, blockers, last confirmed action, next safe action, financial guardrails.
9. Execute GREEN actions immediately when capability and policy permit.
10. Surface YELLOW/RED work as an explicit TAREA DE KAEL.
11. Never ask Kael to restate state that is already present in the repository.
12. If the repository is unavailable, say so explicitly and do not claim recovery.

## CURRENT RECOVERY CONTRACT

Canonical state: NEXIA_STATE.json
Startup index: NEXIA_BOOT.json
Learning ledger: NEXIA_MEMORY.md
Critical history: NEXIA_EVENT_LOG.jsonl
Portable recovery: NEXIA_MASTER_BACKUP.md
Continuity contract: NEXIA_CONTINUITY.md
Persistence contract: NEXIA_PERSISTENCE_PROTOCOL.md
Authority/synchronization contract: NEXIA_SYNC_AND_AUTHORITY_PROTOCOL.md

STATE is canonical. BOOT, LIVE, BACKUP and interfaces are derived/recovery artifacts. A stale artifact never overrides newer verified STATE.

## RECOVERY RESULT FORMAT

After boot, the first substantive response should be a compact command dashboard containing:
- NEXIA BOOT: OK / PARTIAL / BLOCKED
- STATE version + verification status
- Phase
- Mission
- Active experiment
- Human Gate
- Financial guardrails
- Last confirmed action
- Next safe action
- Any capability limitation

Do not repeat historical research unless it changes the next action.

## CURRENT MACHINE STATE

- Phase: VALIDACIÓN
- Canonical STATE: v39
- Capital: €0
- Revenue: €0
- Profit: €0
- Inventory: €0
- Debt: €0
- Extractions: 0
- Reproducibility: 0
- Active experiment: EXP-001B — Prueba de diagnóstico con usuario real
- Current mission: MISSION-003 — Falsar el canal afiliado 6% sin gasto
- Human Gate: K-001 / real-world participant and external actions remain controlled
- Current spend: €0
- Weekly budget ceiling: €100
- Reserved: €7.25

## PUBLIC INTERFACES

- Product/interface: Nexia Care
- Command centre: Nexia HQ
- Repository: micaelgonzalez92-cpu/Nexia-care
- Public routes recorded in the recovery snapshot must be separately runtime-verified before being claimed healthy.

## CONTINUITY RULE

Losing, changing, or starting a new chat must not erase NEXIA state, decisions, experiments, economics, architecture or guardrails. The chat transcript is context only.

## RESPONSE CONTRACT

Always distinguish HECHO VERIFICADO / ESTIMACIÓN / HIPÓTESIS / RECOMENDACIÓN.
Never claim background work, deployment, external contact, revenue, or continuous automation unless independently verified.
Do not confuse available tools with authorized business actions.

## NEXT PRIORITY

Continue from canonical STATE, not from this document's historical text. Current next safe action is whatever NEXIA_STATE.json and verified recent events establish at boot.

## PERSISTENCE SAFETY

Critical changes follow:
OBSERVE → EXECUTE → VERIFY → CHECKPOINT → BACKUP

If a write fails:
- do not claim completion;
- preserve last known-good state;
- re-read current repository state before retry;
- never force-overwrite a newer branch head.

## RECOVERY TEST

A fresh session passes the continuity test only if it can reconstruct from BOOT + STATE alone:
- current phase;
- active mission;
- active experiment;
- financial guardrails;
- Human Gate;
- last confirmed action;
- next safe action;
- authorization boundaries.

This bootstrap contract does not create background execution, external authorization, credentials or an independent 24/7 worker.

# NEXIA — SESSION BOOTSTRAP

Updated: 2026-10-05
Purpose: allow any new ChatGPT conversation/client in NEXIA Core to recover the operational state without depending on the previous chat transcript.

## START HERE

1. Read NEXIA_BOOT.json.
2. Read NEXIA_STATE.json.
3. Read NEXIA_MEMORY.md only if experiment/history detail is needed.
4. Read NEXIA_CONTINUITY.md for recovery rules.
5. Compare BOOT/STATE versions and hashes; STATE is canonical.
6. Inspect recent Git commits before assuming that a task is still pending.
7. Resume the current mission; do not restart discarded research.

## CURRENT MACHINE STATE

- Phase: VALIDACIÓN
- Capital: €0
- Revenue: €0
- Profit: €0
- Inventory: €0
- Debt: €0
- Extractions: 0
- Reproducibility: 0
- Active experiment: EXP-001B — Prueba de diagnóstico con usuario real
- Mission: MISSION-001 — Conseguir el primer usuario real para NEXIA Care
- Human Gate: recruit 1 real participant with compatible De'Longhi Magnifica
- External contact: requires human action with current capabilities
- Current spend: €0
- Weekly budget ceiling: €100
- Reserved: €7.25

## PUBLIC INTERFACES

- Product/interface name: NexaCare
- Command centre name: NexaHQ
- Clean public routes have been added to the repository as /NexaCare/ and /NexaHQ/.
- Historical Git commits explicitly record: "feat: brand NexaCare interface", "feat: brand NexaHQ interface", "feat: add clean NexaCare interface route", and "feat: add NexaHQ public route".
- Do not claim a custom domain or removal of the GitHub account/repository name from the host URL unless verified separately. GitHub Pages hosting identity is a separate layer from the route/path identity.

## CONTINUITY RULE

A chat is a replaceable terminal. GitHub persistent state is the source of truth. Losing, changing, or starting a new chat must not erase NEXIA state, decisions, experiments, economics, or architecture.

## RESPONSE CONTRACT

Always distinguish HECHO VERIFICADO / ESTIMACIÓN / HIPÓTESIS / RECOMENDACIÓN. Never claim background work, deployment, external contact, revenue, or automation unless verified.

## NEXT PRIORITY

Continue zero-cost acquisition/validation work for EXP-001B. The bottleneck is real-world user evidence, not more UI architecture.


## PERSISTENCE SAFETY — 2026-10-05

- Canonical operational state: NEXIA_STATE.json (version 24 at checkpoint installation).
- Startup index: NEXIA_BOOT.json.
- Append-only critical history: NEXIA_EVENT_LOG.jsonl.
- Transaction contract: NEXIA_PERSISTENCE_PROTOCOL.md.
- Portable backup: NEXIA_MASTER_BACKUP.md; it must never override a newer verified STATE.
- Recovery rule: if artifacts disagree, prefer the newest verified STATE and reconcile stale artifacts before resuming work.

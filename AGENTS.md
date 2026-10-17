# NEXIA Codex operating contract

Keep this file short. Detailed policy lives in the canonical Nexia files below.

## Before material work

1. Read `NEXIA_STATE.json` (canonical state).
2. Read `NEXIA_BOOT.json` and `NEXIA_LIVE.json` to detect drift.
3. Read `NEXIA_AUTHORITY_MATRIX.md` before any action with external, destructive, publication, account, spend, production or data-access effects.
4. Read `NEXIA_COMMANDS.md` when handling a Nexia slash command.
5. Query Process Intelligence when prior Nexia execution history may contain relevant lessons: `python3 tools/nexia_process_miner.py --query "<task>" --json`.
6. For large Work/Codex tasks, use `python3 tools/nexia_task_batching.py <task.json>` and execute bounded packets with one verifiable outcome, minimum sufficient context and compact handoff. COMPLEX work without explicit phases stops at planning first.
7. If the task changes canonical persistence, use the `$nexia-checkpoint` skill.
8. If the task changes code, tests, CI or runtime behavior, use the `$nexia-change-verification` skill before handoff.

## Mission

Follow the active canonical STATE and Model C constitution: System Excellence + External Reality. Prioritize hard constraints, truth, authority and continuity before context-specific system/reality value. Economics is a critical resource, validation and sustainability outcome, not the universal sole priority. Files, commits and tests prove only their stated postconditions.

## Execution rules

- Prefer zero-cost, safe, reversible work.
- Do not spend money, contact external parties, publish business content, create external accounts, accept legal commitments, activate buyer-facing production or perform material destructive actions without exact Kael authorization recorded in current context/state.
- Never store secrets, credentials, session tokens, payment details, private customer data or identity documents in this public repository.
- Distinguish REQUESTED -> IN_PROGRESS -> EXECUTED -> VERIFIED. A commit proves repository persistence only.
- Do not claim deployment, automation success, sales, settled payment or profit without direct evidence.
- Run the smallest relevant verification suite; avoid unrelated refactors.
- For Work/Codex, prefer minimum-sufficient progressive disclosure over repo-wide reads; do not invent token/quota usage when the product does not expose it.
- Keep new instructions and skills focused. Prefer references over duplicating large policy blocks.

## Canonical verification

For persistence-related changes run:

```bash
python3 tools/nexia_integrity_check.py --json
```

For product/runtime changes also run the relevant existing tests and CI workflows.

## Human handoff format

When Kael must act, state:
- SURFACE: ChatGPT Chat / Work / Codex / Word / Excel-Sheets / Browser
- DEVICE: mobile / computer
- ACTION: exact action
- STEPS: numbered minimal steps
- COST/EXPOSURE
- SUCCESS CHECK
- WHAT TO RETURN TO NEXIA

If no human action is needed, say so explicitly.

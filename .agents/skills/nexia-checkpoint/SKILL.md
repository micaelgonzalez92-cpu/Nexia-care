---
name: nexia-checkpoint
description: Use when reconciling or persisting NEXIA canonical state, BOOT, LIVE, event index, immutable events, or continuity checkpoints. Ensures evidence-safe atomic state handling and prevents false persistence claims.
---

# Nexia checkpoint

Use this workflow only when operational meaning changed enough to justify a canonical checkpoint.

## Read first

- `NEXIA_STATE.json`
- `NEXIA_BOOT.json`
- `NEXIA_LIVE.json`
- `NEXIA_EVENT_INDEX.json`
- newest relevant immutable event in `events/`
- `NEXIA_AUTHORITY_MATRIX.md`
- `NEXIA_PERSISTENCE_PROTOCOL.md` when present

## Rules

1. `NEXIA_STATE.json` is canonical. LIVE and BOOT are derived/bound artifacts.
2. Never rewrite an immutable event. Corrections create a new event.
3. Do not promote economic stage because code/tests/files changed.
4. Preserve explicit authority, budget and Human Gates exactly unless Kael changed them.
5. Unknown stays UNKNOWN/NOT_INSTRUMENTED.
6. No secret/private data may enter this public repository.
7. Prefer one coherent checkpoint over a sequence of partially synchronized writes.

## Procedure

1. Identify the exact verified delta since the current STATE.
2. Decide whether it changes operational meaning. If not, keep it in EVENT/LIVE and do not bump STATE merely for activity.
3. If it does, prepare the next STATE version and derived BOOT/LIVE metadata.
4. Bind current event-index/latest-event references.
5. Preserve economics truth: revenue, settled revenue, contribution and profit must remain unchanged unless transaction evidence exists.
6. Run:

```bash
python3 tools/nexia_integrity_check.py --json
```

7. Treat exit code 1 as failure. Treat warnings as explicit unresolved debt, not success.
8. Commit coherent files together when technically possible.
9. Re-read changed files or inspect the resulting commit before saying VERIFIED.

## Handoff

Report:
- STATE version before -> after
- exact verified operational delta
- immutable event ID
- integrity result
- cost/economic impact
- unresolved warnings/blockers
- what was NOT proven

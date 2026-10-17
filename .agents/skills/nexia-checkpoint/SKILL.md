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
7. A critical checkpoint must be prepared as one complete candidate and promoted as one commit/ref transition; do not persist STATE/BOOT/LIVE/index/event bindings through a sequence of independent remote file writes.
8. `--allow-main` in the atomic helper is only a technical interlock bypass after the required promotion authority exists; it never grants that authority.

## Procedure

1. Identify the exact verified delta since the current STATE.
2. Decide whether it changes operational meaning. If not, keep it in EVENT/LIVE and do not bump STATE merely for activity.
3. If it does, prepare the complete candidate overlay containing every checkpoint file that must change together.
4. Bind current event-index/latest-event references and preserve economics truth: revenue, settled revenue, contribution and profit stay unchanged unless transaction evidence exists.
5. Record the exact expected branch HEAD before candidate creation.
6. Prepare/validate with the atomic helper when available:

```bash
python3 tools/nexia_atomic_checkpoint.py \
  --candidate-dir <candidate-dir> \
  --branch <target-branch> \
  --expected-head <40-char-sha> \
  --message "<checkpoint message>" \
  --require-path NEXIA_BOOT.json \
  --require-path NEXIA_LIVE.json
```

Add further `--require-path` entries for every file that the checkpoint contract requires. Prepare-only mode must not mutate the remote.

7. Treat helper `FAILED_*`/`BLOCKED_*` states as failure. Treat integrity warnings as explicit unresolved debt, not success.
8. Only when authority permits the target branch write, repeat with `--push`; `main` additionally requires the explicit technical `--allow-main` interlock.
9. Require `PERSISTED_VERIFIED` plus remote ref/file readback before saying persistence is VERIFIED.
10. A successful checkpoint proves repository persistence/integrity only; it does not prove deployment, production behavior, publication, demand, payment or profit.

## Handoff

Report:
- STATE version before -> after
- exact verified operational delta
- immutable event ID
- expected HEAD -> resulting commit
- integrity/readback result
- cost/economic impact
- unresolved warnings/blockers
- what was NOT proven

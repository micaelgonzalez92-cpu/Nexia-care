# NEXIA CORE — PERSISTENCE & CHECKPOINT PROTOCOL

Status: ACTIVE
Effective: 2026-10-05
Cost: €0

## Canonical hierarchy
1. NEXIA_STATE.json — canonical operational state.
2. NEXIA_LIVE.json — current execution visibility; never overrides STATE.
3. NEXIA_MEMORY.md — learning/experiment ledger.
4. NEXIA_EVENT_LOG.jsonl — append-only critical change history.
5. NEXIA_MASTER_BACKUP.md — generated/portable recovery representation.
6. NEXIA_BOOT.json — minimal startup index; never an independent source of truth.
7. Other documentation and chat — context only.

## Transaction rule
A critical operational change is not considered complete until:
OBSERVE → EXECUTE → VERIFY → CHECKPOINT → BACKUP.

Never mark work complete merely because a write was requested.

## Checkpoint contents
Every critical checkpoint must identify:
- timestamp
- action
- previous state version/commit
- resulting state version/commit
- evidence
- actor/capability
- human gate status
- financial impact
- rollback/recovery reference

## Append-only event log
NEXIA_EVENT_LOG.jsonl records critical transitions as immutable lines. Do not rewrite historical events. If a correction is required, append a corrective event referencing the previous event.

## Integrity
Every STATE checkpoint should expose:
- version
- updated_at
- previous_state_version
- previous_state_commit
- state_blob_sha
- backup_sync_status
- event_log_last_event
- checkpoint_status

A mismatch means the newest verified STATE remains authoritative and the stale artifact must be regenerated.

## Backup rule
MASTER_BACKUP must never be treated as a separately edited source of truth. It is a portable snapshot derived from STATE + MEMORY + verified repository facts. If stale, regenerate it; do not let it overwrite newer STATE.

## Recovery
On startup:
1. Read NEXIA_BOOT.json.
2. Read NEXIA_STATE.json.
3. Compare versions/hashes.
4. Inspect recent commits.
5. If artifacts disagree, prefer the newest verified canonical STATE.
6. Rebuild stale BOOT/LIVE/BACKUP metadata.
7. Resume the active mission; do not restart experiments.

## Failure safety
If any write fails after a critical action:
- do not claim completion;
- preserve the previous known-good state;
- append an event describing the failure when possible;
- retry only after re-reading current repository state;
- never force-overwrite a newer branch head.

## Human gates
Persistence changes do not grant business authorization. Spending, external contact, irreversible publication/deletion, and material risk remain Kael-controlled.

## Recovery test
A fresh session must be able to identify phase, mission, experiment, financial guardrails, Human Gate, last confirmed action and next safe action using BOOT + STATE alone.

## Definition of done
The persistence layer is healthy only when BOOT, STATE, LIVE, EVENT_LOG and MASTER_BACKUP are mutually consistent enough to reconstruct the same operational state, with STATE as canonical authority.

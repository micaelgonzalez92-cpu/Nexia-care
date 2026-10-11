# NEXIA CORE — PERSISTENCE & CHECKPOINT PROTOCOL

Status: ACTIVE
Protocol version: 2.0
Effective: 2026-10-11
Cost: €0

## Canonical hierarchy
1. `NEXIA_STATE.json` — canonical operational state.
2. `NEXIA_LIVE.json` — current execution visibility; never overrides STATE.
3. `NEXIA_MEMORY.md` — learning ledger; never overrides STATE.
4. `events/*.json` — immutable event files for new critical transitions.
5. `NEXIA_EVENT_LOG.jsonl` — legacy historical event ledger; READ-ONLY after Event Storage v2 activation.
6. `NEXIA_EVENT_INDEX.json` — derived index of immutable event files; may be regenerated.
7. `NEXIA_MASTER_BACKUP.md` — portable recovery representation derived from verified facts.
8. `NEXIA_BOOT.json` — startup index; never an independent source of truth.
9. Other documentation/chat — context only.

## Why Event Storage v2 exists
The current GitHub connector safely creates new files and replaces known files, but exposes no native append primitive. Replacing the complete historical JSONL merely to append one line creates unnecessary corruption/truncation risk.

Therefore:
- legacy `NEXIA_EVENT_LOG.jsonl` is frozen read-only at its last verified blob;
- every new critical event is written as a new immutable JSON file under `events/`;
- the derived event index points to those files and the legacy boundary;
- creating a new event file is the append operation.

This preserves append-only semantics without rewriting history.

## Immutable event-file schema
Each `events/<EVENT_ID>.json` should include:
- `event_id`;
- `timestamp`;
- `type`;
- `action`;
- `state_version` and `state_blob_sha` when applicable;
- `previous_state_version` when applicable;
- evidence/hashes;
- actor/capability;
- financial impact;
- Human Gate / authority effect;
- result;
- recovery reference;
- truth limitations.

Event files are never edited after verified creation. If correction is needed, create a new corrective event referencing the prior event.

## Transaction rule
A critical operational change follows:
`OBSERVE → EXECUTE → VERIFY → CHECKPOINT → BACKUP`.

Only VERIFIED work is complete. A commit proves persistence, not deployment, buyer acceptance or economic impact.

## Checkpoint contents
Every critical checkpoint identifies:
- timestamp;
- action;
- previous/current state version where applicable;
- evidence and hashes;
- actor/capability;
- Human Gate/authority status;
- financial impact;
- rollback/recovery reference.

## Integrity
A current recovery checkpoint should expose:
- canonical STATE version/blob;
- BOOT state version/blob match;
- LIVE operational phase match;
- MEMORY current canonical notice;
- current BACKUP state version;
- latest immutable event ID/path;
- legacy event-log boundary SHA;
- checkpoint/readback status.

A mismatch means the newest verified canonical STATE remains authoritative and stale derived artifacts must be regenerated.

## Backup rule
MASTER_BACKUP is generated from STATE + MEMORY + verified repository facts. It never overrides STATE. Git history preserves older backups; current backup should emphasize current recovery state rather than accumulate unlimited stale snapshots.

## Recovery
On startup:
1. Read `NEXIA_BOOT.json`.
2. Read `NEXIA_STATE.json`; compare version/hash with BOOT.
3. Read current `NEXIA_MEMORY.md` when learning context is needed.
4. Read `NEXIA_EVENT_INDEX.json`; if present, inspect the latest relevant immutable event file.
5. Treat `NEXIA_EVENT_LOG.jsonl` as historical events before the v2 boundary.
6. Read MASTER_BACKUP when additional recovery context is required.
7. Reconcile stale derived artifacts.
8. Resume current mission; do not restart discarded work.

## Failure safety
If any write fails:
- do not claim completion;
- preserve last known-good canonical STATE;
- re-read before retry;
- never force-overwrite a newer blob;
- never rewrite an immutable event file;
- record a corrective/new event when safe capability exists.

## Human gates
Persistence changes never grant business authorization. Spending, external contact, publication, irreversible deletion and material risk remain Kael-controlled.

## Recovery test
A fresh session should identify from BOOT + STATE, with event/memory context as needed:
- mission;
- active experiment;
- current commercial stage;
- economics/guardrails;
- Human Gate;
- active blockers;
- last verified material action;
- next safe action;
- what is authorized versus merely available.

## Definition of done
Persistence is healthy when current STATE/BOOT/LIVE/MEMORY/BACKUP agree on the operational state and the latest critical transition is durably represented either in the frozen legacy JSONL or an immutable v2 event file. Derived indexes may lag temporarily but must never override STATE.

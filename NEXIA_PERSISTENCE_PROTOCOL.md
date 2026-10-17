# NEXIA CORE — PERSISTENCE & CHECKPOINT PROTOCOL

Status: ACTIVE
Protocol version: 2.2
Effective: 2026-10-17
Cost: €0

## Canonical hierarchy
1. `NEXIA_STATE.json` — canonical operational state.
2. `NEXIA_LIVE.json` — current execution visibility and exact session handoff; never overrides STATE.
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

### Atomic canonical checkpoint rule
A checkpoint that changes canonical bindings must be prepared and promoted as one complete Git transaction:

`READ EXPECTED HEAD → BUILD COMPLETE CANDIDATE → VALIDATE CANDIDATE → CREATE ONE COMMIT → NON-FORCE REF UPDATE → REMOTE READBACK → POSTCONDITIONS`.

Requirements:
- bind the transaction to an explicit expected HEAD SHA;
- assemble every STATE/BOOT/LIVE/index/event binding that must change together before remote mutation;
- run the integrity validator against the complete candidate before promotion;
- use an ordinary fast-forward/non-force update only;
- fail closed if the branch head changed;
- reject unsafe candidate paths, Git metadata overlays and incomplete required candidates;
- require remote ref plus candidate-file readback before declaring `PERSISTED_VERIFIED`;
- never interpret a successful Git checkpoint as deployment, runtime success, customer acceptance, payment, demand or profit;
- rollback by a new forward commit restoring a known-good tree unless a different recovery action is explicitly authorized.

`tools/nexia_atomic_checkpoint.py` is the repository helper for this transaction when available. Prepare-only mode is preferred before any remote write. Its `--allow-main` flag is a technical interlock only and never grants authority to modify `main`.

Independent per-file remote writes may still be used for non-critical documentation or derived artifacts when they cannot create an inconsistent canonical checkpoint. They must not be used as the persistence mechanism for a critical multi-file canonical transition.

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

## Exact session handoff rule
Every material chat/session that ends, reaches a context limit, changes execution surface, or leaves a pending Kael action must preserve an exact resume anchor in `NEXIA_LIVE.json`.

The resume anchor must contain at least:
- `last_completed_verified_action` — the last action that actually happened and was verified;
- `last_user_facing_handoff` — the exact pending task/status communicated to Kael;
- `human_action_required_now` — true/false;
- `pending_human_action` — exact bounded action or null;
- `surface` and `device` when human action exists;
- `success_check` and `return_to_nexia` when human action exists;
- `resume_required_reads` — the specific repository artifacts needed to reconstruct the decision, not merely broad state;
- `resume_from` — the exact next operational point;
- `truth_limit` — what must not be inferred from the handoff.

A conversation transcript is not the persistence layer. If a material decision/task exists only in chat and is not represented in canonical/derived persistence, continuity is NOT VERIFIED.

`NEXIA_LIVE.json` may describe a newer verified execution delta than the last canonical STATE. Such a delta does not override STATE economics/authority, but it MUST be read before declaring the current Human Gate or next action.

## Integrity
A current recovery checkpoint should expose:
- canonical STATE version/blob;
- BOOT state version/blob match;
- LIVE operational phase and exact session handoff;
- MEMORY current canonical notice;
- current BACKUP state version;
- latest immutable event ID/path;
- legacy event-log boundary SHA;
- checkpoint/readback status.

A mismatch means the newest verified canonical STATE remains authoritative for canonical business state, while verified later LIVE/events must be reconciled before deciding the next action. Stale derived artifacts must be regenerated.

## Backup rule
MASTER_BACKUP is generated from STATE + MEMORY + verified repository facts. It never overrides STATE. Git history preserves older backups; current backup should emphasize current recovery state rather than accumulate unlimited stale snapshots.

## Recovery
On startup, before saying Nexia is fully recovered or selecting the next action:
1. Read `NEXIA_BOOT.json`.
2. Read `NEXIA_STATE.json`; compare version/hash with BOOT.
3. Read `NEXIA_LIVE.json` MANDATORILY. Recover `last_user_facing_handoff`, `human_action_required_now`, `pending_human_action`, `resume_required_reads` and `resume_from`.
4. Read every artifact listed in `NEXIA_LIVE.json.resume_required_reads` that exists and is relevant to the current handoff.
5. Read `NEXIA_EVENT_INDEX.json`; inspect every verified event newer than the STATE checkpoint that can change permissions, capabilities, Human Gates, current execution state or next action—not only the single latest event.
6. Read current `NEXIA_MEMORY.md` when learning context is needed.
7. Treat `NEXIA_EVENT_LOG.jsonl` as historical events before the v2 boundary.
8. Read MASTER_BACKUP when additional recovery context is required.
9. Reconcile stale derived artifacts.
10. Only then declare mission, Human Gate, last verified action and next action. Resume from the exact handoff; do not restart discarded/completed work.

### Recovery precedence for the next action
- STATE remains canonical for mission/economics/authority unless a newer atomic STATE supersedes it.
- Verified immutable events and LIVE may contain later operational facts and handoffs that STATE has not absorbed yet.
- A pending explicit Human Gate in LIVE/event evidence must not be silently replaced by `NO_IMMEDIATE_ACTION_REQUIRED` merely because an older STATE says so.
- If the latest chat handoff conflicts with older derived docs, preserve the latest verified evidence and flag the reconciliation need.
- Never claim `RECOVERY COMPLETE` while `resume_required_reads` remain unread or a material post-STATE event is unexamined.

## Failure safety
If any write fails:
- do not claim completion;
- preserve last known-good canonical STATE;
- re-read before retry;
- never force-overwrite a newer blob;
- never rewrite an immutable event file;
- record a corrective/new event when safe capability exists.

## Human gates
Persistence changes never grant business authorization. Spending, external contact, publication, irreversible deletion and material risk remain Kael-controlled. Promotion to a gated branch or surface must have the authority required by the current authority model; a technical CLI flag is never authority.

## Recovery test
A fresh session should identify from BOOT + STATE + mandatory LIVE + required post-STATE event/context reads:
- mission;
- active experiment;
- current commercial stage;
- economics/guardrails;
- exact current Human Gate;
- active blockers;
- last completed verified action;
- last user-facing handoff;
- exact resume point;
- next safe action;
- what is authorized versus merely available.

PASS requires matching the previous session's actual final handoff, not merely reconstructing the same broad mission.

## Definition of done
Persistence is healthy when current STATE/BOOT/LIVE/MEMORY/BACKUP agree on canonical facts or explicitly declare verified deltas, the latest critical transitions are durably represented, and a fresh session can reproduce the exact pending Human Gate/resume point without needing the prior chat transcript.

# NEXIA — CONTINUITY & RECOVERY LAYER

Updated: 2026-10-05
Status: ACTIVE / SAFE / ZERO-COST

## Purpose

Prevent critical NEXIA work from depending on a single ChatGPT conversation, browser, device, permission session, or optional interface.

## Core rule

No critical state, decision, experiment result, financial value, approval status, or architectural decision may exist only inside a conversation.

The persistent repository is the continuity anchor. ChatGPT, Safari, Chrome, the iPhone app, desktop clients, Floot, and future interfaces are replaceable operating surfaces.

## Source hierarchy

1. NEXIA_STATE.json — current machine-readable operational state.
2. NEXIA_MEMORY.md — persistent learning and experiment ledger.
3. NEXIA_EVENT_LOG.jsonl — append-only critical change history when append capability is available.
4. NEXIA_MASTER_BACKUP.md — portable recovery snapshot.
5. NEXIA_BOOT.json — minimal startup index.
6. NEXIA_DECISION_LOG.md — durable decisions and learning.
7. NEXIA_AUTHORITY_ENGINE.md — action authority and approval policy.
8. NEXIA_SYNC_AND_AUTHORITY_PROTOCOL.md — synchronization/verification contract.
9. NEXIA_HUMAN_GATE_QUEUE_2026-10-05.md — parallel human tasks.
10. NEXIA_COMMANDS.md — human-facing control vocabulary.
11. Application files — executable/public interfaces.
12. Conversation context — temporary working context, never the sole source of truth.

## Session independence

A new ChatGPT conversation must be able to reconstruct NEXIA from the persistent repository without relying on the previous chat transcript.

A different client (iPhone app, Safari, Chrome, desktop) must not create a second independent NEXIA state.

## Permission vs persistence

Permissions are temporary capabilities. Persistence is durable project state.

A failed, expired, denied, or unavailable permission must never erase already completed work.

Every externally consequential action should leave a durable record when the capability permits it.

## Authority model

Every action is classified before execution:
- GREEN — safe autonomous action.
- YELLOW — prepare and require explicit Kael approval.
- RED — human-controlled financial, irreversible, credential, legal/security or material-risk action.

Silence is never approval. A previous approval does not automatically authorize a different action.

## Synchronization model

The target is not impossible literal zero-asynchrony. The target is **zero untracked divergence**.

Critical operations follow:
OBSERVE → PLAN → AUTHORIZE → EXECUTE → VERIFY → CHECKPOINT → LOG → LEARN.

Asynchronous systems must remain explicitly marked REQUESTED/RUNNING/VERIFYING until independent verification exists.

NEXIA_STATE.json remains canonical; derived artifacts cannot silently override it.

## Human Gate

Human approval remains mandatory for:
- spending or commitments;
- external contact;
- irreversible publication or deletion;
- material security changes;
- other actions explicitly requiring Kael's decision.

A permission being available does not equal approval for the underlying business action.

## Recovery protocol

On entering a new session:
1. Load NEXIA_STATE.json.
2. Load NEXIA_MEMORY.md when context is needed.
3. Check MASTER_BACKUP for continuity and known limitations.
4. Inspect recent repository changes before making assumptions.
5. Resume the current mission rather than restarting research.
6. Reconcile stale automation/interface claims against verified state.
7. Check authority/gate status before external actions.
8. Report only confirmed execution.

## Automatic ChatGPT bootstrap route — ADDED 2026-10-05

When the GitHub connector is available, ChatGPT should treat the following repository as the first persistence lookup for every new NEXIA session:

- Repository: micaelgonzalez92-cpu/Nexia-care
- Canonical state: NEXIA_STATE.json
- Startup index: NEXIA_BOOT.json
- Learning ledger: NEXIA_MEMORY.md
- Recovery snapshot: NEXIA_MASTER_BACKUP.md
- Critical history: NEXIA_EVENT_LOG.jsonl
- Continuity contract: NEXIA_CONTINUITY.md

Startup sequence:
1. Inspect the repository connection/capability.
2. Read NEXIA_BOOT.json.
3. Read NEXIA_STATE.json and verify its version/blob SHA against BOOT.
4. Read NEXIA_MEMORY.md and recent event/decision information when required to resume safely.
5. Identify mission, active experiment, Human Gate, blockers, last confirmed action and next safe action.
6. Execute GREEN actions immediately.
7. Surface YELLOW/RED actions as explicit TAREAS DE KAEL.
8. Never ask Kael to restate state that is already present in the repository.
9. If the GitHub connector is unavailable, explicitly report the capability limitation; do not claim state recovery.
10. If the repository is reachable but STATE is missing/invalid, recover only from the latest verified repository commit/backup according to the persistence protocol.

This section is an operational contract for persistence. It does not grant external authorization and does not imply background execution.

## Interface independence

Floot is an optional interface layer. Its disappearance must not block NEXIA Core.

Current verified state: Floot project is NOT recovered in the current accessible context. Do not claim that a Floot project, app, backend, or connection exists until independently verified.

## Change logging

Safe architecture changes should be committed to GitHub. The commit itself is evidence that the persistent layer changed; it is not evidence that an external runtime deployed successfully.

## Recovery test

A continuity layer is considered operational only when a fresh session can:
- identify the current mission;
- identify the active experiment;
- recover financial guardrails;
- identify Human Gate blockers;
- distinguish facts from hypotheses;
- avoid repeating discarded work;
- identify the next safe action;
- identify what is authorized versus merely available;
- distinguish requested asynchronous work from verified completion.

## Known current limitations

- Telemetry and notifications are not connected.
- Scheduled automation is partial, not continuous background thought.
- External browser operations require authorized integration/profile.
- The current TinyFish profile exists but authentication is still pending.
- Public deployment requires current verification.
- Real-world user evidence still requires human participation.
- The event log is append-only by design; a previous attempted append was blocked by tool security, so Nexia must not claim a new event-log checkpoint unless the append is actually verified.

## Design principle

NEXIA should survive the loss of a chat, browser, device, permission session, or optional frontend without losing its operational memory.

## Transactional persistence — 2026-10-05

NEXIA uses NEXIA_STATE.json as the canonical operational source, with NEXIA_BOOT.json as a minimal startup index, NEXIA_EVENT_LOG.jsonl as an append-only critical-event ledger, and NEXIA_PERSISTENCE_PROTOCOL.md as the transaction/recovery contract. Critical changes follow OBSERVE → EXECUTE → VERIFY → CHECKPOINT → BACKUP. A stale backup must never override a newer verified STATE.

## Authority and synchronization layer — 2026-10-05

Added:
- NEXIA_AUTHORITY_ENGINE.md
- NEXIA_SYNC_AND_AUTHORITY_PROTOCOL.md
- NEXIA_DECISION_LOG.md
- NEXIA_HUMAN_GATE_QUEUE_2026-10-05.md

These documents establish centralized action classification, Human Gate handling, decision persistence, parallel human tasks, and explicit synchronization/verification states.

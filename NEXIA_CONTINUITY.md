# NEXIA — CONTINUITY & RECOVERY LAYER

Updated: 2026-10-04
Status: ACTIVE / SAFE / ZERO-COST

## Purpose

Prevent critical NEXIA work from depending on a single ChatGPT conversation, browser, device, permission session, or optional interface such as Floot.

## Core rule

No critical state, decision, experiment result, financial value, approval status, or architectural decision may exist only inside a conversation.

The persistent repository is the continuity anchor. ChatGPT, Safari, Chrome, the iPhone app, desktop clients, Floot, and future interfaces are replaceable operating surfaces.

## Source hierarchy

1. NEXIA_STATE.json — current machine-readable operational state.
2. NEXIA_MEMORY.md — persistent learning and experiment ledger.
3. NEXIA_MASTER_BACKUP.md — portable recovery snapshot.
4. NEXIA_COMMANDS.md — human-facing control vocabulary.
5. Application files — executable/public interfaces.
6. Conversation context — temporary working context, never the sole source of truth.

## Session independence

A new ChatGPT conversation must be able to reconstruct NEXIA from the persistent repository without relying on the previous chat transcript.

A different client (iPhone app, Safari, Chrome, desktop) must not create a second independent NEXIA state.

## Permission vs persistence

Permissions are temporary capabilities. Persistence is durable project state.

A failed, expired, denied, or unavailable permission must never erase already completed work.

Every externally consequential action should leave a durable record when the capability permits it.

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
6. Reconcile any stale automation/interface claims against verified state.
7. Report only confirmed execution.

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
- identify the next safe action.

## Known current limitation

Telemetry and notifications are not connected. Scheduled automation is partial, not continuous background thought. Public deployment requires current verification. Real-world user evidence still requires human participation.

## Design principle

NEXIA should survive the loss of a chat, browser, device, permission session, or optional frontend without losing its operational memory.

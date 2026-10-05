# NEXIA SYNC & AUTHORITY PROTOCOL

## Objective
Make NEXIA operationally synchronized as far as the available tools allow, without pretending asynchronous systems are synchronous.

## Core principle
There is one canonical operational truth: NEXIA_STATE.json.

All derived artifacts (BOOT, LIVE, dashboards, backups, reports) are views or recovery artifacts. They never override a newer verified STATE.

## Transaction model
Every critical operation follows:

OBSERVE → PLAN → AUTHORIZE → EXECUTE → VERIFY → CHECKPOINT → PUBLISH/LOG → LEARN.

For safe €0 repository work, AUTHORIZE is satisfied by policy. For external, financial, sensitive or irreversible actions, a Human Gate is mandatory.

## Synchronization guarantees
- Read canonical STATE before critical writes.
- Sequential writes per artifact; never overwrite stale SHA.
- Re-read changed artifacts after writes.
- Record commit/result evidence.
- Detect version/hash drift before reporting completion.
- Derived artifacts must report the STATE version they reflect.
- If synchronization cannot be verified, status = PARTIAL / UNKNOWN, never SYNCHRONIZED.

## What cannot be made synchronous
- Scheduled automations.
- Browser workflows and external websites.
- Third-party processing/delivery.
- GitHub Pages propagation.
- Connector jobs that return asynchronously.

These systems can only be made **eventually consistent with verification**.

## Operational solution
NEXIA should use:
- STATE version + blob SHA as the consistency token.
- Append-only event/checkpoint records where supported.
- Idempotent operations when possible.
- Precondition checks before writes.
- Post-action verification.
- Explicit statuses: PLANNED / AUTHORIZED / RUNNING / VERIFYING / VERIFIED / FAILED / BLOCKED.
- No claim of completion from a requested asynchronous run.

## Single control loop
Control Tower chooses the highest-value safe mission.
Memory Review reconciles state/learning.
Dynamic worker executes the selected safe mission.
Human Gates authorize external/high-risk branches.
All branches report back to canonical STATE when persistence writes are available.

## Goal
Not literal zero latency or zero asynchrony — that is impossible with third-party systems — but **zero untracked divergence**: every meaningful operation should have a known state, owner, status and verification result.

# NEXIA PERSISTENT EXECUTION PLANE

Status: DESIGN / NOT DEPLOYED
Created: 2026-10-06
Priority: MAX

## Purpose

Define the minimum architecture required for NEXIA to operate continuously without requiring Kael to keep ChatGPT open.

This document does not claim that a 24/7 worker currently exists.

## Target architecture

Kael / mobile control
-> authenticated control plane
-> STOP-only Emergency Brake
-> NEXIA Adapter
-> persistent worker
-> NEXIA Core/state
-> decision + research + experiment + economics engines
-> authorized executors
-> verification + checkpoint + audit

ChatGPT is an interface/brain available during active sessions; it is not assumed to be the persistent worker.

## Worker requirements

A future worker must:
- run independently of a ChatGPT conversation;
- recover from STATE/BOOT after restart;
- execute only GREEN work autonomously;
- place YELLOW/RED work into a pending Human Gate;
- checkpoint before/after material state transitions;
- have bounded scope, time, permissions and resource usage;
- fail closed on uncertainty, control-plane loss or unknown material risk;
- never infer approval from silence;
- expose health/last-run/last-checkpoint status;
- support deterministic pause and explicit re-arm.

## Mobile-first human control

The first-priority human control surface must be usable from Kael's mobile device.

Minimum emergency flow:
1. authenticate Kael;
2. press STOP;
3. globally revoke/pause material execution;
4. show explicit confirmation;
5. preserve state;
6. audit trigger and affected paths.

The mobile surface must not contain a START/RESUME shortcut that bypasses explicit re-arm policy.

A second emergency access path is required so loss of the primary phone does not remove the ability to stop the system.

## Device-aware operating policy

- Mobile: status, alerts, approvals and Emergency STOP should be first-class.
- Computer: development, audits, configuration, heavy research and complex operations when materially better suited.
- ChatGPT open: useful interface, not a prerequisite for continuous execution once a real worker exists.
- No device availability may be treated as proof of identity or authorization.

## 24/7 claim standard

NEXIA may only claim 24/7 operation after:
- persistent worker is deployed;
- independent control plane is deployed;
- authentication is verified;
- STOP test passes end-to-end;
- restart/recovery test passes;
- state/checkpoint integrity is verified;
- monitoring/health evidence exists;
- permissions and resource limits are verified.

Until then the status is DESIGN / NOT DEPLOYED.

## Zero-cost build order

1. Map actual execution paths.
2. Define worker contract and job queue boundaries.
3. Define mobile-first control-plane contract.
4. Define independent Emergency STOP.
5. Implement a reversible local/test worker.
6. Run end-to-end STOP and recovery tests.
7. Only then evaluate hosting/runtime options.
8. Do not spend money or connect external accounts without Kael approval.

## Safety invariant

NO BENEFIT -> NO RISK.

A 24/7 worker is not an objective by itself. Continuous execution is justified only when it creates measurable system value while preserving truth, control, recoverability and security.

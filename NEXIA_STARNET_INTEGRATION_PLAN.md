# NEXIA × StarNet — Integration Plan

Status: RESEARCHED / PLAN ONLY — NO RUNTIME CONNECTION
Date: 2026-10-10
Target NEXIA state at inspection: v58, blob SHA `1aaa6cc50782a47072db1ed453d018d4163c6dd5`
NEXIA repository: `micaelgonzalez92-cpu/Nexia-care`
StarNet repository: `androoAGI/starnet`
StarNet branch observed: `feat/harness-backend`
Decision class: GREEN research artifact; no spend, external contact, credentials, publication, or business action.

## 1. Executive decision

Evaluate StarNet as a **bounded execution plane** behind a NEXIA-owned adapter. Do not make StarNet's internal memory, task database, or UI the canonical NEXIA state. Do not attempt a direct GitHub-to-localhost connection: StarNet's sidecar is a local process and is not reachable from a remote GitHub-hosted environment without an explicitly designed, authenticated bridge.

The intended direction is:

NEXIA HQ / client
-> NEXIA Adapter + Governance
-> StarNet local sidecar (authenticated loopback API)
-> bounded agent run / tools / OUTBOX deliverable
-> structured result envelope
-> NEXIA verification
-> canonical STATE + append-only EVENT_LOG + derived artifacts.

StarNet is an execution dependency, not the source of truth. ChatGPT remains an interface, not the system of record.

## 2. Verified baseline

### NEXIA

- Canonical state is `NEXIA_STATE.json`; inspected version is v58.
- `NEXIA_BOOT.json` v16 identifies STATE as canonical and says derived-artifact final readback is pending.
- `NEXIA_PERSISTENCE_PROTOCOL.md` requires OBSERVE -> EXECUTE -> VERIFY -> CHECKPOINT -> BACKUP; the event log is append-only and backups are derived.
- `NEXIA_EXTERNAL_CORE_SPEC.md` defines the adapter/core/governance/executor/verification/persistence separation.
- `NEXIA_AUTOMATION_RESULT_RETURN_CONTRACT.md` says the adapter is not deployed and requires a structured result, evidence, canonical-state reread, and verified persistence before completion claims.
- Current mission is opportunity comparison/falsification. No business contact, purchase, spending, publication, or irreversible action is authorized by this integration research.

### StarNet

- The repository README describes a local-first desktop agent harness with a Node sidecar, per-agent workspaces, bounded permissions, cost/run ledgers, recipes/schedules, MCP connectors and deliverables.
- The inspected default branch is `feat/harness-backend`; documentation itself warns that dated plans/audits can become stale and that current code is the source of truth.
- `docs/HARNESS_ARCHITECTURE.md` describes a validated event contract, capability-gated tool dispatch, budget checks, cancellation and a sidecar bridge.
- `docs/EXECUTION_BACKENDS.md` describes local, Docker Safe Cell, and SSH backends, including their different persistence and isolation guarantees.
- `PRIVACY.md` says transcripts, ledgers and agent memory are stored as plaintext local files; selected credentials have OS-keychain or other storage paths. Some development-mode fallback credential files may be plaintext. Provider prompts/data leave the machine when a cloud model is used.
- API routes require authentication except explicitly exempt routes such as the liveness endpoint. Do not infer that a route is safe to expose just because it listens on localhost.
- The NEXIA GitHub connection has write access to NEXIA; the available StarNet connection is read-only. No StarNet files have been changed.

## 3. Integration boundary

**Additional source finding:** the inspected StarNet revision includes an Agent Client Protocol (ACP) server at `sidecar/acp/serve.js`, which proxies to the running station over authenticated loopback HTTP, streams `/api/run` NDJSON events, and maps permission prompts to client approval/rejection. This makes ACP a serious first candidate for the adapter transport, alongside a narrowly scoped direct HTTP client. Compare both before implementation: ACP may preserve StarNet's consent round-trip better, while direct HTTP may simplify NEXIA-specific task envelopes. Do not scrape `window.__STARNET_API_TOKEN__` as a permanent credential strategy; the source explicitly notes that per-launch tokens can become stale when StarNet restarts. Test supported token injection/refresh behavior and fail closed on expiry.

Create a NEXIA-owned adapter with a narrow, versioned interface. Prefer a same-machine integration using StarNet's documented sidecar API only after confirming the exact route/schema/auth behavior against the current source revision and release build.

Adapter responsibilities:
1. Load a **read-only, minimum-necessary task context** from verified NEXIA STATE and approved artifacts.
2. Apply NEXIA authority rules before dispatch. StarNet tool availability must never be treated as NEXIA authorization.
3. Assign a stable NEXIA action/run ID and an idempotency key.
4. Dispatch only allowlisted task types and capability profiles.
5. Receive a structured event/result stream and preserve raw evidence locally.
6. Produce the NEXIA result envelope below.
7. Verify deliverable paths, run status, costs and any claimed state changes.
8. Request canonical STATE writes only through a separate NEXIA persistence adapter.
9. Read back every write and append a corrective event for errors; never rewrite historical events.

Do not give StarNet direct write access to `NEXIA_STATE.json`, `NEXIA_EVENT_LOG.jsonl`, secrets, payment tools, external messaging, or unrestricted repository operations in the initial pilot.

## 4. Required result envelope

```json
{
  "schema_version": 1,
  "run_id": "stable NEXIA action ID",
  "idempotency_key": "stable key",
  "task_id": "NEXIA task identifier",
  "status": "COMPLETED | BLOCKED | NO_CHANGE | FAILED | UNKNOWN",
  "started_at": "ISO-8601",
  "finished_at": "ISO-8601 or null",
  "starNet_run_id": "provider/runtime run identifier or null",
  "summary": "short factual summary",
  "deliverables": [{"path": "relative outbox path", "sha256": "digest"}],
  "evidence": [{"kind": "event|file|test|log", "ref": "local evidence reference"}],
  "state_change": "YES | NO | UNKNOWN",
  "state_target": null,
  "cost": {"amount": null, "currency": "USD", "status": "VERIFIED | ESTIMATED | UNKNOWN"},
  "external_action": false,
  "human_gate": "NONE | REQUIRED | APPROVED | DENIED",
  "blocker": null,
  "next_action": "one safe next step"
}
```

Missing return evidence means UNKNOWN/UNVERIFIED, not success. Never infer completion from a UI animation, HTTP 200 alone, a scheduled timestamp, or a model's narrative.

## 5. Phased implementation

### Phase 0 — contract and current-code verification (no side effects)
- Pin exact StarNet commit/release and record SHA.
- Read the current API router, auth middleware, run/cancel/status endpoints, event schemas, workspace path jail, cost ledger, cancellation logic and tests.
- Establish how an external local client obtains the API token without scraping frontend state or weakening authentication.
- Confirm the release and supported OS for the target operator machine.
- Exit gate: API/auth/run/cancel/result contracts are grounded in current code, not historical docs.

### Phase 1 — read-only capability probe
- Launch a dedicated StarNet profile/workspace with synthetic data only.
- Probe authenticated health/version and supported read-only status routes.
- Verify bind address is loopback; verify unauthorized requests fail; verify no credentials are emitted in logs/events.
- No provider key, external messaging connector, external write tool, or NEXIA repository write permission.
- Exit gate: security and route contract tests pass; no state mutation possible through the probe.

### Phase 2 — one synthetic bounded run
- Allow one task type only: analyze synthetic opportunity records and write a report to a dedicated OUTBOX/workspace.
- Use a local model or a separately approved provider configuration; account for provider data leaving the machine if cloud models are used.
- Set explicit max cost, iteration/time limits, cancellation test, and no-network tool policy unless the test specifically requires a network.
- Verify output hash, event/run ID, costs, failure/cancel behavior, and repeat-run idempotency.
- Exit gate: success, failure, timeout, cancellation, malformed result and duplicate submission are all tested.

### Phase 3 — NEXIA return adapter (no canonical writes at first)
- Convert StarNet events into the result envelope.
- Validate schema and allowlisted task IDs.
- Store the result as a candidate artifact only; compare it against NEXIA's expected postcondition.
- Keep STATE and EVENT_LOG read-only during this phase.
- Exit gate: all results are observable and independently verifiable; missing results stay UNKNOWN.

### Phase 4 — controlled persistence adapter
- Add a separate NEXIA-owned persistence component with optimistic concurrency against the observed branch head/state hash.
- Apply only approved, minimal, idempotent changes.
- Commit STATE first according to NEXIA's protocol, append a corrective/transition event, reconcile BOOT/LIVE/MEMORY/MASTER_BACKUP as required, and read every artifact back.
- Reject stale hashes, concurrent branch movement, schema mismatch, and unapproved side effects.
- Exit gate: controlled end-to-end write/readback/recovery/rollback tests pass.

### Phase 5 — limited operational use
- Enable only low-risk reversible task profiles.
- Require explicit approval for spending, external contact, publication, credential changes, irreversible operations, and material risk.
- Add an independent STOP path and prove it cancels an active run and prevents re-arm without authorization.
- Treat 24/7 operation as NOT DEPLOYED until worker health, independent stop, restart/recovery and result return are proven.

## 6. Security and reliability gates

- Loopback-only binding; never expose the sidecar publicly or tunnel it without a separate threat model.
- Authenticate every API route according to current StarNet code. Never use the unauthenticated health route as proof of authorization.
- Separate workspaces per task/agent; no direct mount of the NEXIA repository in the first pilot.
- Use least-privilege capability profiles; Docker Safe Cell only after its actual probe and isolation behavior pass.
- Protect plaintext transcripts, agent memory, cost ledgers and deliverables with OS account controls and appropriate filesystem permissions.
- Never place keys in prompts, result envelopes, event payloads, logs, source files, or generated reports.
- Treat model output, retrieved web content, imported memory and skills as untrusted input.
- Enforce run budgets, timeouts, iteration caps, cancellation, duplicate prevention and postcondition verification.
- A successful Git commit proves repository persistence only; it does not prove the runtime integration or business value.

## 7. Acceptance criteria

Integration is NOT complete until all of the following are evidenced:
1. Current StarNet API contract pinned to a commit and covered by tests.
2. NEXIA authority and human gates enforced before tool dispatch.
3. One synthetic task can run, cancel, fail and return a structured result.
4. Duplicate submission does not duplicate side effects.
5. Result evidence and deliverables are independently verifiable.
6. A simulated missing/invalid result remains UNKNOWN.
7. Canonical STATE is unchanged throughout the read-only pilot.
8. A separate persistence pilot passes concurrency, readback, recovery and rollback tests.
9. Spend, network, credentials and external actions remain within the approved boundary.
10. No claim of 24/7 operation or business outcome is made without runtime evidence.

## 8. Immediate next action

Continue zero-cost code inspection on the pinned StarNet revision: locate the live API route table and auth-token lifecycle; verify run/cancel/status response schemas and the current sidecar startup path. Then write adapter contract tests against a fake sidecar before connecting a real instance.

No live connection, installation, credential transfer, external action, spending, runtime test, or canonical NEXIA state change has been performed by this plan.

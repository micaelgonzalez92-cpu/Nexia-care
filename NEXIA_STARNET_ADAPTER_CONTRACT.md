# NEXIA × StarNet — Adapter Contract and First-Pilot Test Matrix

Status: DESIGN / NOT DEPLOYED
Date: 2026-10-10
Branch: research/starnet-integration-plan
Scope: zero-cost, synthetic, read-only-first pilot. No credentials or runtime connection included.

## 1. Decision from source inspection

Do not select ACP as the default NEXIA transport yet. The current StarNet ACP editor bridge documents these constraints:
- StarNet must already be running locally.
- ACP headless execution currently supports OpenRouter plus `STARNET_DEFAULT_MODEL`; other configured providers may not work.
- The bridge reads a per-launch token from the local served page, and the cached token becomes stale after a StarNet restart.
- ACP preserves interactive permission cards, streaming tool events and cancellation well, but it is primarily designed for an ACP-speaking editor.

Source: `docs/ACP_EDITORS.md`, `sidecar/acp/serve.js`, observed at StarNet commit `54899e5ff3f2b002b457757916b3977818db6fc1`.

The OpenAI-compatible API is a stronger first candidate for a NEXIA-owned service adapter because the current documentation exposes:
- a separate bearer key (`STARNET_API_KEY` / `STARNET_V1_KEY`) of at least 16 characters;
- explicit run/status/event/stop routes;
- real HTTP error statuses and typed lifecycle events;
- a structured-output mode for non-streaming responses;
- an `Idempotency-Key` contract for `POST /v1/chat/completions`, with matching requests replaying saved results and conflicts returning 409.

Important constraints:
- `/v1` is disabled unless a sufficiently strong key is configured.
- The API is local-client ingress and has no browser CORS allow-list by default; keep it loopback-only.
- `/v1/runs` creation is explicitly not covered by the documented idempotency reservation mechanism. Do not use it for the first pilot.
- Headless runs use an autonomous surface. Unapproved mutations are default-denied; there is no interactive approval round-trip on `/v1`. Treat this as a hard restriction, not as an inconvenience to bypass.
- A liveness endpoint without auth is not proof of authenticated access.
- Current code and tests must be re-read at the exact commit/release used in the pilot.

Source: `docs/OPENAI_COMPAT.md`, observed at the same commit.

## 2. First-pilot transport

**Candidate:** `POST /v1/chat/completions` with `stream:false`, a fixed allowed model/agent, a strict JSON schema, and an `Idempotency-Key`.

This is only a contract-level choice. It is not permission to install StarNet, configure provider credentials, or launch a live agent. A future local deployment must be explicitly prepared by the operator and use synthetic inputs only.

The adapter must:
1. Bind to a configured loopback endpoint only; reject non-loopback hosts.
2. Load the bearer secret from an OS-protected environment/secret store; never store it in NEXIA STATE, Git, prompts, logs, or result envelopes.
3. Refuse to run if auth is absent, the endpoint is not loopback, or the configured StarNet revision is unpinned.
4. Send only synthetic input and one explicitly allowlisted agent/model.
5. Use a deterministic idempotency key for a stable NEXIA task/run identity.
6. Request schema-constrained JSON with streaming disabled.
7. Parse both HTTP status and the native `starnet.status/completed/partial/failed/error` result extension. HTTP 200 alone is not completion evidence.
8. Classify timeout, transport reset, missing terminal status, malformed JSON, unknown cost, or missing evidence as `UNKNOWN` or `FAILED`, never `COMPLETED`.
9. Save the response and response hash as a candidate artifact only. It must not write canonical STATE or EVENT_LOG.
10. Apply local timeout, response-size limit, no-retry-on-ambiguous-side-effect rule, and a global kill switch.

## 3. NEXIA result envelope

```json
{
  "schema_version": 1,
  "run_id": "stable NEXIA run ID",
  "idempotency_key": "stable deterministic key",
  "task_id": "allowlisted task ID",
  "status": "COMPLETED | BLOCKED | NO_CHANGE | FAILED | UNKNOWN",
  "started_at": "ISO-8601",
  "finished_at": "ISO-8601 or null",
  "transport": "starnet-v1",
  "starNet_revision": "pinned commit SHA",
  "starNet_run_id": "native ID or null",
  "summary": "factual summary",
  "deliverables": [{"path": "relative candidate-outbox path", "sha256": "digest"}],
  "evidence": [{"kind": "http-response|native-status|file|test", "ref": "local evidence reference"}],
  "state_change": "NO | UNKNOWN",
  "cost": {"amount": null, "currency": "USD", "status": "VERIFIED | ESTIMATED | UNKNOWN"},
  "external_action": false,
  "human_gate": "NONE | REQUIRED | APPROVED | DENIED",
  "blocker": null,
  "next_action": "one safe next step"
}
```

The pilot must keep `state_change=NO`. Any attempted mutation is a test failure. Cost must not be converted into EUR without a captured source amount and timestamped exchange-rate source; if no reliable usage data is returned, record UNKNOWN.

## 4. Contract test matrix

All tests run against a fake HTTP server first; no StarNet process, external provider, or paid API required.

| ID | Scenario | Required result |
|---|---|---|
| STN-C01 | Valid schema-conforming completed response | Envelope COMPLETED only if native status and terminal completion evidence agree |
| STN-C02 | HTTP 200 with native `completed:false` | Never COMPLETED |
| STN-C03 | Missing native status / truncated response | UNKNOWN |
| STN-C04 | 401 / 403 auth failure | FAILED/BLOCKED; no token in logs |
| STN-C05 | 429 concurrency cap | BLOCKED/retryable only after explicit safe retry policy |
| STN-C06 | Same key + same payload | One logical result; no duplicate dispatch |
| STN-C07 | Same key + different payload | Conflict; do not silently reuse result |
| STN-C08 | Network timeout after dispatch | UNKNOWN; do not automatically resubmit with a new key |
| STN-C09 | Malformed or schema-invalid JSON | FAILED; never persist as verified result |
| STN-C10 | Unknown/partial provider failure | PARTIAL/FAILED/UNKNOWN; preserve evidence, no success claim |
| STN-C11 | Output contains path traversal / absolute path | Reject deliverable path |
| STN-C12 | Attempted canonical STATE write | Denied; canonical hash unchanged |
| STN-C13 | Non-loopback base URL | Refuse before network request |
| STN-C14 | Secret marker appears in response/log candidate | Redact and fail test |
| STN-C15 | Stop/timeout signal during run | Confirm terminal cancellation or classify UNKNOWN; never claim stopped without evidence |
| STN-C16 | Repeated read-only task after sidecar restart | Reconcile by stable idempotency key; never duplicate uncertain work |
| STN-C17 | Spend/cost absent or contradictory | Cost UNKNOWN; do not invent or approve a budget overrun |
| STN-C18 | Kill switch enabled | No new request dispatched |

## 5. Exit gates

A live synthetic pilot may be considered only after:
- the StarNet commit is pinned and current route/auth/schema behavior is confirmed from source and tests;
- the fake-server contract suite passes;
- loopback, auth, secret-redaction, size and timeout controls pass;
- the allowed agent's tool/capability profile is reviewed and mutations remain unavailable;
- operator configures the local instance explicitly; no credentials are transferred by this plan.

A successful pilot still does not authorize canonical writes. A separate persistence design and explicit approval are required.

## 6. Next action

Implement the fake-server adapter contract tests in a local NEXIA adapter package only after identifying/creating the real code package boundary. This repository currently exposes the NEXIA specification/state artifacts, not an already verified runtime adapter package. Do not place untested runtime code among canonical state artifacts merely to claim implementation progress.

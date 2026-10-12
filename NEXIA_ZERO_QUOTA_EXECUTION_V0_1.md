# NEXIA ZERO-QUOTA EXECUTION v0.1

Status: IMPLEMENTED_ROUTER / PARTIAL_EXECUTION_PLANE
Updated: 2026-10-12
Cash spend: EUR0
Economic result: NONE

## Objective

Reduce dependence on scarce ChatGPT Work/Codex agentic quota without lowering Nexia's authority, verification or safety standards.

## Core principle

Use the cheapest verified executor that can complete a task safely. Executor selection never grants authority.

Routing order:
1. Authority/risk gate.
2. Capability availability.
3. Prefer zero-agentic-quota execution.
4. Fall back to Work/Codex only when a verified local/deterministic path is unavailable.

## Executor classes

- CHAT — strategy, economics, research, reasoning and orchestration.
- GITHUB_ACTIONS — deterministic public/non-secret tests, validation, transforms and CI.
- LOCAL_SCRIPT — deterministic local Python/Node/PowerShell jobs, especially when private/local data is needed.
- LOCAL_GPU — verified local GPU workloads; current verified scope is bounded image generation only.
- LOCAL_AI — future local coding/reasoning model. NOT VERIFIED.
- LOCAL_BROWSER — future Playwright/browser agent path. NOT VERIFIED.
- WORK — scarce fallback for authenticated GUI/browser tasks not yet offloaded.
- CODEX — scarce fallback for complex repository/code work not yet handled by deterministic/local AI routes.
- HUMAN_GATE — external contact, publication, spending, accounts, production activation, destructive/material actions or installation/system change without matching authorization.

## Current routing baseline

| Task type | Route |
|---|---|
| Public research / opportunity scan | CHAT |
| Deterministic tests / validators / transforms without secrets | GITHUB_ACTIONS |
| Deterministic local/private file processing | LOCAL_SCRIPT |
| Bounded image generation with verified ComfyUI stack | LOCAL_GPU |
| Authenticated browser / GUI | WORK until LOCAL_BROWSER is verified |
| Complex new code | CODEX until LOCAL_AI is verified |
| Spend/contact/publish/account/production/install | HUMAN_GATE |

## Current work classification

1. EXP-AUTO-001 market/acquisition research -> CHAT.
2. n8n/product regression and integrity tests -> GITHUB_ACTIONS.
3. UGC-PORTFOLIO-001 Phase A image generation -> LOCAL_GPU when local execution is available; no Work/Codex required for inference itself.
4. Workana authenticated navigation -> WORK for now; candidate for later Playwright/local browser offload.
5. n8n Creator/Gmail review sensing -> existing Chat connector/automation; no Work required for routine email sensing.
6. Repository validation/state consistency -> GitHub Actions + Chat/GitHub connector.
7. New complex engineering -> CODEX only when deterministic GitHub/Chat path is insufficient.

## Instrumentation

Metric: AGENTIC_OFFLOAD_RATE = technical tasks executed without Work/Codex / total technical tasks.

Current value: NOT_INSTRUMENTED. Do not estimate it as a fact.
Target 1: >=50% measured over at least 20 technical task executions.
Target 2: >=75% only after quality/error rate remains acceptable.

Every routed task should eventually record:
- task id
- executor selected
- zero_quota true/false
- outcome PASS/FAIL/BLOCKED
- human minutes
- retries
- Work/Codex quota used if observable
- error/rollback

## v0.1 implemented artifacts

- `tools/nexia_execution_router.py` — pure JSON-to-routing decision function; no execution side effects.
- `tools/test_nexia_execution_router.py` — synthetic safety/routing tests.
- `NEXIA_EXECUTION_CAPABILITIES.json` — verified capability snapshot.
- `NEXIA_EXECUTION_QUEUE.json` — bounded current queue/measurement seed.

## Next capability gates

### Phase 2 — local coding intelligence
Benchmark ONE local coding model on existing Nexia tasks. Candidate stack may use Ollama plus a coding agent, but no installation is authorized by v0.1. Promote LOCAL_AI only if it passes correctness/time/resource gates.

### Phase 3 — deterministic local browser
Prefer Playwright before an AI browser agent. Start public/read-only with disposable profile and allowlist. Authenticated use only after security/logging/recovery gates. Promote LOCAL_BROWSER only after verification.

### Phase 4 — orchestration
Use n8n/events/scheduler to dispatch GREEN tasks to verified executors. Scheduling never broadens authority.

## Security boundaries

- Public GitHub Actions never receives local secrets, cookies, credentials or private customer data.
- No public-repo self-hosted runner attached to Kael's personal PC without a separately designed trust boundary.
- No autonomous authenticated browser/desktop control before sandbox, logs and recovery exist.
- A task routed to HUMAN_GATE cannot be downgraded by `/next`, silence, generic approval or executor availability.

## Truth boundary

This architecture reduces potential agentic quota use; it does not yet prove a measured offload percentage, reduced electricity cost, autonomous operation, sales or profit.

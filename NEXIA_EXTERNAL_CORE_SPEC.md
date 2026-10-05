# NEXIA EXTERNAL CORE SPECIFICATION

Status: ACTIVE / DESIGN BASELINE
Purpose: define the architecture required for NEXIA to remain operationally independent from ChatGPT as its source of truth.

## 1. Principle
ChatGPT is an interface and reasoning surface. The persistent NEXIA Core is the durable memory, governance and operational specification. Replacing the AI/interface must not erase state, decisions, evidence, experiments or authority rules.

## 2. Target architecture
AI/interface -> NEXIA Adapter -> Core API/CLI -> Governance -> Decision / Memory / Experiment / Economics / Evolution engines -> Authorized Executors -> Verification -> Persistence.

## 3. Core layers
- STATE: canonical machine-readable state.
- MEMORY: durable learning and experiment history.
- GOVERNANCE: authority, Human Gates, budget and safety.
- EXECUTION: idempotent action contracts and authorized executors.
- EVOLUTION: instruction review, capability review, regression and improvement.
- OBSERVABILITY: health, telemetry, evidence and audit.
- INTERFACES: ChatGPT, HQ, Care, CLI/API and future clients.

## 4. Execution contract
OBSERVE -> AUTHORIZE -> EXECUTE -> VERIFY -> CHECKPOINT -> LOG -> LEARN.
An action is not complete until the evidence appropriate to its risk exists.

## 5. Authority
GREEN: safe, reversible, zero-cost actions.
YELLOW: prepare only until explicit Kael approval.
RED: financial, credential, irreversible, sensitive, external or material-risk actions require explicit approval.
Never infer authorization from tool availability.

## 6. Canonicality and recovery
NEXIA_STATE.json is canonical until a verified external Core replaces it.
Boot artifacts, backups and live views are derived and cannot override a newer verified STATE.
Recovery must reconstruct mission, experiments, gates, guardrails, recent events, capabilities and next safe action.

## 7. Evolution-first requirement
The external Core must continuously review the whole machine: Core, HQ, Care, QA, dashboards, URLs, connectors, automations, governance, persistence, evidence, economics, security and interface dependencies.
Revenue is a critical outcome, but not the sole objective. The machine must also become more capable, truthful, observable, reproducible, resilient, automated and less dependent on human or interface bottlenecks.
Personal capital is never a substitute for validation. Prefer zero-cost validation; when business-generated revenue exists, reinvestment should be justified by measurable return/capability gain and remains under Kael approval.

## 8. Idempotency / anti-duplication
Every material action should have a stable identity and status. Do not repeat completed work merely because a new session or interface asks again. Retry only after failed verification, changed state or explicit restart.

## 9. Economics
Track revenue, product cost, shipping, VAT, fees, advertising, returns, taxes where applicable, contribution margin and net profit. Distinguish estimates from verified economic results.

## 10. Experiments
Every experiment defines hypothesis, action, cost, metric, success, failure, risk, information gained and stop/rollback condition. Extraction requires real evidence and real economic result plus the required approval.

## 11. Human Gates
A gate must specify exact action, reason, cost, risk, what NEXIA will do after approval and what happens if not approved.

## 12. Migration path
A) strengthen persistent repository governance;
B) expose a read-only Core API/CLI;
C) add verified write operations with authorization and idempotency;
D) connect safe executors and observability;
E) progressively make ChatGPT an interchangeable client rather than the system of record.

## 13. Acceptance criteria for independence
NEXIA is operationally independent when a fresh interface can recover the same canonical state, execute authorized safe actions through the Core, verify and log them, preserve governance, and switch interfaces without loss of operational memory.

## 14. Non-negotiable truth rule
Never claim background execution, automation, permission, connection, revenue, verification or persistence without evidence.

# NEXIA EXP-AUTO-001 — LOCAL HTTP RUNTIME CHECKPOINT — 2026-10-11

Status: EXECUTED LOCALLY / HTTP INTEGRATION 12/12 PASS / NODE-RED FLOW PREPARED NOT RUNTIME-EXECUTED
Cost: €0
External contact: NONE
External account connection: NONE
Commercial validation: NONE

## Objective
Reduce the gap between pure function tests and a real workflow runtime without spending money or claiming platform experience that has not been demonstrated.

## Runtime executed
A local Node.js HTTP runtime was built around the existing EXP-AUTO-001 lead reliability core.

Endpoints:
- `POST /lead`
- `GET /state`
- `POST /reset`

The runtime performs actual HTTP request/response handling on `127.0.0.1`; it does not send email, CRM messages, notifications or data to external services.

## Integration-test result
Node.js v22.16.0 local execution: **12/12 PASS**.

Verified cases:
1. valid JSON POST creates a lead;
2. repeated event ID is idempotently skipped across HTTP requests;
3. normalized email matches an existing record instead of creating a duplicate;
4. missing contact method returns HTTP 422 and does not commit;
5. malformed JSON returns HTTP 400;
6. injected failure immediately before commit returns HTTP 503 and leaves no partial write;
7. local/international phone equivalence is applied only because a country code was explicitly configured;
8. state endpoint exposes record/event/audit counts;
9. unknown route returns 404;
10. reset clears local state;
11. a new event can be created after reset;
12. acknowledgement output remains a draft and is not sent.

This is stronger technical evidence than function-only tests, but it is still synthetic and local. It is not a client deployment.

## Node-RED investigation
Official Node-RED documentation states that Node-RED can run locally, can be installed through npm, uses importable/exportable flow JSON, and supports HTTP In / HTTP Response flows. Node-RED is Apache 2.0 licensed.

Current environment facts:
- Node.js v22.16.0: AVAILABLE;
- npm v10.9.2: AVAILABLE;
- `node-red` command: NOT INSTALLED;
- Docker command: NOT AVAILABLE;
- local `npm view node-red` attempt: TIMED OUT because the container could not reach the registry in the test window.

Interpretation: Node-RED is a suitable zero-license-cost candidate, but installation was not completed in this runtime. Do not report Node-RED runtime execution.

## Node-RED flow prepared
`prototypes/node-red-exp-auto-001-flow.json` is an importable flow design using core node types only:
- POST `/nexia/lead` -> Function -> HTTP Response;
- GET `/nexia/state` -> Function -> HTTP Response;
- POST `/nexia/reset` -> Function -> HTTP Response.

No outbound `http request`, email, websocket, MQTT, TCP or UDP output node is included.

The flow stores only synthetic/local state in Node-RED flow context and returns a draft acknowledgement; it does not send the acknowledgement.

## Static flow validation
`prototypes/validate_node_red_flow.js` executed locally against the flow JSON.

Result: **6/6 PASS**.

Checks:
- unique node IDs;
- all wire references resolve;
- one tab and three HTTP endpoints exist;
- every HTTP In path reaches an HTTP Response;
- no outbound network/message node types are present;
- lead function uses local flow context and contains draft-only acknowledgement wording.

Static validation does not prove that Node-RED itself will accept or execute the flow. Actual Node-RED import/deploy/runtime remains NOT VERIFIED.

## Files
- `prototypes/http_runtime.js`
- `prototypes/test_http_runtime.js`
- `prototypes/node-red-exp-auto-001-flow.json`
- `prototypes/validate_node_red_flow.js`

## Evidence classification
- HECHO VERIFICADO: local HTTP integration tests executed 12/12 PASS.
- HECHO VERIFICADO: Node-RED flow structural validator executed 6/6 PASS.
- HECHO VERIFICADO: npm registry lookup timed out in the current container test.
- HECHO VERIFICADO: Node-RED runtime was not installed or executed here.
- HIPÓTESIS: importing this prepared core-node-only flow into a compatible Node-RED runtime should reduce the remaining platform-specific evidence gap.
- UNKNOWN: behavior after actual Node-RED deploy, persistence characteristics under restart, production CRM integration, buyer willingness to pay, delivery time on client stack, revenue and profit.

## Next gate
1. Do not spend to obtain Node-RED runtime evidence.
2. If a free runtime becomes available, import this flow, execute the same test cases via HTTP and compare results.
3. In parallel continue buyer-initiated opportunity discovery; no need to wait for Node-RED if a truthful, economically viable brief appears.
4. Do not present this work as n8n, Make, GoHighLevel or client production experience.

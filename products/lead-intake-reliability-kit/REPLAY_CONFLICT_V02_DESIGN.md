# Lead Intake Reliability Kit — Replay Conflict V0.2 Design

Date: 2026-10-16
Status: INTERNAL_DESIGN / NOT_RUNTIME_VERIFIED / NOT_PUBLISHED

## Trigger
Fresh competitive evidence shows at least one current free n8n lead-intake implementation explicitly distinguishes an exact duplicate replay from reuse of the same idempotency key with a materially different payload. The current Nexia v0.1 persistent guard blocks an already-seen `eventKey` before it can classify whether the replay is identical or conflicting.

## Current v0.1 truth
`persistent-dedup-guard.json` stores only:
- `eventKey`
- `identityKey`
- `recordId`

Therefore it can prove duplicate blocking, but it cannot reconstruct or compare the original normalized payload and must not claim explicit replay-conflict detection.

## V0.2 candidate contract
For each accepted event, derive and persist:
- `eventKey`
- `identityKey`
- `recordId`
- `payloadHash`

Canonical hash input should include only deterministic normalized fields required for conflict semantics, for example:
`name|email|phone|source|service|message`

Hash algorithm: SHA-256 or equivalent deterministic cryptographic hash available in the implementation surface.

Decision states:
1. `NEW_ACCEPTED` — eventKey unseen and identity policy passes.
2. `EXACT_REPLAY` — eventKey exists and payloadHash matches stored value; do not insert or send.
3. `CONFLICTING_REPLAY` — eventKey exists but payloadHash differs; do not overwrite, do not send, surface for review.
4. `DUPLICATE_IDENTITY` — new eventKey but normalized identity already exists; do not duplicate downstream action.
5. `INVALID` — required event/identity fields missing or malformed.

Every state must retain `autonomous_send=false`.

## Safety rules
- conflicting replay never silently overwrites the first record;
- exact replay is idempotent;
- no external messaging node is added;
- no credentials or real customer data are needed;
- `UNKNOWN/NOT_INSTRUMENTED` is never coerced to a successful state.

## Fixture set required before runtime promotion
- new valid lead;
- exact replay of same event/payload;
- same event ID + changed email;
- same event ID + changed phone/message;
- new event ID + same normalized identity;
- invalid missing event ID;
- invalid missing identity.

## Promotion gate
Do not replace v0.1 until a v0.2 candidate passes:
- static JSON/code checks;
- synthetic decision-table tests;
- n8n runtime test against a clean Data Table;
- persistence test across separate webhook executions;
- restart/reload verification where material;
- zero external sends;
- readback of stored hash/decision evidence.

## Commercial implication
This is a reliability differentiation candidate, not a customer-facing claim yet. The product page must not mention replay-conflict protection until runtime verification passes.

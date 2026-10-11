# NEXIA EXP-AUTO-001 — n8n runtime execution evidence

Date: 2026-10-11
Status: VERIFIED_PASS
Economic effect: NONE VERIFIED
Cost executed: EUR 0
External contact: NONE
Production deployment: NONE

## HECHO VERIFICADO

GitHub Actions workflow `n8n Runtime Smoke`, run `38178359319`, completed with conclusion `success` on commit `78cce66000819e58e100ae1736657d0d9fbfe7f0`.

The run used n8n `2.42.6` and performed both:

1. import/export verification of `prototypes/n8n-huescaventura-intake-demo.json` in an ephemeral n8n database; and
2. real CLI execution inside n8n of `prototypes/n8n-huescaventura-runtime-fixture.json` using workflow id `nexia-exp-auto-001-runtime-fixture`.

The runtime fixture executed these nodes successfully:

- `Manual Trigger`
- `Synthetic Leads`
- `Prepare Lead Review`
- `Assert Runtime Results`

Final assertion output:

```json
{
  "pass": true,
  "cases": 6,
  "runtime": "n8n-code-node",
  "autonomous_send": false
}
```

The six synthetic cases verify at minimum:

- normalized email handling;
- normalized phone handling;
- complete lead routing;
- missing-date detection;
- explicit no-lodging classification;
- ambiguous lodging-negation escalation to manual review;
- company/team-building classification;
- missing `event_id` safe validation failure;
- no autonomous customer message sending.

The GitHub Actions log terminates the execution step with:

`PASS: EXP-AUTO-001 logic executed inside n8n runtime with 6 asserted synthetic cases`

## What this evidence proves

- n8n 2.42.6 can import the current demo workflow.
- n8n can execute the core EXP-AUTO-001 intake/review logic in real Code nodes.
- the tested synthetic cases produce the asserted outcomes.
- the fixture did not require client credentials or external customer messaging.

## What this evidence does NOT prove

- live Airtable/Google Sheets/CRM persistence;
- persistent deduplication or idempotency across separate production executions;
- client credentials or production webhook connectivity;
- production deployment;
- live customer-message delivery;
- client acceptance;
- sales, settled payment, contribution or net profit.

## Remaining technical gate

`PERSISTENT_DEDUP_IDEMPOTENCY = NOT_VERIFIED`

The reference implementation demonstrates deduplication/idempotency with an in-memory store, but the n8n demo still states that persistence must be bound to Airtable/Sheet/DB in the client environment.

Recommended next GREEN test: prove persistent deduplication/idempotency across multiple n8n executions using a zero-cost ephemeral/local n8n-compatible datastore before any live client integration.

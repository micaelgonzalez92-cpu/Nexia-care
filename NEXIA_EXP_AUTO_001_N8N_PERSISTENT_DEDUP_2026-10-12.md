# NEXIA EXP-AUTO-001 — n8n persistent deduplication evidence

Date: 2026-10-12 (Europe/Madrid)
Status: **VERIFIED_PASS_NATIVE_DATA_TABLE**
Economic effect: **NONE VERIFIED**
Cost executed: **EUR 0**
External contact: **NONE**
Production deployment: **NONE**

## HECHO VERIFICADO

GitHub Actions workflow `n8n Runtime Smoke`, run `38180738447`, completed with conclusion `success` on commit `0051aa4c44f7de9f4f24de16de51759be64e1f25`.

The run used n8n `2.42.6` and retained the previously verified gates:

1. import/export of the Huescaventura demo workflow in an ephemeral n8n database; and
2. real n8n runtime execution of the EXP-AUTO-001 intake/review logic with six asserted synthetic cases and `autonomous_send=false`.

The same successful run then exercised persistent deduplication/idempotency using **native n8n Data Tables inside the full `n8n start` server runtime** with the `data-table` module enabled.

## Persistent-dedup proof executed

The proof used three isolated workflows:

- `prototypes/n8n-datatable-dedup-setup.json` — creates the local Data Table `nexia_exp_auto_001_dedup_proof`;
- `prototypes/n8n-datatable-dedup-webhook.json` — normalizes identity, filters already-seen event IDs and identities with Data Table `rowNotExists`, and inserts only genuinely new identities;
- `prototypes/n8n-datatable-dedup-audit.json` — reads the Data Table and asserts the persisted result.

Five separate production-style webhook requests were sent to the local n8n server:

- `p1` / email `Persist@Test.Example` — new identity;
- repeated `p1` / normalized same email — repeated event;
- `p2` / normalized same email — different event, duplicate identity;
- `p3` / phone `+34 600 999 111` — new identity;
- `p4` / same normalized phone — duplicate identity.

The audit required exactly **two persisted unique rows**:

- `event:p1` / `email:persist@test.example` / `lead:p1`;
- `event:p3` / `phone:+34600999111` / `lead:p3`.

The n8n process was then stopped and restarted using the same isolated n8n user/database folder. A sixth request, `p5`, reused `persist@test.example`. A second audit again required exactly **two rows**, proving that the deduplication state survived a process restart and blocked the duplicate identity.

The audit contract also asserts `autonomous_send=false`.

## Negative evidence retained

Before the native Data Table proof, an alternative based on `$getWorkflowStaticData('global')` was tested and **FAILED** this proof: the expected state was not observed across separate webhook executions in that setup. That route is not used as evidence of persistence and is not the selected architecture.

Early Data Table attempts also showed that Data Table helpers were unavailable through the isolated `n8n execute` CLI path. The passing architecture therefore executes Data Table nodes only inside the full n8n server runtime. Those failed attempts are retained as falsification/learning evidence; they are not counted as PASS.

## What this evidence proves

- n8n `2.42.6` executes the current EXP-AUTO-001 intake/review logic in a real n8n runtime;
- native n8n Data Tables can provide persistent event/identity state for this bounded proof;
- repeated event IDs do not create additional rows in the tested workflow;
- different event IDs with the same normalized identity do not create additional rows in the tested workflow;
- persisted deduplication state survives an n8n process restart in the isolated GitHub Actions environment;
- the proof requires no client credentials and performs no customer-message sending.

## What this evidence does NOT prove

- real Airtable, Google Sheets or client CRM integration;
- buyer credentials or buyer production infrastructure;
- production webhook deployment to a customer system;
- concurrency safety under high parallel load;
- long-duration operations or support burden;
- buyer acceptance;
- willingness to pay;
- a contract, settled payment, contribution or net profit.

## Remaining gate

`CLIENT_REAL_DESTINATION_INTEGRATION = NOT_EXECUTED`.

This capability proof strengthens delivery evidence but does **not** advance EXP-AUTO-001 beyond `VETA / PRE-VALIDACION COMERCIAL`. Commercial validation still requires real buyer response and a paid pilot under the existing Human Gate.

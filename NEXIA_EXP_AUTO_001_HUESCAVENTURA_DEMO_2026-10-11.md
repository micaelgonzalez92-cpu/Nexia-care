# NEXIA EXP-AUTO-001 — HUESCAVENTURA-SPECIFIC SYNTHETIC DEMO — 2026-10-11

Status: EXECUTED LOCALLY / 13 OF 13 SYNTHETIC TESTS PASS / NOT CLIENT PRODUCTION
Cost: €0
External contact: NONE
Proposal submission: NOT EXECUTED

## Objective
Strengthen truthful capability evidence for the already-qualified Huescaventura Workana brief while Workana profile moderation remains pending.

## Scope mirrored from the public buyer brief
The synthetic demo models the bounded semiautomatic phase already prepared for Huescaventura:
- classify lead type (despedida, amigos, familia, empresa, escolar, solo actividad, pack con alojamiento, revision);
- detect required missing fields;
- produce an internal summary;
- produce a draft reply only, never autonomous customer sending;
- flag ambiguous classification for human review;
- deduplicate conservatively using email/phone identity keys;
- enforce idempotent event handling;
- retain human decision for follow-up;
- expose a next-step state.

## Test result
Local Node.js execution: **13/13 PASS**.

Verified cases:
1. despedida classification;
2. empresa classification;
3. escolar classification;
4. familia classification;
5. pack con alojamiento classification;
6. unknown/ambiguous input routes to `revision`;
7. `revision` explicitly sets `manual_classification_review`;
8. pack alojamiento requires lodging data;
9. valid lead generates a draft only and autonomous send remains false;
10. repeated event ID is idempotently skipped;
11. repeated normalized email updates the existing record instead of creating a duplicate;
12. missing name/contact blocks processing;
13. missing-field summaries and drafts use business-facing Spanish labels.

## Defect found and repaired before persistence
An intermediate fixture run exposed two presentation/safety issues:
- ambiguous `revision` cases could appear to have no missing data without explicitly signaling that classification itself required review;
- draft replies could expose internal field keys such as `date` instead of Spanish business labels.

Repair:
- added `classification_review_required=true` and `next_step=manual_classification_review` for ambiguous cases;
- mapped internal field keys to Spanish labels such as `fecha` and `número de personas`.

Final suite after repair: **13/13 PASS**.

## Files
- `prototypes/huescaventura_logic.js`
- `prototypes/test_huescaventura_logic.js`

## Evidence classification
- HECHO VERIFICADO: the local synthetic suite executed 13/13 PASS after repair.
- HECHO VERIFICADO: no outbound email, WhatsApp, CRM, Airtable or Workana action occurred.
- HECHO VERIFICADO: the Huescaventura public Workana project remained open/evaluating proposals at the latest web check on 2026-10-11.
- HECHO VERIFICADO: connected Gmail still showed no Workana approval/rejection message at the latest checkpoint.
- HIPÓTESIS: this closer domain-specific demo increases truthful proposal credibility once Workana approval allows submission.
- UNKNOWN: actual n8n/Airtable runtime behavior on buyer infrastructure, buyer acceptance, measured delivery time on real stack, revenue and profit.

## Guardrails
Do not represent this as:
- prior Huescaventura work;
- a client deployment;
- production n8n experience;
- autonomous WhatsApp/email sending;
- buyer acceptance or willingness to pay.

## Next gate
1. Wait for verifiable Workana profile approval evidence without paid moderation.
2. Immediately recheck Huescaventura when approval arrives.
3. If still open, submit the already-authorized €300 bounded proposal manually at zero spend.
4. Continue selective zero-cost buyer-initiated discovery in parallel.

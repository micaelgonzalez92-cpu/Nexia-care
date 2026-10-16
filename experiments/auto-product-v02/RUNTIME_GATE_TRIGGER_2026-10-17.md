# AUTO-PRODUCT V0.2 — bounded n8n runtime gate trigger

Date: 2026-10-17
Authority: GREEN internal verification; EUR0; synthetic data only; no publication or external messaging.

Purpose: trigger the dedicated `n8n Product V0.2 Replay Runtime` workflow after the candidate files were fast-forwarded onto `main` without a normal push event.

Frozen gate for this run:
- n8n 2.42.6 / Node.js 24.21.0 / Ubuntu 24.04;
- candidate remains separate from product v0.1;
- required states: NEW_ACCEPTED, EXACT_REPLAY, CONFLICTING_REPLAY, DUPLICATE_IDENTITY, INVALID;
- payload fingerprint: SHA-256 over deterministic normalized fields;
- native n8n Data Table persistence and readback;
- conflicting replay must not overwrite the original row;
- exact replay must not insert a new row;
- persistence must survive a verified n8n process restart;
- autonomous_send=false in every decision state;
- no outbound action nodes or credentials;
- clean import + runtime smoke target <=30 minutes;
- no commercial claim or publication is authorized by a technical pass.

This file is evidence/control metadata only. It is not a runtime result.

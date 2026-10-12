# VETA-AUTO-PRODUCT-001 — Runtime re-verification

Date: 2026-10-12 (Europe/Madrid)
Classification: HECHO VERIFICADO — isolated internal technical evidence, not commercial validation.

## Final evidence

- Repository/branch: `micaelgonzalez92-cpu/Nexia-care`, `main`.
- Product: `products/lead-intake-reliability-kit/`.
- Workflow: `.github/workflows/n8n-product-runtime-smoke.yml`.
- Tested commit: `ca54ddbc626520a13450aecda6c550d165a42300`.
- Runtime run: [38235228044](https://github.com/micaelgonzalez92-cpu/Nexia-care/actions/runs/38235228044).
- Runtime job: `114764135662`.
- Runtime: n8n `2.42.6`, Node.js `24.21.0`, Ubuntu `24.04`, native n8n Data Table.
- Final result: **SUCCESS — FULL RUNTIME GATE VERIFIED**.
- The four product workflow JSON files and samples are unchanged from the preceding product proof. The correction changes the CI test lifecycle/readiness only.

## Why the earlier green run was insufficient

At recovery, main was `af5beb29d4ad79f14e5e038848e38732ff99fc30`, STATE69/BOOT44. The latest product run was [38233861773](https://github.com/micaelgonzalez92-cpu/Nexia-care/actions/runs/38233861773), tested commit `e8bc85decf2281688e8776b4da15818dcfb2c7a6`, job `114759611429`, GitHub conclusion success.

HECHO VERIFICADO: its stop function killed the npx launcher without asserting server termination. Cleanup found two remaining n8n start processes (PID3471 and PID3588). There was no proof that the health endpoint/port went down, or that a new live process served the post-restart audit.

INFERENCIA: the first server could continue serving requests after the launcher exited. Those logs do not identify the process serving each request, so they cannot support the restart claim. Earlier import/export, valid/invalid-input and sequential dedup results remain useful; the restart claim is superseded by this report and a new corrective event. The earlier immutable event is preserved.

The original [404 run38231949618](https://github.com/micaelgonzalez92-cpu/Nexia-care/actions/runs/38231949618) failed at the initial production-webhook call (curl exit22), after import/export passed.

## Correction and falsification

1. [Commit294bde5](https://github.com/micaelgonzalez92-cpu/Nexia-care/commit/294bde523415c35acefca864568fba4eb62044eb) launches the resolved n8n JavaScript entry point directly with Node. Its PID is checked while starting; stopping requires PID exit, health endpoint down and TCP port closed. Both generations' logs are retained. A read-only audit is performed before any new write after restart.
2. The resulting [run38234612479](https://github.com/micaelgonzalez92-cpu/Nexia-care/actions/runs/38234612479), job114762106353, failed with a real post-restart 404. PID3439 demonstrably stopped; PID3531 started, but the persisted webhook DB rows and /healthz were available before the HTTP routes.
3. [Commitca54ddb](https://github.com/micaelgonzalez92-cpu/Nexia-care/commit/ca54ddbc626520a13450aecda6c550d165a42300) waits for /healthz/readiness. A bounded audit-only retry handles HTTP404, records every such wait and fails on other HTTP/transport errors; output assertions are unchanged. It never repeats the table-bootstrap or dedup writes. Final audit404 waits observed: 0.

HECHO VERIFICADO from the pinned official source: /healthz is installed during server initialization; /webhook routes are installed during server start; readiness additionally requires the server-ready flag and a connected/migrated database. Sources:
- [AbstractServer2.42.6](https://github.com/n8n-io/n8n/blob/n8n%402.42.6/packages/cli/src/abstract-server.ts).
- [Server2.42.6](https://github.com/n8n-io/n8n/blob/n8n%402.42.6/packages/cli/src/server.ts).

## Assertions and observable results

| Gate | Result | Evidence |
|---|---|---|
| Pinned runtime | PASS | Version output2.42.6 |
| Import/export | PASS | Exactly four expected workflow IDs; all inactive by default |
| Registered production webhooks | PASS | Four POST routes recorded before requests |
| Valid lead | PASS | Normalized email/phone; prepared_for_human_review; ok=true |
| Invalid input | PASS | ok=false; validation_failed; missing name/contact; functional rejection, not a claimed HTTP400 |
| Identity dedup | PASS | Different event IDs with the same normalized email leave one row |
| Real stop | PASS | Direct PID exits; /healthz unreachable; TCP5678 closed |
| Real restart | PASS | New direct PID remains alive and readiness succeeds |
| Persistence before any new write | PASS | Exactly the original row is returned by the new server |
| New identity after restart | PASS | Phone-only identity adds exactly one row, total two |
| Final shutdown | PASS | Second direct PID exits and port closes |
| Human-review safety | PASS | Asserted autonomous_send=false |
| Local product QA | PASS | Existing test_product.js executed without product edits |

## Relevant final runtime log

```text
2026-10-12T10:18:41.0552171Z 2.42.6
2026-10-12T10:19:02.8792322Z PASS: all product workflows imported/exported and inactive
2026-10-12T10:19:35.7041856Z Using direct n8n entry point: /home/runner/.npm/_npx/c044e8fe78c51c24/node_modules/n8n/bin/n8n
2026-10-12T10:19:35.7047236Z Started direct n8n process PID=3443
2026-10-12T10:19:41.8386470Z PASS: direct n8n process PID=3443 reached /healthz/readiness
2026-10-12T10:19:41.9481478Z registered webhook: ('nexia-lead-intake-human-review-v01', 'lead-intake-reliability', 'POST')
2026-10-12T10:19:41.9761568Z registered webhook: ('nexia-lead-intake-dedup-bootstrap-v01', 'lead-intake-dedup-bootstrap', 'POST')
2026-10-12T10:19:41.9992851Z registered webhook: ('nexia-lead-intake-dedup-guard-v01', 'lead-intake-dedup-guard', 'POST')
2026-10-12T10:19:42.0232386Z registered webhook: ('nexia-lead-intake-dedup-audit-v01', 'lead-intake-dedup-audit', 'POST')
2026-10-12T10:19:42.4537749Z PASS: valid lead executed through real n8n webhook
2026-10-12T10:19:42.5180234Z PASS: invalid lead rejected through real n8n webhook
2026-10-12T10:19:45.6897776Z {"pass":true,"rows":1,"events":["event:sample-001"],"identities":["email:alex.example@example.com"],"persistence":"n8n-data-table","autonomous_send":false}PASS: audit contains 1 persisted rows
2026-10-12T10:19:45.6930856Z PASS: same normalized identity with different event ID did not create a second row
2026-10-12T10:19:46.7250837Z PASS: direct n8n process PID=3443 exited; health endpoint and TCP port are down
2026-10-12T10:19:46.7253969Z Started direct n8n process PID=3540
2026-10-12T10:19:53.1668016Z PASS: direct n8n process PID=3540 reached /healthz/readiness
2026-10-12T10:19:53.2765034Z registered webhook: ('nexia-lead-intake-human-review-v01', 'lead-intake-reliability', 'POST')
2026-10-12T10:19:53.2984790Z registered webhook: ('nexia-lead-intake-dedup-bootstrap-v01', 'lead-intake-dedup-bootstrap', 'POST')
2026-10-12T10:19:53.3205841Z registered webhook: ('nexia-lead-intake-dedup-guard-v01', 'lead-intake-dedup-guard', 'POST')
2026-10-12T10:19:53.3429972Z registered webhook: ('nexia-lead-intake-dedup-audit-v01', 'lead-intake-dedup-audit', 'POST')
2026-10-12T10:19:53.3467150Z PASS: n8n restarted with a new direct process PID=3540 (previous PID=3443)
2026-10-12T10:19:53.5071302Z {"pass":true,"rows":1,"events":["event:sample-001"],"identities":["email:alex.example@example.com"],"persistence":"n8n-data-table","autonomous_send":false}PASS: audit contains 1 persisted rows
2026-10-12T10:19:53.5102165Z PASS: original Data Table row survived a verified server restart before any new write
2026-10-12T10:19:55.6100453Z {"pass":true,"rows":2,"events":["event:sample-001","event:sample-003"],"identities":["email:alex.example@example.com","phone:+34611222333"],"persistence":"n8n-data-table","autonomous_send":false}PASS: audit contains 2 persisted rows
2026-10-12T10:19:56.6454515Z PASS: direct n8n process PID=3540 exited; health endpoint and TCP port are down
2026-10-12T10:19:56.6455383Z PASS: product Data Table state persisted across n8n process restart
```

## Reproduction

Use the workflow at the tested commit on a clean standard Ubuntu runner (or a matching disposable environment). Run its pinned version step, import/export step and full server-runtime step in order. The file contains exact environment variables, synthetic payloads, assertions and lifecycle controls; its workflow_dispatch entry point permits a separately authorized manual repeat.

The import/export folder and server-runtime folder are separate. The same server user folder/database is reused across the two direct processes. The audit after restart occurs before a new identity is written. n8n workflow publication here activates only the disposable CI server workflows; it is not a Creator submission, storefront publication or external n8n deployment.

## Experiment record

- HIPOTESIS: all product technical gates, including persistence across an actual process restart, are satisfied on n8n2.42.6.
- ACCION: repair the misleading CI lifecycle/readiness test and rerun the complete existing runtime.
- COSTE: EUR0 new cash spend; public standard GitHub Actions runner; no account/tool/credit purchase.
- METRICA / EXITO: every gate in the table passes; one row before restart and before new writes after restart, then exactly two rows after the new identity; autonomous_send=false.
- FRACASO: any failed assertion, unexpected response, process failure or state loss. Failed run38234612479 is retained, not reclassified.
- RIESGO: isolated synthetic data and temporary local CI webhooks; repository changes are reversible via Git history.
- APRENDIZAJE: a green Actions conclusion is only as strong as its assertions. Liveness, readiness, persisted registration and a verified process restart are separate conditions.

## Limits and recovery

No external-user installation, concurrency/load, crash/power-loss recovery, other n8n versions, client credentials, production integration or real customer send was tested. Sequential synthetic dedup does not prove atomic dedup under concurrent requests.

No Creator account/store/payments/analytics was connected. No external n8n production was activated, buyer contacted, proposal sent or commercial product published. The repository already has automatic GitHub Pages builds on main; this task changes no site content or storefront and those builds do not represent a new product launch.

NEXIA_MEMORY.md remains derived/stale at v63 under the existing recorded write restriction and is unchanged. STATE, BOOT, LIVE, the new immutable corrective event/index and backup are reconciled to the new evidence. Canonical version increments once for the material proof correction, not once per run.

No new economic result: registered sales/revenue/realized profit remain zero; NEXIA willingness-to-pay evidence is absent. Traffic, support burden, fees, tax and after-tax unit economics remain UNKNOWN/NOT INSTRUMENTED.

## Commercial decision

The existing validation experiment is reviewed without changing its locked first-cohort USD49 offer or success/failure thresholds. The first prepared free Creator template could test channel acceptance, not willingness to pay. Missing paid-experiment measurement definitions and the stricter tax-reserve condition are recorded in that experiment.

No additional infrastructure is needed now. A future Creator account/submission/publication requires explicit Kael authorization covering only the first FREE template, EUR0 spend and public exposure; paid validation also requires a separate WIP/priority decision. Nothing in this report grants that authority.

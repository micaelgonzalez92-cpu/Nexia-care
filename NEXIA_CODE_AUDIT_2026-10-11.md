# NEXIA CODE AUDIT — 2026-10-11

## Scope
Repository: `micaelgonzalez92-cpu/Nexia-care`, branch `main`.

The recursive repository tree was inspected. Before this audit the executable/static code surface was limited to six HTML files:
- `NexaCare/index.html`
- `NexaHQ/index.html`
- `care/index.html`
- `hq/index.html`
- `prototypes/sme-intake-demo.html`
- `prototypes/sme-intake-test-harness.html`

This audit added one shared JavaScript file:
- `prototypes/sme-intake-core.js`

The remaining repository files are state, logs, protocols, research and operating documentation. They are operationally important but are not executable application code.

## Findings

### F1 — CRITICAL — synthetic harness did not test classification logic
Previous `sme-intake-test-harness.html` classified each case by `c.id` (`T01`, `T02`, etc.) instead of analysing `c.input`. Therefore a PASS only confirmed a hard-coded case-to-answer mapping and could not validate a text classifier.

**Repair:** classification now lives in `sme-intake-core.js`; both demo and harness call the same `classifyRequest(input)` function. Test cases are passed as text inputs.

**Status:** REPAIRED / STATIC READBACK VERIFIED. Browser runtime execution is still NOT VERIFIED.

### F2 — HIGH — demo and tests implemented different logic
The previous demo selected one of three hard-coded result objects while the harness used a separate ID switch. Changes to one could not be detected by the other.

**Repair:** demo and harness now share `sme-intake-core.js`.

**Status:** REPAIRED / STATIC READBACK VERIFIED.

### F3 — HIGH — broken HQ redirects
`NexaHQ/index.html` and `hq/index.html` redirected to `../hq.html`, which was not present in the recursive repository tree.

**Repair:** redirects removed. Both legacy routes now display a noindex retirement notice and explicitly state that they are not live telemetry.

**Status:** REPAIRED / READBACK VERIFIED.

### F4 — HIGH — broken Care redirect and active legacy prototype mismatch
`care/index.html` redirected to the repository root, while the recursive tree contained no root `index.html`. `NexaCare/index.html` still contained the old De’Longhi diagnostic prototype even though canonical state described legacy GitHub Pages surfaces as removed.

**Repair:** both Care legacy routes are neutralized with noindex retirement notices. No old experiment is presented as an active product.

**Status:** REPAIRED / READBACK VERIFIED.

### F5 — HIGH — operational-state drift in `NEXIA_LIVE.json`
The file's top-level state fields pointed to STATE v61 / BOOT v19, while `parallel_work` still referenced successful synchronization of STATE v59 / BOOT v17. This could mislead recovery logic and human operators.

**Repair:** stale historical work items were replaced with current facts. LIVE explicitly states that STATE v61 remains canonical and that the repaired SME harness still lacks browser-runtime evidence. BOOT was advanced to v20 as an index only, without pretending STATE was advanced.

**Status:** REPAIRED / READBACK VERIFIED.

### F6 — HIGH — stale canonical notice in `NEXIA_MEMORY.md`
The first lines say `NEXIA_STATE.json v58 is canonical`, but BOOT and STATE verification point to v61. The same early section also describes NEXIA Care validation as the immediate objective, which is stale relative to the opportunity-engine mission.

**Repair constraint:** `NEXIA_MEMORY.md` is a large append-only learning ledger. It should not be truncated or rewritten from a partial fetch. BOOT v20 and LIVE now explicitly warn that the MEMORY header is stale and that STATE wins.

**Status:** IDENTIFIED / SAFELY CONTAINED / FULL-FILE REWRITE NOT EXECUTED.

## Classifier design after repair
`classifyRequest(input)` is deterministic and conservative:
- empty/very short -> `clarify`
- clear out-of-scope examples -> `out_of_scope`
- urgency with sufficient operational context -> `urgent`
- ambiguous urgency or mixed urgency+quote -> `human_review`
- normal quote request -> `quote`
- verified-info intent -> `info`
- unresolved/default -> `human_review`

The classifier is deliberately not presented as AI. It does not connect to customers, CRM, email or external models.

## Test integrity
The harness contains eight synthetic cases, but no browser runtime has been executed during this audit. Therefore:
- source/readback verification: VERIFIED
- browser execution: NOT VERIFIED
- 8/8 runtime result: NOT CLAIMED
- real-world precision: UNKNOWN
- customer value / willingness to pay: UNKNOWN
- revenue / settled cash / profit: NOT DEMONSTRATED

## Optimization decisions
1. Single source of truth for SME classification logic.
2. Fail-safe default to human review rather than invented certainty.
3. Explicit runtime-not-verified language.
4. No legacy route redirects to missing targets.
5. Legacy surfaces marked `noindex,nofollow` and clearly retired.
6. Canonical state precedence remains STATE > BOOT/LIVE > MEMORY/derived artifacts.
7. BOOT/LIVE carry explicit integrity warnings rather than silently trusting stale MEMORY text.
8. Technical repairs do not change NEXIA economic score.

## Verification pass
Readback completed for:
- `prototypes/sme-intake-core.js`
- `prototypes/sme-intake-demo.html`
- `prototypes/sme-intake-test-harness.html`
- `NexaHQ/index.html`
- `hq/index.html`
- `NexaCare/index.html`
- `care/index.html`
- `NEXIA_BOOT.json`
- `NEXIA_LIVE.json`
- this audit file

## Remaining highest-value technical work
1. Execute the repaired SME harness in a genuinely available zero-cost browser/runtime and capture actual results; do not claim 8/8 before execution.
2. Perform a safe full-file repair of the stale `NEXIA_MEMORY.md` header only when the complete file can be preserved and written atomically.
3. Add a repeatable integrity check that compares STATE version/SHA against BOOT/LIVE and flags stale derived references automatically.
4. Keep business validation separate from technical correctness and continue opportunity selection using evidence/economics gates.

## Cost and authority
Cost: €0.
No purchase, external contact, customer data, account connection or commercial publication was executed as part of this audit.

# NEXIA FLUX IMAGE EDIT — BASE / B1 / B2 PREREG V1

Date: 2026-10-16
Status: PREREGISTERED / NOT_EXECUTED / READY_FOR_BOUNDED_RUNTIME_GATE
Authority: GREEN bounded local experiment. No install, no download, no account, no spend, no publication.

## Why this artifact exists
A Work preflight correctly found that BOOT/LIVE referred to a `preregistered` Base/B1/B2 benchmark but no canonical executable specification contained all literal prompts, inputs, seed and runtime constraints.

This artifact repairs that persistence defect BEFORE any Base/B1/B2 generation occurs.

Truth boundary:
- the three literal prompts below were already defined in the prior Nexia chat before any generation;
- the complete runtime freeze (seed, resolution and execution contract) was NOT previously persisted and is being fixed now, prospectively, before observing any output;
- therefore this is a recovery preregistration, not evidence that a complete earlier prereg artifact existed;
- no historical result is rewritten and no acceptance criterion may be changed after execution begins.

## Objective
Measure two things independently enough to inform the next UGC step:
1. whether the existing local FLUX.2 Klein 4B stack can perform a simple single-reference image edit while preserving one rigid opaque product;
2. whether a structured preservation prompt materially improves adherence versus a generic edit prompt on the exact same source image.

This is NOT a professional-UGC capability test and cannot establish video capability.

## Existing local stack required
Use ONLY the already-present local components:
- ComfyUI 0.39.0;
- `models/diffusion_models/flux-2-klein-4b-fp8.safetensors`;
- `models/text_encoders/qwen_3_4b.safetensors`;
- `models/vae/flux2-vae.safetensors`;
- core image-edit path including `ReferenceLatent` / FLUX.2 Klein image-edit workflow.

If any required component fails to load at runtime: STOP. Do not install, update or download anything.

## Upstream workflow reference
For B1/B2 use the official Comfy-Org FLUX.2 Klein 4B Distilled Image Edit template or a locally saved graph that is demonstrably equivalent in node/model configuration:
`Comfy-Org/workflow_templates/templates/image_flux2_klein_image_edit_4b_distilled.json`

The upstream template explicitly selects the three model files above and exposes a single-reference image-edit graph. The local graph/API prompt actually used must be saved or hashed with the result so equivalence can be audited.

## Frozen execution count
Exactly THREE generations total:
1. BASE: one text-to-image generation;
2. B1: one image-edit generation from BASE;
3. B2: one image-edit generation from the identical BASE.

NO retries, cherry-picking, alternate seeds, hidden warm-up generations or replacement BASE. A load/compile action that does not produce an image is not a generation, but must be logged if material.

## Frozen seed and image size
Seed for BASE, B1 and B2: `20261016`.

BASE requested resolution: `1024 x 1024`.
B1/B2 must use the exact BASE image bytes as their single reference and preserve its native dimensions unless the official workflow necessarily performs an internal deterministic resize; any such resize must be logged and must be identical for B1 and B2.

Rationale for seed: deterministic date-derived constant selected before execution; not selected after observing output.

## Frozen sampler / schedule policy
Use the official/local FLUX.2 Klein 4B Distilled template defaults UNMODIFIED for sampling/scheduling.
Known target defaults from the previously inspected official workflow family are the distilled low-step path (4 steps / CFG 1 / Euler with FLUX.2 scheduler). Do not hand-tune these after seeing output.

Runtime requirement: export or save the actual API prompt/workflow JSON used for BASE, B1 and B2 (or a normalized hash plus the relevant node parameters) so the effective sampler, scheduler, steps and CFG are captured from execution rather than guessed.

If the locally available official template differs materially from the expected defaults, STOP before generation and report the exact difference. Do not silently normalize it.

## BASE — literal prompt
`A single matte dark-blue storage box with a black lid, centered on a light gray tabletop, neutral gray studio background, soft even lighting, realistic product photo, front three-quarter view, clean composition, no hands, no people, no extra objects, no text.`

BASE acceptance precondition for continuing to B1/B2:
- exactly one visually identifiable storage box;
- dark-blue matte body;
- black lid;
- no person/hands;
- no extra product-like object;
- no prominent text.

If BASE fails this precondition, STOP after BASE. Do not reroll. Classify `BASE_PRECONDITION_FAIL`; B1/B2 remain NOT_EXECUTED because the intended controlled input was not obtained.

## B1 — generic edit prompt
Use exact BASE bytes as the only reference.

Literal prompt:
`Change the background to a warm beige interior with a light oak tabletop.`

## B2 — structured preservation prompt
Use the same exact BASE bytes as B1. Same seed and same workflow/settings as B1; only prompt text changes.

Literal prompt:
`Edit the image while preserving the main product exactly: keep one single matte dark-blue storage box with a black lid, preserve its shape, color, size, position, orientation, and proportions. Do not add or remove objects. Do not duplicate the box. Do not change the lid. Only change the environment: replace the neutral gray studio background with a warm beige interior background and a light oak tabletop. Keep the image realistic, clean, and commercially usable.`

## Instrumentation contract
For each executed variant capture:
- exact output path;
- SHA-256 of output image;
- resolution;
- seed;
- effective model filenames;
- effective steps / CFG / sampler / scheduler;
- wall time generation;
- OOM/runtime errors;
- peak process/system RAM if available without changing system configuration;
- peak GPU VRAM if available; label sampled/global GPU usage correctly;
- actual workflow/API-prompt JSON path or SHA-256.

Cost target: EUR 0.

## Frozen QA dimensions
Evaluate B1 and B2 against BASE, not against an imagined ideal image.

Hard dimensions:
1. `OBJECT_COUNT`: exactly one main box remains;
2. `BODY_COLOR`: remains matte dark-blue;
3. `LID`: remains black and recognizably the same lid design;
4. `SHAPE_GEOMETRY`: no material deformation of box/lid;
5. `PROPORTIONS`: product proportions materially preserved;
6. `ORIENTATION`: front three-quarter orientation materially preserved;
7. `POSITION_SCALE`: main product remains approximately centered and similar scale;
8. `NO_DUPLICATION`: no second box/product appears;
9. `NO_UNREQUESTED_PRODUCT_MUTATION`: no new handles, openings, logos, contents or structural parts;
10. `TARGET_ENVIRONMENT`: background becomes warm beige interior and tabletop light oak;
11. `NO_SPURIOUS_TEXT`: no prominent generated typography/watermark;
12. `REALISM`: no obvious severe artifact that makes the image unusable as a product still.

For each dimension label PASS / FAIL / NOT_VERIFIED with a short evidence note.

## Decision logic
`local_flux_image_editing`:
- TECHNICAL_PASS only if at least one edit completes without runtime/OOM failure;
- FIDELITY_PASS for a variant only if dimensions 1-9 all PASS and target environment is materially achieved;
- PROFESSIONAL_CAPABILITY remains NOT_ESTABLISHED regardless of result.

`prompt_engineering_effect`:
- B2 > B1 only if B2 has strictly fewer hard preservation failures (dimensions 1-9) AND achieves the target environment;
- B1 = B2 if hard-failure count is equal or differences are ambiguous;
- B2 < B1 if B2 introduces more hard preservation failures or fails target environment when B1 succeeds.

No subjective score may override the dimension-level comparison.

## Stop rules
STOP immediately and do not retry on:
- OOM or system instability;
- workflow/model load incompatibility;
- BASE precondition failure;
- any need to install/download/update software/model/runtime;
- inability to prove B1 and B2 used identical BASE bytes/settings except prompt.

## Postcondition
After execution, persist a result event containing all measured facts, failed dimensions, limitations and exact artifact hashes. Update INDEX/LIVE/BOOT only after readback. STATE v73 remains unchanged unless a separate material reason exists.

## Next-step rule
If the test passes, increase only one complexity variable in the next preregistered test.
If it fails, trigger TASK-TRIGGERED R&D using Kael corpus first; do not reroll or change model immediately.

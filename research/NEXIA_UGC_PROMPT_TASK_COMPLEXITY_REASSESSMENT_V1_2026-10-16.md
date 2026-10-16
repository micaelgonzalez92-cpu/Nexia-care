# NEXIA UGC PROMPT + TASK COMPLEXITY REASSESSMENT V1 — 2026-10-16

Status: ACTIVE RESEARCH / NO NEW MODEL DOWNLOAD / NO VIDEO MODEL HOPPING

## Trigger
Kael identified a confound in the previous local UGC-video stop decision: the observed FAIL may reflect not only model/hardware limits, but also prompt engineering and an overly difficult first benchmark.

## Evidence boundary
HECHO VERIFICADO:
- The bounded LTX 0.9.8 test completed technically without OOM but failed severe product-integrity and physical-continuity QA.
- The exact generation prompt used in the Work test is not recorded in the canonical close artifacts currently reviewed, so prompt quality cannot be audited from canonical evidence alone.
- Existing local image capability is ComfyUI + FLUX.2 Klein 4B FP8; canonical capability is VERIFIED_BOUNDED_IMAGE_GENERATION, not yet VERIFIED_IMAGE_EDITING.
- Official Black Forest Labs documentation states FLUX.2 Klein 4B supports text-to-image plus single-reference and multi-reference image editing, with the 4B model designed for consumer GPUs.
- Official LTX-Video guidance recommends detailed chronological prompting in one flowing paragraph: start with the main action, specify movements/gestures, object appearance, environment, camera angle/movement, lighting/colors and sudden changes; keep the description literal and precise.

HIPÓTESIS FUERTE:
The first video benchmark combined several difficult constraints at once: transparent/refractive plastic, repeated similar boxes, object-count preservation, interaction/occlusion, physically plausible reversible motion, and product-geometry continuity over time. This makes it a poor first diagnostic for isolating prompt quality versus model capability.

## Revised experimental ladder
Do not reopen model hopping. Reopen only a bounded prompt/task-decomposition R&D path using installed assets first.

### Stage 0 — Prompt audit standard
For every visual generation/edit test, preregister:
- one primary visual objective;
- one object-count contract;
- one geometry-preservation contract;
- one camera instruction maximum;
- explicit background-preservation instruction;
- no unnecessary hands/people/transparency unless that variable is the one being tested;
- seed/settings captured when available;
- exact prompt persisted before generation.

### Stage 1 — Existing FLUX.2 Klein image editing capability gate
Objective: verify whether the already-installed stack can edit one reference image without product mutation.
Test difficulty: LOW.
Scene: one opaque rigid product, simple background, no people, no hands, no transparency, no repeated objects.
Edit: one local change only, e.g. reposition object or change one background element while preserving product identity/shape/count.
No new model/download.
PASS: product geometry/count preserved and requested edit is visible.
FAIL: material mutation, duplication, identity drift, or edit not obeyed.

### Stage 2 — Prompt A/B benchmark on still images
Use the same input/settings and compare:
A. short generic prompt;
B. structured literal prompt with preservation constraints.
Purpose: measure whether prompt engineering materially improves adherence before involving temporal generation.

### Stage 3 — Simple motion benchmark (only after Stage 1/2)
Do not add a video model yet. Prepare the contract only.
When a video runtime is available/authorized, first motion test should use:
- one opaque rigid object;
- no hands/person;
- no transparency;
- fixed camera;
- one direction of motion only;
- no return motion;
- no object creation/removal;
- 2–4 seconds.

### Stage 4 — Add one complexity variable at a time
Only after Stage 3 PASS:
1. repeated objects OR transparency;
2. hand interaction/occlusion;
3. reversible motion;
4. combination.
Never introduce all simultaneously as the first benchmark.

## Prompt design rule for future LTX-style I2V
Prefer chronological positive description rather than a bundle of abstract constraints. Example structure:
1. exact initial state and object count;
2. single action in chronological order;
3. preservation statement for product shape/material/count;
4. fixed/simple camera;
5. background/light continuity;
6. explicit final state.
Negative constraints may be added, but should not replace a clear positive physical description.

## Interpretation rule
A FAIL on a high-complexity scene does not identify root cause unless simpler controls pass/fail first. Attribute failure only after separating:
- prompt/specification quality;
- task difficulty;
- image conditioning/edit fidelity;
- temporal model fidelity;
- hardware/runtime limits.

## Decision
REOPEN_UGC_R&D_ONLY_AS_EXISTING_FLUX_IMAGE_EDIT_AND_PROMPT_BENCHMARK.
Keep LOCAL_VIDEO_MODEL_HOPPING_PAUSED.
No new download, no FramePack, no LTX reinstall, no pagefile change.

## Next gate
Verify local FLUX.2 Klein image-edit workflow availability in the current ComfyUI installation without installing anything. If available, run one bounded low-complexity image-edit test before considering any further video experiment.

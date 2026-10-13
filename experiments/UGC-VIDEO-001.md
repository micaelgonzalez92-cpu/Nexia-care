# UGC-VIDEO-001 — Minimal Local Image-to-Video Benchmark

Status: FINAL FAIL — TECHNICAL EXECUTION PASS / PROFESSIONAL VISUAL QUALITY FAIL
Date: 2026-10-13
Parent: UGC-PORTFOLIO-001 Phase B
Cash budget: EUR0

## Hypothesis

The existing local ComfyUI environment can animate one accepted CLEARNEST keyframe into a short vertical image-to-video clip using LTX-Video 2B v0.9.5 at EUR0 cash cost, without OOM/crash and with enough temporal/product stability to justify assembling a 20-30s SPEC ad.

## Scope

One model family only: LTX-Video 2B v0.9.5.
One existing ComfyUI installation only.
Input: accepted CLEARNEST A2 keyframe.
Target: one 4-second-ish vertical clip; up to 3 total generation attempts.
No publication, no external contact, no cloud/API fallback, no additional video model, no lip-sync tool, no paid service.

## Candidate runtime configuration

- image-to-video
- vertical resolution target: 512x768 (both divisible by 32)
- frames: 97
- fps: 24
- batch: 1
- source image: accepted A2 keyframe from UGC-PORTFOLIO-001
- motion intent: restrained camera push/lateral movement plus small plausible hand/item movement
- avoid readable text/logos

Exact sampler/guidance values begin from the official ComfyUI LTXV image-to-video template. Do not optimize against the gate after observing outputs beyond the permitted attempt budget.

## Authorized download/install bound

Allowed files only:
1. `ltx-video-2b-v0.9.5.safetensors`
2. `t5xxl_fp16.safetensors` only if not already present
3. official stock-ComfyUI workflow/template data needed to run the existing core nodes

No new application, custom node pack, second video model, browser agent or cloud API was included.

## Original fixed PASS gate

PASS required all of the following:
- at least 1 acceptable clip within <=3 generation attempts;
- no OOM, crash or unrecovered ComfyUI failure;
- source product identity remains recognizable and transparent-bin geometry remains materially stable;
- no central hand/body deformation that makes the ad unusable;
- no severe temporal flicker, frame collapse or camera jump;
- clip is usable as at least 3 seconds of a vertical performance-ad edit;
- total human steering/review for benchmark <=30 minutes;
- cash spend EUR0;
- no cloud/API fallback.

## Original quality rubric — 100 points

- temporal stability / absence of flicker or collapse: 25
- product/scene identity preservation: 25
- motion realism: 20
- commercial/ad utility: 15
- vertical framing/editing headroom: 10
- brand/policy safety: 5

Original acceptable threshold: >=75/100 and no hard fail.

## Hard fails

- transparent storage geometry materially mutates or disappears;
- central visible hand/body anatomy is materially broken;
- scene collapses, melts, flashes or jumps across frames;
- prominent readable invented brand/UI text appears;
- output cannot provide at least 3 usable seconds;
- unauthorized external/cloud execution occurs.

## Execution evidence

Technical execution completed locally at EUR0:

- attempt 1 — seed 4201 — 114.14s — completed;
- attempt 2 — seed 4202 — 73.02s — completed;
- attempt 3 — seed 4203 — 72.92s — completed;
- peak whole-GPU VRAM observed: 11577 MiB;
- three MP4 outputs produced;
- no paid/cloud fallback;
- runner exit code 0.

Technical capability result: **PASS for bounded local execution only**.

## Final professional adjudication

The initial model-only visual QA incorrectly rated attempt 3 as visually acceptable. Kael's direct review rejected all three outputs as professionally unusable, specifically calling out poor hand/anatomy quality. That stronger customer-facing acceptance evidence supersedes the prior optimistic adjudication.

Final result: **FAIL**.

Reason:
- the three-attempt budget is exhausted;
- none of the three outputs meets the professional commercial-quality bar;
- visible hand/anatomy defects are unacceptable for customer-facing UGC;
- attempt 3 must be treated as a hard fail under the original rule `central visible hand/body anatomy is materially broken` rather than rescued by an aggregate score;
- no capability promotion to `LOCAL_VIDEO_VERIFIED_FOR_BOUNDED_SPEC_I2V` is allowed from this experiment.

The previous event `EVT-2026-10-13-UGCVIDEO-006` remains historical evidence of an overly permissive QA decision and is superseded by the subsequent corrective event.

## Corrective learning

Future visual experiments must apply `NEXIA_PROFESSIONAL_QUALITY_GATE.md` in addition to experiment-specific technical gates.

For customer-facing visual work:
- obvious hand/finger/face/body defects are hard fail at normal playback speed;
- professional/portfolio readiness requires a stricter internal bar than a minimal capability threshold;
- high-risk anatomy should be deliberately avoided, controlled, cropped or generated with a workflow proven to handle it rather than accepted optimistically after generation;
- visual QA must include an adversarial defect pass before any PASS claim.

No second model, new application, custom nodes, cloud route or additional generation is authorized by this correction.

## Promotion rule

`UGC-VIDEO-001` is closed as FAIL. Any new video-generation approach requires a separately designed experiment and, where scope changes materially, new Kael authorization.

## Commercial truth

Technical local generation was demonstrated. Professional video quality was not. Buyer demand, publication, sale, settled payment and profit remain unverified.

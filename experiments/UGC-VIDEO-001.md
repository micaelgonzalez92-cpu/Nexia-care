# UGC-VIDEO-001 — Minimal Local Image-to-Video Benchmark

Status: PREREGISTERED / NOT AUTHORIZED / NOT EXECUTED
Date: 2026-10-13
Parent: UGC-PORTFOLIO-001 Phase B
Cash budget if authorized: EUR0

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

Exact sampler/guidance values should begin from the official ComfyUI LTXV image-to-video template. Do not optimize against the gate after observing outputs beyond the permitted attempt budget.

## Download/install bound if later authorized

Allowed files only:
1. `ltx-video-2b-v0.9.5.safetensors`
2. `t5xxl_fp16.safetensors` only if not already present
3. official stock-ComfyUI workflow/template data needed to run the existing core nodes

No new application, custom node pack, second video model, browser agent or cloud API is included.

Estimated download exposure if both model files are absent: approximately 15 GB total. This is an estimate from current official ComfyUI template metadata, not a measured local download.

## Fixed PASS gate

PASS requires all of the following:
- at least 1 acceptable clip within <=3 generation attempts;
- no OOM, crash or unrecovered ComfyUI failure;
- source product identity remains recognizable and transparent-bin geometry remains materially stable;
- no central hand/body deformation that makes the ad unusable;
- no severe temporal flicker, frame collapse or camera jump;
- clip is usable as at least 3 seconds of a vertical performance-ad edit;
- total human steering/review for benchmark <=30 minutes;
- cash spend EUR0;
- no cloud/API fallback.

## Quality rubric — 100 points

- temporal stability / absence of flicker or collapse: 25
- product/scene identity preservation: 25
- motion realism: 20
- commercial/ad utility: 15
- vertical framing/editing headroom: 10
- brand/policy safety: 5

Acceptable clip: >=75/100 and no hard fail.

## Hard fails

- transparent storage geometry materially mutates or disappears;
- central visible hand/body anatomy is materially broken;
- scene collapses, melts, flashes or jumps across frames;
- prominent readable invented brand/UI text appears;
- output cannot provide at least 3 usable seconds;
- unauthorized external/cloud execution occurs.

## FAIL gate

FAIL if no acceptable clip is obtained after 3 attempts, any unrecovered OOM/crash blocks execution, human steering exceeds 30 minutes, or any authority/cash gate is violated.

Thresholds are fixed before execution and must not be loosened after seeing results.

## Evidence to record

- exact model files used;
- ComfyUI version if visible;
- each attempt seed/config;
- wall time per attempt;
- approximate peak whole-GPU VRAM if available;
- approximate RAM if available;
- output dimensions/frames/fps;
- QA score and hard-fail decision;
- human steering minutes;
- errors/recovery;
- cash spend.

## Promotion rule

If PASS: promote only to `LOCAL_VIDEO_VERIFIED_FOR_BOUNDED_SPEC_I2V` and proceed to internal Phase-B assembly design/execution planning. This is NOT proof of general video generation, lip-sync, production reliability or buyer demand.

If FAIL: do not download a second model or widen scope without a new Kael authorization.

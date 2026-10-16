# NEXIA LOW-FOOTPRINT I2V COMPARISON V1 — 2026-10-16

Status: READY_FOR_COMPATIBILITY_GATE / NO DOWNLOAD / NO DELETE / NO INSTALL

## Objective
Select the lowest-footprint image-to-video architecture that can plausibly improve on UGC-VIDEO-002 Route A by adding directed action, continuity and product demonstration while reusing the existing ComfyUI stack and respecting the RTX 3060 12GB / 15.96 GiB RAM constraints.

## Current constraints
- UGC-VIDEO-002 Route A stopped at 80/100 provisional; structural blockers were limited action, continuity and product demonstration.
- Existing local stack includes ComfyUI, FLUX.2 Klein, old LTX-Video 2B v0.9.5, t5xxl_fp16, FFmpeg/ffprobe.
- C: is SSD with ample free space; D: is HDD.
- FramePack is technically plausible by VRAM but operationally weak on 16 GiB RAM + 9.5 GiB pagefile, so it remains deferred.

## Candidate comparison

### 1. LTX-Video 2B v0.9.8 distilled FP8 — SELECTED FOR COMPATIBILITY GATE
HECHO VERIFICADO:
- Official Lightricks model: ltxv-2b-0.9.8-distilled-fp8.safetensors.
- Remote file size: 4.46 GB.
- Official LTX release describes 2B 0.9.8 distilled as the smaller/light-VRAM variant; 0.9.8 release notes state improved prompt understanding and detail generation.
- ComfyUI-Manager model list explicitly contains LTX-Video 2B Distilled FP8 v0.9.8 as a checkpoint.
- Comfy-Org quantization documentation states FP8 LTXV exports load in stock ComfyUI on any GPU.
- Existing ComfyUI LTX workflows use t5xxl_fp16.safetensors as the LTXV text encoder; this dependency is already present locally and should be retained.

UNKNOWN / NOT VERIFIED:
- Exact compatibility of the currently installed local ComfyUI build with the 0.9.8 FP8 checkpoint.
- Local runtime quality, speed, RAM/VRAM peaks and professional score.
- Whether a spatial upscaler is needed for the bounded first test; the official inference config references one for its multiscale pipeline, but the minimal stock-ComfyUI checkpoint test has not yet been executed.

### 2. Stable Video Diffusion — REJECT FOR CURRENT OBJECTIVE
HECHO VERIFICADO:
- Native ComfyUI image-to-video workflows exist for 14- and 25-frame SVD checkpoints.
- Official SVD/SVD-XT checkpoint size is about 9.56 GB.
- Basic ComfyUI workflow is init-image driven with motion_bucket/fps/augmentation controls.

REASON TO REJECT:
- Larger checkpoint than selected LTX 2B FP8.
- Basic native workflow offers weaker directed action control for the specific product-demonstration objective.
- Does not improve the footprint/controllability trade-off versus LTX 2B 0.9.8 FP8.

### 3. Hunyuan Video / Cosmos — REJECT FOR LOW-FOOTPRINT PATH
HECHO VERIFICADO:
- Native ComfyUI examples support image-to-video.
- These are substantially larger model families (7B/14B class for Cosmos; Hunyuan video requires multiple additional encoders/models).

REASON TO REJECT:
- Adds more model/dependency footprint rather than exploiting the existing LTX stack.

### 4. FramePack — DEFERRED
- VRAM nominally fits RTX 3060 12GB.
- 16 GiB RAM + 9.5 GiB pagefile creates material operational risk based on upstream community evidence.
- Do not install or change pagefile until lower-footprint LTX replacement is tested.

## Replacement / cleanup logic
1. Do not delete t5xxl_fp16: it is a shared LTXV text-encoder dependency.
2. Old ltx-video-2b-v0.9.5.safetensors (~5.91 GiB observed locally) is a candidate for retirement once the replacement test is authorized.
3. Preferred policy is replacement, not accumulation: if Kael authorizes the bounded 0.9.8 test, remove only the obsolete 0.9.5 checkpoint before downloading the 4.46 GB replacement, while preserving all experiment outputs/evidence.
4. Do not remove the old checkpoint until exact local path and dependency boundary are reconfirmed immediately before deletion.

## Bounded test contract
- Input: one already accepted still from Phase A.
- Goal: one 3–5 second I2V clip demonstrating a concrete product action.
- Cash: €0.
- No publication / no external API.
- Measure: load success, wall time, VRAM peak, RAM peak, output duration, anatomy/product-geometry hard fails, temporal coherence, product action intelligibility.
- PASS to continue: model loads, clip completes without OOM, no hard fail, action is visibly demonstrated, and runtime is operationally tolerable.
- FAIL/STOP: model cannot load, OOM/system instability, severe anatomy/product mutation, or generation time makes the route operationally nonviable.

## Next gate
Read-only local compatibility check: exact ComfyUI version and presence of native LTXV core nodes. No download or deletion before this gate closes.

## Public sources consulted
- https://github.com/Lightricks/LTX-Video
- https://huggingface.co/Lightricks/LTX-Video/blob/main/ltxv-2b-0.9.8-distilled-fp8.safetensors
- https://github.com/Comfy-Org/ComfyUI-Manager/blob/main/model-list.json
- https://github.com/Comfy-Org/comfy-quants/blob/main/docs/quantization/ltxv.md
- https://github.com/comfyanonymous/ComfyUI_examples/blob/master/ltxv/ltxv_image_to_video.json
- https://github.com/comfyanonymous/ComfyUI_examples/blob/master/video/README.md

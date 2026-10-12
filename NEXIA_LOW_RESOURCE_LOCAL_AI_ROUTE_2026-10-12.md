# NEXIA LOW-RESOURCE LOCAL AI ROUTE — 2026-10-12

Status: RESEARCHED / NOT INSTALLED / HARDWARE GPU DETAILS STILL PRIVATE
Cash spend: EUR0

## Trigger

Authorized Work batch verified tooling and processed the real local audit privately. Public/user-returned report reveals total RAM is below the strict 16 GiB gate. That fails the original conservative gates for FLUX.2 Klein 4B, MuseTalk, ComfyUI baseline and Wan2.2 TI2V-5B, but does NOT establish incompatibility or prove cloud-only operation.

## Rule

Do not relax original gates after observing hardware. Instead create a separate LOW_RESOURCE experimental path with its own evidence and authorization.

## Current implications

- Openfield: remains a software-layer candidate if RAM >=8 GB and Node >=20, but it still needs a viable generation backend.
- Browser Use: library remains a candidate if RAM >=8 GB; zero-API operation additionally needs a viable local model.
- Ollama: RAM 8-15.99 GB is LIMITED, not PASS for the original baseline.
- FLUX.2 Klein / MuseTalk / ComfyUI / Wan2.2: original conservative gates remain failed until actual benchmark evidence justifies a separate optimized route.

## Lightweight candidates found

### LTX-Video 2B / distilled / 8-bit route
Official Lightricks LTX-Video repository is Apache-2.0 for code. Repository lists 2B and 2B-distilled checkpoints as lower-VRAM options and references LTX-VideoQ8, reporting 720x480x121 generation under one minute on RTX 4060 8GB in that contribution. Checkpoint/model license must be reviewed separately before commercial use; do not infer model-weight rights from repo code license alone.
Priority: HIGH if actual GPU is NVIDIA >=8 GB VRAM.

### WanGP
Community low-VRAM generation frontend/wrapper claims support for certain models from ~6 GB VRAM and multiple quantized formats. This is third-party software and supports many model families with different licenses. Requires source/dependency/security audit plus exact selected model license. No install authorized.
Priority: WATCH pending exact GPU and security/license review.

### Stable Diffusion 1.5 class / low-VRAM ComfyUI
Community evidence exists for SD1.5-class image generation on 4 GB VRAM using low-VRAM ComfyUI configurations. Treat only as a feasibility signal; quality, specific model license, RAM pressure and commercial adequacy require benchmark.
Priority: FALLBACK for image-only capability when GPU is weak.

### FramePack / low-VRAM forks
Low-VRAM forks exist around ~6 GB VRAM, but model-weight licensing must be checked carefully. Any route depending on Hunyuan weights is NOT approved for Nexia merely because wrapper code is open-source; territorial/commercial restrictions can make a technically working stack unusable in Spain/EU.
Priority: LICENSE-HOLD / NO INSTALL.

## Next required private facts

Only the minimum non-sensitive hardware summary is needed before choosing a benchmark:
- GPU exact model
- GPU VRAM from nvidia-smi if available
- total RAM (already known to be below strict 16 GiB gate; exact value useful)
- free space on the intended SSD target, not merely maximum free volume

Do NOT publish serial numbers, hostnames, usernames, full process lists or other local metadata in the public repository.

## Benchmark order after exact GPU is known

1. Pick ONE smallest viable candidate tied to AI-UGC economic value.
2. Review exact source, dependencies, license and weight license.
3. Estimate download size / target-disk use / electricity / expected generation time.
4. Obtain separate bounded Kael authorization for install/download.
5. Install isolated and reversible.
6. Run one fixed benchmark.
7. Record wall time, peak RAM/VRAM, output quality, failure/recovery and marginal cost.
8. Promote only on verified evidence.

## Economic truth

No model installed, no local generation benchmark performed, no portfolio output, no sale, no settled revenue and no profit. This research only preserves a lower-resource escape route.

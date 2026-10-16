# NEXIA LOCAL UGC VIDEO CAPABILITY BOUNDARY V1 — 2026-10-16

Status: ACTIVE EVIDENCE / LOCAL VIDEO R&D PAUSE RECOMMENDED

## Purpose
Capture the observed boundary of the current local UGC-video path after Route A and LTX-Video tests, without overstating capability.

## Verified experiment chain
- UGC-VIDEO-002 Route A V1: 73/100, professional FAIL.
- Route A V2: 78/100 provisional, professional FAIL.
- Route A V3: 80/100 provisional, encoding fixed but structural action/continuity/product-demonstration gap remained; Route A stopped.
- LTX-Video 2B v0.9.8 distilled FP8 local compatibility gate passed on ComfyUI 0.39.0 with native LTXV nodes present.
- One authorized 3–5 s I2V test was executed using accepted still A2, with one generation submission and no retry.

## LTX 0.9.8 runtime result — Kael-reported Work evidence
Technical execution completed without recorded OOM or runtime error:
- output: 448x800, 97 frames, 24 fps, 4.042 s;
- generation wall time: 53.922 s;
- start + test + shutdown: 154.672 s;
- sampled process RAM peak: 5767 MiB;
- sampled system RAM peak: 14295 MiB;
- sampled whole-GPU VRAM peak: 11537 MiB.

Professional/visual result: FAIL.
- Severe product integrity failure: additional boxes/content mutation visible from about 1.67 s.
- Severe continuity/physics failure: a box is suspended above the stack around 2.67–3.67 s.
- Requested action was not faithfully demonstrated; a generic lift/reposition motion was visible instead.
- Anatomy is NOT VERIFIED as passing.
- Normal-speed playback was NOT completed; 13 sampled frames were reviewed.
- Native single-stage configuration only; no extra upscaler.

## Replacement cleanup result
- Old `ltx-video-2b-v0.9.5.safetensors`: 6,340,729,500 bytes before deletion; deleted and final absence reported verified.
- New official `ltxv-2b-0.9.8-distilled-fp8.safetensors`: 4,461,695,684 bytes; SHA-256 `d6d8fa8ed3a98346787c2503ac80fb5d7cebcf80e356b79a2ba361fbadf97e15`; downloaded for the test and removed after visual FAIL; final absence reported verified.
- Both LTX checkpoints are absent at close.
- `t5xxl_fp16.safetensors` retained with unchanged hash.
- ComfyUI, FLUX and Ollama retained; Ollama not modified or stopped.
- V1/V2/V3 experiment files/reports retained with hashes unchanged according to the Work result.
- Pagefile remained 9728 MiB before/after; no configuration change.
- Cash cost: EUR 0.

## Current capability boundary
The current machine can technically execute the tested LTX 2B FP8 I2V workload without OOM, but the one bounded sample failed the product-integrity and physical-continuity requirements that matter for professional UGC. Runtime feasibility therefore does not equal usable professional capability.

FramePack remains deferred: RTX 3060 12 GB nominally fits, but 15.96 GiB RAM + 9.5 GiB pagefile create weak expected operational fit. No FramePack install or pagefile change is justified from current evidence.

## Rational stop / reopen rule
RECOMMENDATION: pause additional local UGC-video model hopping now. The marginal information value of another similar local model is lower than moving WIP to external reality validation and the already-open automation/product lanes.

Reopen the UGC video architecture only if at least one of these changes materially:
1. external buyer/demand evidence makes stronger video capability worth funding;
2. hardware capacity materially improves;
3. a materially stronger low-footprint model becomes available with credible product-consistency evidence;
4. a bounded cloud/video route becomes available at acceptable cost and authority.

Do not reinterpret this as proof that all local/video approaches are impossible. It is a stop decision for the current evidence, hardware, architecture set and professional objective.

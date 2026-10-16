# UGC-VIDEO-002 — Route A Pre-execution V1

Date: 2026-10-16
Status: READY_FOR_LOCAL_DRY_RUN / NOT_EXECUTED
Cash spend: EUR0
Authority: internal deterministic assembly only. No model download, new app, cloud/API, publication or external contact.

## Objective
Test whether Nexia can build a professionally coherent 24s vertical SPEC performance creative from already accepted CLEARNEST source frames while avoiding the known UGC-VIDEO-001 failure mode: generated hand/anatomy motion.

## Verified source assets
From historical Phase A evidence:
- A1 = `NEXIA_BENCHMARK_00002_.png` — ACCEPT 85/100.
- A2 = `NEXIA_BENCHMARK_00003_.png` — ACCEPT 90/100.

These files were generated locally and visually accepted previously. This experiment does not regenerate them.

## Production architecture
`accepted stills -> deterministic pan/zoom/cuts -> deterministic captions -> silent first proof -> professional QA`

No generative motion is required for Route A V1. If this route fails because static-motion grammar is commercially weak, that is useful evidence and must not be hidden by adding a new model mid-test.

## Exact first cut
Target: 1080x1920, 30fps, ~24s, H.264 MP4, no audio.

1. 0.0–2.5s A1 slow push — `¿Necesitas más espacio?`
2. 2.5–6.0s A1 lateral/push — `O quizá... mejor orden.`
3. 6.0–11.0s deterministic A1->A2 sequence — `De caos a visible y accesible.`
4. 11.0–16.0s A2 lateral movement — `Verlo. Cogerlo. Guardarlo.`
5. 16.0–20.5s A1/A2 before-after cut — `Mismo espacio. Menos caos.`
6. 20.5–24.0s A2 CTA — `Empieza por un solo rincón.` + `CLEARNEST — SPEC CONCEPT`.

## Runner
`tools/run_ugc_video_002_route_a.py`

The runner:
- requires already installed `ffmpeg` and `ffprobe`;
- auto-locates the prior ComfyUI output folder or accepts `--comfy-output`;
- refuses to install anything;
- refuses to proceed if A1/A2 are absent;
- supports `--dry-run` for dependency/source verification;
- builds the deterministic cut and writes a JSON technical report;
- never labels the visual result professionally acceptable.

## Execution sequence when local surface is available
1. `python tools/run_ugc_video_002_route_a.py --dry-run`
2. If and only if dry-run returns `DRY_RUN_PASS`, run without `--dry-run`.
3. Inspect output at normal playback speed.
4. Complete `experiments/UGC-VIDEO-002_LEDGER_TEMPLATE.json`.
5. Apply UGC-VIDEO-002 >=85/100 gate plus zero hard fail.

## Stop conditions
Stop without installation if:
- ffmpeg/ffprobe absent;
- accepted A1/A2 files absent;
- source mapping differs from historical evidence;
- deterministic assembly errors;
- local execution surface is unavailable.

A missing dependency is `BLOCKED_NOT_INSTALLED`, not evidence that Route A failed creatively.

## Hardware-fit decision for Route B
Known machine from Phase B: RTX 3060 12GB / ~16GB RAM.

Current primary-source scan:
- Wan2.2 official TI2V-5B README states its command can run on GPU with at least 24GB VRAM -> native official route does not fit the verified 12GB VRAM envelope.
- LTX-2.5 official quick start uses a 22B transformer and roughly 66 GiB model download; it offers CPU/disk offload for constrained GPUs, but this is not evidence of practical fit on 12GB VRAM + ~16GB RAM and is not justified as the first test.
- HunyuanVideo-1.5 official README references a third-party low-VRAM Wan2GP route reportedly as low as 6GB VRAM; this would require a new application/workflow and therefore remains a candidate for a separate install/download gate, not automatic execution.

Decision: `ROUTE_B_NO_NATIVE_CURRENT_MODEL_INSTALL_YET`. Route A produces more information per cost/risk now.

## Professional gate
PASS only if the final cut scores >=85/100, has no obvious visual hard fail, preserves product identity, tells a coherent commercial story, and total human steering/edit/review <=90 minutes.

Kael's normal-viewing rejection remains a hard fail for customer-facing promotion.

## Truth boundary
This pre-execution package is prepared and the runner is persisted. No local execution or professional PASS has yet occurred. Buyer demand, sale, payment and profit remain unverified.
# NEXIA LOCAL CAPABILITY SCORING SPEC — 2026-10-12

Status: DESIGNED / SCORER CODE NOT YET PERSISTED
Purpose: convert the read-only Windows audit output from `tools/nexia_pc_audit.ps1` into conservative pre-install recommendations for Nexia local AI tooling.

## Truth boundary

This specification is a PRE-INSTALL SCREEN only. It must never be treated as proof that a model runs, is fast enough, is stable, or produces portfolio-grade/commercial output. A model becomes OPERATIVE only after an actual benchmark on Kael's PC.

## Inputs

From `NEXIA_PC_AUDIT.json`:
- total RAM GB
- GPU names
- preferred GPU VRAM from `nvidia-smi` when present; otherwise WMI AdapterRAM as best-effort fallback
- maximum free disk GB among local volumes
- CPU name
- OS
- installed tool versions, especially Node, Python, FFmpeg, Git, Docker, Ollama and nvidia-smi

## Local capability tiers

- `S_LOCAL_CREATIVE`: VRAM >=24 GB, RAM >=32 GB, free disk >=150 GB.
- `A_LOCAL_IMAGE_AVATAR`: VRAM >=8 GB, RAM >=16 GB, free disk >=60 GB.
- `B_LIMITED_LOCAL_AI`: VRAM >=4 GB, RAM >=16 GB, free disk >=40 GB.
- `C_CLOUD_OR_LIGHTWEIGHT_FIRST`: below B gate.

These thresholds are conservative Nexia screening thresholds, not vendor guarantees.

## Capability gates

### Openfield
- Candidate if RAM >=8 GB.
- Separately verify Node >=20.
- First execution must be `compose` or `auto --dry`; no generation/provider call before dependencies/security are reviewed.

### FLUX.2 Klein 4B
- Candidate local evaluation if VRAM >=8 GB, RAM >=16 GB, free disk >=40 GB.
- If below: `BLOCKED_OR_EXPERIMENTAL`; quantized/offload routes require separate evidence.
- Benchmark: one fixed-seed 1024px image; measure wall time, peak VRAM/RAM, reproducibility and visual quality.

### Wan2.2 TI2V-5B
- Candidate 720p evaluation if VRAM >=24 GB, RAM >=32 GB, free disk >=100 GB.
- VRAM 16–23.99 GB with RAM >=32/free disk >=100: `EXPERIMENTAL_OPTIMIZED_ONLY` and require quantization/offload evidence.
- Below: `BLOCKED_LOCAL_VIDEO` for initial Nexia stack.
- Benchmark only if gate permits: one fixed 5-second prompt; measure generation time, VRAM, RAM and output quality.

### MuseTalk
- Candidate local evaluation if VRAM >=4 GB, RAM >=16 GB, free disk >=20 GB.
- Benchmark: 8-second lipsync sample; record processing time and visible artifacts.

### ComfyUI
- `CANDIDATE_GPU` if VRAM >=8 GB, RAM >=16 GB, free disk >=40 GB.
- `CANDIDATE_LIMITED` if RAM >=16 GB and free disk >=40 GB but VRAM below 8 GB.
- Otherwise `BLOCKED_LOW_RESOURCES` for first stack.
- Start with one official workflow only; no custom nodes before baseline measurement.

### Ollama
- RAM >=16 GB: candidate for smaller local models, subject to model-specific license and benchmark.
- RAM 8–15.99 GB: limited.
- Below 8 GB: blocked for baseline.
- Benchmark one permissively licensed model on a fixed task; record tokens/s and RAM/VRAM.

### Browser Use
- Library candidate if RAM >=8 GB.
- Zero-API-cost operation additionally requires a viable local LLM.
- First test must use disposable browser profile + allowlisted public sites only; no authenticated accounts, submissions, purchases or messages.

## Mandatory installation order

1. Run read-only audit.
2. Score capabilities.
3. Select ONE highest-value candidate.
4. Inspect code/dependencies/license/model weights and storage requirement.
5. Install in isolated/reversible location only after Kael authorization if installation changes the computer.
6. Benchmark against a fixed task.
7. Record PASS/FAIL and actual resource use.
8. Only then connect to Openfield/NEXIA HQ/automation.

## Security gates

- No API keys, cookies, credentials or secrets in GitHub or audit output.
- No autonomous browser/desktop control until sandbox, permissions, logs and recovery are verified.
- No large model downloads before free-disk and hardware gate PASS.
- No commercial use until both software license and model/weights license are confirmed compatible with Spain/EU and Nexia's use case.

## Current verification state

- `tools/nexia_pc_audit.ps1`: PERSISTED / RE-READ VERIFIED.
- Scoring logic: DESIGNED and synthetic-tested in chat runtime with four scenarios (high-end, midrange, low-resource, NVIDIA-VRAM preference), all tests passed.
- `tools/nexia_local_capability_score.py`: NOT PERSISTED; connector write was blocked/failed. Do not claim it exists until re-read confirms it.
- Real Kael PC audit: NOT EXECUTED.
- Any installation/model download: NOT EXECUTED.
- Economic effect: EUR0 spend, EUR0 revenue, EUR0 profit.

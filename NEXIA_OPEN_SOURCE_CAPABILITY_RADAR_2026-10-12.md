# NEXIA OPEN-SOURCE CAPABILITY RADAR — 2026-10-12

Status: RESEARCHED / NOT INSTALLED
Cash spend this batch: EUR0
Authority: no new accounts, installs, downloads, API keys or system changes performed.

## Objective

Reduce dependence on paid AI credits and scarce ChatGPT Work/Codex usage by identifying self-hosted/open-source/open-weight capabilities that Nexia can potentially run locally or integrate through MCP/API/CLI.

## Core rule

Open source != zero total cost. Evaluate separately:
- software license;
- model/weights license;
- commercial-use rights;
- hardware/VRAM/RAM/storage requirement;
- electricity/compute time;
- optional API/cloud costs;
- maintenance/security burden.

## Highest-value candidates

### S — Openfield
Repository: VedSoni-dev/openfield
License: MIT
Role: open-source Higgsfield-like orchestration layer with cinematic presets, Cinema Studio, Soul ID character references, AI Director, local UI/Electron, CLI and MCP.
Key fact: provider routes include fal, Replicate and a custom/self-hosted endpoint. The self-host adapter expects POST /create and GET /status/:id, so Nexia can potentially connect Openfield to a local ComfyUI bridge without vendor markup.
Important limit: Openfield itself is free; paid provider keys are not. Zero-marginal-cost generation requires local/self-hosted inference or an external free tier.
Status: CANDIDATE / NOT INSTALLED.

### S — ComfyUI
Repository: Comfy-Org/ComfyUI
Role: local visual AI engine with graph workflows, App Mode and local API. Supports image/video/audio/3D/text workflows and NVIDIA/AMD/Intel/Apple hardware.
Value: likely primary local generation backend for Nexia; reusable workflows can later be called from HQ/Openfield/automation.
Status: CANDIDATE / HARDWARE AUDIT REQUIRED.

### S — FLUX.2 klein 4B
Repository: black-forest-labs/flux2
Model license: Apache-2.0 for 4B variants.
Role: text-to-image + single/multi-reference image editing.
Hardware signal: official repo states ~8GB VRAM fit for Klein 4B on consumer GPUs.
Value: strong candidate for commercially usable local image generation if PC GPU is sufficient.
Status: CANDIDATE / HARDWARE AUDIT REQUIRED.

### S/A — Wan2.2 TI2V-5B
Repository: Wan-Video/Wan2.2
License: Apache-2.0; repository states no rights claimed over generated content subject to lawful use.
Role: text-to-video and image-to-video, 720p/24fps.
Hardware signal: official repo cites consumer RTX 4090 and <9 minutes for a 5-second 720p video without specific optimization.
Value: strongest permissive local video candidate identified for Nexia; hardware burden is material.
Status: CANDIDATE / HARDWARE AUDIT REQUIRED.

### A — Qwen-Image
Repository: QwenLM/Qwen-Image
License: Apache-2.0.
Role: image generation/editing, especially strong text rendering.
Hardware signal: full FP8 workflows commonly target ~20GB VRAM; lighter variants may exist.
Status: SECONDARY IMAGE CANDIDATE.

### A — MuseTalk
Repository: TMElyralab/MuseTalk
Code license: MIT. Project README states trained model is available for commercial use, subject to licenses of dependencies.
Role: lip synchronization / talking-avatar pipeline.
Status: CANDIDATE FOR AI-UGC AVATAR STACK.

### B — LivePortrait
Repository: KlingAIResearch/LivePortrait
Code license: MIT.
Commercial caveat: bundled InsightFace detection models are non-commercial; project explicitly says replace those detection models for commercial use.
Role: portrait animation / character motion.
Status: WATCH / COMMERCIAL DETECTOR REPLACEMENT REQUIRED.

### A — Kokoro / Piper
Licenses: Kokoro Apache-2.0; Piper MIT (verify voice/model-specific licenses before commercial deployment).
Role: local TTS/voice generation.
Status: CANDIDATES FOR LOCAL VOICE LAYER.

### A — Ollama
Repository: ollama/ollama
License: MIT for Ollama software. Individual model licenses vary.
Role: run local LLMs; potential zero-API-cost reasoning/routing for low-risk local tasks.
Status: CANDIDATE / MODEL+HARDWARE AUDIT REQUIRED.

### A — Browser Use
Repository: browser-use/browser-use
License: MIT.
Role: browser agents. Library is free; cloud/provider inference costs are separate. Supports local browser + local model through Ollama.
Risk: authenticated browser automation is security-sensitive and must remain under explicit Human Gates/permissions.
Status: CANDIDATE FOR LOCAL WEB EXECUTION / SECURITY REVIEW REQUIRED.

### A/B — Microsoft UFO
Repository: microsoft/UFO
License: MIT.
Role: Windows Desktop AgentOS for multi-application workflows using GUI + native APIs; current docs include MCP integration.
Risk: system-level control. Must be sandboxed/tested before any authority.
Status: HIGH-POTENTIAL WATCH FOR NEXIA TERMINAL.

### A/B — Agent-S
Repository: simular-ai/Agent-S
License: Apache-2.0.
Role: Windows/macOS/Linux GUI agent controlling mouse/keyboard/screen.
Risk: executes Python and can control the desktop; current setup often relies on external model providers unless paired with compatible local inference.
Status: HIGH-POTENTIAL WATCH / SECURITY REVIEW REQUIRED.

### A/B — Open Interpreter
Repository: openinterpreter/openinterpreter
Current main project license: Apache-2.0.
Role: local coding/computer agent, provider-agnostic, supports local models through Ollama/LM Studio and includes browser/native-app QA capabilities.
Status: CANDIDATE FOR LOCAL NEXIA WORKSTATION; SECURITY/APPROVAL MODEL REQUIRED.

## NO-GO / LICENSE ISSUE

### HunyuanVideo-1.5
The Tencent Hunyuan Community License explicitly excludes the European Union, United Kingdom and South Korea from its Territory. Kael/Nexia operate in Spain, so this model is NO_GO for local/commercial Nexia usage unless licensing changes or separate rights are obtained.

## Proposed zero-paid-credit creative stack

NEXIA / ChatGPT -> Openfield (presets/director/MCP) -> local custom bridge -> ComfyUI -> FLUX.2 klein 4B for images / Wan2.2 5B for video -> MuseTalk for lipsync -> local TTS -> FFmpeg/Remotion-like assembly layer.

This is only a design until the PC hardware audit verifies feasibility.

## Gates before installation

1. Audit PC CPU, GPU exact model, VRAM, RAM, free SSD, OS version and drivers.
2. Select only models that are commercially usable in Spain/EU.
3. Estimate download size, disk use, generation time and electricity.
4. Install one isolated component at a time and benchmark.
5. Verify generated output quality and reproducibility.
6. Never expose API keys in repo or logs.
7. No autonomous desktop/browser control until sandbox, permission boundaries, recovery and logging are verified.

## Economic truth

Research performed, but no local stack installed, no portfolio output generated, no sale/payment/profit created. EUR0 cash spent in this batch.

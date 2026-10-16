# NEXIA REMOTE EXECUTION + HIGGSFIELD UGC OPTIONS — 2026-10-16

Status: RESEARCH_ONLY / NO ACTIVATION / NO SPEND

## Purpose
Reduce dependence on scarce Work/Codex while preserving bounded authority, truth, recoverability and zero-cost defaults. Also assess Higgsfield as an optional cloud UGC backend.

## Current verified constraints
- Work and Codex remain scarce fallback execution planes.
- Existing local bridge has verified one-shot automatic local execution with sanitized GitHub result return; prior scheduler authorization is consumed.
- Recurring/persistent local worker is neither currently authorized nor verified.
- Local image stack: ComfyUI + FLUX.2 Klein 4B FP8 verified for bounded generation; image editing is the next local runtime gate.

## Preferred architecture: NEXIA Local Executor
Use GitHub as bounded command bus and ComfyUI's local HTTP/WebSocket API as the execution interface.

Flow:
Chat writes allowlisted task JSON -> local executor reads authorized task -> calls ComfyUI localhost `/prompt` -> observes `/ws` or `/history/{prompt_id}` -> hashes outputs + captures metrics -> writes sanitized result JSON to GitHub -> stops/returns idle.

Advantages:
- avoids Work/Codex for local ComfyUI jobs;
- no GUI automation required;
- deterministic workflow JSON, exact prompts, seeds and settings can be persisted before execution;
- output hashes and runtime metrics can be returned automatically;
- can enforce task-type allowlists, output directories, max runtime, no shell passthrough and kill switch.

Activation levels:
1. MANUAL-LAUNCH ASSISTED: Kael starts one local launcher when needed; no persistent service.
2. AUTOMATIC-SUPERVISED: local executor starts with Windows and checks for bounded signed/authorized tasks. This is a fresh material gate because it is persistent background execution.

Security rules:
- never expose ComfyUI directly to the public Internet;
- no arbitrary command execution from task JSON;
- task schema allowlist only;
- no secrets in public repo/task/result payloads;
- API credentials stored only locally in OS-protected storage/environment and never committed or pasted into chat;
- per-task max runtime, output path confinement, task idempotency, explicit stop/kill control.

## Other alternatives
- Cloud browser automation can handle websites such as Higgsfield, but cannot reach local ComfyUI unless localhost is exposed; exposing localhost is not recommended by default.
- VPN/tunnel solutions such as Tailscale/Cloudflare Access could technically expose a protected local service but add account/setup/security surface and are inferior to the bounded local executor for current needs.
- Remote desktop tools still require a controlling UI/operator and do not solve agentic orchestration from Chat by themselves.
- Higgsfield API moves generation to the cloud and therefore avoids local-PC remote control entirely, but it is paid per generation and remains a spend/account gate.

## Higgsfield API economics and boundary
- API is separate from Higgsfield website subscriptions/credits.
- API uses prepaid USD balance and pay-per-generation pricing; minimum top-up currently documented as USD 5.
- API playground/interface can be accessed without sales, but generation API usage is not free.
- Use provider cost-estimate endpoint before generation when integrating.
- No API key/funding/production use is authorized by this artifact.

## UGC improvement architecture
1. PROMPT COMPILER
   Convert a creative brief into a structured shot contract: subject/product identity, one primary action, object-count contract, geometry/material preservation, camera rule, environment, final state, negatives only as support.

2. COMPLEXITY LADDER
   Still image -> image edit -> simple I2V one object/no hands -> add one variable at a time -> hand interaction -> repeated/translucent objects -> reversible motion.

3. SHOT DECOMPOSITION
   Prefer several 1.5–4 s low-complexity shots plus local edit/assembly over one 8–15 s generative shot with multiple interacting constraints.

4. BACKEND ROUTER
   Local FLUX for zero-cost still generation/edit tests. Cloud video only when the shot requires stronger temporal capability and the spend gate is approved.

5. REFERENCE-FIRST CONTROL
   Use product reference images, presenter references and reference-ad structure where licensed/allowed. Preserve the product as a first-class constraint rather than asking the video model to invent it repeatedly.

6. HIGGSFIELD OPTIONS
   Marketing Studio supports product shots, UGC, faceless/talking-head/silent formats, reference ads, avatars and motion modes. Current API exposes many image/video models and Marketing Studio Image generation/editing. A dedicated current UGC-video API endpoint was not verified in this research, so do not invent one.

7. MODEL/TASK ROUTING
   Static product exploration can use local FLUX first. If paid cloud testing becomes justified, inexpensive image endpoints can validate product consistency before video. Video models should be chosen by task, not brand preference, and only after cost estimation.

8. QA GATE
   Before promotion: product count, shape, color, logo/text, duplicated objects, geometry, temporal continuity, normal-speed playback, action intelligibility, runtime, cost and reproducible settings.

9. ECONOMIC GUARDRAIL
   Default spend EUR 0. Any Higgsfield API funding/top-up is RED and requires Kael approval. Predeclare max cost per experiment and number of generations before execution.

## Recommendation
Do not use Work/Codex for the next FLUX image-edit benchmark. Preferred route is to build the NEXIA Local Executor as an allowlisted ComfyUI API runner. Prepare/test the runner without persistence first; only activate a persistent supervised worker after a separate explicit Kael gate and reliability/security verification.

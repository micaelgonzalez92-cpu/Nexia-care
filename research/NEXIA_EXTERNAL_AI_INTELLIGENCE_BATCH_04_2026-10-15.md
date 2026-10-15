# NEXIA — EXTERNAL AI INTELLIGENCE BATCH 04

Date: 2026-10-15
Status: PROVISIONAL_RESEARCH / SOURCE-VALIDATED / MORE USER BATCHES EXPECTED
Source: user-provided images covering (A) final image-edit prompt patterns for clothing transformation and final professional edit, (B) Google/Lee Boonstra Prompt Engineering guide screenshots, and (C) yt-dlp.

## Executive conclusion
This batch is valuable, but mostly as a standards/refinement batch rather than a new-stack batch.

Net-new high-value implications:
1. Prompt engineering for Nexia should become TEST-DRIVEN and MODEL-AWARE, not a static bag of tricks.
2. Classic prompting methods (zero/few-shot, role/context prompts, step-back, self-consistency, ToT, ReAct) are useful as patterns, but must be selected per model/task and validated with evals.
3. Explicit chain-of-thought prompting must not become a universal Nexia rule. Modern reasoning models often perform better with clear goals, constraints and success criteria while reasoning internally.
4. yt-dlp is a high-utility local media-ingestion tool for permitted/public content, but must be gated by rights/platform controls.
5. The two visual prompts should extend the IMAGE EDITING SPEC library: clothing changes require geometry/lighting realism and identity preservation; final edit should be minimal and outcome-driven.

## A. Image-edit prompt patterns

### Clothing transformation
Classification: USEFUL PROMPT / QA PATTERN.
Strengths:
- explicitly preserves identity, face, hair, body proportions, pose, expression and environment;
- asks for physically coherent fabric texture, folds, shadows, perspective and lighting;
- correctly treats clothing replacement as an integration problem, not just a texture swap.

Nexia application:
- add to image-edit library under `WARDROBE_REPLACEMENT_IDENTITY_PRESERVING`;
- QA checks: body anatomy unchanged unless explicitly authorized; garment geometry follows pose; occlusion around hair/hands/accessories is coherent; lighting direction and color temperature match the scene; no warped logos/buttons/seams; source identity remains recognizable.

Decision: ADOPT AS VISUAL EDITING SPEC.

### Professional final edit
Classification: USEFUL HIGH-LEVEL FINISHING SPEC.
Strengths:
- prioritizes composition, exposure, white balance, contrast, color, sharpness and distraction removal;
- explicitly preserves identity and important details;
- states that changes should improve the image rather than change it for novelty.

Nexia application:
- use as final QA/finishing pass after task-specific edits;
- do not combine blindly with every edit prompt: final pass must remain subordinate to source fidelity and the requested purpose.

Decision: ADOPT AS `FINAL_PHOTO_QA_PASS`.

## B. Google / Lee Boonstra Prompt Engineering guide

### Authenticity / recency
Classification: REAL DOCUMENT / SOCIAL CLAIM ABOUT RECENCY IS FALSE OR MISLEADING.
Evidence:
- copies/catalog records identify `Prompt Engineering`, author Lee Boonstra, Google, versions dated September 2024 and February 2025, around 65–68 pages;
- screenshots match the documented table of contents: output configuration, zero/one/few-shot, system/context/role prompts, step-back, Chain of Thought, self-consistency, Tree of Thoughts, ReAct, automatic prompt engineering, code prompting, multimodal prompting and best practices;
- therefore `Google acaba de lanzar` is not current truth in October 2026;
- Google Cloud now maintains newer prompt-engineering and agentic prompting documentation updated into 2026.

Decision: KEEP AS HISTORICALLY USEFUL REFERENCE, NOT CURRENT CANONICAL PROMPT STANDARD.

### What remains strongly valid

#### Clear objective + context + output contract
Status: STRONGLY VALID.
Current Google and OpenAI guidance both support clear goals, relevant context, explicit desired output and iterative testing.
Nexia rule candidate:
`GOAL + CONTEXT + CONSTRAINTS + SUCCESS CRITERIA + OUTPUT CONTRACT + EVIDENCE/STOP RULE`.

#### Zero-shot first, examples when needed
Status: VALID WITH MODEL-AWARE NUANCE.
Modern reasoning models often need fewer examples; examples remain valuable when format, taxonomy, tone or edge-case behavior must be demonstrated.
Nexia rule:
- try simplest prompt first;
- add one/few-shot only when eval failures show benefit;
- examples must not contradict instructions.

#### System / contextual / role separation
Status: VALID.
Useful for separating stable policy, task context and user intent. Must remain aligned with instruction precedence.

#### Step-back prompting
Status: USEFUL HEURISTIC.
Useful where solving the concrete question benefits from first identifying governing principles or abstraction. Do not force it on trivial tasks.

#### Self-consistency / multiple candidates
Status: USEFUL BUT COSTLY.
Generating multiple independent solutions and comparing/voting can improve reliability for some tasks, but increases cost/latency. Nexia should trigger only for high-value uncertainty or material decisions.

#### Tree of Thoughts
Status: RESEARCH / SELECTIVE USE.
The core concept—explore multiple candidate paths and score them—is useful for search/planning, but full ToT prompting is often unnecessary with modern reasoning models or tool-based planning. Prefer explicit candidate generation + evaluation when this adds measurable value.

#### ReAct
Status: STRONGLY VALID AS AGENT DESIGN PATTERN.
Current Google Cloud still documents ReAct-style reason/action/observation loops for agentic systems. Nexia already follows a related pattern through research/tool/action loops.
Important improvement: use bounded iterations, explicit exit criteria and tool-result verification.

#### Prompting for code
Status: VALID, but QA is more important than prose prompting sophistication.
Modern code workflows should emphasize tests, linting, CI, diff review and executable acceptance criteria. Prompting alone is insufficient.

### What requires correction for modern Nexia

#### `Chain of Thought = force the model to think step by step`
Status: DO NOT ADOPT AS UNIVERSAL RULE.
Reason:
- modern reasoning models already perform internal reasoning;
- current OpenAI reasoning guidance explicitly says prompts like `think step by step` are unnecessary and can sometimes hurt performance;
- current model guidance favors specifying end state, constraints, success criteria and verification while allowing the model to choose the reasoning path.

Nexia replacement rule:
`Do not request hidden reasoning as a quality mechanism. Request conclusions, evidence, checks, calculations, intermediate artifacts or concise rationale that are actually useful/verifiable.`

For non-reasoning models, explicit decomposition can still help. Therefore behavior must be MODEL-AWARE, not universal.

#### `Temperature = creativity knob`
Status: OVERSIMPLIFIED.
Temperature affects sampling randomness but is not a portable semantic `creativity` dial across every model/provider. Some modern reasoning/model APIs constrain or reinterpret sampling controls. Nexia should treat sampling parameters as model-specific configuration requiring evals.

#### Top-K / Top-P as universal tuning controls
Status: MODEL/PROVIDER SPECIFIC.
Do not bake into a generic Nexia prompt template. Only use if exposed and benchmarked for the selected model.

#### `Prompt engineering is not optional`
Status: DIRECTIONALLY TRUE, BUT PROMPTS ARE ONLY ONE LAYER.
For production-quality Nexia systems, model choice, context engineering, retrieval, tool design, structured outputs, evals, deterministic checks, permissioning, observability and recovery often matter more than wording tricks.

### Proposed Nexia Prompt Standard candidate
`NEXIA_PROMPT_EVAL_STANDARD`:
1. Define task and measurable success.
2. Select model based on task, not habit.
3. Start with simplest clear instruction.
4. Supply only relevant context with delimiters/structure.
5. Specify constraints and required output schema.
6. Specify evidence, tool-use and stopping behavior where material.
7. Run representative eval cases, including edge/adversarial cases.
8. Add examples/decomposition only when failures justify them.
9. Pin model/snapshot where production repeatability matters.
10. Re-run evals whenever model, prompt, tool or context pipeline changes.

Decision: STRONG ADOPT CANDIDATE AFTER FULL INTAKE.

## C. yt-dlp — yt-dlp/yt-dlp
Classification: VERIFIED ACTIVE TOOL / HIGH LOCAL MEDIA-INTAKE VALUE / RIGHTS-GATED.

Verified from repository README:
- feature-rich command-line audio/video downloader;
- supports thousands of sites;
- Python ecosystem with standalone binaries;
- repository currently uses the Unlicense for its code;
- supports subtitles, format selection, post-processing, metadata and embedding as a Python component.

Social-media claim assessment:
- `works with more than a thousand sites` is directionally/technically supported; current README says thousands of sites;
- `download any video` is FALSE/OVERBROAD. Site support, authentication, formats, geo/access restrictions, DRM, platform changes and rights all constrain capability;
- it is not a license to download content one does not have rights/permission to acquire.

Nexia applications:
- ingest user's own videos;
- download public/permitted reference media when lawful and platform-compatible;
- retrieve captions/subtitles/metadata where permitted;
- feed FFmpeg -> faster-whisper -> analysis pipelines;
- collect reproducible research inputs without relying on ad-heavy third-party downloader websites.

Hard boundaries:
- never bypass DRM, paywalls, private access controls, CAPTCHA, authentication restrictions or platform security;
- do not use it to mass-copy copyrighted content for redistribution;
- respect rights, license, terms and user authorization per source;
- prefer official APIs/download/export functions where they are required or materially safer.

Decision: STRONG LOCAL TOOLCHAIN CANDIDATE, RIGHTS-GATED.

## Net-new candidates from Batch 04

### CANDIDATE Q — NEXIA PROMPT EVAL STANDARD
Status: STRONG ADOPT CANDIDATE.
Replace static `prompt hacks` with test-driven, model-aware prompt engineering.

### CANDIDATE R — REASONING-PROMPT ROUTER
Status: STRONG ADOPT CANDIDATE.
Route prompting style by model/task:
- deterministic/simple model: explicit steps may help;
- reasoning model: outcome/constraints/success criteria first;
- agentic task: tool policy + exit criteria + verification;
- classification/extraction: schema + examples where needed.

### CANDIDATE S — LOCAL MEDIA INGESTION GATE
Status: STRONG CANDIDATE.
`authorized source -> yt-dlp/official export -> FFmpeg -> faster-whisper -> structured transcript/metadata -> Nexia analysis`, with rights/platform checks before acquisition.

### CANDIDATE T — VISUAL IDENTITY-PRESERVING EDIT STANDARD
Status: ADOPT.
Consolidate retouch, background, lighting, wardrobe and final-pass prompts into one composable image-edit spec with identity-fidelity QA.

## Current ranking from this batch
1. Prompt Eval Standard — high systemic leverage.
2. Reasoning-Prompt Router — high model-quality/cost leverage.
3. yt-dlp as rights-gated local ingestion — high multimedia/research leverage.
4. Visual editing spec consolidation — useful reusable quality standard.
5. Classic CoT/ToT techniques — retain as optional techniques, not canonical defaults.

## Stop rule
Do not implement broad prompt-system retrofit or install yt-dlp merely because this batch is promising. Continue current intelligence intake. When user declares dump complete, deduplicate Batches 01–04+ and create one consolidated adoption plan with experiments, benchmarks, dependencies, licensing and rollback.
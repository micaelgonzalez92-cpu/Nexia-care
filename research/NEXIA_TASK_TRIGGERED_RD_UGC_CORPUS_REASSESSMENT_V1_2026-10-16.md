# NEXIA TASK-TRIGGERED R&D — UGC CORPUS REASSESSMENT V1

Date: 2026-10-16
Status: READY_FOR_CURRENT_PURPOSE / RESEARCH + ARCHITECTURE / NO INSTALL / NO SPEND
Authority: GREEN internal research. Any installation, new account, paid API, model download, persistent service, publication or production remains separately gated.

## Trigger
Kael identified a process failure: Nexia had already received a large intelligence packet containing software, repos, APIs, agents, prompt patterns and research tools, but the active UGC blocker was researched externally without first re-querying that existing corpus. The weekly R&D radar must not substitute for task-triggered investigation.

## Process correction
The R&D operating standard is amended so that every material blocker/opportunity triggers:
`ACTIVE TASK -> EXISTING CORPUS -> CANONICAL NEXIA -> UPSTREAM VERIFICATION -> MAX 3 SHORTLIST -> COMPARE -> PROPOSE WITHOUT INSTALL -> GATE -> POC -> CAPTURE -> RESUME TASK`.

Task-triggered R&D is an interrupt supporting the active lane, not a fourth WIP lane.

## Existing corpus findings relevant NOW

### 1. Awesome Seedance / LearnPrompt — USE NOW, NO INSTALL
Kael's prior screenshot identified `LearnPrompt/awesome-seedance`. Upstream verification found a current repository with hundreds of verified video-prompt cases, cross-model retests, reusable templates and optional installable skills. We do not need to install the skill to use the public prompt structures.

High-value patterns for VETA-AI-UGC-001:
- second-by-second timeline: each timed segment gets one shot type, one main action and its own sound/dialogue;
- reference identity lock: assign stable reference tokens and declare separately what to inherit and what not to inherit;
- storyboard-grid-to-video: make ordered keyframes/panels own framing/order/timing; video generation only connects them;
- UGC creator review: lock PERSON and PRODUCT independently;
- structurally decompose the product into shape/material/color/parts/proportions;
- weld spoken lines to the exact action beat rather than putting dialogue in a detached section;
- avoid walking plus fine manipulation in the same beat;
- keep generated typography out of the video model; reserve clean frames and add text in post;
- printed labels are a known weak point; do not rely on macro text fidelity;
- end with deterministic hero beats where useful.

Decision: IMPLEMENT these principles into the Nexia UGC prompt compiler and test contract. Do not install the Seedance skill yet.

### 2. Prior image-edit prompt pack — USE NOW, NO INSTALL
The supplied screenshots already contained preservation-oriented edit patterns for professional retouching, cinematic grading, background replacement, portrait refinement and lighting correction.

Direct current value:
- explicit subject/product preservation contract;
- preserve identity/shape/proportions/pose/orientation/material/color;
- isolate the edited dimension;
- adapt perspective, illumination, shadows, depth and color temperature when changing environments;
- specify realism/failure exclusions.

Decision: preserve the already-preregistered Base/B1/B2 FLUX benchmark to avoid moving its goalposts. If it fails, the next preregistered iteration must use the stronger isolation/preservation pattern instead of improvising a new prompt after seeing the result.

### 3. Remotion — PROPOSE FOR BOUNDED POC AFTER THE FLUX EDIT GATE
Kael's prior screenshot identified `remotion-dev/remotion`. Upstream README describes agentic, interactive and programmatic video creation with code, design systems, batch rendering, captions, transitions and effects. Current license permits free commercial/noncommercial video creation for individuals and for-profit organizations up to 3 employees; larger for-profit organizations require a company license.

Why it matters to UGC:
- deterministic captions, CTA, graphics, layouts and transitions;
- reusable shot/template system;
- programmatic assembly means generative models no longer own text, timing and layout;
- compatible with our modular strategy: generated assets in, deterministic final edit out.

Decision: CANDIDATE_FOR_POC, NOT_INSTALLED. Do not install until the FLUX image-edit gate or another active assembly bottleneck proves the need and Kael approves the installation.

### 4. OpenShorts architecture — EXTRACT PRINCIPLES, DO NOT INSTALL
A current GitHub search surfaced an MIT/Docker UGC/short-video project whose README describes an AI-shorts pipeline using script generation, AI actor, TTS, talking-head video, B-roll, FFmpeg composition, captions and publishing.

Useful architecture principles:
- separate script/actor/voice/video/B-roll/composite stages;
- use faster-whisper/FFmpeg/OpenCV-style deterministic media tools around generative steps;
- keep publishing separate from creation;
- queue jobs and capture outputs.

Reasons not to install now:
- AI-UGC path relies on several cloud APIs and is not actually zero-cost;
- upstream/provenance needs stronger canonical verification before adoption;
- installing the entire stack would duplicate capabilities already present and create maintenance burden.

Decision: RESERVE_AS_ARCHITECTURE_REFERENCE.

### 5. Playwright / n8n / agent frameworks — SUPPORT, NOT CURRENT UGC BOTTLENECK
Prior corpus contains Playwright, n8n, OpenHands, Agno, AutoGen, Pydantic AI and LangGraph.
- Playwright remains a browser-QA candidate when repeated browser verification blocks progress.
- n8n remains the workflow layer already in use.
- Pydantic AI/LangGraph remain conditional agent-runtime candidates.
- OpenHands/AutoGen/Agno are not justified for the current UGC blocker merely because they are capable agent frameworks.

Decision: KEEP DEFERRED according to measured capability gaps.

## UGC prompt compiler — revised canonical structure
Future generative-video prompts should be compiled from a backend-neutral SHOT CONTRACT containing:
1. `SHOT_ID / DURATION / ASPECT`;
2. `PERSON_LOCK` when a person exists;
3. `PRODUCT_LOCK` independently, structurally decomposed;
4. `REFERENCE_TOKENS`;
5. `INHERIT_FROM_REFERENCE`;
6. `DO_NOT_INHERIT`;
7. `INITIAL_STATE / OBJECT_COUNT`;
8. exactly one `PRIMARY_ACTION` per beat unless validated otherwise;
9. `CAMERA_RULE`;
10. `ENVIRONMENT / LIGHT`;
11. dialogue inline with the beat where it is spoken;
12. `FINAL_STATE`;
13. `POST_ONLY_ELEMENTS` such as CTA typography/captions/logos when generative text is unreliable;
14. QA criteria and hard-fail conditions.

Then compile the same contract into backend-specific prompt syntax instead of pretending one universal prompt is optimal.

## Revised UGC build order
`REFERENCE/PROMPT INTELLIGENCE -> STILL GENERATION -> IMAGE EDIT FIDELITY -> STORYBOARD/KEYFRAMES -> DETERMINISTIC ASSEMBLY -> SIMPLE MOTION -> ADD ONE COMPLEXITY VARIABLE -> PROFESSIONAL QA`.

Generative video is no longer asked to own typography, captions, final CTA layout, multi-step editing or unnecessary physical interactions.

## Immediate shortlist for current bottleneck
1. **Awesome Seedance prompt corpus — IMPLEMENT NOW as knowledge, no install, EUR0.**
2. **Existing FLUX Image Edit — RUN the preregistered Base/B1/B2 gate, EUR0.**
3. **Remotion — PREPARE POC proposal only after an assembly bottleneck is demonstrated; do not install yet.**

Paid UGC APIs are not the current next action. They remain reserve backends only if the free/local/reference-first path proves insufficient.

## Stop condition
This research interrupt is complete when the process standard is updated, the prior corpus is incorporated into the UGC prompt architecture, and the active task resumes at the FLUX image-edit runtime gate. No broad tool collection continues beyond that decision.

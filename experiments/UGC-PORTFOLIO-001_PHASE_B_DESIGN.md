# UGC-PORTFOLIO-001 — Phase B Design

Status: DESIGNED / NOT EXECUTED
Date: 2026-10-13
Vein: VETA-AI-UGC-001
Cash spent: EUR0
Authority: internal design only; no model download, installation, generation, publication or external contact authorized by this artifact.

## Selection

Selected brief: CLEARNEST / home organization.

Reason:
- Phase A accepted pair A1=85 and A2=90, average 87.5/100, the highest pair average of the three validated briefs.
- The problem -> solution structure is immediately understandable in a short performance ad.
- It does not require a talking-head or lip-sync dependency, reducing technical risk and human effort for the first local video proof.
- Existing A1/A2 keyframes already provide usable visual anchors.

## Phase B objective

Design one 20-30 second vertical 9:16 SPEC performance ad that demonstrates an end-to-end creative concept from hook to CTA. Keep all claims fictional/non-regulated and label the final work SPEC / CONCEPT.

Target duration: 24 seconds.
Format: 9:16 vertical.
Language: Spanish.
Brand: CLEARNEST (fictional).
Primary angle: clutter -> simple organization -> immediate visual payoff.

## Three hook variants

H1 — direct insight:
`Pensaba que necesitaba más espacio. En realidad necesitaba esto.`

H2 — problem reframe:
`Si tu baño parece pequeño, quizá el problema no sea el espacio.`

H3 — everyday friction:
`Si cada mañana pierdes tiempo buscando lo mismo, mira esto.`

Primary hook for the first SPEC cut: H1.

## Voice-over script — target ~24s

`Pensaba que necesitaba más espacio. En realidad necesitaba ordenar mejor lo que ya tenía. Separé lo que uso cada día, lo puse en módulos transparentes y de repente todo estaba a mano. Menos caos, menos tiempo buscando cosas y el mismo baño de siempre. Empieza por un solo rincón.`

No medical, performance, financial or quantified product claims.

## Storyboard

### Shot 1 — 0.0-2.5s — Hook / problem
Visual: A1 clutter keyframe as anchor; subtle handheld push-in.
Caption: `¿Necesitas más espacio?`
VO: `Pensaba que necesitaba más espacio.`
Purpose: stop-scroll and establish pain immediately.

### Shot 2 — 2.5-6.0s — Friction detail
Visual: crop/detail of cluttered products, gentle pan or parallax; no invented readable labels.
Caption: `O quizá... mejor orden.`
VO: `En realidad necesitaba ordenar mejor lo que ya tenía.`
Purpose: reframe problem.

### Shot 3 — 6.0-11.0s — Transformation
Visual: transition into A2 solution frame; hand places item into transparent modular bin; restrained natural motion.
Caption: `Lo que uso cada día → a mano`
VO: `Separé lo que uso cada día, lo puse en módulos transparentes...`
Purpose: product/action demonstration.

### Shot 4 — 11.0-16.0s — Solution detail
Visual: slow lateral move across stacked transparent modules; product geometry must remain stable.
Caption: `Verlo. Cogerlo. Guardarlo.`
VO: `...y de repente todo estaba a mano.`
Purpose: visual proof without unsupported claims.

### Shot 5 — 16.0-20.5s — Before/after payoff
Visual: A1 -> A2 comparison using hard cut or split transition; no synthetic new claim required.
Caption: `Mismo espacio. Menos caos.`
VO: `Menos caos, menos tiempo buscando cosas y el mismo baño de siempre.`
Purpose: clear story resolution.

### Shot 6 — 20.5-24.0s — CTA
Visual: clean A2 crop with caption-safe negative space.
Caption: `Empieza por un solo rincón.`
Secondary footer: `CLEARNEST — SPEC CONCEPT`
VO: `Empieza por un solo rincón.`
Purpose: simple low-friction CTA.

## Audio design

- Voice: natural conversational Spanish voiceover; not influencer-hype.
- Music: optional low-volume neutral/upbeat bed; must be properly licensed before any publication.
- SFX: optional soft drawer/bin placement sounds.
- Lip-sync: NOT REQUIRED for this selected concept.

## Motion/video strategy

Preferred first proof: image-to-video from accepted A2 because it contains the central interaction and strongest product demonstration.

Desired motion:
- subtle camera push/lateral movement;
- small natural hand/item movement;
- no dramatic camera orbit;
- preserve transparent-bin shape, hand anatomy and bathroom geometry;
- avoid creating readable package text.

Fallback if hand animation is unstable:
- animate only camera/parallax around A1/A2 and use editorial cuts rather than forcing object manipulation.

## Technical route — researched, not executed

Candidate: LTX-Video 2B v0.9.5 in stock ComfyUI image-to-video workflow.

Current official ComfyUI template references:
- `ltx-video-2b-v0.9.5.safetensors` (~5.91-6.34 GB depending displayed packaging/accounting);
- `t5xxl_fp16.safetensors` (~9.12 GB) as text encoder;
- core `LTXVImgToVideo`, no custom-node requirement in the template.

License note:
- v0.9.5 uses an Open RAIL-M license permitting commercial use subject to the stated use restrictions.
- do NOT substitute the older v0.9 checkpoint for commercial portfolio work; that older license was academic/research-only.

Local compatibility is NOT VERIFIED on the RTX 3060 12GB / ~16GB RAM machine. Model download size is not runtime-memory proof.

## Phase B execution gate

No full 24s ad should be attempted first. Execute UGC-VIDEO-001 minimal local image-to-video benchmark first if separately authorized.

Promotion to full Phase B assembly only if UGC-VIDEO-001 passes its preregistered technical/quality gate.

## Commercial truth

This storyboard is DESIGN only. Phase A validated still-keyframe production. Nothing here proves local video generation, buyer demand, publication, sales, settled payment or profit.

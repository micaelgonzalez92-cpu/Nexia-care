# UGC-PORTFOLIO-001 — Local AI creative portfolio experiment

Status: PREPARED / NOT EXECUTED
Date: 2026-10-12
Vein: VETA-AI-UGC-001
Cash budget: EUR0
Local engine: ComfyUI + FLUX.2 Klein 4B FP8 (single-run runtime PASS already verified)

## Purpose

Convert verified local image generation into commercial evidence for AI-UGC/performance-creative services without pretending prior client work, publishing externally, contacting buyers or spending money.

## Market evidence informing the experiment

Recent buyer briefs repeatedly ask for vertical 9:16 performance creatives, UGC-native look, multiple hooks/variants, problem-solution structure, product demonstrations, CTA, AI-generated people/voices/assets and portfolios of ad work. A recent restaurant-SaaS brief asks for three initial UGC videos, 20-40s, with 2-3 hooks per video, while providing scripts/ideas/platform access/identity/assets. This experiment therefore tests ad-native keyframe production, not generic art.

## Hypothesis

Using the already-installed local FLUX stack, Nexia can produce commercially plausible keyframes for at least 2 of 3 spec-ad concepts at EUR0 cash cost, with bounded iteration and enough visual quality to justify a later video/lipsync phase.

## Phase A — image/keyframe test

Generate exactly 2 candidate keyframes for each of 3 fictional-brand briefs (6 accepted-keyframe targets total). Do not publish them. Do not present them as client work.

### Brief A — CLEARNEST / home organization

Category: non-chemical home organization.
Angle: problem -> satisfying organization transformation.
Audience: adults 25-45, small apartment/bathroom/kitchen storage frustration.
Keyframe A1: native smartphone-style vertical scene showing cluttered vanity/under-sink space, realistic home, no brand logos, no embedded text, obvious visual problem, safe top/bottom space for later captions.
Keyframe A2: same visual language after organization using clear modular stackable bins, realistic hand placing an item, product visibly understandable, clean but not luxury-studio polished, no embedded text.
Potential hook later: "Pensaba que necesitaba más espacio. En realidad necesitaba esto."

### Brief B — SPINTRAY / rotating beauty organizer

Category: non-cosmetic beauty accessory.
Angle: fast visual demonstration / mess-to-access.
Audience: beauty users with crowded vanity.
Keyframe B1: UGC-style close shot of crowded makeup/skincare surface with a simple rotating organizer as hero object, no readable third-party labels or logos, realistic phone-camera aesthetics.
Keyframe B2: human hand rotating/reaching into the organizer, natural bathroom/bedroom lighting, product geometry preserved, clear demonstration, vertical social-native framing, no embedded text.
Potential hook later: "Si tardas más en encontrarlo que en usarlo, mira esto."

### Brief C — TABLEFLOW / fictional restaurant SaaS

Category: SaaS for restaurant operations.
Angle: creator recommendation + product-screen handoff.
Audience: restaurant owner/manager.
Keyframe C1: believable Spanish creator/presenter in a real-looking small restaurant, direct-to-camera selfie framing, approachable not influencer-glam, holding a phone, no logos, no embedded text.
Keyframe C2: over-shoulder/product-demo composition with phone/laptop screen deliberately clean/neutral for later compositing of UI; restaurant context visible; avoid fake readable interface copy.
Potential hook later: "Si llevas reservas, carta y llamadas por sitios distintos, esto te interesa."

## Generation constraints

- Internal/spec use only.
- Fictional brands only.
- No embedded logos, slogans or UI text; add typography later in editing.
- No medical, health, financial or regulated claims.
- Preserve realistic hands/objects when interaction is central.
- Prefer natural phone-camera/UGC aesthetics over polished stock-photo aesthetics.
- Keep safe zones for later 9:16 captions/CTA.
- Do not use a real buyer's proprietary assets or copy their branding.

## Phase A quantitative gate — fixed before execution

Maximum generation attempts: 18 total (max 6 per brief).
Accepted-keyframe target: 6 (2 per brief).
PASS requires:
- at least 4/6 accepted keyframes overall;
- at least 2 briefs with both keyframes accepted;
- every accepted frame >=75/100 QA;
- no hard fail;
- median attempts per accepted frame <=3;
- total measured human steering/review time <=60 minutes.

FAIL if:
- fewer than 4 accepted frames after 18 attempts;
- fewer than 2 briefs produce a complete 2-frame pair;
- median attempts/accepted frame >3;
- human steering/review >60 minutes;
- repeated geometry/hand/product-consistency defects make the assets unsuitable for ad production.

Do not change thresholds after execution.

## QA score — 100 points

- Realism / absence of obvious AI defects: 20
- Prompt and product fidelity: 20
- 9:16 ad-native composition: 15
- Commercial/story utility: 15
- Human/product interaction correctness: 10
- Pair consistency within brief: 10
- Editing headroom / caption-safe zones: 5
- Brand/policy safety: 5

Accepted frame: >=75/100 and no hard fail.

Hard fails:
- central hand/body deformation materially visible;
- impossible or inconsistent product geometry;
- product identity changes between paired frames;
- illegible pseudo-text presented as real UI/brand copy;
- accidental real-brand/trademark prominence;
- unsafe/regulatory claim;
- composition unusable for vertical ad adaptation.

## Phase B — only if Phase A passes

Select the strongest brief and build one 20-30s SPEC ad storyboard with 3 hooks, voice/script, captions, CTA and an explicit plan for motion/lipsync/video. Phase B may require a separate tool/installation/generation authorization and is NOT authorized by this preparation.

## Commercial truth

This experiment is portfolio validation, not demand validation. Even a PASS does not prove willingness-to-pay, sale, payment or profit. Portfolio pieces must be labeled SPEC / CONCEPT and never represented as prior client work.

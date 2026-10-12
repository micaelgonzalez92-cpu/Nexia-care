# UGC-PORTFOLIO-001 — Prompt Pack

Status: PREPARED / NOT EXECUTED
Engine target: ComfyUI + FLUX.2 Klein 4B FP8
Purpose: generate Phase-A spec-ad keyframes reproducibly.

## Global prompt suffix

Use this suffix on every prompt unless the local workflow already enforces equivalent constraints:

`vertical 9:16 social ad composition, realistic smartphone camera look, natural imperfect lighting, believable consumer environment, commercially useful framing, no embedded text, no visible brand logos, no watermark, no surreal styling, realistic anatomy, realistic hands, realistic object geometry, natural colors, leave safe negative space for later captions and CTA`

Negative intent to enforce through workflow/prompting where supported:

`deformed hands, extra fingers, fused fingers, broken anatomy, duplicated objects, warped product geometry, fake readable text, gibberish UI, logos, watermark, overpolished stock-photo look, hyperglam influencer aesthetic, surrealism`

## Brief A — CLEARNEST

### A1 — Problem frame

`A realistic small apartment bathroom vanity and under-sink storage area that looks genuinely cluttered and frustrating, mixed everyday toiletries and household items placed messily but believably, no readable commercial labels, close smartphone-style angle as if filmed for a social media problem-solution ad, obvious lack of organization, natural indoor morning light, relatable middle-income home, no luxury styling, visual problem immediately understandable`

Append global suffix.

### A2 — Solution/demo frame

`The same type of small apartment bathroom storage scene now organized using simple transparent modular stackable storage bins, one realistic human hand placing a small everyday item into a clear bin, product shape and proportions physically plausible and easy to understand, satisfying but believable transformation, natural home lighting, smartphone social-ad framing, not a studio product shot, the organizer is clearly the hero but the environment remains real`

Append global suffix.

## Brief B — SPINTRAY

### B1 — Crowded vanity / hero product

`A realistic bedroom or bathroom vanity crowded with generic makeup and skincare containers with no readable labels, a simple transparent rotating organizer placed naturally among them as the visual hero, phone-camera close shot made for a TikTok or Instagram style ad, natural household lighting, relatable everyday mess, organizer geometry simple and physically plausible, no luxury beauty campaign styling`

Append global suffix.

### B2 — Demonstration interaction

`A close realistic social-media ad shot of a human hand rotating a transparent circular beauty organizer on a real bathroom or bedroom vanity and reaching for one generic skincare item, believable hand anatomy, physically consistent rotating organizer, natural motion-implied composition, everyday home background, soft natural light, product function obvious from one frame, no readable third-party labels`

Append global suffix.

## Brief C — TABLEFLOW

### C1 — Creator recommendation frame

`A believable Spanish restaurant owner or small-business creator in their 30s to 40s standing inside a real modest independent restaurant during quiet service hours, direct-to-camera selfie composition, holding a smartphone naturally, approachable competent expression, casual neat clothing, authentic small restaurant environment with tables and counter visible, not glamorous and not influencer-styled, looks like a native UGC recommendation video frame`

Append global suffix.

### C2 — Product-demo handoff frame

`Over-the-shoulder realistic restaurant operations scene showing the same kind of creator using a smartphone and laptop at a restaurant counter, device screens intentionally clean and visually neutral with no fake readable interface text so a SaaS UI can be composited later, restaurant context clearly visible, believable workflow moment, smartphone-ad framing, natural indoor restaurant light, professional but not corporate stock photography`

Append global suffix.

## Fixed execution protocol

1. Generate one candidate at a time.
2. Log brief/frame ID, attempt number, seed, generation time, and accept/reject.
3. Do not exceed 6 attempts per brief or 18 total.
4. Do not edit the QA thresholds after seeing outputs.
5. If a frame has a hard fail, reject it regardless of aesthetics.
6. Stop early only if PASS is mathematically secured with all required complete brief pairs, or if FAIL becomes unavoidable under remaining attempt budget.
7. Keep all outputs private/local until a later explicit publication authorization.

## QA record template

For each candidate record:

- ID: A1/A2/B1/B2/C1/C2
- Attempt: n
- Seed: n
- Generation time: seconds
- Realism: /20
- Prompt/product fidelity: /20
- 9:16 ad composition: /15
- Commercial/story utility: /15
- Human/product interaction: /10
- Pair consistency: /10
- Editing headroom: /5
- Brand/policy safety: /5
- Total: /100
- Hard fail: YES/NO + reason
- Decision: ACCEPT/REJECT
- Notes: max 2 lines

## Truth rule

These are SPEC concepts. Never label or present them as paid client work. A successful Phase A validates a local keyframe-production workflow only; it does not validate buyer demand, video production, sales or profit.

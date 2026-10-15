# NEXIA — EXTERNAL AI INTELLIGENCE BATCH 03

Date: 2026-10-15
Status: PROVISIONAL_RESEARCH / PARTIALLY VERIFIED / MORE USER BATCHES EXPECTED
Source: two consecutive user-provided image batches not yet consolidated: (A) DownSub, VirusTotal, Temp-Mail, BandLab, Worse on Purpose + image-edit prompt patterns; (B) rembg, faster-whisper, FFmpeg, OBS Studio, Remotion, Playwright, n8n, Supabase, Excalidraw, AutoHedge.

## Executive conclusion
This batch contains several high-leverage capabilities for Nexia, but only a subset should become near-term architecture candidates.

Highest-value candidates:
1. Playwright for deterministic browser QA and reproducible end-to-end testing.
2. faster-whisper for local transcription with word-level timestamps.
3. FFmpeg as a deterministic local media-processing substrate.
4. rembg as a local background-removal utility, subject to model-license verification.
5. VirusTotal as a security triage surface with a strict prohibition on uploading confidential/private material to public scanning.
6. Remotion for programmatic video/content generation, but only under verified license eligibility and if VELA/content becomes active enough to justify it.

Already present / reinforce:
- n8n is already a verified Nexia core capability; no stack change needed.

Deferred/conditional:
- Supabase only when a real product requires relational database/auth/storage beyond current GitHub/Data Table needs.
- OBS useful for human demos/recording, not core architecture.
- Excalidraw useful but duplicative with existing diagram surfaces.
- BandLab only if music/audio becomes an active Reality Loop.
- Worse on Purpose only as market-signal input, never as sole authority.
- DownSub only for permitted/public transcript extraction when better first-party paths are unavailable.
- Temp-Mail should not be operationalized for bypassing signup, account, identity, trial or platform controls.
- AutoHedge should NOT be connected to real capital/wallets; research-only architecture pattern unless a future explicitly authorized simulation study is justified.

## A. Utility / research / content sources from prior unclosed block

### DownSub
Classification: LOW-PRIORITY UTILITY / RIGHTS AND PLATFORM-CONSTRAINT DEPENDENT.
Claim: can extract subtitles/transcripts from supported video URLs.
Application:
- potentially useful for public/permitted content analysis;
- prefer first-party transcripts, official captions, creator-provided text, or lawful APIs when available;
- do not use to bypass access controls, DRM, paywalls, private content or copyright restrictions.
Decision: RESERVE / NO INTEGRATION.

### VirusTotal
Classification: HIGH-VALUE SECURITY TRIAGE WITH PRIVACY HAZARD.
Verified behavior: public submissions are scanned by many engines and results/samples can be shared with partners/community/premium security users.
Critical Nexia rule:
- NEVER upload credentials, private client data, proprietary source, personal documents, secrets or commercially sensitive files to public VirusTotal scanning;
- hash/URL lookups are safer where they avoid uploading confidential payloads;
- private scanning is a separate paid capability and is not authorized by default.
Decision: ADOPT AS SECURITY CHECK SURFACE WITH STRICT DATA-CLASSIFICATION GATE.

### Temp-Mail
Classification: REAL SERVICE / HIGH MISUSE AND CONTINUITY RISK.
Potential legitimate use: testing email flows in systems we own where disposable inboxes are permitted.
Not acceptable for Nexia:
- bypassing account limits, trials, identity checks, platform controls, KYC or service terms;
- durable project accounts;
- any workflow that would make account recovery unreliable.
Decision: DO NOT ADOPT AS GENERAL ACCOUNT INFRASTRUCTURE. Prefer local test mailboxes or sandboxed test addresses for QA.

### BandLab
Classification: VERIFIED CLOUD DAW / CONDITIONAL RELEVANCE.
Current product supports browser/mobile recording, editing and mixing. Useful only if audio/music production becomes active in VELA/content.
Decision: RESERVE; NO CURRENT WIP.

### Worse on Purpose
Classification: EDITORIAL / MARKET-SIGNAL SOURCE, NOT PRIMARY EVIDENCE.
Useful for:
- discovering product-quality degradation, ownership changes, consumer pain, private-equity rollups and category shifts;
- generating hypotheses for market research.
Limit:
- claims require primary-source verification (ownership filings, manufacturer data, regulations, company disclosures, etc.) before Nexia treats them as fact.
Decision: ADD AS OPTIONAL MARKET-INTELLIGENCE SENSOR.

## B. Image-edit prompt patterns
The user supplied prompt patterns for:
- identity-preserving retouching;
- cinematic color grading;
- background replacement;
- luxury editorial portrait enhancement;
- lighting correction.

Assessment: useful prompt/QA patterns, not factual sources.
Nexia application:
- incorporate into an IMAGE EDITING SPEC library;
- preserve identity, pose, proportions and clothing unless explicitly authorized otherwise;
- require realistic skin texture, coherent lighting/perspective and post-edit QA;
- use source-image editing rather than generating a lookalike when identity fidelity is material.
Decision: ADOPT AS PROMPT/QA PATTERN, not as system architecture.

## C. Open-source / developer stack

### rembg — danielgatis/rembg
Classification: VERIFIED ACTIVE TOOL / HIGH UTILITY.
Verified capabilities:
- local background removal;
- CLI, Python library, HTTP server, Docker;
- batch processing;
- MIT-licensed application code.
Important licensing caveat:
- model weights have their own licenses. Current default BRIA RMBG-2.0 model is documented by rembg as requiring a paid agreement for commercial use; therefore `rembg is MIT` does NOT imply every bundled/default model is commercially free.
Nexia applications:
- product-photo cleanup;
- portfolio assets;
- social/content composition;
- local preprocessing before design/image generation.
Decision: STRONG ADOPT CANDIDATE, but choose and record a commercially compatible model before production use.

### faster-whisper — SYSTRAN/faster-whisper
Classification: VERIFIED ACTIVE TOOL / HIGH UTILITY.
Verified:
- CTranslate2 reimplementation of Whisper;
- documented speed/memory advantages versus openai/whisper in project benchmarks;
- 8-bit quantization options;
- word-level timestamps supported;
- VAD support.
Nexia applications:
- local transcription of user voice/video inputs;
- competitor/video analysis where rights permit;
- content caption generation;
- timestamped transcript pipelines;
- reducing dependence on paid transcription APIs.
Decision: STRONG ADOPT/TEST CANDIDATE.

### FFmpeg
Classification: VERIFIED MATURE MULTIMEDIA INFRASTRUCTURE / VERY HIGH UTILITY.
Verified capabilities include decode/encode/transcode/mux/demux/filter/stream and media probing across platforms.
Nexia applications:
- deterministic video/audio conversion;
- trimming, resizing, compression, extraction, concatenation;
- normalization before transcription;
- render post-processing;
- reusable media pipeline primitives.
Decision: ADOPT AS DEFAULT LOCAL MEDIA SUBSTRATE if environment availability is verified.

### OBS Studio
Classification: VERIFIED FREE/OPEN-SOURCE RECORDING + STREAMING TOOL.
Useful for:
- recording product demos;
- capturing human walkthroughs and evidence;
- multi-source screen/audio capture.
Limit: mostly human-operated; not a substitute for deterministic automated browser/video testing.
Decision: USE AS HUMAN DEMO/EVIDENCE TOOL WHEN NEEDED; NOT CORE AUTOMATION.

### Remotion
Classification: VERIFIED PROGRAMMATIC VIDEO PLATFORM / HIGH POTENTIAL WITH LICENSING CONDITIONS.
Strength:
- React/TypeScript-based programmatic video and reusable templates;
- suitable for captions, motion graphics and deterministic branded content.
Critical correction to social-media framing:
- Remotion is not universally free for all commercial organizations/use cases. Current licensing is free for individuals and organizations up to 3 people, while larger organizations and certain automated product uses can require paid licensing.
Nexia applications:
- VELA/content pipeline;
- automated reels/case-study videos;
- deterministic portfolio/demo video templates.
Decision: CONDITIONAL ADOPT. Verify current eligibility/license before material production use.

### Playwright — microsoft/playwright
Classification: VERIFIED, MATURE BROWSER AUTOMATION / VERY HIGH NEXIA RELEVANCE.
Verified capabilities:
- browser automation/testing across Chromium, Firefox and WebKit;
- form interactions, screenshots, assertions, device/browser coverage.
Nexia applications:
- deterministic functional testing of local prototypes and web assets;
- regression tests before publication;
- screenshot evidence;
- replacing fragile manual/browser QA where permitted;
- stronger successor/complement to the current bounded Chrome DevTools local bridge.
Authority boundary:
- browser automation in test/local/read-only contexts can be GREEN/YELLOW;
- login, submission, publication, purchase, external contact or other material side effects remain gated exactly as today;
- never bypass CAPTCHA/2FA/anti-bot/access controls.
Decision: TOP SYSTEM-LOOP CANDIDATE for controlled adoption/testing after current intelligence intake.

### n8n — n8n-io/n8n
Classification: VERIFIED / ALREADY CORE NEXIA CAPABILITY.
Current reality:
- Nexia already has tested n8n 2.42.6 workflows and persistent Data Table dedup evidence.
Correction to screenshot:
- Community Edition can be self-hosted without a cloud subscription for permitted internal use, but this does not mean zero total cost: infrastructure, model/API calls, maintenance and license scope still matter.
- n8n uses a Sustainable Use License/fair-code model rather than unrestricted OSI open source for all commercial scenarios.
Decision: REINFORCE, DO NOT RE-ADOPT.

### Supabase
Classification: VERIFIED BACKEND PLATFORM / HIGH POTENTIAL BUT CURRENTLY NON-CRITICAL.
Verified:
- managed Free plan exists with bounded quotas;
- self-hosting is supported;
- provides Postgres/database, auth and storage capabilities.
Corrections:
- `free plan` is bounded, not unlimited;
- self-hosting moves infrastructure/ops cost to us; it is not automatically zero-cost.
Nexia application:
- strong candidate when a real product requires user auth, relational data, row-level access, file storage or an application backend.
Current constraint:
- adding it now would duplicate capability before a concrete product need exists.
Decision: RESERVE / ARCHITECTURE OPTION, NOT CURRENT WIP.

### Excalidraw
Classification: VERIFIED OPEN-SOURCE DIAGRAMMING TOOL / USEFUL BUT DUPLICATIVE.
Verified:
- local development and self-hosting supported;
- embeddable React component;
- self-hosted collaboration has limitations.
Nexia application:
- architecture sketches, process maps and explanatory diagrams.
Current reality:
- Nexia already has other diagram surfaces/tools; no need to add a second stack without a requirement.
Decision: RESERVE.

### AutoHedge — The-Swarm-Corporation/AutoHedge
Classification: REAL REPOSITORY / HIGH-RISK / MARKETING CLAIMS NOT FULLY VERIFIED.
README claims an enterprise-grade autonomous hedge fund with Solana execution, multi-agent roles and wallet-key based trading.
Counterevidence:
- an open 2026 issue reports a gap between README claims and observed packaged behavior: manual/analysis flow available, but full autonomous Solana execution was not clearly wired/documented in the tested release.
- project history is relatively small versus the strength of its `enterprise-grade autonomous hedge fund` wording.
Nexia value:
- potentially useful as a research example of role-separated agents: Director -> Quant -> Risk -> Execution;
- useful for studying structured outputs, logging and explicit risk role separation.
Nexia prohibition/default:
- do NOT provide wallet private keys;
- do NOT connect brokerage/exchange accounts;
- do NOT place real trades;
- do NOT treat repository marketing as evidence of profitable or production-safe trading.
Any real-capital use would be RED/high-risk and is outside current Nexia authorization.
Decision: RESEARCH ARCHITECTURE ONLY / NO LIVE FINANCIAL EXECUTION.

## Proposed additions to Nexia architecture after full intake

### CANDIDATE K — LOCAL MEDIA TOOLCHAIN
faster-whisper + FFmpeg + optional rembg + optional Remotion.
Purpose: turn audio/video/image inputs into local, deterministic, reusable assets with lower recurring external cost.
Status: STRONG CANDIDATE.

### CANDIDATE L — BROWSER QA STANDARD WITH PLAYWRIGHT
Purpose: automated end-to-end verification of local/web prototypes, screenshots and regressions before public release.
Status: TOP CANDIDATE.

### CANDIDATE M — SECURITY SCAN DATA-CLASSIFICATION GATE
Purpose: explicitly prevent confidential/private artifacts from being sent to public malware-analysis services; prefer hashes/local scanners when appropriate.
Status: ADOPT.

### CANDIDATE N — BACKEND ESCALATION RULE
Default: do not add Supabase until a concrete application requires database/auth/storage beyond current primitives. When triggered, compare Supabase vs lighter alternatives by reliability, cost, operational burden, privacy and recovery.
Status: ADOPT AS DECISION RULE.

### CANDIDATE O — PROGRAMMATIC CONTENT RENDERING
Use Remotion only when repeated video production is active enough to justify template engineering and current licensing is verified.
Status: CONDITIONAL.

### CANDIDATE P — AGENT ROLE-SEPARATION STUDY
Study AutoHedge only as a role-separation example; compare against simpler deterministic/agent architecture. Never infer trading efficacy.
Status: RESEARCH ONLY.

## Priority ranking from this batch
1. Playwright — System Loop / QA / reliability.
2. FFmpeg — reusable media infrastructure.
3. faster-whisper — local multimodal knowledge intake.
4. rembg — image preprocessing and commercial media efficiency, license-gated per model.
5. VirusTotal policy — security improvement, with privacy safeguards.
6. Remotion — future VELA/content leverage, license/need dependent.
7. Supabase — future backend option.
8. OBS — evidence/demo tool.
9. Excalidraw — optional/duplicative.
10. BandLab / DownSub / Worse on Purpose — specialized sensors/utilities.
11. Temp-Mail — not general-purpose infrastructure.
12. AutoHedge — architecture research only, no capital execution.

## Current stop rule
Do not install, connect, publish, create accounts, or migrate current systems from this batch yet. Continue intake. After the user indicates the current intelligence dump is complete, perform cross-batch deduplication and produce one ranked retrofit plan with the smallest set of high-leverage experiments first.

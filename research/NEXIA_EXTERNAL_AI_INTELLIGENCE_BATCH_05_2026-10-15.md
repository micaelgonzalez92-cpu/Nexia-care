# NEXIA EXTERNAL AI INTELLIGENCE — BATCH 05
Date: 2026-10-15
Status: PROVISIONAL_RESEARCH / SOURCE_VERIFIED_WHERE_NOTED / NO_LIVE_TRADING_OR_EXTERNAL_MUTATION_AUTHORIZED

## Scope
Batch covering Vibe-Trading, Fincept Terminal, LibreChat, Open Generative AI (mislabelled in social post as “Open Higgsfield AI”), Open-LLM-VTuber, Claude Ads, Cloudflare Agentic Inbox, Camofox Browser, HyperFrames, and Xiaomi MiMo-V2.6-Pro.

## Executive decision
- ADOPT/EXTRACT PATTERNS NOW: Claude Ads safety/control-plane architecture; HyperFrames deterministic media-rendering concepts; MiMo-V2.6 as a benchmark/model-router candidate; Fincept/Vibe-Trading as read-only architecture/reference sources.
- PILOT LATER: LibreChat as optional self-hosted multi-provider research UI; HyperFrames vs Remotion benchmark; MiMo-V2.6-Distill-Qwen-9B local benchmark if hardware permits; Agentic Inbox design patterns.
- RESERVE: Open Generative AI, Open-LLM-VTuber.
- REJECT FOR NEXIA CORE USE: Camofox anti-detection/bot-evasion capabilities. Standard browser automation should not bypass anti-bot/CAPTCHA/access controls.
- FINANCIAL EXECUTION: Vibe-Trading/Fincept remain research/read-only. No live orders, wallets, broker writes, money-at-risk automation, or credential connection without a separate RED gate and explicit approved experiment.

## 1. Vibe-Trading — HKUDS/Vibe-Trading
VERIFIED: Public MIT repository, active 2026-10-15, focused on multi-agent trading/research/backtesting. Current repo is much more mature than the social card: built-in skill count has already moved beyond the “64 skills” claim in older social material; recent changelog references 88 built-in skills and extensive reliability fixes.
CRITIQUE: Social framing (“agents debate then trade”) overemphasizes autonomy. Repository history shows substantial effort around backtest correctness, credential redaction, reproducibility, live controls and unsupported-operation blocking.
NEXIA USE: Study its evidence-grounding, bounded live controls, immutable research snapshots, usage budgets, risk separation and backtest reproducibility. Do not copy finance claims or connect live execution.
DECISION: ARCHITECTURE REFERENCE / READ-ONLY.

## 2. Fincept Terminal
VERIFIED: Real Fincept-Corporation project. Open build includes financial analytics, 37 AI agents, 100+ connectors, paper trading and broker integrations. Current README uses AGPL-3.0 and states the public build ships monthly while daily work focuses on a private Enterprise edition.
FALSE/OVERSTATED SOCIAL CLAIM: “This does the same thing as Bloomberg” and “costs $0” are not acceptable Nexia claims. Bloomberg equivalence is unproven; data, API and LLM costs can remain, and commercial/service use has AGPL/trademark implications.
NEXIA USE: Read-only financial research/reference architecture and data-source discovery. No production dependency unless licensing and costs are reviewed.
DECISION: RESEARCH / RESERVE.

## 3. LibreChat
VERIFIED: Active self-hosted web application supporting major providers, local/custom endpoints, agents, MCP, RAG, code execution and multi-user auth.
CRITIQUE: “Every model, free, your data stays yours” is too broad. LibreChat itself is open source/self-hosted, but cloud provider API calls still transmit prompts/files to those providers and can incur provider costs. Full privacy requires local/self-hosted inference and correctly configured storage/tools.
NEXIA USE: Candidate multi-provider experimentation UI and independent research workbench; not a replacement for canonical Nexia state or ChatGPT project control.
DECISION: PILOT ONLY IF MULTI-MODEL ROUTING BECOMES A BOTTLENECK.

## 4. Open Generative AI (social card mislabeled “Open Higgsfield AI”)
VERIFIED: The repository shown is Anil-matcha/Open-Generative-AI, not a verified Higgsfield open-source repository. Current README advertises hundreds of image/video/audio models and local desktop/web UI, but uses Muapi.ai for many remote model calls and requires a Muapi access key.
CRITIQUE: “No subscription” does not mean zero inference cost; “files stay on your computer” is not generally true when remote generation APIs receive media/prompts. Its “unrestricted/no filters” marketing is not a Nexia requirement and should not weaken safety controls.
NEXIA USE: UI/workflow inspiration and model catalog discovery. Compare against ComfyUI/local pipelines before adoption.
DECISION: RESERVE / BENCHMARK, NOT CORE.

## 5. Open-LLM-VTuber
VERIFIED: Active project for hands-free voice interaction + Live2D with local and cloud LLM/TTS/ASR integrations. Project dependencies include OpenAI, Anthropic, ElevenLabs and other cloud services as well as local-capable components.
FALSE/OVERSTATED SOCIAL CLAIM: “Runs 100% offline” and “never forgets you” are configuration-dependent, not universal properties.
NEXIA USE: Potential avatar/voice interface R&D for VELA/content, not core reasoning or continuity.
DECISION: RESERVE.

## 6. Claude Ads — AgriciDaniel/claude-ads
VERIFIED: Real MIT project supporting 12 ad platforms with source-grounded audits, deterministic scoring, versioned JSON contracts, evals/tests, and capability-gated mutations. Current releases show 300+ catalogued checks rather than the social card’s older ~190/250 figure.
HIGH-VALUE PATTERNS FOR NEXIA:
- read-only by default;
- explicit capability discovery;
- pass/fail/unknown/not_applicable rather than treating unknown as failure/zero;
- one conductor owns final artifacts, workers return schema-valid bounded results;
- exact-operation approval, before/after diff, blast radius, ceilings, idempotency key, verification window and rollback before writes;
- no source => no current platform claim;
- no implementation+fixture+test => no capability claim;
- fresh-context verification and independent evaluator for release gates.
DECISION: ADOPT PATTERNS INTO NEXIA QUALITY/AUTHORITY RETROFIT AFTER CROSS-BATCH SYNTHESIS.

## 7. Cloudflare Agentic Inbox
VERIFIED: Real Apache-2.0 self-hosted email client running on Cloudflare Workers, with Durable Objects/SQLite, R2, Email Routing and AI agent. Current implementation auto-drafts replies but requires explicit confirmation before send.
CRITIQUE: Requires Cloudflare account/domain/services. Trust boundary is Cloudflare Access; current README notes no per-mailbox authorization inside a shared Access policy.
NEXIA USE: Strong architecture reference for ASSISTED email: read/search/draft automatically, SEND remains human-approved. Existing Gmail connector means no need to deploy now.
DECISION: EXTRACT DESIGN PATTERN; DO NOT DEPLOY YET.

## 8. Camofox Browser
VERIFIED: Real MIT anti-detection browser automation server with session isolation, proxy rotation, cookie import, VNC and Playwright-core integration.
NEXIA POLICY CONFLICT: Social pitch explicitly markets bypassing bot detection/anti-scraping. Nexia must not use anti-detection to bypass CAPTCHA, platform bot controls, access restrictions or terms-enforcement barriers.
NEXIA USE: None for stealth/bypass. Standard Playwright/CDP remains preferred for authorized QA and browser automation.
DECISION: REJECT FOR CORE / SECURITY NOTE.

## 9. HyperFrames — heygen-com/hyperframes
VERIFIED: Open-source HTML/CSS/media-to-video framework using browser capture + FFmpeg. Provides deterministic frame-based rendering; same input can produce identical output when determinism rules are followed, with Docker for stronger reproducibility.
NEXIA VALUE: Very high for programmatic explainers, product demos, data videos and repeatable social assets. Determinism enables visual regression tests and CI. Cleaner agent-native authoring surface than timeline editors.
NEXT TEST: Compare HyperFrames vs Remotion on one identical 15–30 s Nexia explainer: setup time, render speed, determinism, subtitle/layout control, artifact size, maintainability, CI fit and licensing.
DECISION: HIGH-PRIORITY YELLOW PILOT AFTER CURRENT RESEARCH INTAKE.

## 10. Xiaomi MiMo-V2.6-Pro
VERIFIED OFFICIAL: Released 2026-09-22. Native multimodal input (text/image/video/audio), text output, 1M-token context, tool calling, structured output, web search and caching. Xiaomi publishes open weights and technical resources. Official API pricing currently lists ~$0.435/M uncached input and ~$0.87/M output; free access is not a permanent general guarantee.
MODEL SIZE: Pro RL model is ~1.02T total parameters / 42B active; local deployment is therefore a major hardware task. Xiaomi also released MIT MiMo-V2.6-Distill-Qwen-9B (~18.8 GB weights), much more realistic as a local experiment.
NEXIA USE:
- add MiMo-V2.6-Pro to multi-model benchmark candidates for multimodal/agentic/coding tasks;
- test API only with explicit spend gate if non-free;
- potentially benchmark 9B distill locally against existing Qwen2.5-Coder/Ollama stack if hardware fit is verified.
DECISION: HIGH-VALUE R&D CANDIDATE, NOT DEFAULT MODEL UNTIL NEXIA EVALS.

## Cross-batch improvements triggered
1. CAPABILITY-GATED MUTATION CONTRACT — adopt Claude Ads-style discover→fixture-verify→live-read-verify→bounded-live-write states where applicable.
2. INDEPENDENT VERIFIER / FRESH-CONTEXT RELEASE GATE — strengthen current VERIFY/RE-VERIFY model.
3. MULTI-MODEL ROUTER + EVAL HARNESS — include MiMo alongside current model candidates; no model selected by reputation alone.
4. DETERMINISTIC MEDIA PIPELINE — benchmark HyperFrames against Remotion, reusing FFmpeg and visual QA.
5. PRIVACY TRUTH BOUNDARY — self-hosted UI ≠ local inference; external model/API calls must be disclosed and classified.
6. LICENSE/COST TRUTH BOUNDARY — open source ≠ zero operating cost or unrestricted commercial use.
7. BROWSER POLICY — standard Playwright/CDP for authorized tasks; reject anti-detection/bot-control bypass tooling.
8. FINANCIAL AGENT POLICY — architecture may be studied; real money/broker/wallet execution remains prohibited without explicit RED approval and dedicated risk controls.

## Stop condition
Do not retrofit every candidate yet. Continue intake until Kael finishes the current evidence dump, then deduplicate Batches 01–05, rank by system leverage and run only the minimum high-value experiments.
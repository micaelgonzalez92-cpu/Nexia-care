# NEXIA EXTERNAL AI INTELLIGENCE — SYNTHESIS V1

Date: 2026-10-15
Status: READY_FOR_CURRENT_PURPOSE / INTAKE_CLOSED / PRIORITIZED / NO_EXTERNAL_ACTION_EXECUTED
Inputs: Batches 01–07, AI Employee Stack Candidates V2, GitHub Tooling Radar, current Model C state and active commercial/reality-loop constraints.

## Executive decision
The image-intelligence round produced real value, but the dominant conclusion is **not** "install more tools". Nexia already has enough execution surfaces to make tool accumulation a potential source of complexity debt.

The highest-value output is a set of architecture/quality rules plus a small trigger-based tool queue.

### Top 3 system improvements from the full round
1. **CONTEXT ECONOMY + SOURCE AUTHORITY ROUTER** — minimize repeated/noisy context while preserving canonical truth, provenance and freshness; route research to the right source class instead of generic search.
2. **TEST-DRIVEN RELIABILITY CONTRACT** — deterministic shell by default; model/agent only where uncertainty justifies it; typed/structured outputs; capability-gated mutations; explicit unknown/not-applicable states; evals, independent verification, rollback and human approval for sensitive side effects.
3. **DETERMINISTIC BROWSER QA STANDARD** — Playwright/Playwright-MCP-style reproducible browser tests and screenshots for local/synthetic/read-only verification before public release, without anti-detection or access-control bypass.

### Current bottleneck after synthesis
The active bottleneck is **external reality, not missing infrastructure**: the Contra V4 public profile/media implementation is already prepared internally and requires Kael because it changes a public external account. Until that gate is crossed, adding agent frameworks or model providers has lower expected value than exposing the existing verified capability to the market.

## 1. Adopt now as standards/patterns — no new runtime required

### A. Context Economy & Knowledge Router
Canonical truth remains GitHub `NEXIA_STATE.json` + BOOT/LIVE/evidence artifacts. Derived memory/RAG/Obsidian/agent memory may accelerate retrieval but cannot silently override canonical state.

Operating rules:
- load minimum sufficient context;
- preserve source path/provenance/freshness;
- distinguish canonical vs derived vs ephemeral context;
- deduplicate stale/superseded context;
- read back material writes;
- measure recovery/retrieval failures before adding memory infrastructure.

### B. Source Authority Router
Research should first classify the question:
- primary/official docs, repos, standards, filings;
- research papers / structured evidence synthesis;
- market/community/social discovery;
- deterministic computation;
- direct observed reality.

Discovery sources generate hypotheses. Material facts require stronger evidence. For consequential claims, use a primary path plus independent countercheck where feasible.

### C. Workflow Economics Screen
Before building a commercial automation, test:
- frequency;
- economic/human cost;
- repeatability;
- measurability;
- failure severity;
- data/access availability;
- integration feasibility;
- privacy/compliance burden;
- human approval boundary;
- reversibility;
- buyer urgency/willingness to change.

This complements rather than replaces the current Model C scorecard.

### D. Agent Placement Rule
`deterministic code/workflow -> model judgment -> agentic planning -> multi-agent` is an escalation ladder, not a maturity ladder.

Use the simplest layer that passes the acceptance tests. Multi-agent architecture is not inherently better than one validated deterministic workflow.

### E. Prompt/Eval Standard
For material model-controlled behavior:
`GOAL + CONTEXT + CONSTRAINTS + SUCCESS CRITERIA + OUTPUT CONTRACT + EVIDENCE/STOP RULE`.

Then run representative/edge cases. Add examples, decomposition or additional agent layers only when measured failures justify them. Do not rely on hidden chain-of-thought requests as a quality mechanism.

### F. Capability-Gated Mutation Contract
Before an external/material write:
`discover capability -> verify fixture/synthetic behavior -> verify live read -> define exact mutation -> blast radius/ceiling -> idempotency -> approval -> execute -> verify postcondition -> rollback if needed`.

Unknown/not-instrumented remains distinct from fail/zero.

### G. Rights/privacy/license truth boundaries
- open source != zero operating cost;
- free chat != free API;
- self-hosted UI != local inference;
- MIT/Apache app code does not guarantee every model/data dependency is commercially free;
- public malware scanning must not receive confidential material;
- media/site ingestion remains rights/ToS dependent;
- no CAPTCHA/auth/paywall/DRM/anti-bot bypass;
- no copying protected web expression/code/assets under the label of reverse engineering.

## 2. Existing capabilities to reinforce, not duplicate

### n8n
Keep as current workflow/event spine. Nexia already has tested n8n and persistent dedup evidence. No CrewAI/LangGraph/Agno migration merely for novelty.

### GitHub canonical continuity
Keep as source of truth. Obsidian/Letta/RAGFlow are optional derived layers only if measured retrieval/context failures justify them.

### ChatGPT/Work/Codex/GitHub connectors
Benchmark proposed alternatives against these existing surfaces before adopting a new autonomous-coding, browser, UI or connector stack.

### Current artifact/design surfaces
Canva/Figma/Adobe/image generation/slides tooling mean Open WebUI, Open Design, Photopea and ppt-master are reserve tools unless a concrete deliverable demonstrates a gap.

## 3. Bounded technical experiments — trigger-based queue

These are prepared options, not simultaneous WIP.

### P1 — PLAYWRIGHT-MCP-POC-001
Trigger: a current browser prototype/QA task is blocked or requires repeated manual verification.
Test: local/synthetic/read-only navigation, DOM read, bounded form fill without submit, screenshot, assertion and regression replay.
Success: more reproducible verification and less custom maintenance than current browser bridge.
Cost target: EUR0.
Risk: low if local/read-only; all login/submission/publication effects remain separately gated.
Priority: **FIRST TECHNICAL POC after the current Reality Loop gate if still relevant.**

### P2 — CONTEXT-ECONOMY-POC-001
Trigger: fresh-chat recovery, retrieval recall, token/context overhead or manual re-explanation becomes measurable friction.
Test current GitHub recovery against a derived compact router/index; measure recovery time, precision, stale retrieval and context volume.
Success: lower recovery/context burden with zero truth conflicts.
Candidate tools only if needed: RAGFlow/Letta/derived Markdown index. Tool selection comes after baseline measurement.

### P3 — LOCAL-MEDIA-POC-001
Trigger: VELA/content/media analysis becomes active WIP.
Candidate chain: authorized source/export -> yt-dlp where lawful -> FFmpeg -> faster-whisper -> structured transcript/metadata; rembg/Remotion/HyperFrames only as task requires.
Success: deterministic reproducible media intake/rendering with lower recurring cost and clear rights provenance.

### P4 — DOCUMENT-INTELLIGENCE-POC-001
Trigger: real repeated buyer/system need for invoices/forms/contracts/scanned paperwork.
Candidate: PaddleOCR against built-in vision/other extraction on a bounded permitted corpus.
Measure: field accuracy, table/layout preservation, latency, local-resource cost, failure recovery and human correction time.

### P5 — OBSERVABILITY-POC-001
Trigger: Nexia has an instrumentable multi-call LLM/API runtime.
Candidate: Langfuse or equivalent.
Measure: trace completeness, eval integration, debugging time, cost attribution and privacy/operational burden.

### P6 — TYPED-AGENT-RUNTIME-POC-001
Trigger: an in-code agent/tool runtime is materially needed beyond n8n.
First candidate: Pydantic AI for typed structured contracts. LangGraph only if durable cycles/checkpoints/HITL are also needed.
Kill criterion: if deterministic code/n8n meets requirements more simply, do not adopt an agent framework.

### P7 — MOBILE-SUPERVISION-POC-001
Trigger: repeated human bottleneck classified as `NECESITAR ORDENADOR` where the only missing capability is supervising/controlling an already-authorized local coding agent.
Candidate: Codync.
Required checks before installation: credential storage, network exposure, permission boundaries, auditability, kill switch, recovery and comparison with existing mobile ChatGPT/Codex surfaces.

## 4. High-value reserve candidates
- **changedetection.io**: recurring public page/competitor/regulatory change monitoring.
- **Crawl4AI**: structured public web ingestion when normal search is insufficient.
- **Scrapling**: permitted extraction fallback only; stealth/bypass functions excluded.
- **PaddleOCR**: structured document workloads.
- **HyperFrames vs Remotion**: deterministic programmatic video when repeated content production justifies template engineering.
- **RAGFlow**: derived knowledge retrieval when baseline retrieval is measurably deficient.
- **LiteLLM**: model gateway when multi-provider routing/cost/fallback becomes real.
- **Letta**: episodic agent memory only, never canonical truth.
- **OpenHands**: autonomous engineering benchmark only if current Codex/Work flow is insufficient.
- **Codync**: mobile human-leverage option.
- **MiMo and alternative Chinese/global models**: model benchmark radar, not default infrastructure.

## 5. Defer by overlap / insufficient need
CrewAI, Agno, AutoGen, Open WebUI, LibreChat, Composio, Supabase, Excalidraw, OBS, Photopea, Open-LLM-VTuber, Open Generative AI and most mobile utility apps.

Reason is not that they are bad tools. Reason is **no measured unmet capability currently justifies their integration cost and maintenance surface**.

## 6. Reject / prohibited use
- 12ft Ladder or equivalent for paywall bypass.
- Camofox/stealth browser features for bot-detection or platform-control evasion.
- Temp-mail for trial/account/identity/control bypass.
- real-money AutoHedge/Vibe-Trading/Fincept autonomous execution without a dedicated RED financial-risk experiment.
- downloading/copying protected media without rights/permission.
- website cloning that copies protected code, expression, branding, assets or impersonates the source.
- fabricated client prices, ROI, testimonials, KPIs or results from social cards.

## 7. Commercial opportunity lessons
The strongest commercial signal across the round is not a particular repo. It is the pattern:
`observable expensive workflow -> diagnosis -> minimal bounded capability -> paid pilot -> measure -> expand`.

Open-source software can reduce build cost, but it does not create willingness to pay. Claims such as "$4k monitoring", "$6k website", "$10k leads" or "$12k paperwork" remain hypotheses until Nexia obtains actual buyer evidence, accepted offer and settled cash.

For EXP-AUTO-001 this strengthens the existing positioning: buyer outcome first, reliability/data quality second, technology stack third.

## 8. Portfolio implications
Potential future Reality Loop families, only when evidence justifies them:
1. Lead intake / CRM data reliability — ACTIVE current probe.
2. Document intake / structured paperwork automation — OPTION.
3. Website/market change intelligence — OPTION.
4. Public-data lead/research extraction — OPTION, rights/ToS controlled.
5. Programmatic media/content systems — OPTION via VELA when WIP allows.

Do not activate all five. WIP remains bounded.

## 9. Priority after full intake
### SYSTEM LOOP
Maintain existing quality/recovery work and make the new router/eval/mutation rules apply-on-touch. Do not launch a framework migration.

### REALITY LOOP
The next material step is the already-prepared Contra V4 public implementation and then measured channel exposure. It is blocked by human authority, not engineering.

### RESEARCH OPTION
Keep `PLAYWRIGHT-MCP-POC-001` as first technical experiment after the commercial gate, unless a newer measured bottleneck outranks it.

## 10. Stop rationale
The research round is now `READY_FOR_CURRENT_PURPOSE`:
- intake closed;
- duplicates collapsed;
- unsafe/illegal patterns excluded;
- high-value principles extracted;
- tool candidates ranked by trigger rather than popularity;
- bounded experiment queue defined;
- current system/reality bottleneck identified.

Further broad tool research has lower expected value than crossing the current external-reality gate. Resume research only when a concrete capability gap, buyer signal or new evidence creates a named decision.
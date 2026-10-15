# NEXIA EXTERNAL AI INTELLIGENCE — BATCH 07

Date: 2026-10-15
Status: INTAKE_CLOSED / VERIFIED_WHERE_NOTED / NO_EXTERNAL_ACTION_AUTHORIZED

## Scope
Final unclosed material from Kael's image-intelligence round: AI-employee frameworks, commercially framed open-source repos, Chinese/alternative AI platforms, mobile utilities, Codync, Photopea, paywall-bypass content and repeated image-edit patterns.

## Truth boundary
Social-media cards are discovery signals. Their claimed client prices, savings, star counts, "free" status, production readiness and replacement value are not accepted as Nexia facts without independent evidence. A repo license also does not prove commercial demand or delivery economics.

## 1. AI-employee framework carousel
The detailed registry is maintained in `research/NEXIA_AI_EMPLOYEE_STACK_CANDIDATES_2026-10-15.md` V2.

Verified material signals:
- CrewAI: active MIT multi-agent framework.
- Letta: active Apache-2.0 stateful-agent/memory platform.
- Browser Use: active MIT browser-agent project; no Nexia use of stealth to bypass controls.
- OpenHands: current canonical repo is `OpenHands/OpenHands`, MIT, active 2026-10-15.
- Agno: active Apache-2.0 agent platform.
- Microsoft AutoGen: real public framework; maintenance/license must be revalidated before adoption.
- Pydantic AI: active MIT typed agent framework; high-value design signal for schema/tool validation, but social claims of "0 hallucinations" or "100% reliable" are false/overstated.
- LangGraph: active MIT graph/state orchestration framework; useful only where durable cycles/checkpoints/HITL beat simpler n8n/code.
- Suna: active generalist-agent project, but its current license is Elastic License 2.0, not unrestricted open source; hosted/managed-service restrictions materially affect commercial reuse.

Decision: DO NOT build a ten-framework stack. Extract typed contracts, checkpoints, explicit memory boundaries and HITL concepts; benchmark a framework only when a measured capability gap appears.

## 2. Commercially framed open-source repo carousel

### changedetection.io
VERIFIED: `dgtlmoon/changedetection.io`, Apache-2.0, active 2026-10-15, focused on website change detection and alerts.
VALUE: competitor/product/page monitoring can be useful for Nexia Reality Loop and external-reality sensing.
CORRECTION: the social "clients pay $4,000" statement is not evidence that Nexia can charge that amount or that the repo itself creates that value.
DECISION: HIGH-VALUE SENSOR CANDIDATE, but do not deploy until a recurring monitoring target exists that current web/automation surfaces cannot cover efficiently.

### ai-website-cloner-template
VERIFIED: `JCodesMore/ai-website-cloner-template`, MIT, active, TypeScript template marketed as cloning a website with AI coding agents.
VALUE: useful for lawful reconstruction/prototyping principles and rapid redesign benchmarking.
HARD BOUNDARY: Nexia must not copy protected expression, branding, proprietary assets, copyrighted code, authentication flows or deceptive trade dress. Reverse engineering remains principle-level and implementation must be our own.
CORRECTION: the social "$6,000 reconstruction" figure is unverified marketing, not market evidence.
DECISION: REFERENCE ONLY / RIGHTS-GATED.

### ppt-master
VERIFIED: `hugohe3/ppt-master`, MIT, active; converts documents/topics into native PowerPoint with editable shapes/charts/tables/templates.
VALUE: technically relevant, but Nexia already has a slide-generation surface and artifact workflow. A duplicate runtime is unjustified unless it materially outperforms the existing stack on a measured presentation task.
CORRECTION: social "$5,000 reports" framing is not economic evidence.
DECISION: RESERVE / BENCHMARK ONLY IF CURRENT SLIDE PIPELINE BECOMES A BOTTLENECK.

### Scrapling
VERIFIED: `D4Vinci/Scrapling`, BSD-3-Clause, active adaptive scraping/crawling framework.
VALUE: public permitted lead/research extraction fallback.
BOUNDARY: its stealth features do not authorize bypass of anti-bot, CAPTCHA, auth or access restrictions.
CORRECTION: "$10,000 lead machine" claim is unverified.
DECISION: FALLBACK after simpler public-web research/Crawl4AI/Playwright paths.

### PaddleOCR
VERIFIED: `PaddlePaddle/PaddleOCR`, Apache-2.0, active; current project description explicitly targets structured extraction from PDFs/images and supports 100+ languages.
VALUE: potentially strong for repeatable document-intake products: invoices, forms, contracts, scanned paperwork and RAG preprocessing.
LIMIT: OCR is not automatically the best path for ad-hoc image understanding; Nexia should use it when batch structured extraction, repeatability or local processing creates measurable value.
CORRECTION: "$12,000 paperwork" is unverified.
DECISION: HIGH-VALUE RESERVE / candidate Reality Loop if a document-processing buyer problem is independently observed.

### unidentified CRM card
The image claims an MIT open-source CRM for AI agents and a client price of ~$8,000, but the screenshot does not establish a unique repository identity with sufficient confidence.
DECISION: UNKNOWN_TO_TRIAGE only if a future CRM/product need makes identification material. Do not infer economics from the card.

## 3. Alternative / Chinese AI platform radar
Signals supplied included Dreamina, Qwen Studio, Ling, GLM, Kimi, DeepSeek, ERNIE/Wenxin, Doubao, Yuanbao and Xiaomi MiMo.

Nexia interpretation:
- these are MODEL/PLATFORM DISCOVERY signals, not a mandate to create accounts or migrate workloads;
- free chat access and API pricing are different facts;
- availability, regional access, data handling, commercial terms, model versions and pricing change quickly;
- model selection must follow a representative Nexia eval set: quality, tool use, structured output, multimodal ability, latency, privacy, cost and reliability;
- Xiaomi MiMo was already separately source-verified in Batch 05 and remains an R&D benchmark candidate, not default infrastructure.

Decision: maintain a provider/model radar, but do not open accounts or spend money from this batch. Trigger fresh verification only when a concrete task/model benchmark requires it.

## 4. Mobile human-leverage utilities
Images included iSH, Scriptable, Merlin Bird ID, Seeing AI, Fing, Delta and Just Press Record.

Nexia relevance:
- iSH / Scriptable: potentially useful for Kael-side lightweight scripting or diagnostics from iPhone, but they do not grant Nexia autonomous access to the phone and should not be installed without a concrete workflow.
- Just Press Record: possible capture/transcription convenience, but currently overlaps native/ChatGPT/voice workflows; no demonstrated bottleneck.
- Fing: useful personal/network diagnostic surface; not a Nexia core dependency.
- Merlin Bird ID, Seeing AI and Delta: useful applications in their own domains but no current Nexia system/reality-loop bottleneck justifies WIP.

Decision: RESERVE. Do not turn app discovery into installation debt.

## 5. Codync
VERIFIED: `leepokai/Codync`, Apache-2.0, active 2026-10-15, Rust; current description states support for messaging local coding agents such as Claude Code, Codex, Cursor and Gemini from iPhone/macOS/Windows/Linux/terminal. Snapshot was ~410 stars / 62 forks, so the social material is early-stage rather than evidence of mature adoption.

Potential Nexia value:
- reduce Kael desktop dependency for supervising local coding agents;
- possibly lower human device-friction when a task requires a local machine but only lightweight control/inspection is needed.

Risks/questions before adoption:
- remote-control trust boundary;
- credential/token storage;
- local network exposure;
- agent permission scope;
- audit trail and kill switch;
- whether ChatGPT/Codex/Work mobile surfaces already solve enough of the problem.

Decision: MEDIUM/HIGH HUMAN-LEVERAGE CANDIDATE. Do not install yet; first prove a recurring `NECESITAR ORDENADOR` bottleneck it can safely reduce.

## 6. Photopea
Signal: browser-based image editor compatible with PSD/layers/vector workflows.
Nexia value: emergency/manual image-edit fallback.
Current overlap: Adobe, Canva and image-generation/editing surfaces already exist.
Decision: RESERVE; no integration.

## 7. Paywall-bypass material — 12ft Ladder
The supplied image explicitly proposes inserting a URL into a service to remove/bypass a paywall.
Nexia decision: REJECT FOR BYPASS USE.
Reason: project rules explicitly prohibit bypassing paywalls/access controls. For research use official/open copies, subscriptions already legitimately available, author manuscripts, archives where lawful, libraries, primary sources or alternative public reporting.

## 8. Repeated image-edit prompts
Cinematic portrait, profile photo, travel, editorial, old-photo restoration and golden-hour prompts are useful composable visual specs but duplicate the identity-preserving visual standard already extracted in Batches 03–04.
Decision: DEDUPLICATED / NO NEW ARCHITECTURE. Preserve identity/source fidelity, realistic geometry/light and task-specific QA.

## Net-new candidates from Batch 07
### X — DOCUMENT INTELLIGENCE OPTION
PaddleOCR as a bounded candidate when structured, repeated document extraction becomes a real buyer/system problem.
Priority: MEDIUM/HIGH OPTION, not current WIP.

### Y — CHANGE-DETECTION REALITY SENSOR
changedetection.io pattern/tool for recurring competitor/product/regulatory/page monitoring when current search is inefficient.
Priority: MEDIUM OPTION.

### Z — MOBILE AGENT SUPERVISION OPTION
Codync-style remote coding-agent supervision only if it demonstrably reduces Kael computer dependency while preserving security and authority.
Priority: MEDIUM/HIGH HUMAN-LEVERAGE OPTION.

## Intake close
This was the final image-intelligence batch. The next required step is cross-batch deduplication and prioritization by system leverage, reality value, evidence strength, cost, risk, reversibility, maintenance burden and current bottleneck. No account creation, installation, publication, spend or external contact is justified merely by this batch.
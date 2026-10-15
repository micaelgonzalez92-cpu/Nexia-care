# NEXIA — AI employee stack candidates

Date: 2026-10-15
Status: RESEARCH / NOT_INSTALLED / NOT_CONNECTED / NOT_VERIFIED_IN_NEXIA
Source class: external social-media signals supplied by Kael, cross-checked selectively against official GitHub repositories/docs.

## Truth boundary
Social posts are discovery signals, not proof of capability, economics, licensing fit, safety, production readiness, or customer willingness to pay. Claims such as "clients pay $X", savings, star counts, "free", "production ready", or "replaces Y" are not accepted as Nexia facts without independent evidence.

## Candidate stack observed

| Capability | Candidate | Verified external signal | Nexia assessment |
|---|---|---|---|
| Multi-agent orchestration | CrewAI | Active OSS framework for Crews + event-driven Flows; MIT | CANDIDATE. Do not add unless multi-agent coordination becomes a measured bottleneck; n8n + current agent surfaces may already cover orchestration. |
| Persistent agent memory | Letta | Active stateful-agent platform; current development centered on letta-code; Apache-2.0 | CANDIDATE. May serve episodic/agent memory, but must never replace GitHub/NEXIA_STATE.json as canonical truth. |
| Workflow/event automation | n8n | Active 2.x releases; already used in EXP-AUTO-001 | EXISTING ACTIVE CAPABILITY. Improve and verify before adding a parallel orchestrator. |
| Browser interaction | Browser Use | Active MIT project for browser control/agents | CONDITIONAL. Useful for authorized interactive browser work; no bypass of auth, CAPTCHA, anti-bot controls, paywalls, or site restrictions. Prefer existing supported browser surfaces when sufficient. |
| Knowledge/RAG layer | RAGFlow | Apache-2.0; active 2026 releases; RAG + agent capabilities + knowledge compilation | HIGH-VALUE CANDIDATE for derived retrieval/search over project evidence if current retrieval becomes a proven bottleneck. GitHub remains source of truth. |
| Tool/app integration | Composio | MIT; 1000+ toolkits, auth, triggers, sandbox, agent adapters | CONDITIONAL. Potential connector layer, but overlaps current ChatGPT plugins/connectors and introduces credentials/auth surface. Evaluate only against a concrete missing integration. |
| Public-web extraction | Firecrawl | Active; web search/scrape/interact API; core AGPL-3.0 | CONDITIONAL. Useful for structured public-web ingestion; licensing/ToS/robots/security review required. Existing web/TinyFish may be sufficient. |
| Self-hosted AI interface | Open WebUI | Active self-hosted UI; 2026 added HITL tool approval, context compaction, skills and analytics | LOW/MEDIUM PRIORITY. Valuable only if Nexia needs its own local/multi-model operator UI; current ChatGPT/Work surfaces make it non-critical. |
| Agent observability/evals | Langfuse | Active OSS LLM engineering platform; tracing, evaluation, debugging, self-hosting; v4 active | HIGH-VALUE CANDIDATE once Nexia runs instrumentable LLM/API workflows. Strong fit with VERIFY/CRITIQUE/RE-VERIFY and truth boundaries. |
| Multi-model gateway | LiteLLM | Active gateway for 100+ LLM providers with unified API, cost tracking, guardrails, load balancing, logging | MEDIUM/HIGH CANDIDATE when multi-provider routing, spend control, fallback or model benchmarking becomes real. Not needed merely to add complexity. |

## Architecture rule
Do not install the whole stack. New infrastructure must close a measured gap. Prefer one component per unmet capability, with explicit owner, failure mode, observability, rollback and evidence of benefit.

Provisional layering if justified later:
GitHub canonical state -> derived RAG/search (RAGFlow) -> optional agent memory (Letta) -> orchestration (n8n; CrewAI only if justified) -> tool/browser execution (existing connectors / Composio / Browser Use) -> model gateway (LiteLLM) -> observability/evals (Langfuse) -> optional operator UI (Open WebUI).

## Current priority decision
1. Preserve n8n as the existing workflow spine and improve what is already proven.
2. Evaluate Langfuse as the first new systems candidate when an instrumentable Nexia runtime exists.
3. Evaluate RAGFlow only if GitHub/project retrieval latency, recall or context loss is measured as a material bottleneck.
4. Defer CrewAI, Open WebUI, Composio, Firecrawl, Letta and LiteLLM until a concrete gap triggers them.

## Safety exclusions
- No stealth/anti-detection browsing intended to evade bot controls or access restrictions.
- No CAPTCHA/auth/paywall/DRM bypass.
- No autonomous external sends, purchases, account creation, publication or production activation without the RED gate.
- Credentials remain outside repo and must use approved secret handling.

## Stop rationale
READY_FOR_CURRENT_PURPOSE as an opportunity registry. No installation is warranted from social-media discovery alone. Next change should be triggered by measured need, new verified evidence, or an active system bottleneck.

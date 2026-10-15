# NEXIA — AI employee stack candidates

Date: 2026-10-15
Status: RESEARCH V2 / INTAKE CLOSED / NOT_INSTALLED / NOT_CONNECTED / NOT_VERIFIED_IN_NEXIA
Source class: external social-media signals supplied by Kael, cross-checked selectively against official GitHub repositories/docs.

## Truth boundary
Social posts are discovery signals, not proof of capability, economics, licensing fit, safety, production readiness, or customer willingness to pay. Claims such as "clients pay $X", savings, star counts, "free", "production ready", "0 hallucinations", "100% reliable", "24/7 autonomous", or "replaces a $200k employee" are not accepted as Nexia facts without independent evidence.

## Candidate stack observed

| Capability | Candidate | Verified external signal | Nexia assessment |
|---|---|---|---|
| Multi-agent orchestration | CrewAI | Active Python framework; MIT; ~59.7k stars at snapshot | DEFER. Do not add unless multi-agent coordination becomes a measured bottleneck; n8n + current agent surfaces may already cover orchestration. |
| Persistent agent memory | Letta | Active stateful-agent platform; Apache-2.0; ~25.1k stars | CANDIDATE. Episodic/agent memory only; never replace GitHub/NEXIA_STATE.json as canonical truth. |
| Workflow/event automation | n8n | Existing active Nexia capability | KEEP/IMPROVE. It is the current workflow spine; do not add a parallel orchestrator without measured benefit. |
| Browser interaction | Browser Use | Active MIT browser-agent project | CONDITIONAL. Authorized browser work only. Never use stealth/anti-detection features to bypass CAPTCHA, bot controls, auth, paywalls or site restrictions. |
| Autonomous coding | OpenHands | Active MIT project; current repo OpenHands/OpenHands; ~91k stars at snapshot | BENCHMARK CANDIDATE only if engineering backlog becomes a measured bottleneck. Compare against Codex/GitHub/Work before adding another runtime. |
| Lightweight agent platform | Agno | Active Apache-2.0 Python project; ~42.7k stars | RESERVE. Significant overlap with other agent frameworks; evaluate only against a concrete use case. |
| Multi-agent framework | Microsoft AutoGen | Public framework; repo currently shows CC-BY-4.0 metadata; ~61.4k stars; last push observed 2026-04-15 | DEFER / REVALIDATE BEFORE USE. Strong historical reference, but current maintenance/license fit must be checked at decision time. |
| Typed agent/tool contracts | Pydantic AI | Active MIT project from Pydantic; typed end-to-end agent framework; ~20.6k stars | HIGH-VALUE CANDIDATE when Nexia builds an in-code Python agent runtime. Strong fit for structured outputs, validation and safe tool interfaces. Does not eliminate model hallucinations. |
| Stateful orchestration | LangGraph | Active MIT graph-based agent orchestration; ~43.3k stars | MEDIUM/HIGH CONDITIONAL. Useful for checkpoints, cycles, retries and HITL when in-code orchestration is justified; otherwise n8n remains simpler. |
| Generalist AI OS | Suna | Active project, but current root license is Elastic License 2.0, not unrestricted OSI open source | RESERVE / LICENSE-CONSTRAINED. ELv2 prohibits offering substantial functionality as a hosted/managed service to third parties. Do not adopt as commercial substrate without legal/license fit review. |
| Knowledge/RAG layer | RAGFlow | Apache-2.0; active 2026 releases; RAG + agent capabilities + knowledge compilation | HIGH-VALUE CANDIDATE for derived retrieval/search over project evidence if current retrieval becomes a proven bottleneck. GitHub remains source of truth. |
| Tool/app integration | Composio | MIT; broad toolkits/auth/triggers/agent adapters | CONDITIONAL. Overlaps current ChatGPT plugins/connectors and introduces credentials/auth surface. Evaluate only against a concrete missing integration. |
| Public-web extraction | Firecrawl | Active web-data stack; core AGPL-3.0 | CONDITIONAL. Licensing/ToS/robots/security review required. Prefer lighter existing search/Crawl4AI/Playwright paths first. |
| Self-hosted AI interface | Open WebUI | Active self-hosted operator UI | LOW/MEDIUM. Valuable only if Nexia needs its own local/multi-model operator UI; current ChatGPT/Work surfaces make it non-critical. |
| Agent observability/evals | Langfuse | Active tracing/evaluation/debugging platform | HIGH-VALUE CANDIDATE once Nexia runs an instrumentable LLM/API runtime. Strong fit with VERIFY/CRITIQUE/RE-VERIFY. |
| Multi-model gateway | LiteLLM | Active unified gateway for many LLM providers with routing/cost/guardrail features | MEDIUM/HIGH when multi-provider routing, spend control, fallback or model benchmarking becomes real. Not needed merely to add complexity. |
| Remote coding-agent client | Codync | leepokai/Codync; Apache-2.0, Rust, iPhone/macOS/Windows/Linux, active 2026-10-15; ~410 stars | MOBILE-LEVERAGE CANDIDATE. Interesting if Kael repeatedly needs to control local coding agents from iPhone. Must pass security/privacy and local-agent boundary review first. |

## Architecture rule
Do not install the whole stack. New infrastructure must close a measured gap. Prefer one component per unmet capability, with explicit owner, failure mode, observability, rollback and evidence of benefit.

Provisional layering if justified later:
`GitHub canonical state -> derived retrieval/RAG -> optional episodic agent memory -> n8n workflow spine -> optional typed/graph agent runtime -> authorized tool/browser execution -> optional model gateway -> traces/evals -> optional operator UI`.

## Framework decision hierarchy
When a new agentic requirement appears:
1. Ask whether deterministic code/n8n already solves it.
2. If the missing capability is typed tool contracts / structured validation, benchmark Pydantic AI first.
3. If the missing capability is durable cyclic state/checkpoints/HITL in code, benchmark LangGraph.
4. If the missing capability is role-based multi-agent collaboration, compare CrewAI/Agno/AutoGen only after simpler approaches fail.
5. If the missing capability is autonomous software engineering, benchmark OpenHands against current Codex/Work/GitHub workflow.
6. If the missing capability is long-term episodic agent memory, test Letta as a derived memory layer only.
7. Never let any framework become canonical project truth by default.

## Current priority decision
1. Preserve n8n as the existing workflow spine and improve what is already proven.
2. Extract Pydantic-style typed contracts as a design principle now; test the library only when an in-code agent runtime is justified.
3. Evaluate Langfuse as the first observability candidate when an instrumentable Nexia runtime exists.
4. Evaluate RAGFlow only if retrieval latency/recall/context loss becomes a measured bottleneck.
5. Keep LangGraph/OpenHands/Codync as bounded benchmark candidates tied to specific bottlenecks.
6. Defer CrewAI, Agno, AutoGen, Open WebUI, Composio, Firecrawl, Letta, LiteLLM and Suna until a concrete gap triggers them.

## Safety and license exclusions
- No stealth/anti-detection browsing intended to evade controls or restrictions.
- No CAPTCHA/auth/paywall/DRM bypass.
- No autonomous external sends, purchases, account creation, publication, production activation or financial execution without RED approval.
- Credentials remain outside repo and use approved secret handling.
- Open source/source available/free tier are not synonyms for zero cost or unrestricted commercial use.
- Suna ELv2 hosted-service restriction is a material commercial constraint.

## Stop rationale
READY_FOR_CURRENT_PURPOSE as the completed AI-employee opportunity registry for this intake round. No installation is warranted from social-media discovery alone. Next change must be triggered by measured need, a bounded EUR0-first experiment, or new verified evidence.
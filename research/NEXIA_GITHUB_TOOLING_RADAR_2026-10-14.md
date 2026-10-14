# NEXIA GitHub Tooling Radar — 2026-10-14

Status: RESEARCH / NO INSTALLATION AUTHORIZED
Objective: assess user-provided GitHub resources and adjacent repositories by economic impact, repeatability, automation value, cost, license/risk and implementation effort. Stars are discovery signals only, not proof of reliability or business value.

## Executive decision

### PROBAR — highest expected value
1. **microsoft/playwright-mcp** — standard browser automation surface over MCP. Apache-2.0, actively maintained, ~38k stars. Strong fit with Nexia's existing local authenticated read-only browser bridge. Best candidate for a bounded synthetic/read-only test because it may reduce custom CDP glue and improve reproducibility without changing commercial authority.
2. **unclecode/crawl4ai** — self-hostable Python crawler/scraper producing LLM-ready Markdown/data, with MCP support. Apache-2.0, actively maintained, ~85k stars. Strong fit for public market/opportunity research and evidence collection where normal search is insufficient.
3. **D4Vinci/Scrapling** — adaptive Python scraping/crawling with browser rendering, selector adaptation, MCP and stealth features. BSD-3-Clause, actively maintained, ~87k stars. Potential fallback for difficult public sites, but anti-bot/stealth features raise higher ToS/compliance and operational risk than Crawl4AI; test only on permitted public targets.

### RESERVA — valuable but not first action
4. **browser-use/browser-use** — MIT, actively maintained, ~118k stars. Powerful natural-language browser agents. Higher complexity and model/runtime dependence than Playwright MCP; evaluate only if deterministic MCP/browser automation cannot cover a workflow.
5. **nexu-io/open-design** — Apache-2.0, local-first collaborative AI design workspace, ~101k stars and active development. Can create prototypes, sites, dashboards, decks, images/video and supports coding agents. Potentially useful for portfolio/deliverables, but repository is very large (~3.5 GB reported by GitHub) and Nexia already has Canva/Figma/tldraw/Adobe/document surfaces. Install only if a concrete deliverable proves current surfaces insufficient.
6. **apify/crawlee** — Apache-2.0 mature JS/TS crawling library with Playwright/Puppeteer integration. Strong engineering option but overlaps Crawl4AI/Scrapling; no reason to maintain three crawler stacks before one is validated.
7. **firecrawl/firecrawl** — highly active web-data stack, self-hosting available, but AGPL-3.0 and heavier service footprint. Useful capability, lower priority for Nexia while Apache/BSD alternatives cover the same discovery need with lower licensing/maintenance friction.

### RADAR — discovery sources, not runtime dependencies
8. **public-apis/public-apis** — MIT directory of free/public APIs; ~489k stars and active. Useful to discover zero/low-cost data sources. Each API must be separately revalidated for current pricing, auth, quota, ToS and data quality before use. Do not treat the directory as one stable API service.
9. **punkpeye/awesome-mcp-servers** — MIT directory of MCP servers; ~96k stars and active. High discovery value, high supply-chain/security variance. Never bulk-install. Each server requires source/provenance/license review, version pinning, minimum privilege and a bounded test.
10. **ripienaar/free-for-dev** — active directory of SaaS/PaaS/IaaS free tiers; ~140k stars. Excellent cost-reduction radar. Free tiers change; verify current terms immediately before adoption. It is a list, not an infrastructure component.
11. **sindresorhus/awesome** — CC0 meta-directory, ~519k stars. Useful for broad discovery only. Low direct execution value; query targeted sublists rather than browsing indiscriminately.
12. **Shubhamsaboo/awesome-llm-apps** — Apache-2.0, ~142k stars, active; 100+ agent/RAG/MCP examples and skills. Valuable as a pattern/template library. Do not deploy templates directly to production without dependency, secret, cost and quality review. Mine only when a concrete Nexia problem matches a template.
13. **modelcontextprotocol/servers** — official MCP reference/server repository, ~91k stars and active. Prefer this official source over random MCP directories for baseline patterns (filesystem, fetch, memory, sequential thinking, etc.). Use as trusted reference, not automatic installation authority.

## User-provided repositories — current verification snapshot

| Repository | Current signal | License | Nexia classification | Why |
|---|---:|---|---|---|
| public-apis/public-apis | ~488.7k stars; pushed 2026-10-14 | MIT | RADAR | API discovery; each API must be revalidated |
| punkpeye/awesome-mcp-servers | ~96.3k; pushed 2026-10-09 | MIT | RADAR | MCP discovery; supply-chain review mandatory |
| nexu-io/open-design | ~101.2k; pushed 2026-10-14 | Apache-2.0 | RESERVA | powerful artifact/design workflow but heavy/redundant today |
| Shubhamsaboo/awesome-llm-apps | ~141.7k; pushed 2026-10-13 | Apache-2.0 | RADAR | reusable agent/RAG patterns, not validated production system |
| sindresorhus/awesome | ~519.0k; pushed 2026-09-02 | CC0-1.0 | RADAR | meta-directory only |
| D4Vinci/Scrapling | ~87.6k; pushed 2026-10-14 | BSD-3-Clause | PROBAR/FALLBACK | robust scraping; higher compliance risk on protected sites |
| ripienaar/free-for-dev | ~139.6k; pushed 2026-10-14 | no root license detected by GitHub API | RADAR | cost-saving discovery source only |

The star counts in the supplied images are older than the verified 2026-10-14 GitHub API snapshot; this is normal and confirms that image claims should not be treated as current state.

## Additional high-value repositories verified

### microsoft/playwright-mcp
- Official Microsoft repository; Apache-2.0.
- Browser automation exposed as MCP using Playwright.
- Nexia fit: potentially replace/reduce bespoke local CDP bridge code and provide a standardized browser executor.
- Minimum test if prioritized: local/synthetic or public read-only page; navigation + DOM read + bounded form fill without submit; no credentials, purchases, messages or external effects.
- Success: reproducible execution and lower custom maintenance than current bridge.

### unclecode/crawl4ai
- Apache-2.0, Python, self-hostable, MCP support.
- Converts pages into clean LLM-ready Markdown/structured data for RAG/agents.
- Nexia fit: opportunity discovery, competitor evidence, documentation ingestion, research pipelines.
- Minimum test: 3 permitted public pages (static, JS-rendered, multi-page) against current method; compare extraction completeness, time, failure rate and human attention.

### D4Vinci/Scrapling
- BSD-3-Clause, Python, active.
- Adaptive selectors and browser/stealth capabilities; also ships MCP/agent integration.
- Nexia fit: fallback when permitted public pages break normal extraction.
- Kill criterion: do not use to bypass access controls, authentication, CAPTCHAs or site restrictions without explicit authorization/legal basis. Prefer simpler methods first.

### browser-use/browser-use
- MIT, Python, active.
- Natural-language web agents built around browser automation.
- Nexia fit: multi-step workflows where deterministic selectors are too brittle.
- Risk: higher non-determinism, model cost/runtime dependence and larger verification surface. Keep behind Playwright MCP in priority.

### modelcontextprotocol/servers
- Official MCP ecosystem reference maintained by the Model Context Protocol project.
- Contains/points to reference servers such as filesystem, fetch, memory and sequential-thinking.
- Nexia fit: safe architecture/reference baseline. Prefer official/reference implementations over unknown third-party MCP servers where capability overlaps.

### firecrawl/firecrawl
- AGPL-3.0, very active and self-hostable; web search/scrape/parse agent stack.
- Nexia fit: strong technically, but lower priority due license and operational footprint while Crawl4AI/Scrapling remain untested.

### n8n-io/n8n — licensing correction relevant to Nexia
- Source-available / fair-code, not OSI open source.
- Sustainable Use License permits internal business use and commercial consulting/support such as building n8n workflows, but embedding/providing n8n as a commercial product/service can require a separate agreement.
- Nexia must preserve this distinction when productizing EXP-AUTO-001.

## Top 3 next technical experiments (NOT YET AUTHORIZED/EXECUTED)

1. **PLAYWRIGHT-MCP-POC-001** — compare Microsoft Playwright MCP against current local CDP bridge on a synthetic/read-only task. Cost target EUR0. No external effects. Expected information: maintenance/reliability improvement.
2. **CRAWL4AI-POC-001** — compare Crawl4AI to current public-web research on three permitted pages. Cost target EUR0. Measure completeness, latency, errors and human attention.
3. **SCRAPLING-POC-001** — only if Crawl4AI/current methods fail on a permitted public site; test adaptive extraction without defeating authentication/access controls.

## Anti-overengineering rule
Do not install a repository because it is popular. New tooling enters Nexia only if it has a named bottleneck, a bounded test, EUR0-first economics, measurable success/failure, reversible deployment, clear license fit and lower expected total cost/risk than the existing capability.

## Current business priority
These tools are capability research, not a new material vein. EXP-AUTO-001 remains primary; Workana moderation remains PENDING and the Contra microtest remains designed/instrumented but not authorized. Tooling work must not displace a commercial gate or first-revenue action.

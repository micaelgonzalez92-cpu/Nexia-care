# NEXIA R&D INTELLIGENCE OPERATING STANDARD V1

Date: 2026-10-16
Status: ACTIVE / READY_FOR_CURRENT_PURPOSE / EUR0-FIRST
Authority: GREEN internal research standard; does not authorize external publication, account creation, spend, installation or sensitive actions.

## Objective
Turn external information into verified Nexia capability faster than generic browsing. Optimize for source authority, falsifiability, freshness, reproducibility, cost, privacy and decision value.

## Core loop
`CLASSIFY -> PRIMARY SOURCE -> INDEPENDENT COUNTERCHECK -> REPRODUCE/COMPUTE WHEN POSSIBLE -> LABEL EVIDENCE -> COMPARE TO NEXIA -> IMPLEMENT/TEST/RESERVE/DISCARD -> CAPTURE -> REVERIFY LATER`

Social posts, directories and community discussion are sensors. They do not become HECHO VERIFICADO without stronger evidence when material.

## TASK-TRIGGERED R&D INTERRUPT — MANDATORY
Research is not only a periodic radar. Whenever an ACTIVE task hits a material blocker, repeated failure, avoidable manual friction, missing capability, questionable tool fit, or a plausible faster/cheaper/more reliable route, Nexia must immediately run a bounded R&D interrupt before continuing to polish the current method.

Mandatory triggers:
1. a material acceptance criterion fails or root cause remains ambiguous;
2. an active task is blocked by missing software/API/model/runtime/data/tooling;
3. repeated human action suggests automation or remote execution leverage;
4. a proposed install, model download, paid API, new account or material system change becomes likely;
5. Kael supplies new tool/repo/app/API/social evidence relevant to the active task;
6. a current method is expensive, fragile, slow or high-maintenance and a materially better alternative may exist;
7. an upstream release or new evidence may invalidate the current architecture.

Execution order:
`ACTIVE TASK -> SEARCH EXISTING USER/PROJECT CORPUS -> SEARCH CANONICAL NEXIA ARTIFACTS -> VERIFY PRIMARY/UPSTREAM SOURCES -> COUNTERCHECK FAILURE MODES -> SHORTLIST MAX 3 -> COMPARE WITH CURRENT STACK -> PROPOSE WITHOUT INSTALLING -> AUTHORITY GATE -> BOUNDED POC -> CAPTURE -> RESUME ACTIVE TASK`

Rules:
- The existing user-provided corpus is searched before broad external discovery when it may contain relevant candidates. Prior screenshots, links and notes are sensors and must be upstream-verified before material adoption.
- Task-triggered R&D is an interrupt supporting an existing WIP lane, not a fourth material workstream.
- Weekly/recurring radar is background discovery only. It never substitutes for this interrupt.
- Prefer EUR0, already-installed and open-source routes before paid APIs when they can answer the decision fast enough.
- New software, API, repo, account, model or persistent service is PROPOSED first; installation/activation/spend remains separately gated.
- Stop discovery once one candidate clearly dominates the current decision or after a maximum useful shortlist of three. Capture rejected candidates and reasons to prevent rediscovery loops.
- After the POC, return to the original active task. Research is successful only if it changes a decision, capability, risk posture or measured outcome.

## Source Authority Router
Route every material research question before searching.

### Route A — current product / API / platform / company capability
Priority:
1. official docs / pricing / changelog / release notes;
2. official GitHub repo, commits, releases, issues and license;
3. independent technical/community evidence for failure modes and real-world friction;
4. direct bounded test when feasible.

Use now: native web research + connected GitHub.

### Route B — scientific / technical claim
Priority:
1. original paper / standard / dataset;
2. Crossref/OpenAlex/Semantic Scholar metadata and citation graph;
3. Elicit / Consensus / Scite-style evidence synthesis when available;
4. Connected Papers only for neighborhood exploration;
5. reproduce calculation/experiment where proportionate.

Preprints such as arXiv are evidence but must remain distinguishable from peer-reviewed publication.

### Route C — AI model / dataset / benchmark
Priority:
1. official model card/release/docs;
2. Hugging Face Hub metadata/repository where applicable;
3. original technical report/paper;
4. independent benchmarks and failure reports;
5. Nexia representative eval set / cross-model retest.

Never select a default model solely from vendor benchmarks.

### Route D — software / open-source candidate
Priority:
1. canonical repository;
2. license and dependency licenses;
3. recent commits/releases/issues/security signals;
4. resource/deployment requirements;
5. compare against current Nexia capability;
6. bounded POC only if a measured gap exists.

Discovery sources such as OpenAlternative and Awesome lists may nominate candidates but cannot approve them.

### Route E — market / buyer / workflow problem
Priority:
1. direct observed buyer/workflow evidence;
2. official company/product information and pricing;
3. job posts, forums, reviews and community discussion as signals;
4. competitors and alternatives;
5. bounded real-world probe.

Audience, discussion and claimed prices are not demand, sale or settled cash.

### Route F — quantitative / mathematical claim
Priority:
1. deterministic local calculation/code;
2. calculator/computational engine such as Wolfram-style cross-check;
3. independent second implementation for material calculations.

Do not trust language-model arithmetic when deterministic verification is cheap.

### Route G — fixed evidence packet / private corpus
Use source-grounded corpus analysis such as NotebookLM-style notebooks or Nexia retrieval, but preserve source boundaries and citations. Derived corpus systems never override canonical GitHub state.

### Route H — recurring change monitoring
Only after a repeated target is identified: GitHub releases/commits, official changelogs, changedetection-style public-page monitoring, or authorized automations. Do not deploy monitoring infrastructure without a named decision/action that changes when the condition changes.

## USE NOW — default research stack

| Capability | Tool/source | Role | Rule |
|---|---|---|---|
| Current public research | Native web search | discovery + current verification | prefer primary/official; add counterevidence for material claims |
| Project/code truth | GitHub connector + GitHub REST concepts | canonical Nexia files, repos, commits, releases, issues | read before write; material writes require readback |
| Existing intelligence corpus | Project/conversation files + Nexia retrieval | first-pass candidate recall for active task | search before external discovery; verify upstream before adoption |
| Scholarly DOI metadata | Crossref REST API | paper/DOI metadata, funders, licenses, updates | strong metadata source; inspect original paper for consequential claims |
| Academic graph | Semantic Scholar / OpenAlex | papers, authors, citations, related work | discovery/graph layer, not sole truth |
| Preprints | arXiv | current scientific/technical research | mark peer-review status correctly |
| Models/datasets | Hugging Face Hub/API | model cards, datasets, Spaces, repo metadata | verify license, version, dependencies and benchmark claims |
| Evidence synthesis | Elicit / Consensus / Scite when available | structured literature search and counterevidence | trace consequential claims to originals |
| Fixed corpus | NotebookLM-style source-grounded notebook | bounded synthesis of supplied evidence | noncanonical; source citations required |
| Literature neighborhood | Connected Papers | prior/derivative/similar-paper discovery | never claim exhaustive coverage |
| Quantitative falsification | deterministic code/calculator/Wolfram-style engine | independent numeric verification | mandatory when quantitative result is material |
| OSS discovery | OpenAlternative / Awesome lists | candidate generation | repo-level verification required before adoption |
| Capability learning | MIT OCW / strong textbooks / current papers | targeted curriculum from measured gap | learning must terminate in tested capability |

## APIs to prioritize when programmatic research becomes worthwhile
1. GitHub REST/API — repo metadata, commits, releases, issues/status where authorized.
2. Crossref REST — low-friction scholarly metadata; public access exists without mandatory signup for normal use.
3. Semantic Scholar Academic Graph API — paper/author/citation retrieval; respect quotas/auth terms.
4. OpenAlex API — broad scholarly graph/search and metadata.
5. Hugging Face Hub API / OpenAPI — model/dataset/Space metadata and change detection; respect rate limits/auth requirements.
6. arXiv access/API/data feeds — preprint discovery and metadata, subject to current usage rules.

API integration is not automatic. Create an integration only if repeated manual research cost or recall justifies maintenance.

## Parallel research rule
For material decisions, use at least two independent paths when feasible and EUR0:
- primary source path;
- independent synthesis/counterevidence path.

Add a third deterministic/reproduction path when the claim is computational or technically testable.

Do not parallelize ten overlapping searches merely to create volume.

## Research output contract
Every material finding should resolve to:
- QUESTION / DECISION;
- SOURCE CLASS;
- FRESHNESS;
- HECHO VERIFICADO / ESTIMACIÓN / HIPÓTESIS / RECOMENDACIÓN;
- SUPPORTING EVIDENCE;
- COUNTEREVIDENCE / FAILURE MODE;
- NEXIA IMPACT;
- DECISION: IMPLEMENT / TEST / INVESTIGATE / RESERVE / DISCARD;
- COST / RISK / REVERSIBILITY;
- REVERIFY TRIGGER.

## Immediate architecture rules adopted from the intelligence round
1. Deterministic workflow first; model judgment second; agentic planning only where dynamic planning/tool choice adds measurable value; multi-agent last.
2. Prompt changes are tested with eval cases, not accepted because they sound sophisticated.
3. Material mutations require capability proof, blast-radius control, approval where RED, postcondition verification and rollback.
4. Cross-model/cross-tool retest is required before claiming generalization when material.
5. Open source != zero cost; self-hosted UI != local inference; free chat != free API.
6. Rights/ToS/privacy/license constraints are checked before ingestion or automation.
7. No CAPTCHA/auth/paywall/DRM/anti-bot bypass.

## Tool adoption gate
A new tool/runtime enters ACTIVE only if all are true:
- named unmet capability or measurable bottleneck;
- benchmark against existing Nexia surface;
- license/privacy/security fit;
- expected benefit exceeds integration/maintenance burden;
- bounded POC passes acceptance criteria;
- rollback exists;
- evidence and operational owner are captured.

Otherwise classify RESERVE/DEFER/DISCARD.

## Trigger queue already approved for investigation
P1 Playwright browser QA when repeated manual browser verification blocks progress.
P2 Context-economy POC when fresh-chat recovery/context overhead is measured.
P3 Local media chain (`yt-dlp` where lawful -> FFmpeg -> faster-whisper) when media/VELA becomes active WIP.
P4 PaddleOCR when repeated structured-document extraction becomes a real problem.
P5 Langfuse when an instrumentable multi-call LLM/API runtime exists.
P6 Pydantic AI first, LangGraph only if needed, when an in-code agent runtime is justified beyond n8n.
P7 Codync only if repeated desktop dependency can be safely reduced by remote supervision.

## Stop rule
Broad tool collecting is stopped. Task-triggered R&D starts immediately around a named blocker/opportunity and stops when the decision is resolved. Background radar remains supplemental. The purpose of the research system is better decisions and tested capability, not a larger tool inventory.

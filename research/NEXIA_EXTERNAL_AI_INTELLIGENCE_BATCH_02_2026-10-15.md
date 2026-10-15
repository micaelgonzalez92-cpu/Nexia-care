# NEXIA — EXTERNAL AI INTELLIGENCE BATCH 02

Date: 2026-10-15
Status: PROVISIONAL_RESEARCH / SOURCE-VALIDATED / MORE_USER_BATCHES_EXPECTED
Source: user-provided image batch covering Awesome Seedance, OpenAlternative, Gemini Notebook/NotebookLM, Elicit, Consensus, Connected Papers, MIT OpenCourseWare, Open Library, Open Culture and Wolfram|Alpha; externally checked against current official or primary sources where available.

## Executive conclusion
This batch is highly relevant to Nexia's R&D layer. It contains three distinct source classes:

1. TECHNOLOGY DISCOVERY SOURCES — OpenAlternative, Awesome Seedance.
2. EVIDENCE / RESEARCH SOURCES — Gemini Notebook, Elicit, Consensus, Connected Papers, Wolfram|Alpha.
3. EDUCATION / KNOWLEDGE SOURCES — MIT OCW, Open Library, Open Culture.

The main system-level implication is not to adopt all tools individually, but to formalize a source-selection policy for Nexia R&D. Different sources have different evidentiary roles and should not be treated as interchangeable.

## 1. Awesome Seedance
Classification: VERIFIED RESOURCE / DYNAMIC COUNTS / HIGH RELEVANCE TO AI VIDEO R&D.

Current public repository `LearnPrompt/awesome-seedance` exists and is actively updated. The screenshot was already stale by the time of verification: the image showed roughly 466 cases / 264 cross-model retests / 25 templates / 60 skills, while the live repository showed materially higher counts, including 800+ verified cases, 300+ cross-model retests, 27 templates and 70+ skills. This validates the repository but also demonstrates why screenshot counts must be treated as time-stamped evidence, not current truth.

Useful properties:
- original-post traceability;
- cross-model retesting;
- reusable prompt templates;
- installable AI-video skills;
- daily synchronization.

Nexia application:
- useful for VELA/content/video R&D;
- more importantly, its cross-model retest pattern is a strong methodology worth copying: prompt/effect claims should be reproduced on more than one model where transferability is material;
- use as a discovery/benchmark source, not as sole truth source.

Decision: ADOPT AS R&D REFERENCE; COPY THE RETEST METHODOLOGY, NOT THE CONTENT BLINDLY.

## 2. OpenAlternative.co
Classification: VERIFIED DISCOVERY DIRECTORY / NOT AUTHORITATIVE FOR SECURITY OR QUALITY.

The directory exists and currently tracks many open-source alternatives to proprietary products, including AI, coding, automation, CRM, media and infrastructure tools. It surfaces stars, recent commits, licenses and comparison targets.

Strengths:
- fast discovery of open-source substitutes;
- useful for zero-cost / self-hosted option generation;
- useful for reducing vendor lock-in and identifying local/self-hosted alternatives.

Limits:
- directory inclusion is not proof of quality, security, maintainability or suitability;
- star counts and recent commits are signals, not production-readiness evidence;
- licensing needs direct verification at the source repo before adoption.

Nexia application:
- add as a TECHNOLOGY DISCOVERY SENSOR;
- every candidate found there must pass repo-level verification: license, recent commits, issues, security posture, deployment cost, resource requirements and benchmark against current Nexia tooling.

Decision: ADOPT AS DISCOVERY SOURCE ONLY.

## 3. Gemini Notebook / NotebookLM
Classification: VERIFIED / HIGH-VALUE SOURCE-GROUNDED RESEARCH TOOL.

Google's current documentation confirms that the notebook chat grounds its responses exclusively in the notebook's selected sources and provides inline citations to those sources. It supports PDFs, websites, YouTube transcripts, audio, Google Docs/Slides, Drive files and source discovery. Web pages import text content only; embedded media and paywalled pages have limitations.

The screenshot claim 'it only answers from your files' is directionally correct for notebook chat, but 'files' is too narrow because current source types include web pages, audio, YouTube, Google Drive, books and other source formats.

Nexia application:
- useful as a bounded source-grounded analysis surface for large evidence packets;
- strong candidate for adversarial cross-checking: load a fixed corpus and compare its answer against Nexia's synthesis;
- useful for summarizing externally supplied document collections without mixing in open-web claims;
- not a replacement for canonical GitHub state or Nexia's evidence labels.

Decision: OPTIONAL COMPLEMENTARY RESEARCH SURFACE; DO NOT MAKE CANONICAL.

## 4. Elicit
Classification: VERIFIED / STRONG SCIENTIFIC EVIDENCE TOOL / SCREENSHOT PARTLY OUTDATED.

Elicit currently provides Research Agent, Reports and Systematic Review workflows. Its 2026 help documentation indicates a corpus of roughly 138 million academic papers for its own search plus broader web access in Research Agent sessions. Systematic Review supports structured search, screening, extraction and PRISMA-style workflows; Elicit emphasizes sentence-level supporting evidence and auditable decisions.

The screenshot description ('ask a research question and it finds papers and summarizes them') is broadly true but materially undersells the current product. Elicit now supports much more structured evidence-synthesis workflows than the image suggests.

Nexia application:
- high-value for scientific/technical claims where literature review matters;
- ideal for screening, extracting structured evidence and building reproducible evidence tables;
- particularly useful for healthcare/science or any material claim where peer-reviewed literature should outrank marketing pages;
- results must still be checked against original papers when consequential.

Decision: STRONG R&D CANDIDATE; USE WHEN SCIENTIFIC EVIDENCE IS MATERIAL.

## 5. Consensus
Classification: VERIFIED / STRONG ACADEMIC SEARCH + SYNTHESIS TOOL.

Consensus describes itself as an AI-powered academic search engine grounded in a corpus exceeding 200 million scientific documents/papers. It retrieves research first, then uses AI to synthesize findings with citations. Its corpus includes peer-reviewed papers plus some conference papers and preprints depending on source.

The screenshot framing around yes/no questions is too narrow. Consensus supports broader natural-language academic questions, evidence synthesis, comparison, extraction and deeper research modes.

Nexia application:
- fast literature triage and consensus/disagreement mapping;
- useful counterevidence source before making scientific or technical recommendations;
- useful alongside Scite/Elicit rather than as a single arbiter.

Decision: ADOPT AS SECONDARY SCIENTIFIC EVIDENCE SENSOR WHEN AVAILABLE.

## 6. Connected Papers
Classification: VERIFIED / DISCOVERY GRAPH, NOT COMPREHENSIVE LITERATURE SEARCH.

Connected Papers builds a visual graph of similar papers around a seed paper using Semantic Scholar data. It also provides prior-works and derivative-works views.

The screenshot claim that it 'maps every related paper in the field' is FALSE/OVERSTATED. It creates a similarity graph, not an exhaustive map of every related paper.

Nexia application:
- excellent for finding neighboring, foundational and derivative work from a strong seed paper;
- useful for literature-gap discovery;
- not sufficient by itself for systematic review or exhaustive coverage.

Decision: USE AS EXPLORATION TOOL, NEVER AS EXHAUSTIVE EVIDENCE CLAIM.

## 7. MIT OpenCourseWare
Classification: VERIFIED / HIGH-TRUST EDUCATIONAL SOURCE.

MIT OCW publishes free material from thousands of MIT courses across the curriculum. Courses commonly include syllabus, notes/readings and assignments/exams; many include video lectures and free textbooks. No registration, certificate or credit is implied.

Nexia application:
- strong source for structured upskilling in algorithms, statistics, systems, optimization, software engineering, control, economics and other foundational domains;
- useful for generating internal competency curricula when Nexia identifies a knowledge gap;
- educational material is not automatically the freshest source for fast-moving AI products, so combine with current docs/papers.

Decision: ADOPT AS FOUNDATIONAL LEARNING SOURCE.

## 8. Open Library
Classification: VERIFIED WITH QUALIFICATIONS.

Open Library, operated by the Internet Archive, provides catalog/search and borrowing for digitized books where eligible. Borrowing availability depends on edition/access conditions; not every listed book is freely borrowable at all times.

The screenshot claim 'borrow digital copies of millions of books for free' is directionally true but oversimplified. Some books are lending-controlled, some require an account, some are unavailable, and access varies by edition/rights.

Nexia application:
- useful for locating older books and reference works;
- secondary source for long-form background research;
- avoid assuming unrestricted machine ingestion or redistribution rights.

Decision: KEEP AS OPTIONAL BACKGROUND-RESEARCH SOURCE; RIGHTS/AUTOMATION MUST BE CHECKED PER ITEM.

## 9. Open Culture
Classification: VERIFIED CURATED AGGREGATOR / VARIABLE SOURCE QUALITY.

Open Culture curates free educational and cultural media and currently lists large collections including roughly 1,700 online courses, 1,000 audiobooks, hundreds of ebooks/textbooks and other educational resources.

The screenshot's 'updated constantly' language is promotional and not a useful evidentiary property. More important: Open Culture is an aggregator, so source authority varies with the linked material.

Nexia application:
- useful for discovery of free courses/books/lectures;
- verify the original provider before treating material as authoritative or current.

Decision: LOW-MEDIUM PRIORITY DISCOVERY SOURCE.

## 10. Wolfram|Alpha
Classification: VERIFIED COMPUTATIONAL KNOWLEDGE ENGINE / SCREENSHOT OVERSTATES STEP-BY-STEP UNIVERSALITY.

Wolfram|Alpha is a computational knowledge engine that computes answers from curated data, algorithms and methods rather than functioning as a normal web search engine. It is particularly strong in mathematics, quantitative science and structured factual computation.

The screenshot claim 'type any math problem and it solves it step by step' is too broad. Wolfram supports many step-by-step solutions, but coverage is not literally universal and some enhanced step-by-step features may depend on product tier/context.

Nexia application:
- strong independent calculation/checking engine for mathematics, symbolic manipulation, units, quantitative science and structured facts;
- useful as a falsification/check layer for model-generated calculations;
- not a general current-events or qualitative research source.

Decision: HIGH-VALUE COMPUTATION CROSS-CHECK SOURCE WHERE AVAILABLE.

## R&D source taxonomy proposed for Nexia

### Tier A — Primary / authoritative
- official documentation
- original research papers
- official repositories/releases
- standards bodies
- canonical project state

### Tier B — Evidence synthesis / structured research
- Elicit
- Consensus
- Scite
- Gemini Notebook with fixed corpus
- Connected Papers for graph exploration only

### Tier C — Discovery
- OpenAlternative
- Awesome lists/repos such as Awesome Seedance
- Open Culture
- community discussions

### Tier D — Education / background
- MIT OCW
- Open Library
- textbooks / lecture collections

### Computational cross-check
- Wolfram|Alpha
- deterministic local code/tests/calculators

Rule: no Tier C discovery source may directly upgrade a Nexia belief to HECHO VERIFICADO without Tier A/B verification where material.

## Net-new Nexia improvements from Batch 02

### CANDIDATE F — SOURCE AUTHORITY ROUTER
Decision: ADOPT AFTER FULL BATCH REVIEW.
Every research question should first determine source class: official docs, papers, repositories, market/community evidence, or computation. Route to the right source instead of using one generic search path.

### CANDIDATE G — DUAL-PATH EVIDENCE CHECK
Decision: ADOPT AFTER FULL BATCH REVIEW.
For material claims, require at least one primary source and one independent synthesis/counterevidence path when feasible.

### CANDIDATE H — KNOWLEDGE GAP TO CURRICULUM
Decision: PREPARE.
When Nexia discovers a persistent capability gap, construct a targeted learning plan from MIT OCW / high-quality textbooks / current papers, then convert learning into tested capability rather than passive notes.

### CANDIDATE I — CROSS-MODEL / CROSS-TOOL RETEST STANDARD
Decision: STRONGLY RECOMMENDED.
Borrow the Awesome Seedance methodology: when a prompt, model behavior, or agent technique is claimed to generalize, retest it on at least one independent model/tool where the cost is justified.

### CANDIDATE J — COMPUTATIONAL FALSIFICATION LAYER
Decision: ADOPT WHEN QUANTITATIVE CLAIMS ARE MATERIAL.
Use deterministic code, calculator tools or Wolfram|Alpha-style computation to independently verify arithmetic, symbolic math, units and quantitative results instead of trusting language-model output alone.

## What not to do
- Do not create accounts across every research platform merely because they exist.
- Do not duplicate capabilities without measurable gain.
- Do not ingest copyrighted or lending-controlled books into Nexia without rights/permission.
- Do not treat directories or social screenshots as authoritative.
- Do not assume academic-search AI is infallible; trace consequential claims to original papers.
- Do not freeze current tool names as permanent architecture.

## Current conclusion
Batch 02 materially strengthens the case for a formal Nexia R&D Intelligence Layer. The highest-value change is architectural: create source routing, evidence-tiering, independent cross-checks and targeted learning loops. The individual websites are sensors or tools inside that architecture, not the architecture itself.

Do not perform broad retrofit until the user's current intelligence dump is complete. Continue collecting batches, deduplicating principles, then issue one consolidated adoption/retrofit plan.
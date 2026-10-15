# NEXIA EXTERNAL AI INTELLIGENCE — BATCH 06
Date: 2026-10-15
Status: PROVISIONAL_RESEARCH / SOURCE_VERIFIED_WHERE_NOTED / NO_CANONICAL_MIGRATION_AUTHORIZED

## Scope
Batch covering the “Obsidian second brain + Claude Code” workflow, Explorable Explanations (`explorabl.es`), and Worse On Purpose (`worseonpurpose.com`).

## Executive decision
- HIGH-VALUE PRINCIPLE: build a tiered Nexia context/knowledge architecture that reduces repeated context loading without weakening truth, provenance or recovery.
- DO NOT replace GitHub/NEXIA_STATE as canonical truth with Obsidian. If Obsidian is ever adopted, it should be a derived human-facing knowledge/graph layer over canonical files, not a second source of truth.
- EXTRACT DESIGN PATTERN: use explorable/interactive explanations for complex Nexia systems when manipulation and feedback improve understanding.
- USE AS REALITY SENSOR: Worse On Purpose can surface product-quality, ownership, consolidation and repairability problems, but its claims require independent verification before becoming Nexia facts.

## 1. Obsidian “second brain” + Claude Code

### Verified substrate
VERIFIED: Obsidian stores notes as plain-text Markdown files in a local vault (a normal filesystem folder). It can coexist with Git and other sync methods. This makes it durable, inspectable and tool-friendly.

VERIFIED: Claude Code supports durable project context through `CLAUDE.md`; Claude reads it automatically at session start for the relevant scope. Claude Code also has project auto-memory and explicit context/memory inspection commands. Each session still has its own conversation history and a finite context window.

VERIFIED: Anthropic itself recommends keeping `CLAUDE.md` lean, using it as a project briefing rather than dumping all documentation into context. Prompt caching can reduce repeated token cost when the same context remains cacheable, but cache behavior is conditional rather than a permanent free-memory mechanism.

### Social claims that are overstated
OVERSTATED: “The chat never loses information.” A vault cannot guarantee this. Context windows are finite; information can be compacted, omitted, stale, contradictory, unavailable to the active model or simply not retrieved.

OVERSTATED: “Every new project is automatically saved there.” Obsidian does not by itself persist every Claude project. That requires explicit workflow/instructions/integration and successful verified writes.

CONDITIONAL: “Claude becomes much faster and uses many fewer tokens.” This can happen when project memory is compact, retrieval is selective and caching hits. It can become slower/more expensive if a large vault is repeatedly loaded or retrieval is poor.

### Nexia assessment
Nexia already has a stronger canonical continuity mechanism than the social post: GitHub `NEXIA_STATE.json` + BOOT/LIVE/events/artifacts with read-back verification. Therefore Obsidian must not become canonical truth.

The useful abstraction is not “a second brain”; it is a **Context Economy & Knowledge Router**:
1. Canonical state and authority: GitHub STATE/BOOT/LIVE + required artifacts.
2. Compact always-on instructions: minimal stable operating contract.
3. Repo/task memory: AGENTS.md / CLAUDE.md-like briefings where appropriate.
4. Indexed retrieval: load deep documents only when materially relevant.
5. Ephemeral session context: current task only.
6. Optional human visualization layer: Obsidian or equivalent graph over derived Markdown.

### Required safeguards
- Every retrieved fact retains provenance/source path and freshness.
- Canonical-vs-derived distinction is explicit.
- Conflicts resolve toward canonical state/evidence, not the most recent note visually encountered.
- No silent write is considered persisted without read-back.
- Deduplicate near-identical notes/context fragments.
- Track stale context and superseded decisions.
- Bound context size and measure token/context cost instead of assuming “more memory = better”.

DECISION: HIGH-PRIORITY ARCHITECTURE CANDIDATE AFTER CROSS-BATCH SYNTHESIS. Obsidian itself is optional; the routing architecture is the material capability.

## 2. Proposed Nexia Context Economy metrics
Candidate metrics for a later experiment:
- context input tokens per completed task;
- percentage of loaded context actually cited/used;
- duplicate-context ratio;
- stale/superseded retrieval rate;
- recovery time after starting a fresh chat/surface;
- number of manual re-explanations required from Kael;
- retrieval precision on known-state questions;
- truth-conflict rate between derived notes and canonical state;
- cache/read reuse where instrumentable;
- failure rate caused by missing context versus excessive/noisy context.

Success is not “largest knowledge graph”. Success is **minimum sufficient context with correct provenance and reliable recovery**.

## 3. Explorable Explanations — explorabl.es
VERIFIED: `explorabl.es` is a real open-source hub of interactive educational pieces across programming, mathematics, physics, economics, psychology and other domains. Its own FAQ defines an “explorable explanation” as something that teaches and is meaningfully more interactive than a single-answer quiz. The site also publishes tools/tutorials for building such interactives.

NEXIA VALUE: This is more valuable as a design pattern than as a dependency.

Adopt pattern:
`EXPLAIN -> MANIPULATE -> OBSERVE -> COMPARE -> LEARN`

Potential Nexia uses:
- interactive explanation of the Lead Intake reliability workflow;
- visual dedup/failure-path simulator;
- Human Gate and authority-flow simulator;
- reliability/rollback demonstrations;
- Nexia HQ modules where users can change assumptions and see consequences;
- educational content for clients/users instead of static long documents.

QUALITY RULE: Only build an explorable when interaction teaches something materially better than static text/diagram. Avoid superficial gamification.

DECISION: REUSABLE UX/EDUCATION PATTERN; defer implementation until a concrete active surface benefits.

## 4. Worse On Purpose — external-reality problem sensor
VERIFIED: `worseonpurpose.com` is active in 2026 and publishes investigations on product quality, ownership, consolidation, repairability, warranties and incentives. It also maintains a Brand Ledger.

EVIDENCE BOUNDARY: It is an investigative/editorial source, not itself a canonical primary source. Its thesis or individual company claims must not become Nexia facts without independent verification from primary or strong corroborating evidence (filings, court/regulatory material, manufacturer documentation, ownership records, recalls, technical data, etc.).

NEXIA VALUE:
- signal source for product/service degradation;
- ownership/consolidation radar;
- repair-vs-replace opportunity discovery;
- identification of customer pain tied to declining quality or opaque ownership;
- possible commercial/research niches around verification, provenance, maintenance, repairability and product-quality data.

This aligns with the Reality Loop: the site provides **signals/hypotheses**, not conclusions.

Candidate workflow:
`editorial signal -> extract falsifiable claim -> primary-source verification -> quantify affected users/economics -> opportunity hypothesis -> minimum test -> measured reality`

DECISION: ADD TO EXTERNAL REALITY RADAR AS A NON-CANONICAL SIGNAL SOURCE. Do not auto-ingest its conclusions as truth.

## 5. Cross-batch improvements triggered
### U — NEXIA CONTEXT ECONOMY & KNOWLEDGE ROUTER
Goal: reduce repeated context loading and recovery friction while preserving canonical truth, provenance, freshness and read-back verification.
Priority: HIGH because it directly addresses continuity/context efficiency without requiring migration to a new app.

### V — EXPLORABLE SYSTEMS PATTERN
Goal: turn complex system concepts into deterministic interactive demonstrations when interaction produces better understanding than prose.
Priority: MEDIUM / apply-on-touch.

### W — PRODUCT DEGRADATION / OWNERSHIP SIGNAL RADAR
Goal: treat investigative/editorial product-quality sources as hypothesis generators, then verify claims independently before portfolio/commercial action.
Priority: MEDIUM as a Reality Loop sensor.

## 6. Non-actions / truth boundaries
- Do not migrate canonical Nexia state to Obsidian.
- Do not install/configure Obsidian just to reproduce a social-media workflow; first prove incremental value over current GitHub continuity.
- Do not claim automatic persistence unless writes and read-backs are verified.
- Do not claim token savings until measured on comparable tasks.
- Do not equate a graph visualization with better retrieval or truth.
- Do not treat Worse On Purpose as a primary source.
- Preserve existing WIP limits; new tooling must solve a measured bottleneck before becoming infrastructure.

## Stop condition
Continue evidence intake while Kael is still supplying batches. After intake closes, deduplicate Batches 01–06, rank candidates by system leverage / external reality value / cost / risk / reversibility, and run only the minimum high-information experiments.
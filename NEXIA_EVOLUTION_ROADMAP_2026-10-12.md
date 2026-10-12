# NEXIA CORE — EVOLUTION ROADMAP (ChatGPT Pro era)

Status: RESEARCHED / PRIORITIZED / PARTIALLY IMPLEMENTED
Date: 2026-10-12
Cost executed: EUR0

## North-star review

Current mission remains unchanged until Kael approves a refinement:
> Build a repeatable business engine that reaches >EUR1000/month sustainable net profit after tax.

Recommended precision, not yet canonical:
- Define `SUSTAINABLE` as >=EUR1000 reconciled after-tax net profit in each of 3 consecutive calendar months.
- Gate A — FIRST EXTRACTION: >=1 settled paid transaction with positive realized contribution.
- Gate B — VALIDATED: >=3 accepted/settled transactions in the same offer/path with positive contribution and bounded human time.
- Gate C — REFINED: measured median delivery/acquisition economics meet the offer-specific thresholds.
- Gate D — SCALABLE: evidence supports a plausible repeatable path to the north star without violating capital/risk constraints.

Reason: the main objective is directionally correct but `sustainable` needs a time denominator and leading economic gates.

## Implemented now (GREEN / EUR0)

1. `AGENTS.md` added for concise repo-level Codex operating rules.
2. Repo-local Codex skills added:
   - `.agents/skills/nexia-checkpoint/SKILL.md`
   - `.agents/skills/nexia-change-verification/SKILL.md`
3. `.github/dependabot.yml` added for weekly GitHub Actions dependency PRs.
4. `NEXIA_EXECUTION_SURFACE_PROTOCOL.md` added so every Human Gate identifies Chat / Work / Codex / Browser / Word / Sheets and device/steps.
5. `NEXIA Evolution Radar` weekly automation reactivated and upgraded to research ChatGPT Pro, Work, Codex, Skills, Plugins, GitHub, n8n, agents/evals and automation improvements.
6. Existing security/integrity assets retained: canonical integrity checker, CI, n8n runtime smokes and public-repo secret scan.

## High-priority next improvements

### P1 — Connect Google Drive plugin
Status: AVAILABLE / NOT INSTALLED.
Value:
- private workspace for Docs/Sheets/Slides instead of putting private business artifacts in the public repo;
- allows Nexia to work directly with structured Sheets and reusable document sources;
- supports creating reference-backed personal artifact-template skills;
- reduces manual copy/paste and data fragmentation.
Authority: requires Kael connection action; no account should be connected automatically.

### P1 — Connect OpenAI Developers plugin
Status: AVAILABLE / NOT INSTALLED.
Value:
- current official OpenAI API/Agents/Codex guidance inside the execution surface;
- accelerates future Nexia Adapter/API/agent development;
- reduces stale implementation assumptions.
Authority: requires Kael connection action.

### P1 — Use Work event-triggered tasks where they replace polling
Status: DESIGN / REQUIRES WORK-SURFACE AVAILABILITY.
Targets:
- Workana approval email;
- n8n Creator review result;
- important GitHub PR/failure events.
Rule: replace, do not duplicate, existing sensors when an event trigger proves reliable.

### P1 — Canonical transaction/economics ledger before first payment
Status: PREPARE BEFORE REVENUE.
Need fields: transaction ID, gross realized price, VAT treatment, platform/payment fees, variable tooling, human hours x rate, refunds/defects, contribution, tax assumption, settled date, after-tax reconciled profit.
Reason: prevents the first sale from being celebrated without actual profit reconciliation.

## Medium-term improvements

### P2 — Private operational data plane
Use Drive/Sheets or an appropriate structured store for customer/private operational data; keep GitHub public repo limited to sanitized state/code/evidence.
Do not add CRM until real leads/deals justify it.

### P2 — CRM connector only after pipeline volume exists
Candidates discovered: HubSpot, Zoho CRM, monday.com/HighLevel.
Gate: at least a recurring live commercial pipeline where manual tracking is measurably costly. Otherwise CRM is premature architecture.

### P2 — Payment connector after first validated sales path
Stripe plugin is available, but connecting it before a real payment flow exists adds exposure without evidence gain.
Gate: offer/channel selected and payment acceptance required.

### P2 — Product analytics after a real public product/site
Candidates: PostHog, Amplitude, Mixpanel.
Gate: real users/events. Before then analytics tooling measures no meaningful behavior.

### P2 — Marketing/social operations after repeatable offer + content engine
Candidates discovered include Metricool and multi-source marketing analytics plugins.
Gate: actual channel strategy and publishing authorization. Do not connect only because the integration exists.

## Future architecture

### P3 — Nexia Adapter / Agents API execution service
Potential role:
- durable agent sessions;
- controlled sandboxes;
- skills/capabilities;
- webhook/event-driven execution;
- explicit per-run spending/authority controller;
- trace/eval instrumentation.

Do not build until it removes a proven limitation of ChatGPT Work/Codex/Automations. Architecture must follow economic need.

### P3 — Evals and traces
Create scenario/eval packs for:
- authority routing correctness;
- state recovery/checkpoint correctness;
- opportunity classification;
- economics reconciliation;
- skill trigger reliability.
Gate: repeatable agent workflows exist often enough that regressions cost material time/risk.

### P3 — Private repository or split public/private architecture
Current `Nexia-care` repository is public. If Nexia begins storing proprietary strategy, customer operational data or production config, create a private data/control repository or equivalent private store. Do not move merely for aesthetics; trigger when confidentiality need is real.

## ChatGPT Pro operating model

- Chat: control plane, strategy, research, economics, authority, orchestration.
- Work: long, GUI-heavy, authenticated multi-step execution and event-triggered workflows.
- Codex: repository implementation, debugging, tests, CI, n8n engineering.
- Browser: Kael-only authentication/2FA/final side-effect gates when necessary.
- Word/Documents: final document deliverables, not canonical state.
- Sheets: structured economics/pipeline/operational analysis, not duplicate state.
- Automations: future monitoring/scheduled delivery, never authority bypass.

Use high reasoning only where it changes decision quality. Move repetitive code work to Codex and long app/browser work to Work.

## Skills strategy

Use skills for narrow repeatable workflows, not a single giant Nexia skill.
Recommended sequence:
1. checkpoint (implemented)
2. code/change verification (implemented)
3. opportunity falsification skill
4. unit-economics reconciliation skill
5. commercial Human Gate preparation skill
6. external-submission verification skill

Each future skill needs a trigger description, workflow, evidence boundary and regression/eval cases.

## Anti-bloat rule

Do NOT add a tool because it exists. Add it only if one of these is measurable:
- reduces human time;
- improves evidence quality;
- removes a current blocker;
- reduces risk/error rate;
- improves economics or acquisition;
- enables an experiment otherwise impossible.

No measurable benefit -> no integration risk.

# NEXIA CORE — CAPABILITY EVOLUTION AUDIT 2026-10-12

Status: EXECUTED / ZERO-COST AUDIT + GREEN IMPROVEMENTS APPLIED

## Executive conclusion

Nexia does not currently need more architectural layers. The highest-value evolution is to make the existing stack more deterministic, reusable and event-driven while preserving economic focus.

Recommended stack:
- ChatGPT Chat = control plane / strategy / economics / authority.
- Work = long multi-step and authenticated GUI execution.
- Codex = code/repository/tests/CI.
- GitHub = canonical persistence + CI + public non-sensitive evidence.
- Automations = future sensors, monitoring and recurring research.
- Google Drive/Docs/Sheets/Slides = business workspace and deliverables, not canonical state.
- Plugins = narrow external capabilities only when they remove real manual work.
- Skills = narrow repeatable workflows, not a giant Nexia skill.

## Improvements applied now

### 1. Codex repository contract
Created root `AGENTS.md`.
Effect: Codex receives concise mission, authority, verification, persistence and handoff rules without requiring them in every prompt.

### 2. Local Codex skills
Created:
- `.agents/skills/nexia-checkpoint/SKILL.md`
- `.agents/skills/nexia-change-verification/SKILL.md`

Effect: repeatable state reconciliation and verification workflows can be loaded only when relevant, reducing prompt/context duplication and false completion claims.

### 3. Human execution-surface protocol
Created `NEXIA_EXECUTION_SURFACE_PROTOCOL.md`.
Effect: every Human Gate should identify Chat / Work / Codex / Browser / Word / Sheets, device, exact steps, cost/exposure, success check and evidence to return.

### 4. Dependabot for GitHub Actions
Created `.github/dependabot.yml` with weekly GitHub Actions version updates.
Effect: reduces silent technical debt in CI actions at EUR0; PRs still require review before merge.

### 5. Continuous capability radar
Reactivated and modernized weekly automation as `NEXIA Capability Evolution`.
Scope: OpenAI/ChatGPT Pro, Work, Codex, Skills, Plugins, GitHub, n8n and useful zero-cost capabilities.
Authority: research + safe internal GREEN changes only; no account connection, spend, publication or external contact.

### 6. Objective review
Created `NEXIA_OBJECTIVES_REVIEW_2026-10-12.md`.
North Star remains >EUR1,000/month sustainable after-tax net profit.
Added evidence ladder O1 first paid pilot -> O2 repeatability -> O3 productization -> O4 sustainable scale.
No economic stage promotion occurred.

### 7. Project-instruction patch
Created `NEXIA_PROJECT_INSTRUCTIONS_PATCH_2026-10-12.md` with exact text ready for Kael to append in ChatGPT Project settings.
This adds execution-surface routing, Pro usage discipline, Skills/Plugins rules, objective-review cadence and event-trigger automation rules without replacing existing mission/authority/evidence controls.

### 8. Google Drive
Google Drive became connected during this audit.
Intended role: Docs/Sheets/Slides deliverables, business calculations, working files and project source links.
Boundary: GitHub/NEXIA_STATE.json remains canonical. Do not duplicate the live operational state into Drive.

## OpenAI Developers plugin status

Conflicting platform evidence exists:
- Plugin Directory search reports `OpenAI Developers` as installed/enabled.
- Permission inspection reports `not_installed`.
- No callable OpenAI Developers tool namespace is currently exposed in this conversation.

Classification: `REGISTERED_OR_INSTALLED_BUT_OPERATIONALITY_NOT_VERIFIED`.
Decision: do not depend on it for critical Nexia work until a real callable action is exposed and verified. No repeated install attempts are needed merely to create activity.

## ChatGPT Pro optimization

Use agentic quota as scarce operating capacity.
- Prefer normal Chat for status, research, economics, short synthesis and orchestration.
- Prefer Codex for repository/code/test work instead of generating large code changes manually in Chat.
- Prefer Work for long external/browser/file workflows.
- Escalate to Astra/high reasoning only when complexity/information value justifies the higher allowance use.
- Before large Work/Codex batches, check the account Usage page because current OpenAI documentation states Work and Codex can draw from a shared included allowance depending on plan/configuration.
- Avoid doing the same task independently in Chat, Work and Codex.

## Skills strategy

Create Skills only for stable repeatable workflows with a narrow trigger and verification boundary.

Current recommended skill families:
1. checkpoint/state reconciliation — IMPLEMENTED for Codex;
2. change verification — IMPLEMENTED for Codex;
3. commercial opportunity qualification — FUTURE only after enough real applications to learn a stable workflow;
4. delivery/handover packaging — FUTURE after first accepted pilot;
5. realized unit-economics reconciliation — FUTURE after first settled transaction.

Do not build these future skills before real evidence exists; premature skills would encode hypotheses as process.

ChatGPT personal/template skills may be useful for reusable document/report/spreadsheet layouts. They should be used for presentation consistency, not business-state persistence.

## Plugins / connectors — priority

### Connected / useful now
- GitHub: canonical repo/CI; inherited low-risk permission policy.
- Gmail: operational signal reading; external sends remain gated.
- Google Drive: workspace/deliverables; newly connected.
- TinyFish: browser capability available but n8n authenticated profile handoff remains previously blocked/unreliable.

### Do not connect yet
- CRM (HubSpot/Zoho/HighLevel): no real lead/customer volume yet; adds complexity before first sale.
- Stripe: no validated payment flow or product sales yet; financial connector is premature.
- Marketing analytics/ad connectors: no paid acquisition operation yet.
- Vercel/Render/MongoDB/etc.: only when a selected product actually requires deployment/backend infrastructure.

Gate for a new plugin: it must replace a recurring manual task, improve evidence or unlock an active experiment better than existing tools, with clear permissions/cost/maintenance.

## GitHub / engineering roadmap

NOW:
- AGENTS + local skills + existing CI + secret scan + Dependabot.
- Keep Actions read-only/minimal permissions where possible.

NEXT:
- Use Codex to make canonical checkpoints coherent/atomic when state changes materially.
- Add tests only when they protect a real repeated failure mode.

LATER:
- branch/ruleset protection if repository workflow starts using PR-based production changes or multiple contributors;
- deployment observability only once a live product exists;
- dependency/security tooling based on actual dependency surface, not tool collecting.

## Automation roadmap

NOW:
- current scheduled Control Tower, parallel work, business radar and capability evolution.

NEXT:
- event-triggered Gmail/GitHub Work tasks when a supported event maps cleanly to a current bottleneck; prefer events over frequent polling.
- n8n Creator approval/change request can eventually use an email event trigger if the exact sender/subject pattern becomes stable.

Important limitation from OpenAI documentation: Scheduled tasks created in a Project cannot access uploaded/project files automatically, so task instructions must name accessible external/canonical sources explicitly.

## Economic objective ladder

O1: >=1 paid pilot >=EUR249 equivalent, settled, accepted, <=4 human hours, positive realized contribution.
O2: >=3 accepted paid deliveries, median <=3h, positive economics.
O3: >=5 accepted deliveries/meaningful external product uses; service median <=2h; realized pricing/support/onboarding measured.
O4: realized and reconciled path to >EUR1,000/month sustainable after-tax net profit.

Current status remains before O1. Technical improvements do not advance this ladder by themselves.

## Highest-value next Human Gate

Append the prepared project-instruction patch in ChatGPT Project settings. This changes behavior across future Nexia chats and enforces surface/device/step-by-step guidance requested by Kael.

Cost: EUR0.
Risk: low/reversible.
Economic effect: indirect; expected reduction in execution friction and duplicated work.

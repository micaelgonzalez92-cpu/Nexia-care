# NEXIA CORE — EVOLUTION AUDIT 2026-10-12

Status: EXECUTED RESEARCH + PARTIAL IMPLEMENTATION / NO ECONOMIC STAGE PROMOTION

## Executive conclusion

Nexia does not currently need a larger architecture. It needs tighter routing between business strategy, long-running execution, code, persistent state, external apps and human gates. The highest-value improvements are those that reduce repeated context, reduce manual verification, improve event responsiveness and convert paid ChatGPT Pro capabilities into evidence velocity without opening more business WIP.

## Verified changes implemented now

1. Root `AGENTS.md` created for Codex repository behavior.
2. Repo-local Codex skill `$nexia-checkpoint` created for canonical state reconciliation.
3. Repo-local Codex skill `$nexia-change-verification` created for code/CI/runtime verification.
4. `.github/dependabot.yml` configured for weekly GitHub Actions version updates. Presence is verified; future Dependabot PR creation remains unverified until observed.
5. `NEXIA_EXECUTION_SURFACE_PROTOCOL.md` created so every Kael task identifies Chat / Work / Codex / Browser / Word / Sheets and mobile/computer.
6. `NEXIA Capability Evolution` weekly automation reactivated to monitor material changes in ChatGPT Pro, Work, Codex, Skills, Plugins, GitHub and n8n without spend or external side effects.
7. Google Drive connected during the audit. It is a delivery/analysis surface, not the canonical state source.
8. `NEXIA_OBJECTIVES_REVIEW_2026-10-12.md` created; North Star remains >EUR1,000/month sustainable after-tax net profit and the next economic gate remains first paid accepted pilot.

## Current architecture recommendation

### ChatGPT Chat — control plane
Use for:
- mission, economics and prioritization;
- web research/falsification;
- authority/Human Gates;
- plugin reads/actions;
- selecting the next batch.

Do not use Chat for long code implementation when Codex is available.

### ChatGPT Work — long multi-step execution
Use for:
- authenticated GUI/browser workflows;
- substantial cross-app work;
- long deliverable creation;
- event-triggered tasks where supported.

Work and Codex can share plan allowance/credits depending on plan. Reserve Work for tasks that actually need a cloud computer or multi-step app interaction.

### Codex — engineering plane
Use for:
- repository changes;
- tests/refactors/debugging;
- GitHub Actions;
- n8n engineering;
- scripts/adapters.

Codex should receive stable context through `AGENTS.md` and narrow `.agents/skills/`, not through giant repeated prompts.

### GitHub — canonical persistence + CI
Keep `NEXIA_STATE.json` as business/operational source of truth. Use Actions for repeatable verification, immutable events for evidence and Dependabot for maintenance. Do not turn commit count into business progress.

### Google Drive / Docs / Sheets / Slides — business artifacts
Use Drive for human-readable reports, customer handovers, financial sheets, experiment tables and presentations. Never duplicate canonical state just for display. Sensitive/customer data should not enter the public GitHub repo.

### Automations — sensors, not autonomous authority
Use scheduled/monitoring tasks for change detection and recurring research. Event-triggered Work tasks are attractive for Gmail/GitHub signals because they react to supported events rather than polling. They still inherit app permissions and Human Gates.

## Skills strategy

### Use now
Repo-local Codex skills for repeated engineering workflows:
- checkpoint/persistence;
- change verification.

### Add after repetition is observed
Potential future skills:
- `nexia-experiment-preregistration` — only if experiment setup repeats enough to justify it;
- `nexia-commercial-evidence-pack` — after at least one real commercial cycle;
- `nexia-n8n-product-release` — only after template/product distribution becomes recurring;
- `nexia-openai-integration` — only when Nexia actually implements OpenAI API/agent code.

Do not build one giant "Nexia skill". Global policy belongs in project instructions/AGENTS; skills should stay narrow and triggerable.

## Plugin / connector evaluation

### Connected / high relevance
- GitHub: canonical repo/CI.
- Gmail: approval/operational signals.
- Google Drive: documents, Sheets, Slides and file lifecycle.
- TinyFish: browser automation, but previous n8n authenticated setup route was blocked; do not depend on it for current n8n Creator state.
- OpenAI Developers: plugin catalog/dependency metadata reports installed and user-enabled. Permission inspection produced a contradictory `not_installed` result and no direct tool namespace is exposed in this chat. Treat as INSTALLED / DIRECT ACTION OPERABILITY NOT VERIFIED until a real callable capability is observed.

### Useful later, not now
- Stripe: connect only when there is an actual product/payment flow to instrument. Before that it adds surface without economic value.
- HubSpot / Zoho / Airtable / monday: do not connect before repeated real leads/customers justify a CRM. Current volume is zero.
- Mixpanel/PostHog/Amplitude: connect when Nexia has a real public product/funnel with users. Current external users=0.
- Windsor/Supermetrics/Metricool: useful only after real marketing/social/ad channels are active. Do not connect merely for capability accumulation.
- Render/Vercel/Lovable/Floot: evaluate when a concrete production application needs hosting. No deployment should precede a validated use case.

## GitHub improvements

### Applied now
- Dependabot for GitHub Actions.
- Existing CI for state integrity and product tests.
- Existing secret scan.
- Reduced ChatGPT GitHub permission from app-specific full access to inherited low-risk default.

### Next when justified
- Require PR/checks before main only if branch-protection capability becomes available and the friction is justified by multiple contributors or higher production risk.
- Add a CODEOWNERS/review policy only when there are actual multiple contributors or automated PR flow requiring ownership.
- Add dependency ecosystems to Dependabot only when actual package manifests exist; do not add empty config.

## ChatGPT Pro exploitation strategy

1. Keep Chat as low-friction strategy/control plane.
2. Use higher reasoning only for high-value ambiguity, economics, architecture and stubborn debugging.
3. Use Work for long app/browser flows and event-triggered workflows.
4. Use Codex for repository/code tasks; do not burn Work quota on straightforward code.
5. Use Scheduled Tasks for monitoring. Pro supports more active tasks than lower tiers, but task count is not a KPI.
6. Exploit Plugins only when they remove a current manual bottleneck or expose needed real data.
7. Use Skills to encode repeated workflows after repetition is demonstrated, not prospectively for every possible task.
8. Use Drive/Sheets for structured business data and human deliverables while GitHub remains canonical.

## Event-driven automation recommendation

Future high-value migration:
- Workana/n8n approval emails: replace or complement daily polling with an event-triggered Gmail Work task if the UI exposes the supported event trigger for this connected account.
- GitHub PR activity: use an event-triggered Work task only when Dependabot/Codex starts creating PRs that need triage.

Do not create event-triggered tasks merely to consume available quota.

## Objective review

North Star remains valid. Do not replace it.

Operating gates:
- O1: >=1 paid pilot >=EUR249 equivalent, settled, accepted, <=4 human hours, positive realized contribution.
- O2: >=3 accepted paid deliveries, median <=3 human hours.
- O3: >=5 accepted deliveries/meaningful external product uses, service median <=2h and realized median price >=EUR400 or equivalent economics.
- O4: repeatable route to >EUR1,000/month sustainable after-tax net profit with full cost reconciliation.

The current machine is still pre-validation. More architecture is subordinate to the first real economic proof.

## Priority roadmap

### P0 — NOW
- Wait for n8n Creator #1 review and Workana moderation while sensing zero-cost alternatives.
- Preserve current economic gates.
- Use the new execution-surface contract for every Human Gate.
- Use Codex AGENTS/skills on the next engineering task.
- Let Dependabot run; verify only when first PR appears.

### P1 — NEXT MATERIAL EVENT
If Workana approves:
- reverify Huescaventura;
- submit already-authorized EUR300 proposal only if still open and EUR0 submission;
- instrument delivery hours and realized economics immediately.

If n8n approves template #1:
- record 1 approved template;
- measure external usage/installation evidence;
- prepare template #2 internally;
- require a new explicit Kael authorization before submission.

### P2 — AFTER FIRST PAID CUSTOMER
- create a real sales/experiment Sheet in Drive if it reduces reconciliation work;
- connect Stripe only if it matches the actual payment route;
- add CRM only after repeated leads justify it;
- create a commercial evidence-pack skill only after the workflow repeats.

### P3 — AFTER EXTERNAL USERS / PRODUCT TRAFFIC
- connect product analytics (PostHog/Mixpanel/Amplitude) based on stack fit;
- build event-triggered user/support monitoring;
- evaluate production hosting/deployment tooling.

## Rejected for now

- More parallel business veins.
- Generic CRM before customers.
- Analytics stack before users.
- Paid marketing tooling before validated acquisition economics.
- New hosting before a concrete application/use case.
- Large all-purpose skill framework.
- Additional internal n8n engineering with no review/user request.

## Cost and truth boundary

Implemented audit improvements cost EUR0 in direct spend.
No implemented capability produces revenue by itself.
Revenue, settled revenue and realized profit remain EUR0.

# NEXIA CORE — AUTHORITY & ACTION PERMISSION MATRIX

Status: CANONICAL / ACTIVE
Version: 1.1
Effective date: 2026-10-12
Purpose: convert Kael authority + technical capability into one deterministic pre-action router. This file does **not** grant new authority. It narrows execution to the safest interpretation of existing authority.

## 1. Core rule: four gates before execution

Every material action must pass, in order:

1. **CAPABILITY GATE** — Is the required tool/account actually connected and able to perform the action?
2. **TECHNICAL PERMISSION GATE** — Does ChatGPT/app permission allow the tool call without an additional platform confirmation?
3. **KAEL AUTHORITY GATE** — Is this action type already authorized at the exact scope/account/cost/exposure required?
4. **COST/RISK GATE** — Is the action free or within an explicit spend/risk approval, reversible enough, legal, and consistent with current experiment limits?

Decision:
- All four PASS -> EXECUTE and verify.
- Capability/technical permission missing -> BLOCKED / NOT_CONNECTED.
- Human authority missing but preparation is safe -> PREPARE_ONLY / YELLOW.
- Spend, external commitment, publication, contact, account creation, production activation or material irreversible risk without exact approval -> RED / HUMAN_GATE.

A tool's technical permission never expands Kael's authority. Work, Codex, browser automation, automations and plugins are execution planes, not authority sources.

## 2. Effective authority classes

| Action class | Default Nexia authority | May execute without new confirmation? | Notes |
|---|---|---:|---|
| Public web research / market research | GREEN | YES | Read-only; verify freshness for material decisions. |
| Read canonical GitHub state / CI / logs | GREEN | YES | Existing project scope. |
| Write/update canonical Nexia state, events, tests, docs and code in `Nexia-care` | GREEN | YES | Only safe/reversible project-internal changes; repo is public, so never store secrets/private data. Re-read after commit. |
| Run CI/tests / synthetic experiments | GREEN | YES | No production side effects, no paid infrastructure, no buyer-facing sends. |
| Create/update internal automations that only monitor/research/notify | GREEN | YES | Future task inherits the same authority limits; scheduling never grants future publication/contact/spend authority. |
| Draft proposals, emails, listings, templates, forms | GREEN | YES | Draft/preparation only; do not submit/send/publish. |
| Read connected Gmail for project-relevant operational signals | GREEN | YES | Read/search only; avoid unrelated personal data. |
| Archive/label/modify external mailbox state | YELLOW | NO by default | Execute only when specifically useful and authorized; sending is separate RED class. |
| Authenticated browser navigation / read-only inspection of an already authorized account | GREEN/YELLOW | YES only if no side effect | Stop before submission, purchase, account setting changes or commitments unless separately authorized. |
| Fill a form but do not submit | YELLOW / PREPARE_ONLY | YES when reversible | Must stop before external commitment. |
| External message/contact/proposal submission | RED | NO | Exact recipient/platform/scope/cost must be explicitly authorized. Existing one-off authorization does not generalize. |
| Public marketing/content/template publication | RED | NO | Exact asset/channel/scope must be authorized. Routine canonical GitHub persistence is the exception already authorized by project architecture. |
| Create a new external account / creator profile / seller account | RED | NO | Exact platform/purpose required. |
| Spend money / buy credits / subscriptions / ads / Connects / moderation | RED | NO | Exact amount and purpose required; weekly cap remains EUR100 unless Kael changes it. |
| Connect payment method / wallet / banking / payouts | RED | NO | Material financial exposure. |
| Production deployment or activation affecting real users/buyers | RED | NO | Requires explicit scope + rollback + success criterion. |
| Delete production/external data, irreversible destructive change | RED | NO | Explicit approval required. |
| Rotate/revoke exposed secret after verified security incident | RED unless emergency policy specifically authorizes | NO by default | Preserve evidence and minimize downtime; never expose secret values in chat/repo. |

## 3. Current technical permission layer (snapshot 2026-10-12)

This section records observed technical access; it does not override the authority table.

### GitHub
- Connection: CONNECTED.
- ChatGPT app permission: `Use my default`.
- Effective inherited global permission: `Allow low-risk actions`.
- Previous app-specific override `Allow all actions` was removed by explicit Kael instruction on 2026-10-12.
- Observed capability: repository read/write, file create/update/delete, commits/branches/PR/issues, CI/run/log inspection within exposed connector functions, subject to the current ChatGPT permission layer.
- Limits: plugin/connector does not imply unrestricted GitHub administration, secrets access or deployment access.
- Effective Nexia rule: internal canonical repo work may be GREEN when permitted by the platform; external/public business publication or risky destructive changes still require the relevant Kael authority gate.

### Gmail
- Connection: CONNECTED.
- ChatGPT app permission: inherits global `Allow low-risk actions`.
- Observed connector family includes read/search plus mail-changing/sending actions.
- Effective Nexia rule: project-relevant read/search is GREEN; sending/forwarding external mail is RED unless explicitly authorized; mailbox mutations are YELLOW unless specifically required.

### TinyFish / browser automation
- Connection/plugin: INSTALLED / AVAILABLE.
- ChatGPT app permission: inherits global `Allow low-risk actions`.
- Capability: dynamic browser navigation/click/forms and reusable browser profiles when authentication works.
- Current operational limitation: n8n profile-setup handoff links repeatedly expired on 2026-10-12; do not claim authenticated TinyFish access to n8n.
- Effective Nexia rule: public/read-only browser work may be GREEN; external submission/account changes/purchases remain gated.

### Automations
- Capability: CONNECTED / ACTIVE.
- Effective Nexia rule: safe monitoring, research and notifications may be created/updated GREEN. A scheduled task cannot bypass future Human Gates and must not be written to autonomously spend, publish, contact or commit externally without a matching standing authorization.

### Work / Codex / GitHub Actions
- Role: execution environments for long multi-step work, code, CI and browser/app interaction.
- Effective Nexia rule: execution environment does not expand authority. All actions still pass this four-gate router.

### n8n Creator
- Account: ACTIVE by Kael confirmation.
- Template #1: `SUBMITTED_PENDING_REVIEW`, Creator workflow ID 20799, cost EUR0.
- Template #2 submission / paid product publication: NOT AUTHORIZED.
- Direct n8n connector: NOT CONNECTED; current authenticated interaction is human/browser-side.

### Workana
- Account/profile: authenticated previously; freelancer moderation pending by latest verified state.
- Direct Workana connector: NOT CONNECTED.
- One Huescaventura proposal at EUR300: specifically authorized **only after** profile approval is verified, opportunity remains open and submission cost is EUR0.
- This one-off authorization does not authorize other proposals, contacts, payments or platform purchases.

## 4. Standing permissions vs one-off permissions

### Standing GREEN authority
Nexia may, without asking again:
- research and falsify opportunities;
- read project-connected sources when relevant;
- run tests/CI/synthetic experiments;
- improve safe reversible internal code/docs/state;
- create/update safe monitoring automations;
- prepare drafts and execution packages;
- reconcile/persist verified project state in the canonical repo;
- stop or avoid an action when evidence, capability or authority is insufficient.

### Always gated unless Kael gives an exact standing authorization
- spend or financial exposure;
- external messages/proposals/contact;
- new external accounts;
- public business/marketing publication;
- real-user production activation/deployment;
- material deletion/destructive changes;
- payment/wallet/banking setup;
- legal/contractual commitments;
- widening data access or permissions.

## 5. Permission inheritance rule

`/next`, `/batch`, `continue`, `ejecutar`, `hazlo`, silence or generic approval do **not** widen authority.

A specific authorization is represented as:
`ACTION + TARGET + SCOPE + MAX_COST + EXPOSURE + EXPIRY/CONDITION`.

Example:
`Submit template #1 to n8n Creator + FREE + EUR0 + public exposure + only this template`.
It does not authorize template #2 or a paid listing.

## 6. Automatic routing behavior

Before any material action, Nexia should internally classify:
- `GREEN_EXECUTE`
- `YELLOW_PREPARE_ONLY`
- `RED_HUMAN_GATE`
- `BLOCKED_NOT_CONNECTED`
- `BLOCKED_TECHNICAL_PERMISSION`

For GREEN actions, execute without redundant confirmation and verify the result.
For YELLOW, complete all safe preparation and stop immediately before the external side effect.
For RED, present one compact Human Gate: exact action, reason, cost/exposure, risk, reversibility and success criterion.

## 7. Permission drift audit

Re-check the technical permission snapshot when:
- a plugin/tool is connected, removed or its permission is changed;
- a new external account becomes operational;
- a previously blocked authenticated browser flow starts working;
- a command or automation begins performing a new action class;
- Kael grants or revokes a standing authorization.

Latest verified drift:
- 2026-10-12: GitHub changed from app-specific `Allow all actions` to `Use my default`, inheriting global `Allow low-risk actions`; effect = reduced technical exposure, no expansion or reduction of Kael's business authority.

Do not re-audit unchanged tools every cycle. Persist only material changes.

## 8. Security boundary for the public canonical repo

`Nexia-care` is public. Allowed persistence: project state, non-sensitive evidence, sanitized logs, code, tests, economics, decisions and authority metadata that do not expose personal/private secrets.

Never persist: passwords, API keys, cookies/session tokens, payment details, private identity documents, private customer data, confidential buyer data, or raw credentials.

If a sensitive value appears, keep it out of GitHub, redact it from derived artifacts and treat remediation as a security task under the Authority Engine.

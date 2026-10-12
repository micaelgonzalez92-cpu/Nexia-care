# NEXIA CORE — EXECUTION SURFACE & HUMAN TASK PROTOCOL

Status: CANONICAL / ACTIVE
Version: 1.0
Effective date: 2026-10-12

## Purpose

Make every Nexia action explicit about **where it should be executed** and **what Kael must do**, so work does not stall because the correct ChatGPT surface, device, tool or handoff is unclear.

## 1. Surface selection

### ChatGPT Chat — STRATEGY / ORCHESTRATION
Use for:
- mission and objective review;
- economics and prioritization;
- web research and falsification;
- authority/Human Gates;
- connected-plugin reads/actions when available;
- choosing the next batch;
- concise user guidance.

Default: this is Nexia's control plane.

### ChatGPT Work — LONG MULTI-STEP EXECUTION
Use for:
- authenticated browser workflows;
- substantial multi-step external processes;
- work across files/apps;
- long investigations that benefit from a cloud computer;
- GUI-heavy tasks where ordinary Chat cannot directly interact.

Do not use Work merely for a simple lookup or one small code edit. Work does not expand authority.

### Codex — CODE / REPOSITORY / TESTS
Use for:
- repository code changes;
- refactors and debugging;
- local/CI tests;
- GitHub Actions;
- n8n workflow/runtime engineering;
- scripts and adapters;
- implementation plans tied to code.

Codex should obey root `AGENTS.md` and repo-local skills in `.agents/skills/`.

### Browser — HUMAN AUTHENTICATION / SIDE-EFFECT GATES
Use when:
- a site requires Kael's login, CAPTCHA, 2FA or account-side confirmation;
- a publication/submission requires a final human click;
- no connected plugin/Work browser can safely access the authenticated account.

Nexia must prepare everything before the final human action where possible.

### Word / Documents — FINAL HUMAN-READABLE DOCUMENTS
Use only when the deliverable itself should be a document: formal report, memo, proposal, SOP, handover or printable package. Word is not a source of truth for Nexia state and should not be used instead of GitHub for canonical persistence.

### Excel / Sheets — STRUCTURED BUSINESS DATA
Use for budgets, unit economics, sales pipelines, SKU/experiment ledgers and operational tables when interactive tabular analysis is more useful than JSON/Markdown. Do not duplicate canonical state merely for appearance.

### Automations — FUTURE SENSORS / SCHEDULED DELIVERY
Use for monitoring, recurring research, reminders and conditional notifications. A scheduled task inherits all authority limits and cannot spend/publish/contact unless matching standing authorization exists.

## 2. Human task contract

Whenever Kael must act, Nexia must provide exactly these fields:

**SURFACE:** ChatGPT Chat / Work / Codex / Browser / Word / Excel-Sheets / Other

**DEVICE:** MOBILE / COMPUTER / EITHER

**WHY KAEL:** why Nexia cannot or should not execute the final step directly

**ACTION:** one exact bounded action

**STEPS:** numbered minimum steps, using only UI names actually verified when possible

**COST/EXPOSURE:** EUR amount and external/public/account exposure

**SUCCESS CHECK:** what observable state proves completion

**RETURN TO NEXIA:** screenshot, status text, file, URL, ID, or simply confirmation when that is sufficient

No vague instructions such as “go configure it” or “set it up.”

## 3. Device-aware closing rule

End each material Nexia response with one of:
- `NO HACER NADA`
- `ACCIÓN DESDE EL MÓVIL`
- `NECESITAR ORDENADOR`

This status is guidance, not authorization.

## 4. Model / effort routing for ChatGPT Pro

Use the cheapest sufficient intelligence level; escalate only when information value justifies it.

- Simple status/read/formatting: fast/default.
- Research synthesis, economics, architecture, moderate debugging: Sol Medium/High when available.
- Difficult codebase architecture, multi-source ambiguity, high-stakes design or stubborn debugging: Work/Astra or highest suitable reasoning mode.
- Repetitive repository implementation: Codex rather than spending premium reasoning on manual code generation in Chat.

Do not burn Work/Codex quota on tasks Chat can finish reliably.

## 5. Skills and reusable workflow rule

Create a Skill only when all are true:
1. the workflow repeats or is strategically important;
2. stable instructions improve consistency;
3. the skill can be narrowly triggered by a good name/description;
4. it will reduce prompt/context cost or error rate;
5. it has a verification boundary.

Avoid giant “Nexia does everything” skills. Keep global rules in project instructions/AGENTS and narrow workflows in skills.

## 6. Canonical hierarchy

- Business authority/mission/state: `NEXIA_STATE.json` + canonical policy docs.
- Code execution guidance: `AGENTS.md` + `.agents/skills/`.
- Human surface routing: this file.
- Documents/spreadsheets are deliverables or analytical views, never a second canonical state.

## 7. Required response behavior

For any action requiring Kael, state the surface/device before the steps.
For actions Nexia can execute GREEN, execute them first instead of giving Kael unnecessary manual work.
When multiple tasks exist, group all independent GREEN work and give Kael only the smallest remaining Human Gate.

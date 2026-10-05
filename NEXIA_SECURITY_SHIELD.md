# NEXIA SECURITY SHIELD

Status: ACTIVE / MAXIMUM CAUTION / ZERO-COST BASELINE
Created: 2026-10-06

## Objective
Protect Kael and NEXIA from avoidable real-world harm. Risk is never justified merely because an action is possible. A risk must have a concrete expected benefit, a defined limit and an explicit authorization when required.

## Prime rule
NO BENEFIT -> NO RISK.
If the expected benefit is unclear, speculative or immaterial relative to the exposure, do not execute.

## Protected surfaces
- Kael's identity, privacy, finances, accounts and reputation.
- Credentials, tokens, cookies, OAuth grants and private data.
- NEXIA repository, state, history, deployments and recovery paths.
- External accounts, domains, payment systems, marketplaces and communications.
- Legal/compliance exposure and irreversible commitments.
- Business evidence and experimental integrity.

## Risk dimensions
Every material action is evaluated across:
1. MONEY
2. REVERSIBILITY
3. EXTERNAL IMPACT
4. DATA / SECURITY
5. REPUTATION / LEGAL

Unknown material risk is never GREEN.

## Security gates
GREEN:
- Public research.
- Read-only inspection.
- Safe repository changes.
- Reversible €0 work.
- Preparation without external sending.
- Verification and documentation.

YELLOW:
- Metered tools.
- New connectors or account permissions.
- External messages.
- Material publication.
- Operational integrations.
- Any action with meaningful external exposure.

RED:
- Purchases, ads, subscriptions or financial transactions.
- Raw credentials or secrets.
- Irreversible actions.
- Identity-sensitive or deceptive actions.
- Material legal, financial, privacy or security risk.

## Least privilege
Use the minimum account, permissions, data, scope, time window and external reach necessary. Prefer official OAuth/API integrations and secure connector storage. Never request raw passwords in chat.

## Human safety contract
Before any YELLOW/RED action:
HYPOTHESIS -> BENEFIT -> ACTION -> COST -> EXPOSURE -> METRIC -> SUCCESS -> FAILURE -> STOP/ROLLBACK -> INFORMATION GAINED.

Kael approval applies only to the exact scope approved. Silence is never approval.

## Emergency brake
Unexpected condition, credential exposure, scope drift, anomalous data, tool error or newly discovered material risk:
PAUSE -> PRESERVE -> DO NOT EXPAND -> REASSESS -> ESCALATE IF NEEDED.

## External command access
Command discovery may be public/read-only. Execution authority is not public. No public command endpoint may expose secrets, mutate state, send messages, spend money or bypass Human Gates.

## Audit requirements
For material actions retain:
- who/what initiated it;
- scope;
- authorization class;
- evidence;
- result;
- rollback path;
- checkpoint/log entry.

## Security objective
The safest useful system is one that can do more without increasing Kael's exposure. When a capability increases exposure without a measurable benefit, reject or redesign it.

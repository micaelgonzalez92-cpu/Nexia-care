# NEXIA EXP-AUTO-001 — CAPABILITY DEMO / CHANNEL FALSIFICATION

Date: 2026-10-11
Status: SYNTHETIC CAPABILITY DEMO EXECUTED / 9 OF 9 TESTS PASS / NO CLIENT DEPLOYMENT / NO OUTREACH
Cost: €0

## Why this exists

Current buyer-initiated marketplace research shows a structural acquisition problem:
- higher-budget lead/CRM automation briefs ($300–$1,000 examples observed) frequently require prior similar production projects, screenshots/case studies, platform-specific experience or a portfolio;
- lower-friction briefs frequently pay only $5–$30 and fail EXP-AUTO-001's contribution target;
- Nexia must not invent production/client experience to cross that gap.

Therefore the next safe action was to create and test a truthful synthetic reference implementation of the reliability logic buyers repeatedly request.

## Files

- `prototypes/lead-intake-reliability-demo.js`
- `prototypes/test-lead-intake-reliability-demo.js`

These files do not connect to email, CRM, WhatsApp, Slack, n8n, Make, GoHighLevel or any external service. They use an in-memory store and synthetic data only.

## Capability demonstrated

The reference implementation covers:
1. deterministic input normalization;
2. required-field validation;
3. email and phone validation;
4. idempotent event handling;
5. deduplication by known identities;
6. non-destructive merge: populated existing fields are preserved rather than silently overwritten;
7. explicit internal-notification objects rather than real sends;
8. acknowledgement **drafts** explicitly marked as not sent;
9. synthetic failure injection before commit;
10. failure alerts requiring manual review;
11. no partial write on the injected pre-commit failure;
12. audit entries for committed events.

## Test execution

Runtime: Node.js v22.16.0.

First execution: **7/8 PASS**.

The failed case attempted to treat an international phone (`+34 600...`) and a local form (`600...`) as automatically equivalent. That assumption is unsafe without country context and can create false duplicate matches.

### Repair

Phone normalization was changed so that local/international equivalence is applied only when `defaultCountryCode` is explicitly configured. Without that context the system does not guess.

A negative regression case was then added to prove that an unconfigured local number is **not** silently merged with the international form.

Second execution after repair: **9/9 PASS**.

Covered tests:
- deterministic normalization;
- valid lead creation;
- no real acknowledgement send;
- same-event idempotency;
- same-email deduplication;
- preservation of populated existing values;
- missing contact method -> human review / no write;
- malformed email -> validation failure / no write;
- injected pre-commit failure -> visible failure / no partial write;
- phone equivalence with explicit country context;
- no guessed phone equivalence without country context.

(There are nine test cases because several assertions are grouped inside each case.)

## Fixture execution

A six-event synthetic fixture was also executed locally.

Observed statuses:
1. valid lead -> `processed`;
2. repeat of same event -> `idempotent_skip`;
3. new event with same normalized email -> `processed` into existing record;
4. missing contact method -> `validation_failed` with no commit;
5. injected pre-commit failure -> `failed_safe` with no commit;
6. second valid independent lead -> `processed`.

Final fixture state:
- source events: 6;
- final records: 2;
- committed processed events: 3;
- audit entries: 3.

## Local SHA-256 evidence before persistence

- core demo: `683a9eafa3652920e59fb3362c4a9da553d71af3bf436e99eeb6da7e4533f0f3`
- test file: `c79d0a6e8ff8d7ad30f2ed0729ca497d1091ccc46d11274686baf5fa89c2ab12`
- fixture report: `0cb9bb5b489f84643d5616d083a43c59417bd15e8a6229d91915810ad42f0ba7`

GitHub readback after persistence:
- demo blob SHA: `fb04d7cc57515d5c4e7ef961045e27bec9427923`
- tests blob SHA: `582392fbf7dbed487d4723e67138239f6047e635`

## What this does NOT prove

- It is not an n8n, Make, Zapier, GoHighLevel, HubSpot or Pipedrive production deployment.
- It has not processed real customer data.
- It has not sent an email, SMS, WhatsApp or Slack message.
- It has not connected OAuth/API credentials.
- It does not prove platform-specific expertise requested by many marketplace buyers.
- It does not prove a client would pay €249.
- It does not prove delivery can be completed in <=4 hours against a real stack.
- It does not create a portfolio claim such as "built for clients".

Truthful wording is limited to: **Nexia has a tested synthetic reference implementation demonstrating reliability logic and failure-handling principles relevant to lead-intake automation.**

## Buyer-initiated channel re-evaluation

Recent public buyer briefs were checked again after the demo was built.

### High-budget examples — still NO-GO for immediate proposal
- $500 GoHighLevel lead automation: strong scope match and one hire observed, but asks for a similar GHL project already completed.
- $800 n8n AI lead qualification: strong scope match, but explicitly requires prior n8n/LLM workflow experience and a similar workflow.
- $1,000 full GHL buildout: strong economics but materially broader than EXP-AUTO-001 and asks for prior GHL buildouts, demos/screenshots and Retell/Twilio experience.
- $300 CRM architecture: asks for proven CRM setup/funnel experience and examples/case studies.

### Price-fail examples
- Multiple current n8n/GHL/lead-routing briefs at $5, $10, $15, $20 and $30 despite substantial scope.

### Scope/risk NO-GO examples
- $400 recruiting outbound automation requires compliant data sourcing, decision-maker discovery, automated cold email sequences and anti-spam compliance; this is not the bounded inbound reliability pilot.
- Workana clinic/dental lead automation is a wider WhatsApp/CRM recovery system in a healthcare-adjacent domain and is outside the first-pilot risk boundary.

## Channel conclusion

**Current qualified public marketplace opportunities that satisfy all EXP-AUTO-001 gates: 0.**

This is not a failure of the business hypothesis yet. It is a falsification of the assumption that a first paid pilot can immediately be obtained from the currently visible marketplace sample without either:
- accepting uneconomic micro-gigs, or
- overstating platform/client experience.

Both are rejected.

## Next gate

Continue with one of these only:
1. find buyer-initiated briefs with price >=€249-equivalent, bounded inbound lead scope and no unverifiable experience requirement; or
2. increase truthful demonstrable capability by implementing a real local/open-source workflow runtime at €0, then reassess higher-value briefs; or
3. use inbound/opt-in channels if they become available.

Unsolicited Spanish commercial cold email remains NO-GO under the existing channel/legal gate.

External proposal submission remains a Human Gate.

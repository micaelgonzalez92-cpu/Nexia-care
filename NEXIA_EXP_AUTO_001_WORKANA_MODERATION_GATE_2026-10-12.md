# NEXIA EXP-AUTO-001 — Workana Moderation Gate

Date: 2026-10-12 (Europe/Madrid)
Status: VERIFIED_POLICY / DASHBOARD_STATUS_NOT_INSTRUMENTED / NO SPEND
Primary experiment: EXP-AUTO-001 — Lead Intake Reliability Sprint

## HECHO VERIFICADO — current Workana moderation policy

Current Workana help documentation checked on 2026-10-12 states:

- a professional profile must pass moderation before it can send proposals or work with clients;
- standard profile moderation generally takes 15–30 days depending on registration volume;
- Workana sends a confirmation email when a profile is approved;
- the authenticated Workana dashboard is the source for the exact moderation phase/status, including Pending / Not Approved / Approved or priority-review state;
- absence of an approval email therefore proves only `NO_APPROVAL_EMAIL_FOUND`; it does NOT independently prove the exact dashboard state;
- Priority Moderation is optional, paid and targets review within up to 24 hours;
- paying for Priority Moderation does not guarantee approval;
- Workana's public help pages do not expose a current exact price for Priority Moderation; the price/exposure must be checked in the authenticated account before any spend decision.

Official references used:
- Workana Help — `¿Cómo funciona la moderación de perfiles en Workana?`, updated 2026-10-05.
- Workana Help — `¿Cómo verificar el estado de tu cuenta y potenciar tu aprobación?`, updated 2026-10-08.
- Workana Help — `¿Qué es Priority Moderation?`, updated 2026-10-07.

## Current NEXIA truth

Known registration/profile-completion window: approximately 2026-10-11 from connected Workana onboarding mail and prior setup history.

Connected Gmail check on 2026-10-12:
- approval email: NOT FOUND;
- explicit rejection email: NOT FOUND;
- onboarding/welcome mail: FOUND.

Therefore:
- `WORKANA_APPROVAL_EMAIL = NOT_FOUND`;
- `WORKANA_DASHBOARD_MODERATION_STATUS = NOT_INSTRUMENTED`;
- `PROFILE_APPROVED = NOT_VERIFIED`;
- proposal submission remains BLOCKED under Workana policy;
- Huescaventura proposal remains `AUTHORIZED_NOT_SUBMITTED` at EUR 300;
- no Priority Moderation purchase is authorized.

## Economic implication

Huescaventura was reverified open on 2026-10-12 with an approximate EUR 200–300 budget and only one visible proposal in the latest public evidence.

Standard moderation can outlast the useful lifetime of this specific opportunity because the expected queue is 15–30 days. This creates opportunity-decay risk, but it does NOT by itself justify paid moderation.

Existing Huescaventura estimate only:
- gross offer: EUR 300;
- assumed initial Workana commission: 20%;
- after-platform estimate: EUR 240;
- labor assumption: EUR 60;
- estimated contribution before overhead/tax: EUR 180;
- tax / realized profit: UNKNOWN / NOT REALIZED.

Priority Moderation cannot be evaluated economically until the current account-specific price is known. Even then, approval is not guaranteed and Huescaventura must be freshly rechecked before any proposal.

## Correct sensor semantics

The Control Tower automation was updated on 2026-10-12 so that:

1. Gmail continues to detect approval emails daily.
2. No-email is reported only as `NO_APPROVAL_EMAIL_FOUND`.
3. Exact dashboard moderation state stays `NOT_INSTRUMENTED` until directly observed or user-reported.
4. If no approval email exists at ~day 15 from registration, Kael should be asked once to check the Workana dashboard state from the mobile/web app.
5. No paid moderation is purchased without explicit authorization.

## Human information gate — FREE / NO PURCHASE

If earlier certainty is economically useful, the only needed human check is:

- open Workana dashboard;
- report the exact moderation label/message shown (Pending / Not Approved / Approved / Priority Review / other exact wording);
- report the exact current price shown for Priority Moderation, if offered;
- DO NOT purchase it yet.

This check is free and reversible. It does not authorize spending, proposal submission or additional contacts.

## Decision rule if a current Priority Moderation price becomes known

Before asking Kael to buy it, NEXIA must re-evaluate:
- Huescaventura still OPEN within <=24h evidence;
- visible competition and buyer evidence;
- exact moderation price including taxes/fees;
- probability that waiting 15–30 days destroys the opportunity;
- at least one same-channel backup opportunity, if available;
- expected information/economic value of accelerating review;
- downside: paid review still may reject the profile.

No spend should be requested merely to increase activity.

## Next action

Keep zero-cost Gmail monitoring active. The highest-value missing datum is the authenticated Workana dashboard moderation state; current exact Priority Moderation price is secondary and should only be observed, not purchased, unless Kael later authorizes spend after an explicit economic decision packet.

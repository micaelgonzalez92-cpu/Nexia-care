# EXP-AUTO-001 — Contra Acquisition Microtest V1

Status: AUTHORIZED_BOUNDED / ACQUISITION_NOT_YET_STARTED / CURRENT_PRECONDITIONS_APPLY
Date: 2026-10-15
Purpose: test whether Contra can generate buyer intent for the same EXP-AUTO-001 offer at EUR0 cash spend and bounded human attention, while preserving truthful evidence and Human Gates.

## Current truth boundary

Canonical authority and experiment state come from `NEXIA_STATE.json` + `NEXIA_LIVE.json` and fresher indexed events. This document preserves the precommitted microtest design and thresholds; it does not independently widen authority.

HECHO VERIFICADO from current canonical state:
- the Contra microtest is authorized as a bounded EXP-AUTO-001 Reality Loop;
- maximum applications: 6;
- acquisition window: 14 calendar days;
- cash-spend ceiling: EUR0;
- Contra profile was last visibly 89% complete;
- applications submitted: 0;
- identity verification: incomplete;
- payout setup: incomplete;
- Portfolio V2 source/storyboard work is prepared internally but media/visual QA and exact current publication postconditions are not yet fully verified;
- qualified responses, settled revenue and reconciled profit remain 0 where explicitly recorded by canonical state.

UNKNOWN / NOT INSTRUMENTED:
- total setup attention already consumed;
- exact current published-work count after later profile edits;
- whether a specific matched job is currently suitable until freshly checked.

The authorization does not mean a generic `/next`, `continue` or `execute` may bypass identity/payout/publication/contact gates or submit an application whose exact scope/cost/postconditions have not been checked.

## HIPÓTESIS — preserved
A truthful Contra Independent profile built from existing technical evidence, followed by a maximum of 6 matched buyer-initiated applications, can generate at least 1 qualified buyer response within 14 calendar days at EUR0 cash spend and bounded human attention.

The 4-hour attention ceiling is an EXPERIMENT LIMIT, not a permanent Nexia rule. Historical/precommitted thresholds are preserved and must not be relaxed after observing results.

## PRECOMMITTED LIMITS — preserved

Cash-spend ceiling: EUR0.
Maximum applications: 6.
Acquisition window: 14 calendar days after the profile is sufficiently operational to apply to matched jobs.
Total acquisition Human Attention ceiling: 4h split into non-interchangeable buckets:
- SETUP_REUSABLE: max 2h;
- ACQUISITION_VARIABLE: max 2h total;
- variable average ceiling: max 20 minutes per submitted application.

Because past setup attention was not fully instrumented, do not fabricate a remaining setup balance. `UNKNOWN_NOT_INSTRUMENTED` is not zero and is not permission to reset the clock. Future measured attention must be recorded prospectively.

## CURRENT EXECUTION PRECONDITIONS

Before counting the acquisition window as started or submitting any application:
1. profile/application surface is operational enough to apply;
2. Portfolio V2/current profile evidence is truthfully usable and competitively adequate for the selected job;
3. the job is freshly verified as buyer-initiated and materially matched to EXP-AUTO-001;
4. application/submission cost is EUR0;
5. no false client, production, earnings, review, ROI or experience claims are required;
6. any identity/KYC/payout step is completed directly by Kael through official surfaces if required;
7. exact external action falls within the active bounded authorization and current authority matrix.

If any precondition is UNKNOWN or fails, remain PREPARE_ONLY.

## MÉTRICAS — preserved
Primary conversion metric:
- qualified_buyer_responses / submitted_applications.

Attention metrics:
- setup_reusable_hours;
- acquisition_variable_minutes_total;
- acquisition_variable_minutes_per_application;
- total_acquisition_human_attention_hours;
- human_attention_hours_per_qualified_response;
- human_attention_hours_per_paid_or_accepted_pilot;
- revenue_per_acquisition_human_attention_hour once revenue exists;
- contribution_per_acquisition_human_attention_hour once contribution can be reconciled.

Commercial secondary metrics:
- genuinely matched jobs found;
- applications submitted;
- requests for call/details;
- price objections;
- qualified responses;
- paid/accepted pilots;
- settled revenue;
- platform/payout friction.

A qualified response must show real buyer engagement with scope, price, timing or next step. Auto-acknowledgements and spam do not count.

## ÉXITO — preserved
Commercial signal success if either occurs within 14 calendar days after the acquisition window starts:
- >=1 qualified buyer response within the first 6 matched applications; OR
- >=1 paid/accepted pilot >=EUR249 equivalent with positive expected contribution.

A paid pilot still must satisfy EXP-AUTO-001 delivery/reliability gates before being counted as a demonstrated commercial engine result.

## FRACASO — preserved
Fail the microtest if any occurs:
- 0 qualified responses after 6 matched applications and 14 calendar days;
- fewer than 3 genuinely matched opportunities are available during the 14-day window after profile readiness;
- SETUP_REUSABLE exceeds 2h before reaching an operational profile, where prospectively measurable;
- ACQUISITION_VARIABLE exceeds 2h before a qualified response;
- average variable attention exceeds 20 minutes per submitted application once completed applications are measured;
- account/platform requirements force cash spend, misleading experience claims or materially excessive support/administration.

## KILL CRITERIA — preserved
Stop immediately if:
- mandatory cash spend is required;
- an application requires fabricated paid-client/production experience;
- requested unpaid custom work exceeds trivial clarification;
- safety/compliance/KYC cannot be completed by Kael through official surfaces;
- current platform mechanics make the EUR300 bounded pilot economically non-viable;
- 6 applications are consumed without a qualified response;
- a precommitted measured attention bucket is exhausted before its required milestone.

## INTERPRETATION RULES
- profile work, portfolio work and applications are activity, not buyer acceptance;
- setup time is a real cost and must not be erased;
- future repeatability analysis reports reusable setup separately from marginal acquisition effort;
- a positive first sale does not prove scalability;
- no retroactive threshold changes;
- a strong response may justify stopping early and evaluating the economic/delivery gate;
- `AUTHORIZED_BOUNDED` means the experiment exists within a defined envelope, not that every future application is automatically executable.

## CURRENT CHANNEL ROLE
Contra is the primary active acquisition surface for EXP-AUTO-001. Workana is secondary/pending revalidation and remains useful as an opportunity/competition sensor. This ranking can change only from fresh evidence and the normal Nexia decision model.

## AUTHORITY
Research, internal preparation, QA and ledger maintenance are GREEN within project scope. Identity/KYC, payout/banking, public profile/work publication where not already specifically authorized, external contact and any application outside the exact bounded authorization remain Human Gates. Spend remains EUR0 for this microtest.

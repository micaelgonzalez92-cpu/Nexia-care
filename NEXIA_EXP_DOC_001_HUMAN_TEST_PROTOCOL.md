# EXP-DOC-001 — Human reproducibility protocol

## Objective
Determine whether the Exception Desk produces real, repeatable operator-time savings rather than synthetic-model savings.

## Test design
Use 10 synthetic cases from the existing benchmark. Each case contains 10 expected items and a mixed state: verified, missing, received/unverified, overdue, ambiguous.

### Run A — baseline
Operator receives the case data and produces:
- missing list;
- unresolved/received-but-unverified list;
- owner/next action;
- close-blocker digest.

### Run B — Exception Desk
Operator uses the structured exception workflow to produce the same outputs.

Run A and B must use equivalent information. No external messages are sent.

## Measurement
Record wall-clock seconds per case and errors. Repeat with a second operator if available.

Primary metric: median seconds/case.
Secondary metrics: state coverage, next-action coverage, false reminders, missed blockers, ambiguous cases correctly escalated.

## Pass gate
- >=20% median time reduction;
- >=95% state coverage;
- zero fabricated receipt/status;
- zero autonomous client communication;
- no hidden ambiguity: ambiguous cases must remain explicitly human-review.

## Reproducibility gate
A single pass is not enough. Repeat the test at least twice or with a second operator. The result becomes REPRODUCIBLE only if the direction of improvement persists and no critical error appears.

## Commercial gate
Even a reproducible pass is not commercial validation. A real accounting/bookkeeping buyer must confirm the problem and accept a bounded pilot.

## Cost
EUR 0.
## Human gate
No external outreach until Kael authorizes/connects an execution channel.

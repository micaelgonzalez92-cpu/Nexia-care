# EXP-DOC-001 — Blinded synthetic case set V1

Purpose: provide a fixed, reusable test set for baseline vs Exception Desk timing.

## Structure
10 cases x 10 expected items = 100 item records.

Each case deliberately mixes verified, missing, received-but-unverified, overdue and ambiguous items requiring human review.

## Fixed test rule
The case set must not change between baseline and Exception Desk runs. The operator receives the same information in both conditions.

## Output contract
For every case the operator must produce:
1. Missing items.
2. Received/unverified items.
3. Owner/next action.
4. Close blockers.
5. Human-review exceptions.

## Scoring
Each output is scored against fixed ground truth. Timing is recorded independently from correctness.

## Blindness
Case identifiers are neutral (CASE-01 to CASE-10). Do not expose which cases contain the highest number of exceptions before timing.

## Status
READY FOR HUMAN TIMED RUN.
No human run has been performed by Nexia in this chat, so no timing result is claimed.

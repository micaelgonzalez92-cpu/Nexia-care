# EXP-DOC-001 — Synthetic Exception Desk Benchmark

## Purpose
Test whether the proposed wedge creates measurable operational value before any real outreach or sensitive data.

## Dataset
20 synthetic client files. Each file has 8–12 expected items and a mixed state:
- missing
- received/unverified
- verified
- ambiguous/needs human decision
- overdue

Target composition: 200 expected items total, approximately 20% missing, 15% received/unverified, 10% ambiguous, remainder verified.

## Baseline workflow
1. Read each client list.
2. Manually identify missing items.
3. Manually separate received-but-unverified items.
4. Decide next owner/action.
5. Draft follow-up list.
6. Produce close-blocker summary.

## Exception Desk workflow
1. Normalize expected vs received.
2. Compute state per item.
3. Suppress reminders for received/unverified items.
4. Prioritize overdue + close-impact missing items.
5. Assign next action/owner.
6. Route ambiguous cases to human review.
7. Produce one approval queue and one blocker digest.

## Metrics
- baseline minutes/file
- Exception Desk minutes/file
- minutes saved/file
- % items with explicit state
- % items with explicit next action
- false-reminder count
- ambiguous cases correctly escalated
- close-blocker recall

## Decision gate
PASS only if the workflow produces:
- >=20% time reduction on the synthetic task, AND
- >=95% explicit state coverage, AND
- zero invented document receipt, AND
- zero autonomous client-facing send.

FAIL if time is not materially reduced, if ambiguity is hidden rather than escalated, or if the workflow merely reproduces a checklist without decision value.

## Evidence classification
This is an internal synthetic benchmark. Any result is **ESTIMACIÓN / INTERNAL TEST**, not market validation.

## Commercial implication
Even a pass does not prove willingness to pay. A real accounting/bookkeeping firm remains required for commercial validation.

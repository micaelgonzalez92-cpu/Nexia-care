# EXP-DOC-001 — Synthetic benchmark result

Date: 2026-10-05
Status: INTERNAL SIMULATION — NOT MARKET VALIDATION

## Run
- 20 synthetic client files
- 10 expected items/file
- 200 expected items total
- deterministic state mix: verified, missing, received/unverified, ambiguous, overdue

## Modeled effort
Baseline workflow: 230.0 min total (11.50 min/file).
Exception Desk workflow: 56.0 min total (2.80 min/file).
Modeled reduction: 75.65%.

## Gate checks
- >=20% modeled time reduction: PASS
- >=95% explicit state coverage: PASS by construction of the state model
- invented receipt: 0 in the synthetic model
- autonomous client-facing send: 0
- ambiguous items routed to human review: YES

## Important limitation
The timing figures are a deterministic **model**, not stopwatch measurements from a human operator. Therefore this result is evidence that the proposed workflow can have favorable unit economics in a toy model, but it is NOT evidence of real-world time savings or willingness to pay.

## Decision
**PROVISIONAL PASS for internal prototype logic.**
Proceed to a small human-operated test with synthetic data or an authorized real firm before claiming product-market evidence.

## Next gate
Obtain an authorized channel and run a bounded pilot where actual operator time is measured with a stopwatch or activity log. No spend required.

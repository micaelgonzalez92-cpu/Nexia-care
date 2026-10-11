# NEXIA INTEGRITY CHECK — 2026-10-11

## Purpose
Prevent silent drift between canonical `NEXIA_STATE.json` and derived `NEXIA_BOOT.json` / `NEXIA_LIVE.json` metadata.

## Added capability
- `tools/nexia_integrity_check.py`
- `tools/test_nexia_integrity_check.py`

The checker is read-only. It does not write repository files, contact external services, spend money, or modify business state.

## Checks implemented
1. Required STATE / BOOT / LIVE files exist and parse as JSON objects.
2. STATE version matches BOOT state version references.
3. STATE Git blob SHA matches BOOT and LIVE state SHA references.
4. LIVE state version/SHA matches canonical STATE.
5. LIVE boot version/SHA matches the actual BOOT file.
6. Active mission ID matches between STATE and BOOT.
7. Active experiment ID matches between STATE and BOOT.
8. Revenue/profit fields match where present.
9. MEMORY header is inspected for a stale `NEXIA_STATE.json vN is canonical` notice.
10. Operational LIVE text mentioning older STATE versions is surfaced as a warning, not automatically treated as an error because historical references can be legitimate.

## Exit codes
- `0`: PASS — no errors or warnings.
- `1`: FAIL — at least one integrity error.
- `2`: WARN — warnings only.

## Local unit-test execution
Executed in the current local runtime with Python 3.13.

Result: **4/4 PASS**.

Cases:
- clean fixture -> PASS
- stale MEMORY canonical notice -> WARN
- deliberately wrong STATE SHA in BOOT -> FAIL
- deliberately stale LIVE state version -> FAIL

A loader issue in the first version of the test itself was detected before repository persistence and repaired by registering the dynamically imported module in `sys.modules` before execution. The corrected suite then passed 4/4.

## Repository readback
Readback from GitHub completed for both persisted files:
- `tools/nexia_integrity_check.py`
- `tools/test_nexia_integrity_check.py`

Status: **VERIFIED**.

## Current repository integrity evidence
Connector metadata currently verifies canonical STATE v61 with blob SHA `c41ad8f136c00e1b5c3680b75df3b56220ae21ed`. BOOT/LIVE state references match it. Before the next BOOT index update, LIVE also referenced the current BOOT blob correctly.

Known warning:
- `NEXIA_MEMORY.md` still begins with an obsolete notice naming STATE v58 as canonical. STATE v61 remains authoritative. The checker is designed to emit `STALE_MEMORY_CANONICAL_NOTICE` for this condition.

The checker has **not** been executed against a full local clone of the live repository in this session because the container has no outbound DNS access to GitHub. Current repository invariants were cross-checked via the connected GitHub API instead. Do not present this as an end-to-end local repository execution.

## Browser/runtime gate
The available dynamic browser route in this session is metered. No spending authorization exists for this runtime test, so it was not executed. The SME harness remains source/readback verified but browser-runtime unverified.

## Economic status
Cost: €0.
No external contact, purchase, publication, paid browser run, sale, settled revenue, or profit was produced by this work.

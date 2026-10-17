# NEXIA ATOMIC CANONICAL CHECKPOINT — CONTRACT V1

Date: 2026-10-17  
Status: FEATURE-BRANCH CANDIDATE / EUR0 / INTERNAL  
Authority: GREEN for design, local simulation and feature-branch testing. This contract does not authorize a `main` update, repository-setting change, publication, spend, external contact, KYC/payment, or production activation.

## Problem

Nexia already verifies canonical consistency after writes, but a multi-file checkpoint can be temporarily inconsistent if STATE/BOOT/LIVE/index/event bindings are written in separate commits. Detection is necessary but weaker than preventing a partial checkpoint from becoming the branch head.

## Goal

A material canonical checkpoint is promoted as **one Git commit / one tree / one branch-ref transition** after the complete candidate has passed pre-commit validation. The remote branch update must fail closed if the expected parent/head is stale.

## Required transaction

`READ EXPECTED HEAD -> BUILD COMPLETE CANDIDATE -> VALIDATE CANDIDATE -> CREATE ONE COMMIT -> CONDITIONAL FAST-FORWARD PUSH -> REMOTE REF READBACK -> POSTCONDITION READBACK`

A failure before the ref update must leave the remote canonical branch unchanged. A failed/refused push must not be reported as persistence.

## Invariants

1. **Expected-head binding** — every transaction starts from an explicit commit SHA. The candidate commit has that SHA as its single parent.
2. **Complete candidate tree** — all checkpoint-related replacements are assembled before validation. No canonical file is remotely replaced independently as part of this transaction.
3. **Candidate validation before push** — `tools/nexia_integrity_check.py --json` runs against the candidate tree/worktree before remote mutation. Exit code 1 blocks promotion. Warnings remain visible debt and are not converted to PASS.
4. **No history rewrite** — immutable events are not edited; corrections create new events. The transaction must use an ordinary fast-forward push, never force push.
5. **Fail closed on stale head** — because the candidate commit is parented to the expected remote head, a changed remote branch rejects the push as non-fast-forward. The helper must surface this as failure and not retry by force.
6. **Readback** — after a successful push, read the remote branch ref and require it to equal the candidate commit. Fetch/read the promoted commit and verify bound candidate file blobs or byte hashes.
7. **Truth boundary** — a successful checkpoint proves repository persistence/integrity only. It does not prove runtime functionality, deployment, publication, customer acceptance, payment, demand or profit.
8. **Authority preservation** — persistence never expands Kael permissions, budget, Human Gates or commercial stage.
9. **Unknown preservation** — UNKNOWN/NOT_INSTRUMENTED remains unknown.
10. **Rollback** — rollback is a new forward commit restoring a known-good tree unless Kael explicitly authorizes a different recovery action. Do not rewrite public history by default.

## Candidate interface V1

The helper should accept:

- repository root;
- target branch;
- explicit expected-head SHA;
- candidate directory whose relative paths overlay the expected-head tree;
- commit message;
- optional validation command override for tests;
- dry-run/prepare-only mode.

The candidate directory is an overlay, not a complete repository copy. V1 does not require arbitrary deletions; deletion support must be added only with explicit tests and safety rules.

## Implementation strategy

V1 should prefer standard Git primitives available in a normal clone:

1. create a temporary detached worktree at `expected_head`;
2. overlay candidate files using safe repository-relative paths;
3. validate the complete candidate worktree;
4. stage the candidate delta and create exactly one commit whose parent is `expected_head`;
5. confirm target remote ref still equals `expected_head` immediately before push when observable;
6. perform ordinary non-force push `candidate_commit:refs/heads/<branch>`;
7. require the remote ref readback to equal `candidate_commit`;
8. fetch/readback candidate paths and compare content hashes;
9. remove the temporary worktree.

The pre-push remote-head check is an optimization/diagnostic. The authoritative stale-head protection is the non-force fast-forward push itself.

## Required fault injection

Tests must cover at least:

- invalid candidate integrity -> no remote ref change;
- stale expected head -> push rejected/no overwrite;
- missing/incomplete candidate requirement -> no remote ref change;
- unsafe/path traversal candidate path -> rejected before staging;
- readback mismatch simulation -> result is failure/not VERIFIED;
- successful local bare-remote transaction -> one new commit, expected parent, expected files, exact remote head.

All fault tests should use temporary repositories/bare remotes. They must not mutate `main` or require network access.

## Result states

- `PREPARED` — complete candidate validated locally; remote unchanged.
- `PERSISTED_VERIFIED` — push succeeded and remote readback/postconditions passed.
- `FAILED_VALIDATION` — candidate invalid; remote unchanged.
- `FAILED_STALE_HEAD` — expected head no longer current / push rejected; remote not overwritten.
- `FAILED_PUSH` — remote update failed for another reason; persistence not claimed.
- `FAILED_READBACK` — push may have occurred but verification is incomplete/failed; do not claim verified persistence until reconciled.

## Promotion boundary

Feature-branch implementation and local/bare-remote fault tests are GREEN. Updating `main` with this new checkpoint mechanism is a separate promotion decision after tests and CI. Repository visibility, branch protection and other GitHub settings remain separate Human Gates.

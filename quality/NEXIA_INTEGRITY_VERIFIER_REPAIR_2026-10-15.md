# NEXIA integrity verifier repair — 2026-10-15

Scope: offline project integrity tooling and its existing CI integration.
Audited base: `e52cc90374b5c139354021ce3e07b2cc19537f11`.
Canonical mission/authority/economics: STATE v72, unchanged.

## Verified problem and cause

The previous checker required LIVE-to-BOOT fields absent from schema 28, even
though current BOOT binds LIVE instead. Its four regressions passed while the
real snapshot failed on those two obsolete field requirements. It did not
traverse the composite index chain or inspect indexed event/artifact hashes.

The replacement found one real index error and one unbound historical entry:

- `NEXIA_EVENT_INDEX.json` incorrectly assigns the CI activation event the
  hash of the permission event. The CI event's current hash
  `8a6cc25993cd987e827e44aed8128c541e5be27b` is also its original creation hash
  in commit `4c7a016461d547299a6d9d2dd384907ceec71443`.
- V8 omits the hash for `EVT-2026-10-14-WORKANA-PENDING-001`. Its bytes are
  pinned by `51087ca0714cfa84f9ec195036e7beae4338f8fa`; V9 also records it.

The uncorrected V28 snapshot yielded FAIL: 1 error, 1 warning, 27 indexes,
101 indexed events, 29 explicit post-STATE artifact references, 4 historical
artifact blobs, and the 6 previously documented artifact errata applied.
Those findings are preserved here; thresholds were not relaxed.

## Repair

- Preserve legacy reverse binding checks; require current BOOT-to-LIVE binding
  for modern schemas. Compare declared mission/probe, precedence and shared
  economic fields without inventing missing values.
- Walk the active index chain, validating bytes, IDs and latest pointers.
- Validate explicit path/hash pairs in indexed events at or after current
  STATE; historical payloads before that STATE are outside this payload audit.
- Accept a correction only when its source event/index, source SHA, original
  path and declared hash match the exact older claim. Report applied corrections
  as INFO, preserve original files and reject ambiguous/conflicting errata.
- Verify historical artifact bytes from offline Git objects or an explicitly
  supplied content-addressed cache. Do not mistake a legitimate later document
  edit for a historical hash error. Recalculate hashes of supplied bytes.
- Reject escaping paths, malformed references, cycles and excessive chain/file
  sizes. The checker performs no writes or network requests.
- CI fetches full history and triggers on versioned event indexes as well as
  existing code/state/event paths. No new paid infrastructure or executor.
- Align the active repository mission with Model C and remove the obsolete
  Project UI installation task from the queue.

V29 records the two exact index reference corrections. V28's six artifact
errata remain in force. No historical event/index is rewritten.

## Verification

36 local regressions pass, including negative tests for event/index tampering,
bad hashes/IDs, traversal, cycles, missing evidence, fake/conflicting errata,
corrupt historical caches, offline Git objects, read-only behavior, legacy
compatibility and CLI PASS/WARN/FAIL exit codes.

Observed candidate result: PASS, zero errors and zero warnings, across 28
indexes, 102 indexed events, 39 explicit post-STATE artifact references and
8 exact historical corrections (6 artifact claims plus 2 index claims).

Before publication, run the candidate checker against the coherent candidate
checkpoint and require exit 0 with zero errors/warnings. After publication,
re-read the commit and inspect the actual CI run; a commit alone is not CI PASS.

Commands from a byte-preserving checkout with full offline history:

```text
python -B tools/test_nexia_integrity_check.py
python -B tools/nexia_integrity_check.py --json
```

For an isolated source snapshot, add `--blob-cache <verified-blob-directory>`.

## Boundaries and recovery

These checks prove byte/reference consistency in the declared scope. They do
not prove prose truth, ownership of a path in an old commit, all legacy event
payloads, universal repository compliance, production behavior or external
commercial results. Existing historical failures and unknowns remain intact.

Cost: EUR0. No business authority, deployment, persistent worker, contact,
payment, revenue or profit is created by this repair.

Rollback: restore the affected code/policy/workflow from the audited base in
a new commit, then record a corrective event and rebind LIVE/BOOT/index. Do not
erase history or leave pointers referring to reverted content.

# NEXIA — IDENTITY & NAMING CONTRACT

Status: ACTIVE / ZERO-COST / COMPATIBILITY-FIRST
Updated: 2026-10-06

## 1. Canonical identity

NEXIA is the root project/system/matrix.
Kael is the human operator and authority, not a NEXIA module.

Canonical components currently established:
- NEXIA Core — core operational/strategic layer.
- NEXIA HQ — headquarters / Control Tower / command-centre layer.
- NEXIA Care — product/application for diagnosis and decision support.

Do not invent additional official NEXIA modules unless explicitly established in persistent state or architecture documentation.

## 2. Canonical spelling

Canonical technical/display names:
- NEXIA
- NEXIA Core
- NEXIA HQ
- NEXIA Care

NEXIA HQ is correct. HQ means Headquarters / Control Tower and is part of NEXIA.

Nexa is not a canonical technical identity for NEXIA. In voice/conversation it may be a transcription artifact; in code, docs, UI, filenames or URLs it must be classified before changing.

## 3. Voice/transcription normalization

Normalize intended technical references as follows:
- system -> NEXIA
- HQ -> NEXIA HQ
- Care -> NEXIA Care

Do not treat ordinary conversational wording as a repository defect without technical context.

## 4. Technical naming rule

In new code, UI, documentation, metadata and public-facing text use NEXIA, NEXIA Core, NEXIA HQ and NEXIA Care.
Do not introduce Nexa, NEXA, NexiaHQ, NexaHQ or NexaCare as new canonical identifiers.
Preserve existing compatibility paths/aliases when changing them could break links or deployment.
A legacy path is not automatically a canonical product name.

## 5. URLs and compatibility

URL naming is a separate compatibility concern.
Current deployed paths include /NexaCare/ and /NexaHQ/.
These paths must not be renamed blindly. They are compatibility/public-route identifiers until migration is verified.
Their semantic identities are NEXIA Care and NEXIA HQ respectively.
Existing /hq/, /hq.html and /care/ routes may remain as compatibility routes where deployed.
Any future URL migration requires an explicit canonical target, compatibility redirect, verification of old and new routes, and a rollback path.

## 6. Repository/file naming

Do not mass-rename solely for casing consistency.
Before renaming a directory/file, verify references, GitHub Pages behaviour and redirects; preserve rollback and record the change.
Current NexaCare/ and NexaHQ/ directories are legacy/compatibility technical identifiers, not the preferred semantic brand.

## 7. Evidence classification

HECHO VERIFICADO = directly observed.
ESTIMACIÓN = inferred but not fully verified.
HIPÓTESIS = plausible explanation requiring testing.
RECOMENDACIÓN = proposed change.
Search-index absence is not proof that the entire repository is clean.

## 8. Audit procedure

1. Recover NEXIA_STATE first.
2. Search for Nexa, NEXA, Nexia, NEXIA, NexaHQ, NexiaHQ, NexaCare and NexiaCare.
3. Inspect relevant files directly because search indexes may be incomplete.
4. Classify occurrences as canonical, legacy/compatibility, conversational/transcription, or true technical error.
5. Fix only true technical errors or safe branding inconsistencies.
6. Verify changed files after writing.
7. Never change STATE hierarchy implicitly.

## 9. UI/display rule

User-facing interfaces must display NEXIA, NEXIA HQ and NEXIA Care exactly.
Legacy URL/path strings may remain in routing for compatibility but should not be presented as the semantic brand.

## 10. Regression rule

A future naming regression check should flag new non-canonical technical identifiers while allowing explicitly declared compatibility paths, historical references and documented legacy examples.

## 11. Authority

Creating/updating this contract and applying safe €0 branding corrections are GREEN actions.
Renaming public routes, changing hosting identity, buying domains, changing external ownership or irreversible deployment changes require the applicable Human Gate.

## 12. Current conclusion

The architecture is correctly rooted in NEXIA.
NEXIA HQ is canonical and valid.
The main naming risk is legacy/variant technical strings such as NexaCare/NexaHQ, especially route names and older documentation.
The strategy is semantic normalization plus compatibility-preserving routing, not removal of the NEXIA root.

## 13. Next action

Audit and normalize clearly incorrect visible branding first; keep legacy route identifiers stable until a verified migration is available.

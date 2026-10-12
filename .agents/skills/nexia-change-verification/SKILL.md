---
name: nexia-change-verification
description: Use before handing off any Nexia code, test, CI, workflow, automation, or runtime behavior change. Selects the smallest relevant verification and records evidence boundaries.
---

# Nexia change verification

Use after implementing code/CI/runtime changes and before declaring them complete.

## Principle

Verification must match the claim. A commit is not a deployment. A green unit test is not a production result. A synthetic runtime is not willingness-to-pay.

## Procedure

1. Classify the change:
   - docs/state only
   - Python tooling
   - Node/JS prototype
   - n8n workflow/product
   - GitHub Actions/CI
   - browser/UI artifact
   - external integration
2. Run the smallest existing test suite that actually covers the changed behavior.
3. For canonical persistence changes also run `$nexia-checkpoint`.
4. For n8n changes, prefer real n8n runtime smoke evidence over static JSON checks when behavior changed.
5. For GitHub Actions changes, validate syntax/logic and inspect the actual workflow run when available.
6. For external integrations, do not claim success without observable external evidence.
7. Record known gaps such as concurrency, crash recovery, real-user install, buyer acceptance, payment or deployment when untested.

## Default commands when relevant

```bash
python3 tools/test_nexia_integrity_check.py
python3 tools/nexia_integrity_check.py --json
node products/lead-intake-reliability-kit/test_product.js
```

Also use the existing project-specific tests listed in `.github/workflows/nexia-ci.yml` when their files or behavior are affected.

## Handoff

Report:
- change made
- tests executed
- pass/fail evidence
- verification boundary
- rollback path
- economic effect (normally NONE unless direct evidence exists)

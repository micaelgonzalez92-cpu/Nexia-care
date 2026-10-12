# Lead Intake Reliability Kit — QA Checklist

Status: INTERNAL v0.1

The kit must not move to `VALIDATION_READY` unless every mandatory item passes.

## A. Packaging
- [ ] All JSON files parse successfully.
- [ ] All workflows import as inactive.
- [ ] No buyer-specific names, IDs or credentials are embedded.
- [ ] No real customer data exists in samples.
- [ ] Every sample uses synthetic values.

## B. Lead Intake Human Review
- [ ] Valid payload returns `ok=true`.
- [ ] Email is trimmed/lowercased.
- [ ] Phone is normalized deterministically.
- [ ] Missing name/contact returns `validation_failed`.
- [ ] Output includes structured summary and reply draft.
- [ ] Output always contains `autonomous_send=false`.
- [ ] Workflow contains no outbound messaging node.

## C. Persistent Dedup Guard
- [ ] Bootstrap creates `lead_intake_reliability_keys` with `eventKey`, `identityKey`, `recordId`.
- [ ] Dedup guard normalizes email and phone.
- [ ] Same event ID is blocked from a second insert.
- [ ] Different event ID with same normalized identity is blocked from a second insert.
- [ ] Unique identity can be inserted.
- [ ] Workflow contains no external-send action.

## D. Runtime Evidence Boundary
- [ ] Documentation states that NEXIA's runtime/dedup proof is internal technical evidence, not paid-client production work.
- [ ] Product copy does not claim revenue lift, conversion lift or zero-failure guarantees.
- [ ] Product requires the buyer's own n8n environment.
- [ ] Product does not host n8n for customers.

## E. Self-Serve Installation Target
Target, not yet verified with external users:
- import + bootstrap + sample test <=30 minutes for a competent n8n user;
- no support call required for standard setup;
- all credential-dependent downstream integrations remain explicitly outside the core kit.

## F. Commercial Gate
Before publication:
- [ ] publication/account action explicitly authorized by Kael;
- [ ] test price fixed before launch;
- [ ] minimum sales/refund/support thresholds fixed before launch;
- [ ] platform fees reverified;
- [ ] product page claims checked against technical evidence;
- [ ] no paid promotion or subscription added without separate approval.

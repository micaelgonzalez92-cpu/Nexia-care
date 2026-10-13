# LOCAL-BROWSER-001 — zero-install browser execution benchmark

Status: PREPARED / NOT YET EXECUTED
Date: 2026-10-13
Cash budget: EUR0
Purpose: reduce dependence on scarce ChatGPT Work hours by verifying a local browser execution path using an already-installed Chromium browser, without installing software or using an authenticated account in the first gate.

## Hypothesis

Kael's Windows PC can execute bounded browser navigation and DOM extraction locally using an already-installed Edge or Chrome runtime, with no Work/Codex quota and no new software installation.

## Gate A — public/read-only probe

Allowed:
- detect existing Edge/Chrome executable;
- launch one headless public page request to https://example.com;
- capture exit code and a bounded DOM/title proof;
- write a local result file.

Not allowed:
- login;
- cookies/session reuse;
- external form submission;
- downloads other than normal page resources;
- publication/contact/spend/account changes;
- software installation;
- browser extension installation.

PASS if:
- existing Edge or Chrome is found;
- headless browser exits successfully;
- returned DOM contains the expected Example Domain marker;
- EUR0 cash spend;
- no Work/Codex execution used.

FAIL if:
- no usable Chromium browser is present;
- browser cannot launch headless;
- navigation/DOM capture fails after one bounded run.

## Gate B — later authenticated profile benchmark

Only after Gate A PASS. This will be separately designed with a dedicated browser profile, explicit security/logging/recovery boundaries, and no external side effect. It must not reuse personal browser state silently. Authenticated use remains unverified until separately tested.

## Promotion rule

Gate A PASS promotes only to LOCAL_BROWSER_PUBLIC_READONLY_VERIFIED. It does not replace Work for authenticated GUI tasks. Work replacement requires Gate B plus recovery/security evidence.

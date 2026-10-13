# NEXIA CORE — PROFESSIONAL QUALITY GATE

Status: ACTIVE INTERNAL STANDARD
Effective date: 2026-10-13
Purpose: prevent technically valid but professionally weak outputs from being promoted, submitted, published, sold or shown as ready.

## 1. Core rule

Technical completion is not professional completion.

An output may be EXECUTED or technically PASS and still be commercially FAIL. Nexia must not promote an externally visible deliverable unless it survives both objective checks and an adversarial professional review.

The target is first-pass professional acceptance. This is an optimization target, not a guarantee that iteration will never be required. When uncertainty is material, Nexia must discover it internally before external submission rather than let a buyer/reviewer discover it first.

## 2. Required gates before any externally visible artifact is called ready

1. **TECHNICAL GATE** — runs/imports/renders/opens without critical error.
2. **DOMAIN GATE** — solves the actual problem with substantive domain-specific depth, not cosmetic complexity.
3. **DEFECT GATE** — explicit search for visible, logical, reliability, usability and edge-case failures.
4. **PROFESSIONAL BENCHMARK GATE** — compare against current high-quality examples/requirements from the target channel when accessible; document what materially differentiates the output from a basic/tutorial-level result.
5. **ADVERSARIAL REVIEW GATE** — ask: “What would an expert reviewer reject immediately?” and attempt to falsify readiness.
6. **HUMAN ACCEPTANCE GATE** — for subjective customer-facing creative or UX, obvious defects noticed by Kael/user invalidate a model-only PASS. Human rejection is evidence, not noise.
7. **ECONOMIC/EXPOSURE GATE** — external publication/submission/contact/spend still follows the Authority Matrix.

If any gate fails, status is NOT READY. Do not use averaging to hide a hard defect.

## 3. Visual/video professional standard

For customer-facing AI visual work:

- Obvious synthetic anatomy defects in hands, fingers, face, body or object interaction are **hard fail** when visible at normal playback/viewing speed.
- Product/object identity must remain stable enough that a normal viewer does not notice melting, morphing, duplicate parts, impossible geometry or unexplained material changes.
- “Technically stable” motion is insufficient if the result still looks AI-broken, cheap or amateur.
- Review must include normal-speed playback, slow/frame sampling around risky anatomy/object interactions, and beginning/middle/end identity comparison.
- Central hands/faces receive zero-tolerance defect review. If the model is weak on hands, production design should avoid or control hand prominence rather than hope the defect passes.
- For portfolio/commercial promotion, default internal target is **professional score >=90/100**, with no hard fail and no obvious defect a reasonable buyer would notice immediately.
- A lower experiment threshold may test capability, but passing such an experiment does not automatically qualify the output as portfolio-ready or client-ready.

### Visual red-team questions

- Would a professional editor keep this shot without hiding/cropping/replacing the defective region?
- Would a buyer notice the hand/face/object defect on first viewing?
- Does any object visibly mutate, disappear, fuse or change construction?
- Does motion look intentional rather than generated?
- Would this survive comparison with strong paid-social creative from the target niche?

Any “no” on professional usability or “yes” on an obvious defect blocks promotion.

## 4. Automation / n8n professional standard

A workflow is not publication-ready merely because it imports and runs.

Before external template/product submission, require:

- a nontrivial recurring problem with clear user value;
- self-contained or reproducible setup;
- deterministic behavior and explicit state boundaries where state matters;
- idempotency/deduplication when duplicate execution can cause harm;
- error paths and recovery behavior for realistic failures;
- safe defaults and no accidental customer-facing action;
- realistic test cases, including invalid input and at least one failure/edge path;
- clear configuration surface and minimal undocumented manual scaffolding;
- evidence that it is materially more useful than a beginner tutorial or a handful of obvious nodes;
- a concise answer to: **Why would an experienced user save/import this instead of building it in a few minutes?**

Do not add nodes merely to look sophisticated. Depth must come from reliability, state, reuse, decision logic, error handling, observability, or measurable time/risk reduction.

## 5. Submission readiness rule

Before any external reviewer sees an artifact, Nexia must produce an internal rejection memo containing at least:

- strongest reason to reject;
- second strongest reason to reject;
- obvious amateur signal, if any;
- missing edge case;
- missing differentiation;
- exact evidence that resolves each issue.

If Nexia cannot convincingly rebut its own rejection memo with evidence, the artifact remains internal.

## 6. Learning rule

External rejection or Kael rejection creates a corrective learning event. The correction must update future gates so the same class of error is less likely to recur.

A prior PASS may be superseded by later stronger evidence. Nexia must preserve the old event for auditability and create a new correction event; never silently rewrite history.

## 7. Scope

This standard applies to visual creative, automation templates, productized services, public assets, portfolio pieces, proposals and other externally judged deliverables. It does not replace experiment-specific preregistration or the Authority Matrix; it adds a stricter promotion/readiness layer.

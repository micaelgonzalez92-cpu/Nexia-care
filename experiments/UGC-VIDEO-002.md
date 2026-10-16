# UGC-VIDEO-002 — Hybrid Professional UGC Capability Benchmark

Date: 2026-10-16
Status: PREPARED / NOT_EXECUTED
Parent vein: VETA-AI-UGC-001
Supersedes: no historical result. `UGC-VIDEO-001` remains FINAL FAIL.
Cash budget for prepared phase: EUR0.
Authority: internal/synthetic testing only. No publication, external contact, new account, purchase, paid API, subscription or production activation.

## Why a new experiment
UGC-VIDEO-001 proved bounded local video generation but failed the professional bar because all three clips contained unacceptable hand/anatomy defects. Repeating the same I2V configuration would add little information. UGC-VIDEO-002 changes the production architecture around the known failure mode instead of relaxing quality.

## Hypothesis
Using Nexia's current verified image generation, local scripting and deterministic media assembly capabilities, plus only zero-cost/reversible additions that pass hardware/license checks, Nexia can create at least one portfolio-grade 15-30s vertical SPEC performance creative with better professional reliability than the failed raw-I2V route, while measuring human time, usable-output yield and failure modes.

## Design principle
`stable source assets -> bounded generative motion where useful -> deterministic edit/composition -> adversarial professional QA`

Do not require a generative video model to solve every shot.

## Test routes

### Route A — Hybrid product-first / anatomy-minimized
Priority: FIRST.
- Create/use accepted product/scene stills with current verified image capability.
- Avoid central generated fingers/hands/faces where they are not essential.
- Use crop, object-only demonstration, camera movement, parallax, zoom/pan, cuts, overlays and caption-safe framing.
- Assemble deterministically with FFmpeg or equivalent local tooling if available/approved.
- Add voice/captions only through a rights-safe zero-cost path; otherwise test silent/captioned creative first.

Purpose: determine whether professional UGC-style commercial utility can be achieved without exposing the pipeline to its known highest-risk anatomy failure mode.

### Route B — Updated bounded local I2V benchmark
Priority: SECOND, only after hardware-fit research.
- Do not blindly redownload or reuse LTX 2B v0.9.5 as the answer.
- Identify one current local/open-weight I2V route compatible with the actual PC/GPU and license constraints.
- No model download/install until file size, VRAM/RAM, dependencies, license and expected information value are checked.
- If no materially stronger zero-cost candidate fits the machine, record `NO_LOCAL_UPGRADE_FIT` rather than forcing a run.

Purpose: test whether the local quality ceiling has materially moved since UGC-VIDEO-001.

### Route C — Hosted/current-generation comparison
Priority: RESEARCH ONLY until RED gate.
Potential model families/platform routes may include current Seedance/Kling/Higgsfield/other top-tier video systems discovered by the R&D radar.
No account creation, credits, subscription or paid API is authorized by this document.

Purpose: establish the minimum external capability/cost that could close the quality gap if local/hybrid execution remains insufficient.

## Candidate deliverable
One fictional-product vertical SPEC ad, 15-30 seconds, clearly marked concept/spec internally.
Preferred creative grammar:
1. hook/problem frame;
2. product/solution demonstration;
3. proof/benefit visualization without fabricated KPI;
4. CTA/end frame.

No fake customer results, testimonials, ad-spend performance or real brand impersonation.

## Metrics
Record for every route actually executed:
- professional visual QA score;
- hard-fail defects;
- product/scene identity preservation;
- anatomy defect count when humans are present;
- usable seconds / generated seconds;
- accepted shots / attempts;
- wall-clock render time;
- human steering/edit/review minutes;
- VRAM/RAM where locally measurable;
- cash/tool cost;
- repeatability notes;
- exact model/tool/version/provenance.

## Professional QA gate
A candidate deliverable is ACCEPTABLE only if:
- score >=85/100;
- zero obvious hand/finger/face/body hard fail at normal viewing speed;
- zero material product-geometry mutation;
- no invented readable brand/UI text presented as real;
- no severe temporal flicker/melting/jumps;
- at least 15 seconds of coherent usable final edit;
- commercial story is understandable without explanation;
- no rights/policy violation.

Rubric:
- realism / absence of obvious AI defects: 25
- product/identity fidelity: 20
- motion/edit coherence: 15
- commercial/hook-story utility: 15
- social-native framing/caption headroom: 10
- audio/caption quality if used: 5
- repeatability/editability: 5
- brand/policy safety: 5

## Human quality rule
Model-only scoring cannot promote a customer-facing visual result. Kael's normal-viewing professional rejection is a hard fail and must be preserved as evidence, not averaged away.

## Initial PASS / FAIL
Technical/capability PASS requires:
- at least one 15-30s final SPEC creative passing professional QA;
- cash spend EUR0 for the first bounded test;
- measured human steering/edit/review <=90 minutes for the accepted creative;
- no unauthorized cloud/API/account action.

STRONG PASS / repeatability promotion requires a second distinct accepted creative under the same architecture with no relaxation of the gate.

FAIL if:
- no accepted creative after the preregistered bounded route/attempt budget;
- professional defects remain obvious;
- human time exceeds the threshold materially;
- only paid/new-account capability can close the gap (record as external capability gate, not as technical PASS).

## Execution-surface routing
- Chat/GitHub: research, experiment design, evidence, scripts, scoring and persistence.
- Local PC: existing ComfyUI/GPU, deterministic media tooling and local scripts when Kael grants/starts an appropriate local surface.
- Work/Codex: optional bounded fallback for code/GUI tasks when justified; not default.
- Existing local execution bridge is verified only for bounded one-shot read-only/browser patterns; its prior scheduler authorization is consumed and does not authorize a new recurring/persistent worker.

## Immediate pre-execution tasks — GREEN/YELLOW
1. Audit existing UGC assets/scripts and recover strongest accepted source frames.
2. Hardware-fit check for a current local video candidate before any download.
3. Build Route A deterministic storyboard/edit specification.
4. Define exact input/output filenames and measurement ledger.
5. Stop at any install/download/account/spend/publication gate that is not already authorized.

## Commercial truth
This is a capability/portfolio experiment. PASS would not prove buyer demand, sale, payment, ROAS or profit. Those require a separate Reality Loop exposure.
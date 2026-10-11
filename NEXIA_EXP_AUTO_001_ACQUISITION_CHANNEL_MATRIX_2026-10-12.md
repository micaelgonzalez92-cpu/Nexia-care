# NEXIA EXP-AUTO-001 — Acquisition Channel Matrix

Date: 2026-10-12 (Europe/Madrid)
Status: RESEARCHED / CORRECTED FOR FRESHNESS / NO ACCOUNT CREATION / NO CONTACT / NO SPEND
Primary experiment: EXP-AUTO-001 — Lead Intake Reliability Sprint

## Objective
Reduce dependency on Workana moderation by ranking alternative buyer-initiated channels using verified access friction, proposal cost, marketplace fee, visible demand and fit with the existing commercial evidence pack.

## Mandatory freshness rule
A marketplace project must NOT be treated as CURRENT/OPEN from stale search-index text alone.

For any material acquisition decision:
- require direct project-page access showing an open state, or another source checked within the project-status freshness window;
- target freshness <=24 hours for project availability;
- relative phrases such as "6 days left", "posted 1 minute ago" or "open" from a result crawled weeks earlier are STALE, not current evidence;
- if a direct URL now returns 404/removed, classify the project as CLOSED_OR_REMOVED unless fresh contradictory evidence exists.

This rule was added after `Freelancer.com Project 40722058` appeared open in a search snapshot crawled about three weeks earlier while its direct URL returned 404 on 2026-10-12.

## Ranking

### C0 — Workana — CURRENT PRIMARY
State: ACCOUNT/PROFILE EXISTS, APPROVAL NOT VERIFIED.
Why #1: primary opportunity Huescaventura remains the selected qualified opportunity in canonical STATE. Its material status must be rechecked within 24h before submission.
Acquisition blocker: profile approval not yet verified.
Existing authority: one EUR 300 Huescaventura proposal only after profile approval is verified, project is freshly rechecked open, and submission spend is zero.

### C1 — Guru — LOW-UPFRONT BID CHANNEL / CURRENT PROJECT UNKNOWN
Official access economics verified from Guru:
- Basic Membership is free;
- Basic includes 10 Bids per month;
- one normal Quote uses one Bid;
- Basic freelancer job fee is 9% on paid invoices.

Demand signal:
- Guru publicly lists automation/ERP/CRM/n8n projects;
- a September 2026 n8n ERPNext listing was visible in the indexed public job board, but its send-before date was 2026-10-07 and is therefore expired relative to current date 2026-10-12.

Current exact-fit live opportunity: NOT VERIFIED.
Decision: CHANNEL_CANDIDATE_HIGH_ACCESS / PROJECT_UNKNOWN.
Human Gate: account/profile creation and any Quote submission require Kael authorization.
Reason for rank: no verified cash-balance prerequisite merely to send the included Basic bids, and lower published fee than Workana's initial tier.

### C2 — PeoplePerHour — LOW-UPFRONT CHANNEL / LIVE DISCOVERY BLOCKED HERE
Official access economics previously verified:
- no registration/sign-up fee;
- 15 proposal credits are provided free each month;
- each normal proposal uses one credit;
- service fee on freelancer earnings is 20% below EUR 300 lifetime billing per buyer, 7.5% from EUR 300 to EUR 6000, and 3.5% above EUR 6000 (excluding VAT as applicable).

Current environment limitation verified 2026-10-12:
- direct opening of the live PeoplePerHour project category returned a JavaScript/anti-bot verification page;
- search results exposed automation projects, but their crawl dates were months old and therefore cannot establish current project availability.

Current exact-fit live opportunity: UNKNOWN / NOT VERIFIABLE FROM THIS ENVIRONMENT.
Decision: CHANNEL_CANDIDATE_HIGH_ACCESS_BUT_DISCOVERY_BLOCKED.
Human Gate: account/profile creation and any proposal require Kael authorization.
Do not create an account solely to discover whether demand exists unless Kael authorizes that experiment.

### C3 — Upwork — VERIFIED DEMAND, PROPOSAL-TOKEN FRICTION
Market evidence: n8n/automation jobs are widely indexed and exact-fit lead-intake/CRM patterns exist, but many low-ticket postings are economically invalid and higher-value examples can have heavy proposal counts.
Official access economics previously verified:
- free to join;
- proposals generally consume Connects;
- additional Connects cost money;
- freelancer service fee/exposure must be checked before a material proposal.

Existing reserve candidate from prior research: USD 250 lead-management automation with 50+ proposals; current status requires fresh revalidation before any action.
Decision: CHANNEL_CANDIDATE_MEDIUM_LOW until account state, Connect requirement and exact proposal exposure are known.
Human Gate: account creation/connection, any Connect spend and any proposal.

### C4 — Freelancer.com — CAPITAL_GATED / NO CURRENT VERIFIED PROJECT
Official channel economics verified 2026-10-12:
- registration is free;
- fixed-price freelancer project fee is 10% of winning bid or USD 5 minimum;
- some bids require at least USD 20 available in the Freelancer wallet before the bid form is available;
- deposited funds remain in the Freelancer account until a transaction requires them;
- deposit processing fees may apply depending on payment method;
- eligible PayPal/credit-card deposits can be requested back under the platform's refund rules, but refund timing and payment-method conditions apply.

Correction of prior candidate:
`Production-Ready Lead Intake & Booking Automation in n8n` — Project ID 40722058
- old indexed snapshot: budget USD 250-750, 17 proposals, high technical fit;
- search snapshot was crawled about three weeks before 2026-10-12;
- direct project URL checked on 2026-10-12 returned 404;
- classification: CLOSED_OR_REMOVED / NOT A CURRENT RESERVE OPPORTUNITY.

Decision: CHANNEL_CANDIDATE_MEDIUM_CAPITAL_GATED; no active candidate.
Do not create/fund account or bid without explicit Kael approval.

### C5 — Contra — PROFILE CHANNEL / FULL JOB ACCESS GATED
Verified correction from Contra's current public jobs page:
- Contra markets contractor earnings as commission-free;
- profile/discovery features exist;
- Contra explicitly states that access to all jobs is unlocked with Contra Pro.

Therefore prior wording that implied unrestricted free opportunity access was too broad.
Current exact-fit buyer brief: NOT VERIFIED.
Decision: CHANNEL_CANDIDATE_LOW_MEDIUM_FOR_PROFILE_DISCOVERY, not preferred for immediate buyer-initiated extraction while full job-board access is gated.
Human Gate: account/profile creation, Pro purchase, or any proposal/contact require Kael authorization as applicable.

### C6 — Malt — EUROPEAN PROFILE/INBOUND CHANNEL
Previous verified economics: first-client commission through Malt around 10% excl. tax, lower for longer/own-client relationships depending on Malt's applicable terms.
Strength: European/Spanish relevance and professional buyer positioning.
Weakness: no current public buyer-initiated n8n brief comparable to Huescaventura has been verified; discovery is more profile/matching driven.
Decision: CHANNEL_CANDIDATE_MEDIUM_FOR_LATER.
Human Gate: account/profile creation or any external action.

## Current acquisition conclusion

There is currently NO verified live non-Workana project that simultaneously meets all of:
- freshness <=24h or direct-open verification;
- gross ticket plausibly >= approximately EUR 200 equivalent;
- bounded scope compatible with Lead Intake Reliability Sprint;
- no requirement to fabricate paying-client production experience;
- no unauthorized spend/account action already needed to inspect or apply.

Therefore the correct state is NOT "we have an active Freelancer backup". The correct state is:
- Workana/Huescaventura remains primary subject to its own freshness and profile-approval gate;
- Guru and PeoplePerHour are the best low-upfront channels to investigate for fresh candidates;
- PeoplePerHour live discovery is blocked by JS/anti-bot in this environment;
- Guru public indexed automation listings found in this batch were expired by date;
- Freelancer has strong demand but no current verified candidate and can require USD 20 wallet balance before bidding;
- Upwork has demand but proposal-token friction;
- Contra full job access is partially Pro-gated.

## No-Go rules
- Do not call a stale indexed marketplace result CURRENT.
- Do not call free bidding 'zero cost' when a platform requires cash balance, credits, identity/payment verification or another economic exposure.
- Do not buy memberships, bid packs, Connects, verification, featured placement or fund marketplace wallets without explicit approval.
- Do not create a second marketplace account merely for activity; require either a freshly verified candidate or an explicitly authorized channel-validation experiment.
- Do not represent the technical evidence pack as client production work.

## Next gate
Continue zero-cost discovery with strict freshness. The next material Human Gate should only be raised when one of these becomes true:
A) Workana profile approval is verified and Huescaventura is freshly confirmed open; or
B) a non-Workana project is freshly verified, economically viable and specific enough that account creation/proposal exposure can be justified with a concrete expected-information gain.

No account creation, funding or proposal submission is authorized by this document.

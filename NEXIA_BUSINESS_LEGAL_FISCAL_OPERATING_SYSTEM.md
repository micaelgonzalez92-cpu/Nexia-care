# NEXIA BUSINESS LEGAL · FISCAL · ACCOUNTING OPERATING SYSTEM

Status: DESIGN + RESEARCH ACTIVE
Date: 2026-10-08
Scope: B2C resale e-commerce of second-hand clothing, initially Spain/Valencia, with possible multichannel expansion.
Authority: Nexia may research, structure, calculate, prepare drafts, check deadlines and identify required human actions. Kael retains control over registrations, payments, signatures, credentials, banking and irreversible legal/tax actions.

## 1. PURPOSE

Build a complete business operating layer so that legal, tax, invoicing, bookkeeping, compliance, cash control and recurring filings are handled as systematically as possible.

Core principle:
OBSERVE → CLASSIFY → DOCUMENT → CALCULATE → CHECK → PREPARE → HUMAN GATE → FILE/PAY → VERIFY → ARCHIVE → REVIEW.

No tax/legal conclusion is treated as final when it depends on facts not yet established. Each item is labelled:
- HECHO VERIFICADO
- ESTIMACIÓN
- HIPÓTESIS
- RECOMENDACIÓN
- HUMAN GATE

## 2. BUSINESS STRUCTURE TO DECIDE

Initial working model:
- Individual entrepreneur / autónomo.
- B2C online resale of clothing.
- Primary market Spain, with EU/international sales possible later.
- Channels may include Vinted Pro and other marketplaces.
- Inventory can contain:
  A) stock purchased from professional wholesalers;
  B) used goods purchased from private individuals;
  C) own pre-existing garments.

Critical tax distinction:
A, B and C must never be mixed in the accounting engine because acquisition evidence and VAT treatment can differ.

Potential legal forms:
1. Autónomo: default low-complexity candidate for initial validation.
2. Sociedad limitada: reconsider only when liability, profit retention, scale, partners or other facts justify it.
3. Other structures: only after professional/legal analysis.

Nexia must not recommend incorporation solely for image or tax folklore.

## 3. PRE-START REGISTRATION GATE

**Current classification research (not yet a filing decision):**
- **CNAE-2025 candidate: 47.79 — Comercio al por menor de artículos de segunda mano.** INE expressly includes retail sale of second-hand clothing in this class and says activities are classified by the goods sold, not by whether sales occur in a shop or online. citeturn4view0
- **IAE candidate: Grupo 656 — Comercio al por menor de bienes usados tales como muebles, prendas y enseres ordinarios de uso doméstico.** This is the IAE group specifically covering used goods including garments. citeturn5search14turn5search17
- These are **RECOMMENDATION / CANDIDATE**, not a final registration instruction. Before filing, verify the exact activity mix (used clothing only vs. new stock, accessories, other goods, own pre-existing stock) and the current AEAT census classification.

Before habitual business activity:

Before habitual business activity:
- Determine exact IAE activity/epigraph.
- Determine CNAE.
- Determine tax residence and activity address.
- Determine start date.
- Determine IVA regime.
- Determine IRPF estimation method.
- Determine whether RETA registration is required and correct contribution forecast.
- Determine whether intra-EU operations require ROI/VIES registration.
- Determine marketplace/platform reporting implications.
- Determine whether consumer-law obligations apply to each sales channel.
- Prepare the census registration (normally Modelo 036; exact configuration must be verified before filing).
- Prepare RETA registration through Importass.

Social Security states that autonomous workers must register before starting activity and asks for IAE, CNAE, activity date/address, estimated annual net income, contribution base/benefits, mutual insurer and bank details.

## 4. VAT DECISION ENGINE

The engine must test, rather than assume, at least:
- General VAT regime.
- Recargo de equivalencia.
- REBU (special regime for used goods).
- Other special regimes only if facts justify them.
- Intra-EU distance sales / OSS if thresholds and destination rules become relevant.
- Import VAT/customs if sourcing outside the EU.

### Recargo de equivalencia

AEAT states this regime applies to qualifying retail merchants and, among other conditions, generally requires more than 80% of sales to final consumers when the prior-year test applies.

**Critical correction for this business (official AEAT 2026):** the 2026 AEAT manual lists **used goods among the exclusions** from the recargo of equivalence. Therefore the resale of used clothing must **not** be treated as subject to recargo by default. The engine must test the exact goods and transaction facts against the current exclusion rules before registration or accounting treatment.

If applicable to a transaction/activity not excluded:
- suppliers charge VAT plus the recargo;
- the retailer does not file ordinary output-VAT settlements for those retail operations;
- input VAT on the activity is not deducted.

For the core second-hand clothing model, **REBU vs. general VAT treatment is the priority VAT decision; recargo is not the default path for used goods.**

### REBU

AEAT states REBU is voluntary and can apply to resellers of qualifying used goods. For used goods, qualifying acquisition sources include private individuals and certain VAT situations.

Under the operation-by-operation method, the taxable margin is based on:
sale price (VAT included) - purchase price (VAT included),
with the VAT calculated on that margin.

For REBU sales, the VAT is not separately shown on the invoice and the invoice must state that the special regime applies.

This is potentially important for second-hand clothing purchased from private individuals. It must not automatically be applied to stock bought from VAT-charging wholesalers.

## 5. IRPF ENGINE

Working candidate for initial autonomous activity: direct estimation, subject to final census/tax classification.

Engine must track:
- sales income;
- deductible purchases;
- shipping and packaging;
- marketplace commissions;
- payment processing;
- advertising;
- software;
- professional services;
- business-use telecommunications/internet where legally deductible;
- other substantiated business expenses;
- depreciation where applicable;
- inventory/cost allocation rules;
- private vs business expenditure.

Quarterly preparation:
- Model 130 where applicable.
- Supporting books and calculations.

Annual:
- Renta / IRPF return including economic activity.
- Reconcile annual income, expenses, payments on account and withholding data.

No expense is classified as deductible merely because it is useful. Nexia must test necessity, linkage to activity, documentary evidence and applicable tax rules.

## 6. IVA FILINGS

Potential recurring workflow:
- Monthly/quarterly VAT ledger close.
- Reconcile sales and purchases.
- Separate VAT by regime and transaction type.
- Prepare Modelo 303 when applicable.
- Determine Modelo 390 obligation/exemption at year-end.
- Check intra-EU / OSS / import obligations where applicable.

AEAT provides electronic formats for VAT and IRPF books and Pre303/Pre130 assistance.

## 7. INVOICING

System requirements:
- sequential invoice numbering;
- dates;
- seller identification;
- customer identification where required;
- taxable base;
- VAT treatment;
- total;
- rectifying invoice mechanism;
- credit/return traceability;
- channel/order reference;
- payment status;
- accounting classification.

Consumer sales may have simplified/documentary rules different from B2B invoices. Nexia must generate the correct document type from the transaction data rather than using one generic invoice template.

Invoice records must feed the accounting engine automatically where technically possible.

## 8. VERI*FACTU / SIF ROADMAP

As of 2026-10-08:
- AEAT confirms the SIF/VERI*FACTU framework.
- Current official extension states systems used by companies subject to Corporate Income Tax must be adapted before 2027-01-01.
- Other businesses/autónomos using invoicing systems have a stated adaptation deadline of 2027-07-01.
- Separately, mandatory B2B electronic invoicing has a later calendar: 2027-10-06 for businesses/professionals above €8m turnover and 2028-10-06 for the rest, with additional payment-status obligations later.

Nexia should therefore design the business around compliant digital records from day one, not retrofit them later.

Preferred design candidate:
- structured invoice ledger;
- immutable/traceable invoice records;
- compliant software or AEAT-provided option when appropriate;
- no homemade system should be declared compliant without verification.

## 9. BOOKKEEPING DATA MODEL

Minimum ledgers:

### Sales
sale_id
date
channel
order_id
sku
customer_type
gross_sale
VAT_regime
VAT_amount
platform_fee
payment_fee
shipping_paid_by_business
return_cost
net_cash
payout_date

### Purchases
purchase_id
date
supplier
supplier_type
invoice/document
batch_id
gross_cost
VAT
recargo
transport
customs
payment_status
inventory_allocation

### Inventory
sku
batch
origin
acquisition_cost
allocated transport
preparation cost
VAT treatment
current status
sale date
realized contribution

### Expenses
expense_id
date
category
supplier
document
gross
VAT
deductible_base
deductible_VAT
payment method
business-use evidence
accounting status

### Tax
period
tax
model
base
output
input
payment
filing date
status
evidence/archive reference

### Cash
account
date
movement
category
business/private
amount
reconciliation status

## 10. INVENTORY ACCOUNTING

Never use supplier marketing claims as accounting evidence.

For sourced lots:
allocated acquisition cost =
purchase cost + attributable inbound transport + directly attributable acquisition costs,
allocated according to the documented batch method.

For stock bought from private individuals:
retain the required acquisition document/evidence and determine whether REBU applies.

For own pre-existing clothing:
acquisition cost is not automatically current market value. Keep separate from sourced stock and only assign a historical economic cost when justified and documented.

## 11. MARKETPLACE CONTROL

For each channel, maintain:
- legal seller identity;
- account type;
- platform terms;
- commission schedule;
- payout schedule;
- VAT/reporting treatment;
- consumer protection rules;
- return policy;
- prohibited products/claims;
- data/privacy obligations;
- transaction export availability.

Never rely on marketplace dashboards alone. Preserve transaction-level evidence.

## 12. CONSUMER / E-COMMERCE LEGAL LAYER

Before scale:
- legal identification of seller;
- terms and conditions;
- privacy notice;
- cookie policy where relevant;
- withdrawal/return rules where legally applicable;
- statutory conformity/consumer guarantees where applicable;
- complaint/refund process;
- pricing transparency;
- shipping information;
- marketplace-specific rules;
- evidence retention.

Second-hand goods require special attention to condition disclosure and defects. Listings must not make unsupported claims about authenticity, vintage, material, origin or condition.

## 13. DATA PROTECTION

Determine:
- what personal data is processed;
- controller/processor roles;
- marketplace-only vs own-store data;
- retention periods;
- lawful basis;
- privacy notices;
- processor agreements where needed;
- security controls;
- deletion/access workflows.

Do not collect customer data that the business does not need.

## 14. BANKING / CASH

Separate business and personal movements operationally even when the legal structure does not force a separate bank account.

Daily/weekly engine:
cash opening
+ customer receipts
- supplier payments
- taxes
- fees
- shipping
- operating expenses
= available business cash.

Reserve taxes before treating cash as distributable profit.

## 15. MONTHLY CLOSE

At each month end Nexia should prepare:
1. sales reconciliation;
2. marketplace payout reconciliation;
3. bank reconciliation;
4. purchase reconciliation;
5. inventory movement;
6. expense document completeness;
7. VAT reconciliation;
8. IRPF/quarterly provision;
9. returns/incidents;
10. contribution margin;
11. cash runway;
12. compliance alerts.

Status:
GREEN = complete
AMBER = missing evidence / human review
RED = deadline, tax, legal or cash risk.

## 16. QUARTERLY CLOSE

Before each quarterly filing:
- freeze period;
- reconcile all channels;
- reconcile bank;
- reconcile supplier invoices/documents;
- reconcile inventory movements;
- calculate tax;
- run anomaly checks;
- prepare draft filings;
- present HUMAN GATE if filing/payment/signature is required;
- archive submitted form and proof;
- record payment;
- verify tax account where possible.

Nexia may prepare calculations and drafts, but must not claim a filing/payment occurred without evidence.

## 17. ANNUAL CLOSE

Annual checklist:
- annual sales reconciliation;
- inventory valuation;
- expense reconciliation;
- tax reconciliation;
- IRPF/Renta preparation;
- annual VAT obligations;
- information returns where applicable;
- platform/reporting reconciliation;
- asset/depreciation review;
- documentation completeness;
- legal/contract review;
- insurance/risk review;
- next-year tax calendar.

## 18. DEADLINE ENGINE

Maintain a live calendar with:
- obligation;
- model/form;
- period;
- due date;
- preparation date;
- evidence required;
- status;
- responsible party;
- payment amount;
- filing proof;
- contingency date.

The system must alert before the deadline, not on the deadline.

## 19. DOCUMENT ARCHIVE

Folder taxonomy:
01_LEGAL
02_TAX_REGISTRATION
03_SOCIAL_SECURITY
04_INVOICES_SALES
05_INVOICES_PURCHASES
06_EXPENSES
07_BANKING
08_MARKETPLACES
09_INVENTORY
10_TAX_RETURNS
11_CONSUMER_LEGAL
12_PRIVACY
13_CONTRACTS
14_INSURANCE
15_AUDIT_EVIDENCE
16_ANNUAL_CLOSE

Every document gets:
date / type / counterparty / period / amount / tax treatment / related transaction / source / verification status.

## 20. RISK REGISTER

High priority risks:
- starting activity before correct registrations;
- wrong IVA regime;
- incorrectly applying REBU;
- incorrectly applying recargo de equivalencia;
- treating asking prices as revenue;
- missing purchase evidence;
- mixing private and business expenses;
- missing quarterly deadlines;
- non-compliant invoicing software;
- unsupported authenticity/vintage claims;
- platform account restrictions;
- consumer return/guarantee errors;
- cash spent before tax provisioning;
- undocumented marketplace fees;
- cross-border VAT mistakes;
- inability to reproduce accounting evidence.

## 21. HUMAN GATES

Nexia cannot independently perform these without the required authorization, credentials or legally binding human action:
- tax registration submission/signature;
- RETA registration where human identity/consent is required;
- bank account actions;
- tax payments;
- social-security payments;
- legal contracts;
- accountant/lawyer engagement;
- marketplace identity verification;
- submission of declarations where authenticated human action is required.

When needed:
🔴 TAREA DE KAEL
Exact action + amount + deadline + reason + evidence Nexia prepared.

## 22. AUTOMATION TARGET

Target:
Kael should ideally only have to:
1. approve decisions;
2. provide missing documents/data;
3. perform identity/signature/payment gates;
4. resolve exceptions.

Nexia should handle:
- transaction classification;
- document naming;
- ledger preparation;
- reconciliation;
- margin calculations;
- tax provision estimates;
- draft forms;
- deadline monitoring;
- anomaly detection;
- evidence checklist;
- monthly/quarterly reports;
- archive indexing;
- questions for professional review.

No background execution is claimed unless an actual connected automation exists.

## 23. FIRST IMPLEMENTATION PHASES

PHASE A — Tax/legal fact discovery
- exact activity description;
- seller status;
- expected customer mix;
- sourcing mix: wholesaler/private;
- channels;
- Spain/EU sales;
- expected turnover;
- home/other activity address;
- existing autónomo/company status if any;
- other economic activities if any.

PHASE B — Regime decision
- IAE/CNAE;
- IVA regime;
- REBU eligibility by sourcing type;
- recargo equivalence test;
- IRPF method;
- RETA.

PHASE C — Compliance pack
- registration checklist;
- invoice template/system;
- books;
- tax calendar;
- consumer legal pack;
- privacy pack;
- archive structure.

PHASE D — Operating integration
- connect inventory SKU to accounting;
- connect order to invoice;
- connect payout to bank;
- connect purchase batch to stock;
- connect stock to contribution;
- connect contribution to tax provision.

PHASE E — Pilot
Run the system against the first 10 sourced garments and the existing OWN inventory without inventing tax treatment where evidence is missing.

PHASE F — Scale
Only after a clean close:
- repeat sourcing;
- increase inventory;
- add channels;
- consider external accounting support if complexity justifies it;
- evaluate legal structure again.

## 24. CURRENT STATUS

HECHO VERIFICADO:
- Business direction is resale of second-hand clothing.
- Pilot is 10 branded T-shirts.
- Checkout total verified at €61.30 delivered.
- Payment is still pending.
- Existing resale data model already captures acquisition, preparation, listing, sale and contribution.

NEW BUSINESS CONTROL LAYER:
- Legal/tax/accounting architecture created by this document.
- Official AEAT sources checked on 2026-10-08.
- REBU, recargo de equivalencia, IRPF payments, VAT books, invoicing/SIF and e-invoicing timelines identified as critical research areas.

NOT YET VERIFIED:
- exact IAE/CNAE;
- final VAT regime;
- whether recargo de equivalencia applies to the exact intended activity;
- when/where REBU will apply;
- exact RETA contribution;
- exact filing calendar for the final configuration;
- whether professional tax/accounting review is required for the chosen setup.

## 25. IMMEDIATE NEXT ACTION

No-spend action:
build a fact sheet and decision matrix for the exact business configuration before any registration is filed.

Required facts from Kael will be requested only when needed for a concrete registration/regime decision.

This document is an operational planning and research layer, not a substitute for individualized legal or tax advice. Final legal/tax decisions should be checked against current AEAT/Seguridad Social rules and, where material, a qualified asesor fiscal/laboral.

## SOURCES CHECKED 2026-10-08

Official AEAT:
- VAT regimes and Modelo 303/036.
- Recargo de equivalencia.
- REBU.
- Modelo 130.
- VAT books.
- SIF/VERI*FACTU.
- Electronic invoicing calendar.

Official Seguridad Social / Importass:
- Autónomo registration requirements and timing.

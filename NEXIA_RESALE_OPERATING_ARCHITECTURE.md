# NEXIA — RESALE OPERATING ARCHITECTURE

Status: ACTIVE / PRIMARY-MISSION ADAPTATION
Documentation sync: 2026-10-08 — pilot checkout amount reconciled with canonical STATE v45.
Date: 2026-10-08
Mission: MISSION-RESALE-001
Experiment: EXP-RESALE-001 / pilot EXP-RESALE-001A

## 1. Objective
NEXIA is now structurally optimized around professional second-hand clothing resale in Spain as the primary commercial vehicle. Other missions remain preserved but paused.

The objective is not simply to list clothes. It is to build a repeatable machine:
SOURCING -> INSPECTION -> COSTING -> SKU -> PREP -> LISTING -> PRICING -> SALE -> FULFILMENT -> RETURNS -> ACCOUNTING -> LEARNING -> REBUY.

## 2. Core business modules

### A. Sourcing Intelligence
Inputs: supplier catalogue, local availability, brand/category signals, public marketplace prices, historical sell-through.
Outputs: supplier score, target buy list, expected landed cost, expected sellable rate, risk.

### B. Intake & Quality Control
Every incoming item receives a SKU and records:
- supplier and batch;
- purchase cost allocation;
- brand/category/subcategory;
- size;
- condition/grade;
- defects;
- measurements;
- cleaning/repair requirement;
- sellable / non-sellable decision;
- intake minutes.

### C. Unit Economics Engine
Canonical formulas:
- landed item cost = allocated purchase + inbound transport + applicable preparation allocation;
- effective cost per sellable item = total batch cost / actually publishable items;
- contribution = realized sale price - item cost - preparation - packaging - channel variable costs - expected return loss;
- net profit = contribution - fixed/periodic operating costs - applicable taxes.

Never use supplier €/kg or asking prices as profitability evidence.

### D. Pricing & Listing Engine
Prepare channel-specific listing data without prohibited direct automation on Vinted.
Fields: title, brand, category, size, condition, measurements, defect disclosure, photo checklist, target price, minimum acceptable price, expected contribution.

### E. Inventory & Cash Engine
Track units by status:
PURCHASED -> RECEIVED -> QC -> READY -> LISTED -> RESERVED -> SOLD -> SHIPPED -> COMPLETED / RETURNED / LOSS.

Track cash separately from inventory valuation. Never count listed inventory as revenue.

### F. Channel Engine
Primary: Vinted Pro.
Secondary: Wallapop Pro/business, eBay, Etsy selective, Vestiaire premium.

Compliance boundary: no account farms, bots, scraping or direct Vinted automation unless explicitly authorized by the platform and verified.

### G. Returns & Risk Engine
Measure claims, returns, defects, item-not-as-described incidents, lost parcels and channel disputes. Reserve an explicit expected-return cost in contribution calculations.

### H. Learning & Rebuy Engine
A supplier/category is promoted only when evidence supports it. Rebuy decisions require observed economics and reproducibility, not attractive listings alone.

## 3. Decision hierarchy
1. Realized contribution per sellable item.
2. Contribution per human minute.
3. Sell-through / days to sale.
4. Sellable rate and defect rate.
5. Reproducibility of sourcing.
6. Cash cycle and capital intensity.
7. Scalability and automation potential.

## 4. Pilot protocol — EXP-RESALE-001A
Approved scope: 10 branded T-shirts from Vintage4Originals; checkout total verified at 61,30 € delivered.
Checkout total verified: 61,30 € delivered (product + shipping + taxes). Product component: 55 €; payment pending; no spend executed.
Purchase execution: pending Kael payment; no payment integration exists.

On receipt, record every unit before listing. The pilot is successful only if the predefined metrics are measured from real outcomes:
- >=80% sellable;
- average realized sale price >=15 €;
- >=10 € contribution per sold unit;
- preparation time tracked;
- returns/incidents tracked.

Failure signals:
- <60% sellable;
- average realized sale price <12 €;
- >20 min preparation per item without compensating economics;
- repeated quality/compliance issues.

## 5. Data model to implement next
Minimum entities:
Supplier, Batch, Item/SKU, Inspection, Preparation, Listing, Channel, PriceEvent, Order, Shipment, Return, Expense, Payout, Experiment, EvidenceEvent.

Each Item/SKU must be traceable back to Supplier + Batch and forward to Listing + Order + realized economics.

## 6. Automation boundaries
GREEN / €0: spreadsheets/data schemas, SKU generation, cost allocation, margin calculations, QA checklists, listing drafts, reporting, supplier comparison.
YELLOW: external account creation, channel onboarding, bulk operational changes, paid tools.
RED: purchases, payments, ads, credentials, prohibited automation, irreversible external actions.

## 7. Architecture priority
Before building a large dashboard or automation layer, prove the data model with the first batch. Avoid warehouse/software complexity until inventory turnover justifies it.

## 8. Success condition for scaling
Do not scale inventory because the first batch sells. Scale only when sourcing quality, contribution, preparation time, sell-through and cash cycle are reproducible across repeated batches.

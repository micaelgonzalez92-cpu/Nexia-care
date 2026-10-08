# NEXIA CORE — Procurement, Packaging & Brand Presentation
Status: DESIGNED / INTERNAL POLICY ONLY — NO PURCHASING OR SUPPLIER CONTACT
Effective: 2026-10-09
Cost: €0
Owner / material decision authority: Kael

## 1. Purpose
Create a controlled procurement function for inventory, shipping materials, packaging, labels, brand presentation and operating consumables. Its goal is not to buy the cheapest item in isolation: it is to secure the required quality and delivery reliability at the lowest verified total cost, without tying up cash or damaging unit economics.

This document authorizes internal planning and research only. It does not authorize purchases, supplier contact, account creation, paid samples, subscriptions, external commitments or publication.

## 2. Scope and ownership
Procurement coordinates with:
- Sourcing & Inventory: stock, supplier, batch/lot, condition, sizes, defects and sellable yield.
- Operations & Fulfilment: pick/pack, packing time, dispatch requirements and storage.
- Brand & Customer Experience: presentation, inserts, labels and packaging consistency.
- Finance & Unit Economics: landed cost, per-order consumables, cash exposure, VAT treatment and net contribution.
- Quality & Returns: damage prevention, complaint/return causes and replacement consumption.
- Compliance: packaging obligations, claims, materials and marketplace/carrier requirements applicable to the sales territory.

No function may treat a quote, cart, supplier lead or budget ceiling as purchase approval.

## 3. Procurement categories
### A. Product and resale inventory
- Garments or other saleable units; supplier/lot identity; item count; size/brand mix; condition grades; defects; expected sellable yield; delivered cost; invoice/receipt and return terms.
- Record cost per acquired unit and cost per sellable unit separately.
- No inventory order until the existing experiment's gates and the specific purchase Human Gate are satisfied.

### B. Essential shipping consumables
- Mailing bags / poly mailers in a small number of suitable sizes.
- Recycled paper mailers or cardboard boxes where garment protection, carrier rules or customer experience justify them.
- Protective inner bags only where useful for cleanliness/moisture protection.
- Packing tape, labels, printer paper/thermal labels, marker and a scale if needed.
- Reuse clean suitable packaging when safe, presentable and permitted; do not compromise protection or mislead customers.

### C. Brand and presentation
- Logo/brand stickers, thank-you cards, care cards, tissue paper, branded labels and custom-printed mailers.
- Treat all branded extras as optional until they demonstrate measurable customer or commercial value.
- Begin with low-cost, generic or self-printed materials if feasible. Avoid custom minimum orders before repeat demand is demonstrated.

### D. Operating equipment and overhead
- Measuring tape, lint roller, garment steamer/iron, neutral photo background, lighting, storage boxes, garment hangers and cleaning supplies, but only when a demonstrated workflow bottleneck justifies them.
- Track one-off equipment separately from per-order consumables and allocate its cost transparently over a defined period/order count.

### E. Contingency and after-sales
- Spare packaging for damaged/wrong-size materials, replacements, return shipments and lost/damaged parcels.
- Do not assume returns, replacement packaging or seller-paid postage cost zero; mark unknown costs NOT INSTRUMENTED until measured.

## 4. Supplier comparison standard
For each candidate, record:
- Supplier, URL, date checked, item/SKU and material/specification.
- Price excluding/including VAT, tax recoverability assumption, minimum order quantity, quantity breaks and setup/customization fees.
- Shipping, handling, delivery estimate, delivery restrictions and total delivered cost.
- Unit cost at realistic quantities; storage footprint; shelf life/material durability; defect rate and return/replacement policy.
- Compatibility with actual carrier size/weight limits, marketplace workflow and product dimensions.
- Sustainability or recycled-content claims only when supported by supplier evidence.
- Evidence quality: official current quote / public listing / estimate / unverified lead.
- No external contact without Kael's explicit approval for the exact supplier and message.

Compare at least three candidates when feasible, but do not waste time forcing three options if the market or requirements do not support it. Lowest sticker price is not automatically best.

## 5. Costing rules
For each shipment/order, calculate packaging cost as the sum of the actual consumables used:
- Outer mailer/box + tape + shipping label + protective inner packaging + branded insert/sticker + other used materials.
- Include inbound freight and non-recoverable tax in the material's landed cost where applicable; do not double-count recoverable VAT.
- Unit cost = total delivered purchase cost / usable quantity received.
- Packaging cost per order = sum of unit costs for quantities actually used per order.
- For custom setup/equipment, show both cash outlay and the explicitly chosen amortization assumption; do not hide the cash exposure.
- Add measured packing time × an explicit hourly-rate assumption to contribution analysis.
- Shipping paid by the buyer is not automatically profit; reconcile carrier charges, label costs, fees and any seller subsidy.
- Keep revenue, VAT collected, gross margin, contribution, cash movement and after-tax net profit separate.

UNKNOWN values must remain UNKNOWN / NOT INSTRUMENTED, never silently treated as €0.

## 6. Minimal viable packing standard
Initial design principle: clean, secure, low-cost, repeatable and professional enough for the chosen channel.
1. Verify item identity, size, condition and order before packing.
2. Protect garment from dirt/moisture with suitable inner protection when needed.
3. Choose the smallest outer package that safely fits the item and complies with carrier limits.
4. Seal securely; attach the correct label; confirm tracking/order association.
5. Add branding only if its cost is recorded and justified.
6. Record actual consumables and packing time during the pilot.
7. Retain evidence of dispatch and resolve exceptions through the approved workflow.

This is a draft standard; adapt it to the selected carrier, product, packaging law and platform rules before live use.

## 7. Purchase and reorder gates
GREEN — internal, free, reversible:
- Research public prices and specifications.
- Build comparison tables, calculate unit costs and draft specifications.
- Measure and record materials already owned by Kael if he provides the information.
- Prepare purchase proposals without ordering.

YELLOW — prepare and stop:
- Supplier shortlist, basket/cart, sample request draft, custom print mockups, reorder recommendation.
- Any change with uncertain compliance, quality or operational impact.

RED — explicit Human Gate required:
- Purchase any stock, packaging, equipment, sample or subscription.
- Pay a deposit, accept terms, create supplier account or send an external message.
- Order customized materials, commit to minimum quantities or activate automatic replenishment.

Every purchase proposal must state exact vendor/items/quantity, total delivered cash exposure including VAT and shipping, cost per usable unit, intended use, alternatives, expected benefit, risk, reversibility, success metric and stop criteria. The €100/week budget is a ceiling, not authorization.

No automatic reorder until actual consumption, lead time, repeat sales and reconciled contribution support a reorder point and Kael explicitly approves a maximum spend and scope.

## 8. Inventory control and replenishment
Track each material with:
- material_id; specification; supplier; unit; quantity on hand; usable quantity; reserved quantity; average landed unit cost; last price check; lead time; minimum order quantity; weekly usage; stockout risk; reorder point; storage location; batch/lot; evidence.
- Reorder point = expected usage during lead time + a documented safety buffer. Do not invent usage or lead time; keep unknowns uninstrumented.
- Initially purchase no more than a small, justified pilot quantity after live orders reveal actual consumption. Avoid speculative branded stock.
- Review dead stock, damage, obsolete branding and cash tied up before replenishing.

## 9. Pilot measurement plan
Before any live purchase, define a bounded test:
- Hypothesis: a selected packaging configuration safely ships the target item type while meeting an explicit per-order cost ceiling.
- Action: first use existing materials if suitable; if not, submit a specific purchase proposal for approval.
- Cost: €0 for planning; any physical purchase requires separate approval.
- Metrics: packaging cost/order, packing minutes/order, damage/complaint/return rate, dispatch errors, customer feedback where legitimately available, usable-unit yield and cash tied up.
- Success/failure thresholds: set before the paid test; do not infer success from a single anecdote.
- Risk: poor protection, carrier incompatibility, overbuying, custom stock obsolescence and false economy from under-packaging.
- Learning: compare actual costs and incidents with the baseline and update the specification only with evidence.

## 10. Current known state and boundaries
- This document is an internal design/policy artifact, not a connected procurement system.
- No packaging stock, equipment, inventory, samples or custom materials have been purchased by this action.
- No supplier has been contacted; no account or subscription has been created.
- Current resale pilot inventory remains unpurchased. Existing economic gates are unchanged.
- Actual packaging inventory, order volume, preferred carrier, parcel dimensions, brand assets, packing time and current material costs are UNKNOWN until provided or measured.
- Canonical NEXIA_STATE.json is not changed by this document. Persistence synchronization remains partial; do not claim full checkpoint consistency.

## 11. Definition of done
The procurement function is operational only when: the actual fulfilment channel and parcel requirements are known; a verified supplier comparison exists; costs and taxes are reconciled; a packing standard has been tested on real orders; consumption and stock are instrumented; the purchase Human Gate is respected; and repeatable replenishment is supported by evidence.

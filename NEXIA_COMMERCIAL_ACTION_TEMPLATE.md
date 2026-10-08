# NEXIA — Commercial Action & Product Intake Template
Status: TEMPLATE / NO LIVE ACTION IMPLIED
Cost: €0

Use one copy per product batch or external action. Do not leave unknown values as zero; use UNKNOWN / NOT INSTRUMENTED.

## A. Product / SKU intake
- Batch ID:
- SKU:
- Product type / brand:
- Source / supplier:
- Purchase date and evidence:
- Unit acquisition cost (€):
- Inbound transport allocated (€):
- Preparation / cleaning / repair (€):
- Packaging (€):
- Condition / defects:
- Size / measurements:
- Sellable status: UNKNOWN / YES / NO
- Photo references and confirmed SKU match:
- Sellable yield for batch (%): UNKNOWN until counted
- Platform restrictions/IP/brand authenticity checks:
- Proposed channel(s):
- Proposed realized selling price (€):
- Price evidence type: realized comparable / active listing / estimate / hypothesis
- Expected platform/payment fees (€):
- Seller-paid shipping / subsidy (€):
- Expected returns/defects allowance (€):
- Discount/ads/other variable costs (€):
- Human time (minutes) and explicit hourly-rate assumption (€):
- VAT/tax treatment: UNKNOWN until checked / source:
- Contribution estimate before overhead/income tax (€):
- Key uncertainty and evidence against the thesis:
- Decision: RESEARCH / PREPARE / HUMAN GATE / STOP

## B. Listing draft (not published)
- Platform and account type:
- Title:
- Description:
- Category:
- Brand:
- Size:
- Condition:
- Measurements:
- Price:
- Shipping settings:
- Returns/consumer information:
- Photo order and image-to-SKU verification:
- Platform policy checked on (date/source):
- Draft preview reviewed:
- Publication approval reference:
- Status: DRAFT ONLY unless independently verified live

## C. Human Gate — required for RED actions
- Action ID:
- Exact action:
- Platform/vendor and target:
- Scope / SKU / quantity / duration:
- Maximum all-in exposure (€):
- Fees, VAT, delivery, contingency:
- Expected economic outcome and uncertainty:
- Success metric:
- Failure/stop criteria:
- Risk and reversibility:
- Required permissions/data:
- Postcondition to verify:
- Rollback/cancellation plan:
- Kael's explicit approval (exact scope):
- Approval timestamp:
- Gate status: NOT REQUESTED / REQUESTED / APPROVED / REJECTED / EXPIRED

## D. Execution evidence
- Action ID:
- Status: REQUESTED / IN_PROGRESS / EXECUTED / VERIFIED / BLOCKED / FAILED / CANCELLED
- Actor/tool and capability evidence:
- Preflight / duplicate check:
- Start timestamp:
- Completion timestamp:
- Before-state evidence:
- After-state evidence:
- Actual cost (€):
- Receipt / order / listing reference:
- Settlement status:
- Error and recovery action:
- Verified by / verification timestamp:
- Human minutes:
- Notes / data redaction check:

## E. Economic reconciliation
- Period start/end:
- Units acquired:
- Units confirmed sellable:
- Units listed:
- Units sold:
- Units delivered/accepted:
- Transactions settled:
- Gross customer payments:
- VAT collected/remitted treatment:
- Proceeds excluding VAT collected:
- Cost of sold inventory (allocated landed cost):
- Platform/payment fees including VAT on fees where applicable:
- Packaging and seller-paid shipping:
- Refunds/returns/defects/discounts:
- Ads and other variable costs:
- Contribution before labor:
- Human time × stated hourly rate:
- Contribution after labor:
- Allocated overhead:
- Income-tax provision/basis:
- Net profit after tax (only if reconciled):
- Evidence references:
- Repeatability assessment:
- Decision: STOP / REVISE / REPEAT / SCALE PROPOSAL

## F. Mandatory preflight
- [ ] Capability state is known; no unsupported claims of connection or automation.
- [ ] Platform terms and permitted automation method checked.
- [ ] No raw passwords, OTPs, payment data or secrets in prompts/logs/repository.
- [ ] Human Gate approved the exact action, scope and maximum exposure if RED.
- [ ] Costs and unknowns are explicit; VAT is not double-counted.
- [ ] Duplicate/idempotency check completed where applicable.
- [ ] Stop/rollback route is defined.
- [ ] Success and failure criteria were set before execution.

## G. Mandatory postflight
- [ ] Actual postcondition independently checked.
- [ ] Status reflects evidence; EXECUTED is not automatically VERIFIED.
- [ ] Actual costs and receipts captured.
- [ ] No private data or secrets exposed in the evidence record.
- [ ] Economic result reconciled or marked UNKNOWN / NOT INSTRUMENTED.
- [ ] Learning and next action recorded.

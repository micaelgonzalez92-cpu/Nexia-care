const fs = require('fs');
const path = require('path');
const vm = require('vm');

const root = __dirname;
const loadJson = rel => JSON.parse(fs.readFileSync(path.join(root, rel), 'utf8'));
const assert = (cond, msg) => { if (!cond) throw new Error(msg); };

const intake = loadJson('workflows/lead-intake-human-review.json');
const bootstrap = loadJson('workflows/dedup-table-bootstrap.json');
const dedup = loadJson('workflows/persistent-dedup-guard.json');
const validSample = loadJson('samples/valid-lead.json');
const invalidSample = loadJson('samples/invalid-lead.json');
const duplicateSample = loadJson('samples/duplicate-lead.json');

for (const [name, workflow] of Object.entries({ intake, bootstrap, dedup })) {
  assert(workflow.active === false, `${name}: workflow must be inactive`);
  const serialized = JSON.stringify(workflow).toLowerCase();
  assert(!serialized.includes('huescaventura'), `${name}: buyer-specific branding leaked into product`);
}

const intakeAllowed = new Set([
  'n8n-nodes-base.webhook',
  'n8n-nodes-base.code',
  'n8n-nodes-base.respondToWebhook',
]);
for (const node of intake.nodes) {
  assert(intakeAllowed.has(node.type), `intake: unexpected node type ${node.type}`);
}

const intakeCode = intake.nodes.find(n => n.type === 'n8n-nodes-base.code');
assert(intakeCode, 'intake: missing Code node');
const runIntake = payload => vm.runInNewContext(`(()=>{${intakeCode.parameters.jsCode}})()`, {
  $input: { all: () => [{ json: payload }] },
}, { timeout: 1000 });

const validOut = runIntake(validSample);
assert(Array.isArray(validOut) && validOut.length === 1, 'intake: valid sample did not return one item');
assert(validOut[0].json.ok === true, 'intake: valid sample not ok');
assert(validOut[0].json.status === 'prepared_for_human_review', 'intake: wrong valid status');
assert(validOut[0].json.identity.email === 'alex.example@example.com', 'intake: email normalization failed');
assert(validOut[0].json.identity.phone === '+34600123456', 'intake: phone normalization failed');
assert(validOut[0].json.autonomous_send === false, 'intake: autonomous_send must be false');
assert(validOut[0].json.reply_draft.includes('has not been sent'), 'intake: reply draft safety text missing');

const invalidOut = runIntake(invalidSample);
assert(invalidOut[0].json.ok === false, 'intake: invalid sample should fail');
assert(invalidOut[0].json.status === 'validation_failed', 'intake: invalid status mismatch');
assert(invalidOut[0].json.missing_fields.includes('name'), 'intake: missing name not detected');
assert(invalidOut[0].json.missing_fields.includes('email_or_phone'), 'intake: missing contact not detected');
assert(invalidOut[0].json.autonomous_send === false, 'intake: invalid path autonomous_send must be false');

const bootstrapTable = bootstrap.nodes.find(n => n.type === 'n8n-nodes-base.dataTable');
assert(bootstrapTable, 'bootstrap: Data Table node missing');
assert(bootstrapTable.parameters.resource === 'table', 'bootstrap: wrong resource');
assert(bootstrapTable.parameters.operation === 'create', 'bootstrap: wrong operation');
assert(bootstrapTable.parameters.tableName === 'lead_intake_reliability_keys', 'bootstrap: wrong table name');
const columns = bootstrapTable.parameters.columns.column.map(c => c.name).sort();
assert(JSON.stringify(columns) === JSON.stringify(['eventKey','identityKey','recordId'].sort()), 'bootstrap: wrong columns');

const dedupAllowed = new Set(['n8n-nodes-base.webhook','n8n-nodes-base.code','n8n-nodes-base.dataTable']);
for (const node of dedup.nodes) {
  assert(dedupAllowed.has(node.type), `dedup: unexpected node type ${node.type}`);
}
const dedupCode = dedup.nodes.find(n => n.type === 'n8n-nodes-base.code');
assert(dedupCode, 'dedup: Code node missing');
const runDedupCode = payload => vm.runInNewContext(`(()=>{${dedupCode.parameters.jsCode}})()`, {
  $json: { body: payload },
}, { timeout: 1000 });

const key1 = runDedupCode(validSample)[0].json;
const key2 = runDedupCode(duplicateSample)[0].json;
assert(key1.eventKey !== key2.eventKey, 'dedup: sample event keys should differ');
assert(key1.identityKey === key2.identityKey, 'dedup: normalized duplicate identity should match');
assert(key1.identityKey === 'email:alex.example@example.com', 'dedup: normalized identity mismatch');
assert(key1.autonomous_send === false && key2.autonomous_send === false, 'dedup: autonomous_send must be false');

const dtNodes = dedup.nodes.filter(n => n.type === 'n8n-nodes-base.dataTable');
assert(dtNodes.length === 3, 'dedup: expected three Data Table nodes');
assert(dtNodes.filter(n => n.parameters.operation === 'rowNotExists').length === 2, 'dedup: expected two rowNotExists guards');
assert(dtNodes.filter(n => n.parameters.operation === 'insert').length === 1, 'dedup: expected one insert');
for (const node of dtNodes) {
  assert(node.parameters.dataTableId.value === 'lead_intake_reliability_keys', `dedup: ${node.name} references wrong table`);
}

console.log(JSON.stringify({
  pass: true,
  product: 'lead-intake-reliability-kit-v0.1',
  valid_intake: true,
  invalid_input_rejected: true,
  normalized_duplicate_identity: true,
  dedup_structure: true,
  autonomous_send: false
}));

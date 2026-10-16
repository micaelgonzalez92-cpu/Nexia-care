const fs = require('fs');
const path = require('path');
const assert = require('node:assert/strict');

const root = path.join(__dirname);
const names = ['bootstrap-v02.json', 'guard-v02.json', 'audit-v02.json'];
const workflows = Object.fromEntries(names.map(name => [name, JSON.parse(fs.readFileSync(path.join(root, name), 'utf8'))]));

for (const [name, workflow] of Object.entries(workflows)) {
  assert.equal(workflow.active, false, `${name} must be inactive by default`);
  const nodeNames = workflow.nodes.map(n => n.name);
  assert.equal(new Set(nodeNames).size, nodeNames.length, `${name} node names must be unique`);
  const nodeIds = workflow.nodes.map(n => n.id);
  assert.equal(new Set(nodeIds).size, nodeIds.length, `${name} node ids must be unique`);
  const bannedTypes = new Set([
    'n8n-nodes-base.httpRequest', 'n8n-nodes-base.emailSend', 'n8n-nodes-base.gmail',
    'n8n-nodes-base.slack', 'n8n-nodes-base.telegram', 'n8n-nodes-base.twilio',
    'n8n-nodes-base.sendGrid', 'n8n-nodes-base.mailjet'
  ]);
  for (const node of workflow.nodes) {
    assert.ok(!bannedTypes.has(node.type), `${name} contains outbound action node ${node.type}`);
  }
  for (const node of workflow.nodes) assert.equal(node.credentials, undefined, `${name} must not embed credentials`);
}

const bootstrap = workflows['bootstrap-v02.json'];
const create = bootstrap.nodes.find(n => n.name === 'Create V0.2 Table');
assert.ok(create, 'bootstrap must create the V0.2 table');
assert.equal(create.parameters.tableName, 'lead_intake_reliability_keys_v02');
assert.deepEqual(create.parameters.columns.column.map(c => c.name), ['eventKey','identityKey','recordId','payloadHash']);

const guard = workflows['guard-v02.json'];
assert.equal(guard.id, 'nexia-lead-intake-replay-conflict-v02-candidate');
const crypto = guard.nodes.find(n => n.name === 'Hash Payload');
assert.ok(crypto, 'guard must hash payloads');
assert.equal(crypto.type, 'n8n-nodes-base.crypto');
assert.equal(crypto.parameters.type, 'SHA256');
assert.equal(crypto.parameters.dataPropertyName, 'payloadHash');
const inserted = guard.nodes.find(n => n.name === 'Insert New Event');
assert.ok(inserted, 'guard must persist accepted events');
assert.equal(inserted.parameters.columns.value.payloadHash, '={{ $json.payloadHash }}');
const code = guard.nodes.filter(n => n.type === 'n8n-nodes-base.code').map(n => n.parameters.jsCode).join('\n');
for (const state of ['NEW_ACCEPTED','EXACT_REPLAY','CONFLICTING_REPLAY','DUPLICATE_IDENTITY','INVALID']) {
  assert.ok(code.includes(state), `guard must expose state ${state}`);
}
assert.ok(code.includes('autonomous_send:false'), 'all decision outputs must remain non-autonomous');
assert.ok(code.includes("missing_event_id"), 'missing event must be classified');
assert.ok(code.includes("missing_identity"), 'missing identity must be classified');

const eventExists = guard.nodes.find(n => n.name === 'Event Exists');
const eventNotSeen = guard.nodes.find(n => n.name === 'Event Not Seen');
assert.equal(eventExists.parameters.operation, 'rowExists');
assert.equal(eventNotSeen.parameters.operation, 'rowNotExists');
const getPrior = guard.nodes.find(n => n.name === 'Get Prior Event');
assert.equal(getPrior.parameters.operation, 'get');
assert.equal(getPrior.parameters.filters.conditions[0].keyName, 'eventKey');

const audit = workflows['audit-v02.json'];
const getRows = audit.nodes.find(n => n.name === 'Get V0.2 Rows');
assert.equal(getRows.parameters.operation, 'get');
assert.equal(getRows.parameters.returnAll, true);

console.log(JSON.stringify({
  pass: true,
  contract: 'AUTO_PRODUCT_V02_STATIC_CANDIDATE',
  workflows: names,
  decision_states: ['NEW_ACCEPTED','EXACT_REPLAY','CONFLICTING_REPLAY','DUPLICATE_IDENTITY','INVALID'],
  payload_hash: 'SHA256',
  autonomous_send: false,
  external_action_nodes: 0
}));

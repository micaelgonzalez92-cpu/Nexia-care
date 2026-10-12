const fs = require('fs');
const assert = require('node:assert/strict');

const raw = fs.readFileSync(process.env.AUDIT_OUTPUT, 'utf8');
const out = JSON.parse(raw);
const item = Array.isArray(out) ? out[0] : out;

assert.equal(item.pass, true);
assert.equal(item.rows, Number(process.env.EXPECTED));
assert.equal(item.persistence, 'n8n-data-table');
assert.equal(item.autonomous_send, false);

console.log(`PASS: audit contains ${item.rows} persisted rows`);

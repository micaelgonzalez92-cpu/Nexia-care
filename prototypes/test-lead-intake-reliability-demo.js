'use strict';
const assert = require('node:assert/strict');
const {
  createStore,
  processLead,
  normalizeLead,
} = require('./lead-intake-reliability-demo');

function base(overrides = {}) {
  return {
    event_id: 'evt-1',
    source: 'Web Form',
    name: ' Ana  Pérez ',
    email: ' ANA@EXAMPLE.COM ',
    phone: '+34 600 123 456',
    service: 'Presupuesto',
    message: 'Necesito información',
    ...overrides,
  };
}

const tests = [];
function test(name, fn) { tests.push({ name, fn }); }

test('normalizes deterministic fields', () => {
  const n = normalizeLead(base());
  assert.equal(n.name, 'Ana Pérez');
  assert.equal(n.email, 'ana@example.com');
  assert.equal(n.phone, '+34600123456');
  assert.equal(n.source, 'web form');
});

test('creates one valid lead and drafts but does not send acknowledgement', () => {
  const store = createStore();
  const r = processLead(base(), store);
  assert.equal(r.status, 'processed');
  assert.equal(r.category, 'created');
  assert.equal(r.committed, true);
  assert.match(r.acknowledgement_draft, /no se ha enviado/i);
  assert.equal(Object.keys(store.records).length, 1);
});

test('same event id is idempotently skipped', () => {
  const store = createStore();
  processLead(base(), store);
  const r = processLead(base(), store);
  assert.equal(r.status, 'idempotent_skip');
  assert.equal(Object.keys(store.records).length, 1);
  assert.equal(store.audit.length, 1);
});

test('same email on a new event updates existing record without overwriting populated good fields', () => {
  const store = createStore();
  processLead(base({ service: 'Instalación', message: 'Texto original' }), store);
  const r = processLead(base({ event_id: 'evt-2', name: 'Ana P.', service: 'Mantenimiento', message: 'Texto nuevo', phone: '' }), store);
  assert.equal(r.category, 'updated_existing');
  assert.equal(Object.keys(store.records).length, 1);
  const record = Object.values(store.records)[0];
  assert.equal(record.name, 'Ana Pérez');
  assert.equal(record.service, 'Instalación');
  assert.ok(r.merge.preserved.includes('name'));
  assert.ok(r.merge.preserved.includes('service'));
});

test('missing contact method routes to human review and writes nothing', () => {
  const store = createStore();
  const r = processLead(base({ email: '', phone: '' }), store);
  assert.equal(r.status, 'validation_failed');
  assert.equal(r.committed, false);
  assert.ok(r.errors.includes('missing_contact_method'));
  assert.equal(Object.keys(store.records).length, 0);
});

test('malformed email fails validation and writes nothing', () => {
  const store = createStore();
  const r = processLead(base({ email: 'not-an-email', phone: '' }), store);
  assert.equal(r.status, 'validation_failed');
  assert.ok(r.errors.includes('invalid_email'));
  assert.equal(Object.keys(store.records).length, 0);
});

test('synthetic failure before commit is visible and leaves no partial CRM write', () => {
  const store = createStore();
  const r = processLead(base(), store, { failStage: 'before_commit' });
  assert.equal(r.status, 'failed_safe');
  assert.equal(r.committed, false);
  assert.equal(r.failure_alert.action, 'manual_review_required');
  assert.equal(Object.keys(store.records).length, 0);
  assert.equal(store.processedEvents.size, 0);
});

test('phone equivalence merges only when a default country code is explicitly configured', () => {
  const store = createStore();
  processLead(base({ email: '', event_id: 'evt-1' }), store, { defaultCountryCode: '34' });
  const r = processLead(base({ email: 'second@example.com', event_id: 'evt-2', phone: '600123456' }), store, { defaultCountryCode: '34' });
  assert.equal(r.category, 'updated_existing');
  assert.equal(Object.keys(store.records).length, 1);
});

test('without explicit country context local and international phone forms are not guessed equivalent', () => {
  const store = createStore();
  processLead(base({ email: '', event_id: 'evt-1' }), store);
  const r = processLead(base({ email: 'second@example.com', event_id: 'evt-2', phone: '600123456' }), store);
  assert.equal(r.category, 'created');
  assert.equal(Object.keys(store.records).length, 2);
});

let passed = 0;
for (const t of tests) {
  try {
    t.fn();
    console.log(`PASS ${t.name}`);
    passed++;
  } catch (err) {
    console.error(`FAIL ${t.name}`);
    console.error(err.stack || err);
  }
}
console.log(`${passed}/${tests.length} tests passed`);
process.exitCode = passed === tests.length ? 0 : 1;

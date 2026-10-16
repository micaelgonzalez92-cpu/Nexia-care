const assert = require('node:assert/strict');

const BASE_URL = process.env.BASE_URL || 'http://127.0.0.1:5678';
const GUARD_PATH = process.env.GUARD_PATH || 'lead-intake-replay-conflict-v02';
const BOOTSTRAP_PATH = process.env.BOOTSTRAP_PATH || 'lead-intake-replay-bootstrap-v02';
const AUDIT_PATH = process.env.AUDIT_PATH || 'lead-intake-replay-audit-v02';
const CONCURRENCY = 12;
const failures = [];

async function requestJson(path, body) {
  const response = await fetch(`${BASE_URL}/webhook/${path}`, {
    method: 'POST',
    headers: {'content-type': 'application/json'},
    body: JSON.stringify(body),
  });
  const text = await response.text();
  if (!response.ok) throw new Error(`HTTP_${response.status}:${text}`);
  if (!text) return null;
  return JSON.parse(text);
}

function unwrapGuard(raw) {
  if (Array.isArray(raw)) return raw.length ? raw[0] : null;
  return raw;
}

async function guard(body) {
  try {
    const raw = await requestJson(GUARD_PATH, body);
    return unwrapGuard(raw);
  } catch (error) {
    return {state: 'HTTP_ERROR', error: String(error?.message || error), autonomous_send: false};
  }
}

async function auditRows() {
  const raw = await requestJson(AUDIT_PATH, {});
  if (raw == null) return [];
  return Array.isArray(raw) ? raw : [raw];
}

function counts(results) {
  const out = {};
  for (const r of results) {
    const state = r?.state ?? 'MISSING_STATE';
    out[state] = (out[state] || 0) + 1;
  }
  return out;
}

function requireInvariant(ok, message, details) {
  if (!ok) failures.push({message, details});
}

function validHash(value) {
  return typeof value === 'string' && /^[0-9a-f]{64}$/.test(value);
}

function validateDecisions(results, label) {
  for (let i = 0; i < results.length; i++) {
    const r = results[i];
    requireInvariant(r != null, `${label}: response ${i} is null/missing`, r);
    if (r == null) continue;
    requireInvariant(r.autonomous_send === false, `${label}: response ${i} autonomous_send must be false`, r);
    if (!['INVALID', 'HTTP_ERROR'].includes(r.state)) {
      const hash = r.payloadHash ?? r.candidatePayloadHash;
      requireInvariant(validHash(hash), `${label}: response ${i} hash invalid`, r);
    }
  }
}

async function sameEventBurst(burst) {
  const eventId = `v021-race-event-${burst}`;
  const email = `v021-race-event-${burst}@example.com`;
  const payload = {
    event_id: eventId,
    name: `V021 Race Event ${burst}`,
    email,
    phone: '',
    source: 'synthetic-v021-concurrency-stress',
    service: 'consultation',
    message: `v021 same-event burst ${burst}`,
  };
  const results = await Promise.all(Array.from({length: CONCURRENCY}, () => guard(payload)));
  const c = counts(results);
  console.log(JSON.stringify({test:'V021_SAME_EVENT', burst, concurrency:CONCURRENCY, counts:c}));
  requireInvariant(c.NEW_ACCEPTED === 1, `A${burst}: expected 1 NEW_ACCEPTED`, c);
  requireInvariant(c.EXACT_REPLAY === 11, `A${burst}: expected 11 EXACT_REPLAY`, c);
  requireInvariant(Object.keys(c).every(k => ['NEW_ACCEPTED','EXACT_REPLAY'].includes(k)), `A${burst}: unexpected state`, c);
  validateDecisions(results, `A${burst}`);
  const rows = await auditRows();
  const matching = rows.filter(r => r?.eventKey === `event:${eventId}`);
  requireInvariant(matching.length === 1, `A${burst}: expected exactly one persisted event row`, {matching:matching.length,total:rows.length});
  if (matching[0]) requireInvariant(validHash(matching[0].payloadHash), `A${burst}: persisted hash invalid`, matching[0]);
}

async function sameIdentityBurst() {
  const email = 'v021-race-identity@example.com';
  const payloads = Array.from({length:CONCURRENCY}, (_,i) => ({
    event_id:`v021-race-identity-${String(i+1).padStart(2,'0')}`,
    name:'V021 Race Identity', email, phone:'',
    source:'synthetic-v021-concurrency-stress', service:'consultation',
    message:'v021 same-identity distinct-event burst',
  }));
  const results = await Promise.all(payloads.map(guard));
  const c = counts(results);
  console.log(JSON.stringify({test:'V021_SAME_IDENTITY_DISTINCT_EVENTS',concurrency:CONCURRENCY,counts:c}));
  requireInvariant(c.NEW_ACCEPTED === 1, 'B: expected 1 NEW_ACCEPTED', c);
  requireInvariant(c.DUPLICATE_IDENTITY === 11, 'B: expected 11 DUPLICATE_IDENTITY', c);
  requireInvariant(Object.keys(c).every(k => ['NEW_ACCEPTED','DUPLICATE_IDENTITY'].includes(k)), 'B: unexpected state', c);
  validateDecisions(results, 'B');
  const rows = await auditRows();
  const matching = rows.filter(r => r?.identityKey === `email:${email}`);
  requireInvariant(matching.length === 1, 'B: expected exactly one persisted identity row', {matching:matching.length,total:rows.length});
}

(async () => {
  assert.equal(process.env.NEXIA_EXPECTED_SERIAL_LIMIT, '1', 'test contract serial limit marker must be 1');
  await requestJson(BOOTSTRAP_PATH, {});
  console.log('PASS: V0.2.1 bootstrap executed');
  for (let i=1;i<=3;i++) await sameEventBurst(i);
  await sameIdentityBurst();
  const rows = await auditRows();
  const eventKeys = rows.map(r => r?.eventKey);
  const identityKeys = rows.map(r => r?.identityKey);
  const dupEvents = eventKeys.filter((v,i,a)=>v && a.indexOf(v)!==i);
  const dupIds = identityKeys.filter((v,i,a)=>v && a.indexOf(v)!==i);
  requireInvariant(rows.length === 4, 'GLOBAL: expected exactly 4 rows', {total:rows.length, rows});
  requireInvariant(dupEvents.length === 0, 'GLOBAL: duplicate eventKey', dupEvents);
  requireInvariant(dupIds.length === 0, 'GLOBAL: duplicate identityKey', dupIds);
  for (const row of rows) requireInvariant(validHash(row?.payloadHash), 'GLOBAL: invalid persisted payloadHash', row);
  const evidence = {contract:'AUTO_PRODUCT_V021_SERIALIZED_CONCURRENCY_STRESS',concurrency:12,same_event_bursts:3,same_identity_bursts:1,observed_rows:rows.length,failures,pass:failures.length===0};
  console.log(JSON.stringify(evidence));
  if (failures.length) throw new Error(`V021_CONCURRENCY_STRESS_FAIL ${JSON.stringify(failures)}`);
  console.log('BOUNDED_SYNTHETIC_CONCURRENCY_PASS_SERIALIZED_PROFILE_12X3_PLUS_12X1');
})().catch(error => {
  console.error(error?.stack || error);
  process.exitCode = 1;
});

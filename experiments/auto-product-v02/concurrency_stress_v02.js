const assert = require('node:assert/strict');

const BASE_URL = process.env.BASE_URL || 'http://127.0.0.1:5678';
const GUARD_PATH = process.env.GUARD_PATH || 'lead-intake-replay-conflict-v02';
const BOOTSTRAP_PATH = process.env.BOOTSTRAP_PATH || 'lead-intake-replay-bootstrap-v02';
const AUDIT_PATH = process.env.AUDIT_PATH || 'lead-intake-replay-audit-v02';
const CONCURRENCY = 12;
const errors = [];

async function post(path, body) {
  const response = await fetch(`${BASE_URL}/webhook/${path}`, {
    method: 'POST',
    headers: {'content-type': 'application/json'},
    body: JSON.stringify(body),
  });
  const text = await response.text();
  if (!response.ok) throw new Error(`HTTP_${response.status}:${text}`);
  const parsed = text ? JSON.parse(text) : null;
  return Array.isArray(parsed) ? parsed[0] : parsed;
}

async function guardedPost(body) {
  try {
    return await post(GUARD_PATH, body);
  } catch (error) {
    return {state: 'HTTP_ERROR', error: String(error?.message || error), autonomous_send: false};
  }
}

async function auditRows() {
  const raw = await post(AUDIT_PATH, {});
  if (raw === null || raw === undefined) return [];
  return Array.isArray(raw) ? raw : [raw];
}

function stateCounts(results) {
  const counts = {};
  for (const item of results) counts[item?.state ?? 'MISSING_STATE'] = (counts[item?.state ?? 'MISSING_STATE'] || 0) + 1;
  return counts;
}

function requireInvariant(condition, message, details = undefined) {
  if (!condition) errors.push({message, details});
}

function validateHash(value, label) {
  requireInvariant(typeof value === 'string' && /^[0-9a-f]{64}$/.test(value), `${label}: payloadHash must be lowercase SHA-256 hex`, value);
}

async function sameEventBurst(burst) {
  const eventId = `race-event-${burst}`;
  const email = `race-event-${burst}@example.com`;
  const payload = {
    event_id: eventId,
    name: `Race Event ${burst}`,
    email,
    phone: '',
    source: 'synthetic-concurrency-stress',
    service: 'consultation',
    message: `same-event burst ${burst}`,
  };
  const results = await Promise.all(Array.from({length: CONCURRENCY}, () => guardedPost(payload)));
  const counts = stateCounts(results);
  console.log(JSON.stringify({test: 'SAME_EVENT', burst, concurrency: CONCURRENCY, counts}));
  requireInvariant(counts.NEW_ACCEPTED === 1, `same-event burst ${burst}: expected exactly 1 NEW_ACCEPTED`, counts);
  requireInvariant(counts.EXACT_REPLAY === CONCURRENCY - 1, `same-event burst ${burst}: expected exactly ${CONCURRENCY - 1} EXACT_REPLAY`, counts);
  requireInvariant(Object.keys(counts).every(k => ['NEW_ACCEPTED','EXACT_REPLAY'].includes(k)), `same-event burst ${burst}: unexpected state`, counts);
  for (const result of results) {
    requireInvariant(result.autonomous_send === false, `same-event burst ${burst}: autonomous_send must remain false`, result);
    if (result.state !== 'HTTP_ERROR') validateHash(result.payloadHash ?? result.candidatePayloadHash, `same-event burst ${burst}/${result.state}`);
  }
  const rows = await auditRows();
  const matching = rows.filter(r => r.eventKey === `event:${eventId}`);
  requireInvariant(matching.length === 1, `same-event burst ${burst}: expected exactly one persisted event row`, {matching: matching.length, totalRows: rows.length});
  if (matching[0]) validateHash(matching[0].payloadHash, `same-event burst ${burst}/persisted`);
}

async function sameIdentityDistinctEventsBurst() {
  const email = 'race-identity@example.com';
  const requests = Array.from({length: CONCURRENCY}, (_, i) => ({
    event_id: `race-identity-${String(i + 1).padStart(2, '0')}`,
    name: 'Race Identity',
    email,
    phone: '',
    source: 'synthetic-concurrency-stress',
    service: 'consultation',
    message: 'same-identity distinct-event burst',
  }));
  const results = await Promise.all(requests.map(body => guardedPost(body)));
  const counts = stateCounts(results);
  console.log(JSON.stringify({test: 'SAME_IDENTITY_DISTINCT_EVENTS', concurrency: CONCURRENCY, counts}));
  requireInvariant(counts.NEW_ACCEPTED === 1, 'same-identity burst: expected exactly 1 NEW_ACCEPTED', counts);
  requireInvariant(counts.DUPLICATE_IDENTITY === CONCURRENCY - 1, `same-identity burst: expected exactly ${CONCURRENCY - 1} DUPLICATE_IDENTITY`, counts);
  requireInvariant(Object.keys(counts).every(k => ['NEW_ACCEPTED','DUPLICATE_IDENTITY'].includes(k)), 'same-identity burst: unexpected state', counts);
  for (const result of results) {
    requireInvariant(result.autonomous_send === false, 'same-identity burst: autonomous_send must remain false', result);
    if (result.state !== 'HTTP_ERROR') validateHash(result.payloadHash ?? result.candidatePayloadHash, `same-identity/${result.state}`);
  }
  const rows = await auditRows();
  const matching = rows.filter(r => r.identityKey === `email:${email}`);
  requireInvariant(matching.length === 1, 'same-identity burst: expected exactly one persisted identity row', {matching: matching.length, totalRows: rows.length});
  if (matching[0]) validateHash(matching[0].payloadHash, 'same-identity/persisted');
}

async function finalAudit() {
  const rows = await auditRows();
  const eventKeys = rows.map(r => r.eventKey);
  const identityKeys = rows.map(r => r.identityKey);
  const duplicateEventKeys = eventKeys.filter((v, i, a) => a.indexOf(v) !== i);
  const duplicateIdentityKeys = identityKeys.filter((v, i, a) => a.indexOf(v) !== i);
  requireInvariant(rows.length === 4, 'global invariant: expected exactly 4 persisted rows', {totalRows: rows.length});
  requireInvariant(duplicateEventKeys.length === 0, 'global invariant: duplicate persisted eventKey detected', duplicateEventKeys);
  requireInvariant(duplicateIdentityKeys.length === 0, 'global invariant: duplicate persisted identityKey detected', duplicateIdentityKeys);
  for (const row of rows) validateHash(row.payloadHash, `final-audit/${row.eventKey}`);
  console.log(JSON.stringify({test: 'FINAL_AUDIT', totalRows: rows.length, duplicateEventKeys, duplicateIdentityKeys}));
  return rows;
}

(async () => {
  await post(BOOTSTRAP_PATH, {});
  console.log('PASS: concurrency stress table bootstrap executed');
  for (let burst = 1; burst <= 3; burst++) await sameEventBurst(burst);
  await sameIdentityDistinctEventsBurst();
  const rows = await finalAudit();
  const evidence = {
    contract: 'AUTO_PRODUCT_V02_CONCURRENCY_STRESS',
    concurrency: CONCURRENCY,
    same_event_bursts: 3,
    same_identity_bursts: 1,
    expected_total_rows: 4,
    observed_total_rows: rows.length,
    autonomous_send: false,
    errors,
    pass: errors.length === 0,
  };
  console.log(JSON.stringify(evidence));
  if (errors.length) {
    process.exitCode = 1;
    throw new Error(`CONCURRENCY_STRESS_FAIL ${JSON.stringify(errors)}`);
  }
  assert.equal(rows.length, 4);
  console.log('CONCURRENCY_STRESS_PASS_BOUNDED_12X_3_PLUS_12X_1');
})().catch(error => {
  console.error(error?.stack || error);
  process.exitCode = 1;
});

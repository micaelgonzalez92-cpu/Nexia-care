const crypto = require('crypto');
const assert = (cond, msg) => { if (!cond) throw new Error(msg); };

const clean = v => String(v ?? '').trim().replace(/\s+/g, ' ');
const normalize = raw => {
  const eventId = clean(raw.event_id);
  const name = clean(raw.name);
  const email = clean(raw.email).toLowerCase();
  const phoneRaw = clean(raw.phone);
  const digits = phoneRaw.replace(/\D/g, '');
  const phone = phoneRaw ? (phoneRaw.startsWith('+') ? '+' + digits : digits) : '';
  const source = clean(raw.source).toLowerCase();
  const service = clean(raw.service).toLowerCase();
  const message = clean(raw.message);
  if (!eventId) return {state:'INVALID', reason:'missing_event_id', autonomous_send:false};
  if (!email && !phone) return {state:'INVALID', reason:'missing_identity', autonomous_send:false};
  const identityKey = email ? `email:${email}` : `phone:${phone}`;
  const canonical = [name.toLowerCase(), email, phone, source, service, message].join('|');
  const payloadHash = crypto.createHash('sha256').update(canonical).digest('hex');
  return {eventKey:`event:${eventId}`, identityKey, recordId:`lead:${eventId}`, payloadHash, autonomous_send:false};
};

function decide(raw, store) {
  const n = normalize(raw);
  if (n.state === 'INVALID') return n;
  const priorEvent = store.events.get(n.eventKey);
  if (priorEvent) {
    return {state: priorEvent.payloadHash === n.payloadHash ? 'EXACT_REPLAY' : 'CONFLICTING_REPLAY', ...n};
  }
  if (store.identities.has(n.identityKey)) return {state:'DUPLICATE_IDENTITY', ...n};
  store.events.set(n.eventKey, n);
  store.identities.set(n.identityKey, n.eventKey);
  return {state:'NEW_ACCEPTED', ...n};
}

const base = {
  event_id:'sample-001', name:'Alex Example', email:' Alex.Example@Example.com ', phone:'+34 600 123 456',
  source:'website-form', service:'consultation', message:'I need help automating inbound enquiries.'
};
const exact = {...base};
const conflictEmail = {...base, email:'changed@example.com'};
const conflictMessage = {...base, message:'Changed material request.'};
const duplicateIdentity = {...base, event_id:'sample-002'};
const missingEvent = {...base, event_id:''};
const missingIdentity = {...base, event_id:'sample-003', email:'', phone:''};

const store = {events:new Map(), identities:new Map()};
assert(decide(base, store).state === 'NEW_ACCEPTED', 'base should be NEW_ACCEPTED');
assert(decide(exact, store).state === 'EXACT_REPLAY', 'exact replay should be EXACT_REPLAY');
assert(decide(conflictEmail, store).state === 'CONFLICTING_REPLAY', 'changed email should conflict');
assert(decide(conflictMessage, store).state === 'CONFLICTING_REPLAY', 'changed message should conflict');
assert(decide(duplicateIdentity, store).state === 'DUPLICATE_IDENTITY', 'same identity new event should duplicate');
assert(decide(missingEvent, store).state === 'INVALID', 'missing event should be invalid');
assert(decide(missingIdentity, store).state === 'INVALID', 'missing identity should be invalid');
for (const value of store.events.values()) assert(value.autonomous_send === false, 'autonomous_send must remain false');
console.log(JSON.stringify({pass:true, contract:'REPLAY_CONFLICT_V02_REFERENCE', states:['NEW_ACCEPTED','EXACT_REPLAY','CONFLICTING_REPLAY','DUPLICATE_IDENTITY','INVALID'], runtime:'NODE_REFERENCE_ONLY_NOT_N8N'}));

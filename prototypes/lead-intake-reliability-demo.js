'use strict';

/**
 * EXP-AUTO-001 synthetic reference implementation.
 * Read-only with respect to external systems: no network, email, CRM or messaging calls.
 * Demonstrates validation, idempotency, deduplication, non-destructive merge,
 * failure visibility and human-review routing using an in-memory store.
 */

function clean(value) {
  return String(value ?? '').trim().replace(/\s+/g, ' ');
}

function normalizeEmail(value) {
  return clean(value).toLowerCase();
}

function normalizePhone(value, defaultCountryCode = '') {
  const raw = clean(value);
  if (!raw) return '';
  const digits = raw.replace(/\D/g, '');
  if (raw.startsWith('+')) return '+' + digits;
  const cc = String(defaultCountryCode || '').replace(/\D/g, '');
  return cc ? '+' + cc + digits : digits;
}

function normalizeLead(raw = {}, options = {}) {
  return {
    event_id: clean(raw.event_id),
    source: clean(raw.source).toLowerCase(),
    name: clean(raw.name),
    email: normalizeEmail(raw.email),
    phone: normalizePhone(raw.phone, options.defaultCountryCode),
    service: clean(raw.service),
    message: clean(raw.message),
  };
}

function validateLead(lead) {
  const errors = [];
  if (!lead.event_id) errors.push('missing_event_id');
  if (!lead.source) errors.push('missing_source');
  if (!lead.name) errors.push('missing_name');
  if (!lead.email && !lead.phone) errors.push('missing_contact_method');
  if (lead.email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(lead.email)) errors.push('invalid_email');
  if (lead.phone && lead.phone.replace(/\D/g, '').length < 7) errors.push('invalid_phone');
  return errors;
}

function identityCandidates(lead) {
  const ids = [];
  if (lead.email) ids.push(`email:${lead.email}`);
  if (lead.phone) ids.push(`phone:${lead.phone}`);
  return ids;
}

function cloneStore(store) {
  return {
    records: structuredClone(store.records),
    identityIndex: structuredClone(store.identityIndex),
    processedEvents: new Set(store.processedEvents),
    audit: structuredClone(store.audit),
  };
}

function createStore() {
  return { records: {}, identityIndex: {}, processedEvents: new Set(), audit: [] };
}

function findExistingId(store, lead) {
  for (const identity of identityCandidates(lead)) {
    if (store.identityIndex[identity]) return store.identityIndex[identity];
  }
  return null;
}

function safeMerge(existing, lead) {
  const merged = { ...existing };
  const preserved = [];
  const filled = [];
  for (const field of ['name', 'email', 'phone', 'service', 'message', 'source']) {
    const incoming = lead[field];
    if (!incoming) continue;
    if (!merged[field]) {
      merged[field] = incoming;
      filled.push(field);
    } else if (merged[field] !== incoming) {
      preserved.push(field);
    }
  }
  return { merged, preserved, filled };
}

function failureResult(lead, stage, reason) {
  return {
    status: 'failed_safe',
    category: 'human_review',
    committed: false,
    failure_alert: {
      event_id: lead.event_id || null,
      stage,
      reason,
      action: 'manual_review_required',
    },
  };
}

function processLead(raw, store, options = {}) {
  const lead = normalizeLead(raw, options);
  const errors = validateLead(lead);
  if (errors.length) {
    return {
      status: 'validation_failed',
      category: 'human_review',
      committed: false,
      errors,
      failure_alert: { event_id: lead.event_id || null, stage: 'validation', reason: errors.join(','), action: 'manual_review_required' },
    };
  }

  if (store.processedEvents.has(lead.event_id)) {
    return { status: 'idempotent_skip', category: 'duplicate_event', committed: false, event_id: lead.event_id };
  }

  const draft = cloneStore(store);
  if (options.failStage === 'after_validation') return failureResult(lead, 'after_validation', 'synthetic_failure');

  let recordId = findExistingId(draft, lead);
  let operation;
  let mergeMeta = { preserved: [], filled: [] };

  if (recordId) {
    const result = safeMerge(draft.records[recordId], lead);
    draft.records[recordId] = result.merged;
    mergeMeta = { preserved: result.preserved, filled: result.filled };
    operation = 'updated_existing';
  } else {
    recordId = `lead_${String(Object.keys(draft.records).length + 1).padStart(4, '0')}`;
    draft.records[recordId] = { id: recordId, ...lead };
    operation = 'created';
  }

  for (const identity of identityCandidates(lead)) draft.identityIndex[identity] = recordId;
  if (options.failStage === 'before_commit') return failureResult(lead, 'before_commit', 'synthetic_failure');

  draft.processedEvents.add(lead.event_id);
  draft.audit.push({ event_id: lead.event_id, record_id: recordId, operation });

  store.records = draft.records;
  store.identityIndex = draft.identityIndex;
  store.processedEvents = draft.processedEvents;
  store.audit = draft.audit;

  return {
    status: 'processed',
    category: operation,
    committed: true,
    record_id: recordId,
    merge: mergeMeta,
    internal_notification: {
      type: 'new_or_updated_lead',
      record_id: recordId,
      source: lead.source,
      service: lead.service || 'not_provided',
    },
    acknowledgement_draft: `Gracias, ${lead.name}. Hemos recibido tu solicitud${lead.service ? ` sobre ${lead.service}` : ''}. Este mensaje es un borrador y no se ha enviado.`,
  };
}

function runFixture(fixture) {
  const store = createStore();
  const results = fixture.map((item) => processLead(item.lead, store, item.options || {}));
  return {
    results,
    final_record_count: Object.keys(store.records).length,
    processed_event_count: store.processedEvents.size,
    audit_count: store.audit.length,
    records: store.records,
    audit: store.audit,
  };
}

module.exports = {
  clean,
  normalizeEmail,
  normalizePhone,
  normalizeLead,
  validateLead,
  createStore,
  processLead,
  runFixture,
};

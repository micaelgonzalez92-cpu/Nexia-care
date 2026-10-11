'use strict';

const LABELS={date:'fecha',people:'número de personas',activities:'actividades',lodging:'alojamiento',name:'nombre',contact:'contacto'};

const CATEGORIES = [
  'despedida','amigos','familia','empresa','escolar','solo_actividad','pack_alojamiento','revision'
];

const REQUIRED = {
  despedida: ['name','contact','date','people','activities'],
  amigos: ['name','contact','date','people','activities'],
  familia: ['name','contact','date','people','activities'],
  empresa: ['name','contact','date','people','activities'],
  escolar: ['name','contact','date','people','activities'],
  solo_actividad: ['name','contact','date','people','activities'],
  pack_alojamiento: ['name','contact','date','people','activities','lodging'],
  revision: ['name','contact']
};

function clean(v){ return String(v ?? '').trim().replace(/\s+/g,' '); }
function contactOf(l){ return clean(l.email) || clean(l.phone); }
function normalizePhone(v){ const s=clean(v); if(!s) return ''; return s.startsWith('+') ? '+'+s.replace(/\D/g,'') : s.replace(/\D/g,''); }
function normalizeEmail(v){ return clean(v).toLowerCase(); }

function classify(raw={}){
  const text = [raw.group_type, raw.message, raw.activities, raw.lodging].map(clean).join(' ').toLowerCase();
  if ([raw.group_type, raw.message, raw.activities, raw.lodging].some(value => /\b(?:sin(?:\s+necesidad\s+de)?|no\s+(?:queremos|necesitamos))\s+(?:alojamiento|hotel|hostal|casa rural)(?:\s+|[,;:]\s*)\S/.test(clean(value).toLowerCase()))) return 'revision';
  const withoutLodgingText = text.replace(/\b(?:sin(?:\s+necesidad\s+de)?|no\s+(?:queremos|necesitamos))\s+(?:alojamiento|hotel|hostal|casa rural)\b/g, ' ');
  const withoutLodging = withoutLodgingText !== text;
  if (withoutLodging && /\b(?:alojamiento|hotel|hostal|casa rural)\b/.test(withoutLodgingText)) return 'revision';
  const rules = [
    ['despedida', /despedid/],
    ['empresa', /empresa|team\s?building|corporativ/],
    ['escolar', /escolar|colegio|instituto|alumn/],
    ['familia', /familia|niñ|hijos?/],
    ['pack_alojamiento', /alojamiento|hotel|hostal|casa rural|pack/],
    ['solo_actividad', /solo actividad|actividad suelta|sin alojamiento/],
    ['amigos', /amigos?|grupo/],
  ];
  for (const [cat, rx] of rules) if (rx.test(text)) return cat === 'pack_alojamiento' && withoutLodging ? 'solo_actividad' : cat;
  return 'revision';
}

function missingFields(raw, category){
  const view = {
    name: clean(raw.name),
    contact: contactOf(raw),
    date: clean(raw.date),
    people: clean(raw.people),
    activities: clean(raw.activities),
    lodging: clean(raw.lodging)
  };
  return (REQUIRED[category] || REQUIRED.revision).filter(k => !view[k]);
}

function identityKeys(raw){
  const keys=[];
  const e=normalizeEmail(raw.email); const p=normalizePhone(raw.phone);
  if(e) keys.push(`email:${e}`);
  if(p) keys.push(`phone:${p}`);
  return keys;
}

function createStore(){ return {records:{}, index:{}, events:new Set(), audit:[]}; }

function buildSummary(lead, category, missing){
  return [
    `Tipo: ${category}`,
    `Nombre: ${clean(lead.name) || 'N/D'}`,
    `Contacto: ${contactOf(lead) || 'N/D'}`,
    `Fecha: ${clean(lead.date) || 'N/D'}`,
    `Personas: ${clean(lead.people) || 'N/D'}`,
    `Actividades: ${clean(lead.activities) || 'N/D'}`,
    `Alojamiento: ${clean(lead.lodging) || 'N/D'}`,
    `Faltan: ${missing.length ? missing.map(x=>LABELS[x]||x).join(', ') : 'nada crítico'}`
  ].join('\n');
}

function draftReply(lead, category, missing){
  const name = clean(lead.name) || 'Hola';
  if(missing.length){
    return `${name}, gracias por contactar con Huescaventura. Para orientarte mejor sobre ${category}, antes necesitamos confirmar: ${missing.map(x=>LABELS[x]||x).join(', ')}. Este mensaje es un borrador para revisión humana y no se ha enviado.`;
  }
  return `${name}, gracias por contactar con Huescaventura. Tenemos la información básica para revisar tu solicitud de ${category}. Prepararemos la opción más adecuada y confirmaremos disponibilidad y condiciones antes de responderte. Este mensaje es un borrador para revisión humana y no se ha enviado.`;
}

function processLead(raw, store){
  const eventId=clean(raw.event_id);
  if(!eventId) return {status:'validation_failed',committed:false,errors:['missing_event_id']};
  if(store.events.has(eventId)) return {status:'idempotent_skip',committed:false,event_id:eventId};
  if(!clean(raw.name) || !contactOf(raw)) return {status:'validation_failed',committed:false,errors:['missing_name_or_contact']};

  const category = classify(raw);
  const missing = missingFields(raw, category);
  const keys = identityKeys(raw);
  let id = keys.map(k=>store.index[k]).find(Boolean) || null;
  let operation='created';
  if(!id){ id=`lead_${String(Object.keys(store.records).length+1).padStart(4,'0')}`; store.records[id]={id}; }
  else operation='updated_existing';

  const prior=store.records[id];
  const merged={...prior};
  for(const field of ['name','email','phone','date','people','activities','lodging','message','source']){
    const v=clean(raw[field]); if(v && !merged[field]) merged[field]=v;
  }
  merged.category=category;
  merged.classification_review_required = category === 'revision';
  merged.missing_fields=missing;
  merged.summary=buildSummary({...raw,...merged},category,missing);
  merged.reply_draft=draftReply({...raw,...merged},category,missing);
  merged.next_step = category === 'revision' ? 'manual_classification_review' : (missing.length ? 'request_missing_data' : 'human_review_quote_or_availability');
  merged.followup = {status:'pending_human_decision', autonomous_send:false};
  store.records[id]=merged;
  for(const k of keys) store.index[k]=id;
  store.events.add(eventId);
  store.audit.push({event_id:eventId,record_id:id,operation,category,missing_count:missing.length});
  return {status:'processed',committed:true,record_id:id,operation,category,classification_review_required:merged.classification_review_required,missing_fields:missing,summary:merged.summary,reply_draft:merged.reply_draft,next_step:merged.next_step,followup:merged.followup};
}

module.exports={LABELS,CATEGORIES,REQUIRED,classify,missingFields,createStore,processLead};

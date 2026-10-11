'use strict';
const assert=require('node:assert/strict');
const {classify,missingFields,createStore,processLead}=require('./huescaventura_logic');
const tests=[]; const test=(n,f)=>tests.push([n,f]);
function lead(o={}){return {event_id:'e1',source:'web',name:'Ana',email:'ana@example.com',phone:'+34600111222',date:'2026-11-15',people:'8',activities:'rafting',lodging:'',message:'grupo de amigos',...o};}

test('classifies despedida',()=>assert.equal(classify(lead({message:'despedida de soltero'})),'despedida'));
test('classifies empresa',()=>assert.equal(classify(lead({message:'evento empresa team building'})),'empresa'));
test('classifies escolar',()=>assert.equal(classify(lead({message:'grupo escolar instituto'})),'escolar'));
test('classifies familia',()=>assert.equal(classify(lead({message:'familia con niños'})),'familia'));
test('classifies alojamiento pack',()=>assert.equal(classify(lead({message:'queremos pack con alojamiento'})),'pack_alojamiento'));
test('unknown goes to human review',()=>assert.equal(classify(lead({message:'consulta especial',activities:''})),'revision'));
test('revision explicitly flags manual classification',()=>{const s=createStore();const r=processLead(lead({message:'consulta especial',activities:''}),s);assert.equal(r.classification_review_required,true);assert.equal(r.next_step,'manual_classification_review');});
test('pack alojamiento requires lodging',()=>assert.ok(missingFields(lead({message:'pack con alojamiento',lodging:''}),'pack_alojamiento').includes('lodging')));
test('valid lead produces draft only',()=>{const s=createStore();const r=processLead(lead(),s);assert.equal(r.committed,true);assert.match(r.reply_draft,/no se ha enviado/i);assert.equal(r.followup.autonomous_send,false);});
test('duplicate event skipped',()=>{const s=createStore();processLead(lead(),s);const r=processLead(lead(),s);assert.equal(r.status,'idempotent_skip');assert.equal(Object.keys(s.records).length,1);});
test('same email updates existing',()=>{const s=createStore();processLead(lead(),s);const r=processLead(lead({event_id:'e2',phone:'',message:'familia con niños'}),s);assert.equal(r.operation,'updated_existing');assert.equal(Object.keys(s.records).length,1);});
test('missing name/contact blocked',()=>{const s=createStore();const r=processLead(lead({name:'',email:'',phone:''}),s);assert.equal(r.status,'validation_failed');assert.equal(Object.keys(s.records).length,0);});
test('summary exposes missing fields in Spanish',()=>{const s=createStore();const r=processLead(lead({date:'',people:''}),s);assert.ok(r.missing_fields.includes('date'));assert.ok(r.missing_fields.includes('people'));assert.match(r.summary,/fecha/);assert.match(r.reply_draft,/número de personas/);});

const lodgingNegationCases = [
  ['No queremos hotel, sin desayuno','revision'],
  ['No queremos alojamiento: sin baño privado','revision'],
  ['Solo actividad sin alojamiento.','solo_actividad'],
  // A qualifier changes the scope of the negative; it does not establish no-lodging intent.
  ['No queremos hotel sin desayuno','revision'],
  ['No queremos alojamiento sin baño privado','revision'],
  ['solo actividad sin alojamiento','solo_actividad'],
  ['Sólo actividad SIN ALOJAMIENTO','solo_actividad'],
  ['Actividad suelta, sin alojamiento','solo_actividad'],
  ['Solo actividad; no queremos alojamiento','solo_actividad'],
  ['Solo actividad; no necesitamos alojamiento','solo_actividad'],
  ['Solo actividad, sin necesidad de alojamiento','solo_actividad'],
  ['Solo actividad sin hotel','solo_actividad'],
  ['Solo actividad sin hostal','solo_actividad'],
  ['Solo actividad sin casa rural','solo_actividad'],
  // Conflicting negative and positive lodging intent requires review; do not infer chronology.
  ['sin alojamiento al principio, ahora queremos pack con alojamiento','revision'],
  ['queremos pack con alojamiento','pack_alojamiento'],
  // Preserve existing group categories; resolving group versus lodging dimensions is out of scope.
  ['familia sin alojamiento','familia'],
  ['empresa con pack de alojamiento','empresa'],
  ['consulta especial','revision']
];

for(const [message,expected] of lodgingNegationCases){
  test('lodging intent: '+message,()=>{
    const r=processLead(lead({message,activities:'rafting'}),createStore());
    assert.equal(r.category,expected);
    assert.equal(r.classification_review_required,expected==='revision');
    if(expected==='solo_actividad')assert.equal(r.missing_fields.includes('lodging'),false);
    if(expected==='revision')assert.equal(r.next_step,'manual_classification_review');
    assert.equal(r.followup.autonomous_send,false);
    assert.match(r.reply_draft,/no se ha enviado/i);
  });
}

let pass=0; for(const [n,f] of tests){try{f();console.log('PASS',n);pass++;}catch(e){console.error('FAIL',n,e.stack||e)}}
console.log(`${pass}/${tests.length} tests passed`); process.exitCode=pass===tests.length?0:1;

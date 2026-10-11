'use strict';
const assert = require('node:assert/strict');
const {createRuntime} = require('./http_runtime');

function base(overrides={}) { return {event_id:'evt-1',source:'web form',name:'Ana Pérez',email:'ana@example.com',phone:'+34 600 123 456',service:'Presupuesto',message:'Info',...overrides}; }

(async()=>{
  const server = createRuntime({defaultCountryCode:'34'});
  await new Promise((resolve,reject)=>server.listen(0,'127.0.0.1',err=>err?reject(err):resolve()));
  const {port}=server.address(); const root=`http://127.0.0.1:${port}`;
  const results=[];
  async function test(name,fn){try{await fn();results.push([name,true]);console.log('PASS',name);}catch(e){results.push([name,false]);console.error('FAIL',name,e.stack||e);}}
  async function post(path,body,headers={}){return fetch(root+path,{method:'POST',headers:{'content-type':'application/json',...headers},body:typeof body==='string'?body:JSON.stringify(body)});}
  async function state(){return (await fetch(root+'/state')).json();}

  await test('valid POST creates lead', async()=>{const r=await post('/lead',base()); assert.equal(r.status,200); const j=await r.json(); assert.equal(j.category,'created'); assert.equal(j.committed,true);});
  await test('same event is idempotent over HTTP', async()=>{const r=await post('/lead',base()); const j=await r.json(); assert.equal(j.status,'idempotent_skip');});
  await test('same normalized email updates not duplicates', async()=>{const r=await post('/lead',base({event_id:'evt-2',email:' ANA@EXAMPLE.COM ',phone:'',name:'Ana P.'})); const j=await r.json(); assert.equal(j.category,'updated_existing'); const s=await state(); assert.equal(s.record_count,1);});
  await test('missing contact returns 422 and no commit', async()=>{const before=await state(); const r=await post('/lead',base({event_id:'evt-3',email:'',phone:''})); assert.equal(r.status,422); const j=await r.json(); assert.equal(j.committed,false); const after=await state(); assert.equal(after.audit_count,before.audit_count);});
  await test('malformed JSON returns 400', async()=>{const r=await post('/lead','{"bad"'); assert.equal(r.status,400); assert.equal((await r.json()).error,'invalid_json');});
  await test('injected pre-commit failure returns 503 with no partial write', async()=>{const before=await state(); const r=await post('/lead',base({event_id:'evt-4',email:'new@example.com',phone:'+34600999999'}),{'x-nexia-fail-stage':'before_commit'}); assert.equal(r.status,503); const j=await r.json(); assert.equal(j.committed,false); const after=await state(); assert.equal(after.record_count,before.record_count); assert.equal(after.processed_event_count,before.processed_event_count);});
  await test('local phone matches +34 only because country explicitly configured', async()=>{const r=await post('/lead',base({event_id:'evt-5',email:'other@example.com',phone:'600123456'})); const j=await r.json(); assert.equal(j.category,'updated_existing'); const s=await state(); assert.equal(s.record_count,1);});
  await test('GET state exposes audit evidence', async()=>{const s=await state(); assert.equal(s.record_count,1); assert.equal(s.processed_event_count,3); assert.equal(s.audit_count,3);});
  await test('unknown route is 404', async()=>{const r=await fetch(root+'/missing'); assert.equal(r.status,404);});
  await test('reset clears runtime state', async()=>{const r=await post('/reset',{}); assert.equal(r.status,200); const s=await state(); assert.equal(s.record_count,0); assert.equal(s.audit_count,0);});
  await test('after reset new event creates clean record', async()=>{const r=await post('/lead',base({event_id:'evt-reset'})); assert.equal((await r.json()).category,'created');});
  await test('acknowledgement remains draft only', async()=>{const r=await post('/lead',base({event_id:'evt-6',email:'six@example.com',phone:'+34600666666'})); const j=await r.json(); assert.match(j.acknowledgement_draft,/no se ha enviado/i);});

  server.close();
  const pass=results.filter(x=>x[1]).length;
  console.log(`${pass}/${results.length} HTTP integration tests passed`);
  process.exitCode=pass===results.length?0:1;
})().catch(e=>{console.error(e);process.exitCode=1;});

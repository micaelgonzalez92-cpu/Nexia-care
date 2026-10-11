'use strict';
const fs=require('node:fs');
const assert=require('node:assert/strict');
const flow=JSON.parse(fs.readFileSync(process.argv[2]||'node-red-exp-auto-001-flow.json','utf8'));
const byId=Object.fromEntries(flow.map(n=>[n.id,n]));
const checks=[]; const check=(name,fn)=>{try{fn();checks.push([name,true]);console.log('PASS',name);}catch(e){checks.push([name,false]);console.error('FAIL',name,e.message);}};
check('all node ids are unique',()=>assert.equal(Object.keys(byId).length,flow.length));
check('all wire targets exist',()=>{for(const n of flow) for(const group of (n.wires||[])) for(const id of group) assert.ok(byId[id],`${n.id}->${id}`);});
check('contains one tab and three HTTP endpoints',()=>{assert.equal(flow.filter(n=>n.type==='tab').length,1);assert.equal(flow.filter(n=>n.type==='http in').length,3);assert.equal(flow.filter(n=>n.type==='http response').length,3);});
function reachesResponse(id,seen=new Set()){if(seen.has(id))return false;seen.add(id);const n=byId[id];if(!n)return false;if(n.type==='http response')return true;return (n.wires||[]).flat().some(next=>reachesResponse(next,new Set(seen)));}
check('every HTTP In path reaches HTTP Response',()=>{for(const n of flow.filter(n=>n.type==='http in'))assert.ok(reachesResponse(n.id),n.id);});
check('no outbound network/message nodes',()=>{const banned=new Set(['http request','e-mail','websocket out','mqtt out','tcp out','udp out']);for(const n of flow)assert.ok(!banned.has(n.type),n.type);});
check('lead function uses local flow context and draft-only acknowledgement',()=>{const f=flow.find(n=>n.id==='fn-lead').func;assert.match(f,/flow\.get\('nexiaStore'\)/);assert.match(f,/flow\.set\('nexiaStore'/);assert.match(f,/no se ha enviado/);});
const pass=checks.filter(x=>x[1]).length;console.log(`${pass}/${checks.length} structural checks passed`);process.exitCode=pass===checks.length?0:1;

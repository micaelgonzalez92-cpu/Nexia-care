'use strict';
const http = require('node:http');
const { createStore, processLead } = require('./lead-intake-reliability-demo');

function json(res, status, body) {
  const data = JSON.stringify(body);
  res.writeHead(status, {'content-type':'application/json; charset=utf-8','content-length':Buffer.byteLength(data)});
  res.end(data);
}

function readBody(req, limit=100000) {
  return new Promise((resolve, reject) => {
    let body='';
    req.setEncoding('utf8');
    req.on('data', chunk => {
      body += chunk;
      if (body.length > limit) reject(Object.assign(new Error('payload_too_large'), {code:'PAYLOAD_TOO_LARGE'}));
    });
    req.on('end', () => resolve(body));
    req.on('error', reject);
  });
}

function createRuntime(options={}) {
  let store = createStore();
  const defaultCountryCode = options.defaultCountryCode || '';
  const server = http.createServer(async (req,res) => {
    try {
      if (req.method === 'POST' && req.url === '/lead') {
        let raw;
        try { raw = JSON.parse((await readBody(req)) || '{}'); }
        catch (err) {
          if (err.code === 'PAYLOAD_TOO_LARGE') return json(res,413,{status:'rejected',error:'payload_too_large'});
          return json(res,400,{status:'rejected',error:'invalid_json'});
        }
        const failStage = req.headers['x-nexia-fail-stage'] || undefined;
        const result = processLead(raw, store, {defaultCountryCode, failStage});
        const status = result.status === 'validation_failed' ? 422 : result.status === 'failed_safe' ? 503 : 200;
        return json(res,status,result);
      }
      if (req.method === 'GET' && req.url === '/state') {
        return json(res,200,{
          record_count:Object.keys(store.records).length,
          processed_event_count:store.processedEvents.size,
          audit_count:store.audit.length,
          records:store.records,
          audit:store.audit,
        });
      }
      if (req.method === 'POST' && req.url === '/reset') {
        store = createStore();
        return json(res,200,{status:'reset'});
      }
      return json(res,404,{status:'not_found'});
    } catch (err) {
      return json(res,500,{status:'failed_safe',error:'internal_error'});
    }
  });
  return server;
}

if (require.main === module) {
  const port = Number(process.env.PORT || 0);
  const server = createRuntime({defaultCountryCode: process.env.DEFAULT_COUNTRY_CODE || ''});
  server.listen(port, '127.0.0.1', () => {
    const a = server.address();
    console.log(JSON.stringify({status:'listening',host:a.address,port:a.port}));
  });
}
module.exports={createRuntime};

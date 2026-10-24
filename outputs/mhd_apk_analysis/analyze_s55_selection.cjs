const fs = require('node:fs');
const path = require('node:path');
const {createHash} = require('node:crypto');
const root = 'C:/Users/alper/Desktop/MHD';
const sourcePath = path.join(root, 'tools/decompiled-5.30/as.cs');
const source = fs.readFileSync(sourcePath, 'utf8');
const start = source.indexOf('public virtual yz[] a(');
const end = source.indexOf('\n\tpublic byte[] b(', start);
if (start < 0 || end < 0) throw new Error('Selector boundaries missing');
const selection = source.slice(start, end);
const baseKey = 623802178 + 7 + 5 + 39 + 66 + 86;
const decode = encoded => Array.from(encoded, (c, i) => {
  const code = c.charCodeAt(0);
  const high = ((code & 255) ^ (baseKey + 2 * i)) & 255;
  const low = ((code >>> 8) ^ (baseKey + 2 * i + 1)) & 255;
  return String.fromCharCode((high << 8) | low);
}).join('');
const markers = [...selection.matchAll(/LinearSportGauge\.c\(("(?:[^"\\]|\\.)*")/g)]
  .map(m => ({line: source.slice(0, start + m.index).split('\n').length,
    decoded: decode(JSON.parse(m[1]))}));
const corpus = path.join(root, 'BMW-XDFs-master/BMW-XDFs-master/F series N55 S55 N13');
const files = fs.readdirSync(corpus).filter(f => f.endsWith('.bin')).map(name => {
  const file = path.join(corpus, name);
  const fd = fs.openSync(file, 'r');
  const bytes = Buffer.alloc(8);
  const read = fs.readSync(fd, bytes, 0, 8, 131098);
  fs.closeSync(fd);
  const image=fs.readFileSync(file);
  const identities = [131109,2096527,2096385].map(offset => {
    const raw=image.subarray(offset,offset+7);
    if(raw.length!==7)throw new Error('Identity range outside image');
    return {offset,hex:raw.toString('hex').toUpperCase(),sgbm_number:raw.readUInt32BE(0),
      version:[raw[4],raw[5],raw[6]]};
  });
  return {name,sha256:createHash('sha256').update(image).digest('hex'),identities,byte_length:fs.statSync(file).size,marker_offset:131098,
    bytes_read:read,marker_hex:bytes.toString('hex'),marker_ascii:bytes.toString('ascii'),
    matches_literal:markers.some(m => m.decoded === bytes.toString('ascii'))};
});
const n = JSON.parse(fs.readFileSync(path.join(root, 'tools/rea-local/MHD_5_30_members.json'),'utf8')).normalized_result;
const selector = n.methods.find(m => m.declaring_type_token === '0x020000c9' && m.name === 'a' && m.signature.parameter_count === 8);
if (!selector) throw new Error('REA selector identity missing');
const predicates = ['an','am','al','ak'].map(name => {
  const m=n.methods.find(x=>x.declaring_type==='zz'&&x.name===name);
  return {name,token:m.token,signature:m.signature,body:m.body,
    calls:n.call_edges.filter(e=>e.caller_token===m.token),
    field_accesses:n.field_accesses.filter(e=>e.method_token===m.token)};
});
const result={assembly:n.artifact,identity:n.identity_scope,
  identity_methods:n.methods.filter(m =>
    (m.declaring_type_token==='0x020000c9'&&['w','x','v','t','y'].includes(m.name))||
    (m.declaring_type==='zz'&&m.name==='bp')||
    (m.declaring_type==='ECU_Tools.XWE'&&['FromBin','ToHex'].includes(m.name)))
    .map(m=>({token:m.token,type_token:m.declaring_type_token,type:m.declaring_type,name:m.name,
      signature:m.signature,body:m.body,
      field_accesses:n.field_accesses.filter(e=>e.method_token===m.token),
      calls:n.call_edges.filter(e=>e.caller_token===m.token)})),
  source:{path:sourcePath,sha256:createHash('sha256').update(fs.readFileSync(sourcePath)).digest('hex')},
  selector:{token:selector.token,type_token:selector.declaring_type_token,signature:selector.signature,body:selector.body},
  decoded_literals:markers,files,predicates,
  limitations:['String decoding is a reconstruction of the decoder seen in ILSpy; MHD was not executed.',
    'Directory labels and marker matches do not prove compatibility with the actual vehicle.',
    'Static instruction and call evidence does not establish programming order or branch reachability.']};
fs.writeFileSync(path.join(__dirname,'REA_S55_SELECTION.json'),JSON.stringify(result,null,2));
console.log(JSON.stringify({selector_token:selector.token,markers,files},null,2));

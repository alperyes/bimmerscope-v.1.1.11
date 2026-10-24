const fs = require('node:fs');
const path = require('node:path');
const base = 'C:/Users/alper/Desktop/MHD/tools/rea-local';
const envelope = JSON.parse(fs.readFileSync(path.join(base, 'MHD_5_30_members.json'), 'utf8'));
const data = envelope.normalized_result;
const methods = new Map(data.methods.map(m => [m.token, m]));
const describe = m => ({ token: m.token, type_token: m.declaring_type_token,
  type: m.declaring_type, name: m.name, signature: m.signature,
  body: { status: m.body.status, file_offset: m.body.file_offset,
    il_size: m.body.il_size, il_sha256: m.body.il_sha256,
    instruction_count: m.body.instruction_count,
    decoded_instruction_count: m.body.decoded_instruction_count } });
const selected = data.methods.filter(m =>
  (m.declaring_type === 'zz' && ['bl', 'bj', 'bi'].includes(m.name)) ||
  m.token === '0x060008af' ||
  m.token === '0x060009ac' ||
  (m.declaring_type === 'zz' && m.name === 'b' &&
    JSON.stringify(m.signature.parameter_types) === '["string","bool"]') ||
  (['0x020000f5','0x020000fa','0x02000105'].includes(m.declaring_type_token) && m.name === 'MoveNext'));
const count = (items, get) => items.reduce((out, item) => {
  const key = get(item); out[key] = (out[key] || 0) + 1; return out;
}, {});
const result = {
  provider: envelope.provider, subject: envelope.subject,
  local_override: { representation_budget_bytes: 2147483648,
    upstream_budget_bytes: 67108864, package: 'rea-agents@6.4.0' },
  coverage: data.coverage,
  counts: { types: data.types.length, methods: data.methods.length,
    call_edges: data.call_edges.length,
    bodies: count(data.methods, m => m.body.status),
    method_signatures: count(data.methods, m => m.signature.parse_status) },
  selected: selected.map(m => ({ ...describe(m),
    callers: [...new Set(data.call_edges.filter(e => e.target_token === m.token).map(e => e.caller_token))]
      .map(t => methods.has(t) ? describe(methods.get(t)) : {token:t}),
    calls: [...new Set(data.call_edges.filter(e => e.caller_token === m.token).map(e => e.target_token))]
      .map(t => ({ ...(methods.has(t) ? describe(methods.get(t)) : { token:t,
        name: data.member_refs.find(r => r.token === t)?.name ?? null }),
        call_sites: m.body.anchors.filter(a => a.operand_kind === 'method' && a.operand === t)
          .map(a => ({ il_offset:a.il_offset, opcode:a.opcode })) }))
  })),
  limitations: data.limitations.concat([
    'Calls are static references; they do not establish execution order or branch reachability.',
    'Nested type names can be ambiguous; preserve declaring type tokens with method tokens.',
    'Local budget override is an analyzer modification, not an upstream REA release.'
  ])
};
fs.writeFileSync(path.join(__dirname, 'REA_5_30_focus.json'), JSON.stringify(result, null, 2));
console.log(JSON.stringify({counts:result.counts, selected:result.selected.map(m=>({
  token:m.token,type_token:m.type_token,type:m.type,name:m.name,
  callers:m.callers.map(c=>c.token), internal_call_count:m.calls.filter(c=>c.type==='zz').length
}))},null,2));

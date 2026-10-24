const fs=require('node:fs');
const crypto=require('node:crypto');
const sourcePath='C:/Users/alper/Desktop/MHD/tools/decompiled-5.30/z5.cs';
const source=fs.readFileSync(sourcePath,'utf8');
const records=[];
for(const signature of ['public List<XWE> b(XWE A_0)','public List<XWE> b(XWE A_0, int A_1)']){
  const start=source.indexOf(signature);
  if(start<0)throw new Error('Missing method '+signature);
  const remainder=source.slice(start+signature.length);
  const next=remainder.search(/\n\t(?:public|private|protected|internal) /);
  const end=next<0?source.length:start+signature.length+next;
  const section=source.slice(start,end);
  const key=623802178+Number(section.match(/int a_ = (\d+);/)[1])+5+39+66+86;
  const literals=[...section.matchAll(/LinearSportGauge\.c\(("(?:[^"\\]|\\.)*")/g)].map(m=>{
    const encoded=JSON.parse(m[1]);
    let decoded='';
    for(let i=0;i<encoded.length;i++){
      const code=encoded.charCodeAt(i);
      decoded+=String.fromCharCode((((code&255)^(key+2*i))&255)<<8|(((code>>>8)^(key+2*i+1))&255));
    }
    return {line:source.slice(0,start+m.index).split('\n').length,decoded};
  });
  records.push({signature,literals});
}
const evidence=JSON.parse(fs.readFileSync('C:/Users/alper/Desktop/MHD/tools/rea-local/MHD_5_30_members.json','utf8'));
const methods=evidence.normalized_result.methods.filter(m=>['0x0600058f','0x06000590'].includes(m.token));
const result={evidence_id:evidence.evidence_id,assembly:evidence.subject,source:{path:sourcePath,sha256:crypto.createHash('sha256').update(source).digest('hex')},records,methods:methods.map(m=>({token:m.token,signature:m.signature,body_sha256:m.body.il_sha256,instruction_count:m.body.instruction_count})),limitations:['Static decoder reconstruction only; no MHD execution or database query.','Catalog contents and target-car identifiers have not been established.']};
fs.writeFileSync(__dirname+'/REA_CATALOG_SELECTION.json',JSON.stringify(result,null,2));
console.log(JSON.stringify({records,methods:result.methods},null,2));

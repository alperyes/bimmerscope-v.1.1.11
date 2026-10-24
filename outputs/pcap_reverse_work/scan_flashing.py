import collections, hashlib, json, pathlib, subprocess
root=pathlib.Path('C:/Users/alper/Desktop/pcap')
rows=[]
for p in sorted(root.rglob('*')):
    if p.suffix.lower() not in ('.pcap','.pcapng'): continue
    result=subprocess.run(['C:/Program Files/Wireshark/tshark.exe','-2','-r',str(p),'-Y','hsfz.ctrlword == 1 && hsfz.sourceaddr == 0xf4 && uds.reply == 0','-T','fields','-e','frame.number','-e','uds.sid'],capture_output=True,text=True,check=True)
    counts=collections.Counter()
    frames=[]
    for line in result.stdout.splitlines():
        frame,_,sids=line.partition('\t')
        for sid in sids.split(','):
            if sid:
                value=int(sid,16);counts[f'{value:02X}']+=1
                if value in (0x27,0x34,0x35,0x36,0x37):frames.append([int(frame),sid])
    rows.append({'file':str(p.relative_to(root)),'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'requests':sum(counts.values()),'services':dict(counts),'programming_frames':frames})
out=pathlib.Path(__file__).with_name('flashing_scan.json')
out.write_text(json.dumps(rows,indent=2),encoding='utf-8')
print(json.dumps({'captures':len(rows),'requests':sum(r['requests'] for r in rows),'programming':[(r['file'],r['programming_frames']) for r in rows if r['programming_frames']]}))

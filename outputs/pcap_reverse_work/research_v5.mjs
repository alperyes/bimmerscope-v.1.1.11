import fs from 'node:fs/promises';
import {FileBlob,SpreadsheetFile} from '@oai/artifact-tool';
const desktop='C:/Users/alper/Desktop';
const dir=new URL('.',import.meta.url).pathname.replace(/^\/(\w:)/,'$1');
const wb=await SpreadsheetFile.importXlsx(await FileBlob.load(`${desktop}/PCAP_Reverse_v2.xlsx`));
const prior=await SpreadsheetFile.importXlsx(await FileBlob.load(`${desktop}/PCAP_Reverse_v4_S55_N20_evidence.xlsx`));
if(process.argv.includes('--verify')){
 const saved=await SpreadsheetFile.importXlsx(await FileBlob.load(`${desktop}/PCAP_Reverse_v5_flashing_research.xlsx`));
 for(const [sheet,range,name] of [['Evidence ledger','G47:J50','evidence_added'],['UDS reference','A15:F20','uds_added'],['B1V crosswalk','A15:E15','b1v_added'],['Research sources','A11:E13','sources_added'],['Flashing research','A16:E22','flash_later']]){
  const im=await saved.render({sheetName:sheet,range,scale:1,format:'png'});
  await fs.writeFile(`${dir}/${name}.png`,new Uint8Array(await im.arrayBuffer()));
 }
 console.log('Saved workbook reimport and render checks complete');
 process.exit(0);
}
if(process.argv.includes('--inspect')){
  console.log((await wb.inspect({kind:'workbook,sheet,table',maxChars:1800})).ndjson);
  const image=await prior.render({sheetName:'Research sources',range:'A1:C7',scale:1,format:'png'});
  await fs.writeFile(`${dir}/research_before.png`,new Uint8Array(await image.arrayBuffer()));
  process.exit(0);
}
const col=n=>String.fromCharCode(64+n);
const widths={
 'Evidence ledger':[12,15,17,28,45,34,21,64,85,70],
 'UDS reference':[18,34,18,82,56,86],
 'B1V crosswalk':[48,35,78,66,78],
 'Source inventory':[85,12,18,16,68],
 'BIN comparison':[40,35,55,96],
 'ECU comparison':[36,48,48,100],
 'Research sources':[34,26,90,105,75],
};
function styleSheet(sh,rows,ws){
 const end=col(ws.length);
 sh.showGridLines=false;sh.tabColor='#235B82';
 sh.getRange(`A1:${end}${rows}`).format.font={name:'Aptos',size:10,color:'#172431'};
 sh.getRange(`A1:${end}${rows}`).format.wrapText=true;
 sh.getRange(`A1:${end}${rows}`).format.verticalAlignment='top';
 sh.mergeCells(`A1:${end}1`);sh.mergeCells(`A2:${end}2`);
 sh.getRange(`A1:${end}1`).format={fill:'#172431',font:{name:'Aptos',size:16,bold:true,color:'#FFFFFF'}};
 sh.getRange(`A1:${end}1`).format.rowHeight=35;
 sh.getRange(`A2:${end}2`).format.fill='#EDF4F8';sh.getRange(`A2:${end}2`).format.rowHeight=36;
 sh.getRange(`A4:${end}4`).format={fill:'#235B82',font:{name:'Aptos',size:10,bold:true,color:'#FFFFFF'},wrapText:true};
 sh.getRange(`A4:${end}4`).format.rowHeight=35;
 sh.getRange(`A5:${end}${rows}`).format.rowHeight=56;
 ws.forEach((w,i)=>sh.getRange(`${col(i+1)}:${col(i+1)}`).format.columnWidth=w);
 sh.freezePanes.freezeRows(4);
}
for(const [name,ws] of Object.entries(widths)){
 const source=prior.worksheets.getItem(name),values=source.getUsedRange().values;
 const sh=wb.worksheets.add(name);
 sh.getRangeByIndexes(0,0,values.length,ws.length).values=values;
 styleSheet(sh,values.length,ws);
}
function append(name,rows,height=65){
 const sh=wb.worksheets.getItem(name),start=sh.getUsedRange().values.length;
 const range=sh.getRangeByIndexes(start,0,rows.length,rows[0].length);
 range.values=rows;range.format.font={name:'Aptos',size:10,color:'#172431'};
 range.format.wrapText=true;range.format.verticalAlignment='top';range.format.rowHeight=height;
}
const scan=JSON.parse(await fs.readFile(`${dir}/flashing_scan.json`,'utf8'));
const source=wb.worksheets.getItem('Source inventory');
source.getRange('F4:K4').values=[['Decoded tester requests','27 SecurityAccess','34 RequestDownload','35 RequestUpload','36 TransferData','37 TransferExit']];
source.getRange('F4:K4').format={fill:'#235B82',font:{name:'Aptos',size:10,bold:true,color:'#FFFFFF'},wrapText:true};
source.getRange('F:K').format.columnWidth=20;
let matched=0;
for(let i=4;i<source.getUsedRange().values.length;i++){
 const name=String(source.getCell(i,0).values[0][0]);
 const hit=scan.find(x=>name.replaceAll('\\','/').endsWith(x.file.replaceAll('\\','/')));
 if(hit){
   source.getRangeByIndexes(i,5,1,6).values=[[hit.requests,...['27','34','35','36','37'].map(s=>hit.services[s]??0)]];
   matched++;
 }
}
if(matched!==scan.length)throw new Error(`Capture inventory coverage ${matched}/${scan.length}`);
source.getRange('A2').values=[['SHA-256 identifies each file. New counts use two-pass Wireshark dissection: HSFZ type 1, tester F4, UDS request. Zero means no decoded request in these files; encrypted or undecoded traffic is outside this audit.']];
source.getRange('A2:E2').format.rowHeight=48;
const ledgerRows=[
 ['N20-21','Identity','User observation','F18C serial matches label','22 F1 8C','62 F1 8C 30 31 37 30 36 37 35 36 38 34','11 Oct 2026 phone screenshot and DME label','User-supplied screenshots; N20 classification in current pcap sheet','ASCII 0170675684 matches printed 170675684 with a leading zero. Keep as text.','The screenshots do not show VIN or F150. N20 attribution follows the user workbook, not an independent session capture.'],
 ['S55-23','Programming','Source-defined candidate','Flash timing parameters','22 25 04','Response not observed','s55.b1v:157895 FLASH_TP_LESEN','Local S55 diagnostic description','Five two-byte timing fields: erase, check, bootloader installation, authentication, reset.','Units, live support and values have not been verified on captured 6MC9ED0B.'],
 ['N20-22','Programming','Source-defined candidate','Flash timing parameters','22 25 04','Response not observed','mevd1724.b1v:104282 FLASH_TP_LESEN','Local N20 diagnostic description','Same five timing fields as S55. This is a read-data job, not a flashing command.','Units, live support and values have not been verified on captured 9VT9G40B.'],
 ['ALL-01','Programming','Offline capture audit','No decoded programming transfer','Filter: HSFZ type 1, source F4, UDS request','27/34/35/36/37: all zero','26 files; 1,840 decoded tester service occurrences','Source inventory columns F:K; tshark two-pass decode','The available captures show no decoded SecurityAccess or download/upload transaction.','Scope is these files and Wireshark-recognized UDS. This does not establish ECU unlock state.'],
];
// IDs continue each engine ledger without replacing any earlier evidence.
const existingIds=new Set(wb.worksheets.getItem('Evidence ledger').getUsedRange().values.slice(4).map(r=>r[0]));
for(const row of ledgerRows){if(existingIds.has(row[0]))row[0]+='-NEW';}
append('Evidence ledger',ledgerRows,110);
const cross=wb.worksheets.getItem('B1V crosswalk');
const crossValues=cross.getUsedRange().values;
const serialRow=crossValues.findIndex(r=>r[0]==='SERIENNUMMER_LESEN');
cross.getCell(serialRow,3).values=[['N20 user screenshot: 62 F1 8C + ASCII 0170675684; physical label 170675684.']];
cross.getCell(serialRow,4).values=[['S55 live serial remains unread. N20 classification follows the current user workbook; screenshot lacks VIN.']];
append('B1V crosswalk',[
 ['FLASH_TP_LESEN (S55 and N20)','22 25 04','Five two-byte flash timing fields.','S55 line 157895; N20 line 104282.','Source-defined only; no captured response or verified timing unit.'],
]);
append('ECU comparison',[
 ['F18C serial','Not observed','ASCII 0170675684','User screenshot and case label agree. Preserve leading zero; N20 attribution follows latest pcap sheet.'],
 ['2504 flash timings','Defined in S55 B1V','Defined in N20 B1V','Both descriptions expose FLASH_TP_LESEN; response and units remain unverified.'],
 ['Programming capture','No decoded 27/34/35/36/37','No decoded 27/34/35/36/37','26-file audit in Source inventory. No ECU-specific flashing sequence can be reconstructed from these files.'],
]);
wb.worksheets.getItem('ECU comparison').getRange('C18').setNumberFormat('@');
append('UDS reference',[
 ['0x10 (hex)','DiagnosticSessionControl','0x50 (hex)','10 02 requests programming session; 10 03 requests extended session. Positive response carries session timing.','ISO 14229-1:2013 section 9.2; udsoncan services','Existing 10 03 success is not proof that 10 02 or programming is allowed.'],
 ['0x27 (hex)','SecurityAccess','0x67 (hex)','Seed/key exchange unlocks a diagnostic security level using an ECU-specific algorithm.','ISO 14229-1:2013 section 9.4; udsoncan client','No decoded 27 request in current capture audit. A security level is not proof of a persistent tuning patch.'],
 ['0x34 (hex)','RequestDownload','0x74 (hex)','Request: SID, DFI, ALFID, address, size. Reply reports maxNumberOfBlockLength.','ISO 14229-1:2013 section 14.2, PDF pp.279–282','No decoded request in current captures. Address, erase layout, compression and encryption remain ECU-specific.'],
 ['0x35 (hex)','RequestUpload','0x75 (hex)','Sets up a transfer from ECU to tester; later 36 messages return bytes.','ISO 14229-1:2013 section 14.3','No decoded request. Existing 23 memory reads are a different service.'],
 ['0x36 (hex)','TransferData','0x76 (hex)','Counter starts at 01; increments and wraps FF to 00. Reply echoes the counter.','ISO 14229-1:2013 section 14.4, PDF pp.288–291','No decoded request. Payload limit must be derived from 74, not from the 23 read block size.'],
 ['0x37 (hex)','RequestTransferExit','0x77 (hex)','Closes active transfer; optional parameters are manufacturer-defined.','ISO 14229-1:2013 section 14.5; udsoncan RequestTransferExit','No decoded request. A 77 reply alone does not establish successful boot or valid image.'],
]);
const flashRows=[
 ['Evidence available','F150 / F101 / F18C','Identify diagnostic variant, software inventory and ECU serial independently.','S55: F150 0F1EA0; N20: 0F1810. Serial screenshot: 0170675684.','Evidence ledger; ECU comparison. None of these identifiers proves programming access.'],
 ['What a flash does','Erase / write / validate / restart','A programming client prepares the ECU, transfers selected software or calibration blocks, validates them, and checks the ECU after restart.','No complete write sequence appears in the available S55 or N20 captures.','ISO sections 9, 13, 14; conceptual sequence. Exact BMW order and routines remain unknown.'],
 ['Session selection','10 02 → 50 02; 10 03 → 50 03','Programming and extended sessions are distinct. Session support and returned timing govern subsequent requests.','Captured extended-session success does not prove programming-session support on either DME.','ISO 9.2; udsoncan services. Need actual programming-session exchange from matching software.'],
 ['Access authorization','27 <level> → 67 <level> ...','UDS defines seed/key messages. The accepted level and algorithm belong to the ECU implementation.','No decoded 27 exchange in the 26-file audit. Persistent OBD tuning unlock remains unverified.','udsoncan client security_algo; MHD FAQ Unlock Check. No seed/key algorithm inferred.'],
 ['Erase and integrity routines','31 <subfunction> <routine ID> ...','RoutineControl is the envelope for implementation-specific operations. Names or example IDs do not establish a supported erase/check procedure.','The observed routine 0205 reports software metadata. It is not evidence of flash erase or validation.','ISO section 13; existing 0205 captures. Need routine IDs, inputs, completion status and dependencies.'],
 ['Start a download','34 <DFI> <ALFID> <address> <size>','DFI 00 means no compression/encryption. ALFID high nibble is size-byte count; low nibble is address-byte count.','S55 and N20 download address/size layouts are unobserved. Do not copy 23 read addresses into 34.','ISO 14.2, PDF pp.279–281; udsoncan RequestDownload source.'],
 ['Negotiate block length','74 <LFID> <maximum length>','The reported maximum covers the complete TransferData UDS request, including SID and counter.','Neither DME has a captured 74 reply. The observed 0FFC read size is not a negotiated flash block length.','ISO 14.2.3, PDF p.281. For plain 36 + counter + data, available data bytes = maximum minus 2.'],
 ['Transfer blocks','36 <counter> <data> → 76 <counter>','Start counter at 01, increment per new block, wrap FF to 00. Match each acknowledgment to the request.','No 36/76 transaction is decoded in either family capture set.','ISO 14.4, PDF pp.288–290; udsoncan TransferData. Transfer direction comes from 34 versus 35.'],
 ['Lost acknowledgment','Repeat same block and counter','The standard handles an immediately repeated previous block without programming it twice. Retry policy still needs bounded timeouts and ECU validation.','No S55/N20 retry or recovery trace is available.','ISO 14.4.2 and 14.4.4, PDF pp.289–291. Never advance a block solely because a timeout expired.'],
 ['Finish the transfer','37 [optional parameters] → 77 ...','TransferExit closes the transfer. Additional checksum/signature checks and dependency routines depend on the ECU.','No 37/77 or programming verification sequence is captured.','ISO 14.5; udsoncan RequestTransferExit. Positive transfer completion does not prove the ECU will boot.'],
 ['Pending versus failure','7F <SID> 78; NRC 72/73','78 means processing continues. 72 signals programming failure; 73 signals a block-counter problem.','Current captures contain pending replies for other operations, not a demonstrated programming recovery.','ISO 7.5 and 14.4.4. udsoncan client documents separate P2/P2* timing.'],
 ['Reset and post-check','11 <reset> → 51 <reset>; read identity again','After the defined final checks, restart and verify VIN, expected software inventory, communication and faults.','Observed reset requests target broadcast DF on both families. Those traces do not prove a DME-only programming reset.','Existing reset evidence; exact programming reset mode and reconnection timing remain unverified.'],
 ['Flash timing candidate','22 25 04 → 62 25 04 ...','Both B1Vs describe five two-byte timing fields: erase, check, bootloader installation, authentication and reset.','S55 B1V line 157895; N20 B1V line 104282. No response is established.','FLASH_TP_LESEN source comments; units and live implementation remain to be checked.'],
 ['Image scope and backup','Full software / calibration / reference image','The contents transferred depend on the flash operation. A file called stock or backup does not establish that every byte was read from the ECU.','S55 BM3 read matches a 523,264-byte BIN window in the prior analysis. MHD captures show short probes on both engines.','Evidence ledger and BIN comparison; MHD FAQ says OEM restore does not require a stock backup.'],
 ['Vendor platform coverage','MHD S55; bootmod3 S55 and N20','Published product support establishes vendor capability, not BimmerScope compatibility with a particular DME.','MHD lists F82 S55 2014 onward. bootmod3 lists both N20/N26 and S55 in its guide.','MHD S55 product page; bootmod3 Get Started. Current software and unlock requirement must be checked separately.'],
 ['Supply and connection','Ignition on, engine off; sustained power','The vendor workflow requires maintaining the connection during flashing and recommends a charger. Required supply specification depends on the actual procedure.','No programming voltage profile has been measured on the target F82 or N20 bench.','bootmod3 Get Started. A single battery-voltage read does not demonstrate stable programming power.'],
 ['BimmerScope implementation gap','One-off console versus programming client','The manual console creates a new socket per send and restores polling afterward. A flash needs a controlled multi-message session and verified recovery behavior.','Current console can inspect individual replies. No authorized programming workflow is established for either ECU.','rust/src/api/vehicle.rs send_manual_diagnostic_message; need target-specific procedure, images, checks and recovery validation.'],
 ['Next evidence to obtain','Matched programming capture and image manifest','Record tool/version, VIN, F150/F101, security/session exchange, erase routines, 34 addresses/sizes, 74 limit, 36 counters, 37 result and post-reset identity.','Collect S55 and N20 evidence separately. Include recovery behavior and exact software versions.','Research gap from the capture audit. Do not infer executable flashing instructions from this conceptual outline.'],
];
const flash=wb.worksheets.add('Flashing research');
flash.getRange('A1').values=[['How ECU flashing works']];
flash.getRange('A2').values=[['11 October 2026. Protocol and source research; available captures do not contain a decoded programming transfer.']];
flash.getRange('A4:E4').values=[['Topic','Message shape','Meaning','S55 / N20 evidence','Source and remaining unknown']];
flash.getRange(`A5:E${flashRows.length+4}`).values=flashRows;
styleSheet(flash,flashRows.length+4,[30,44,70,64,64]);
flash.getRange(`A5:E${flashRows.length+4}`).format.rowHeight=65;
append('Research sources',[
 ['udsoncan RequestDownload','Primary implementation','DFI/ALFID/address/size request and maximum block length response.','https://udsoncan.readthedocs.io/en/latest/_modules/udsoncan/services/RequestDownload.html','Generic UDS implementation. Its docstring loosely says number of blocks; ISO defines complete message length in bytes. Checked 11 Oct 2026.'],
 ['udsoncan TransferData','Primary implementation','Sequence counter and acknowledgment parsing.','https://udsoncan.readthedocs.io/en/latest/_modules/udsoncan/services/TransferData.html','Generic protocol code, not a BMW flashing procedure. Checked 11 Oct 2026.'],
 ['udsoncan RequestTransferExit','Primary implementation','Optional transfer exit parameters and response parsing.','https://udsoncan.readthedocs.io/en/latest/_modules/udsoncan/services/RequestTransferExit.html','Does not define target signature verification. Checked 11 Oct 2026.'],
 ['udsoncan client','Project documentation','Security algorithm hook, response matching and P2/P2* timeouts.','https://udsoncan.readthedocs.io/en/latest/udsoncan/client.html','No BMW seed/key implementation supplied by these docs. Checked 11 Oct 2026.'],
 ['MHD S55 product','Vendor primary source','F82 support and published unlock qualifications.','https://mhdtuning.com/products/mhd-flasher-license-for-s55','Does not prove this F82 is currently unlocked. Checked 11 Oct 2026.'],
 ['bootmod3 Get Started','Vendor primary source','N20/N26 and S55 platform listing, ENET connection and guided flash workflow.','https://www.bootmod3.com/get-started','Does not publish the low-level flashing algorithm. Checked 11 Oct 2026.'],
 ['ISO 14229-1:2013 programming','User-provided primary document','Sections 14.2–14.5; PDF pp.279–299. Block length, sequence, retry and transfer exit.','ISO_14229-1_2013.en.PDF.pdf','Standard service rules do not establish target addresses, routines, access level or image checks.'],
 ['S55 and N20 timing jobs','Local diagnostic descriptions','FLASH_TP_LESEN at S55 line 157895 and N20 line 104282.','b1v/s55.b1v; b1v/mevd1724.b1v','Definitions differ in target software from captures; timing unit and live response unverified.'],
 ['User F18C evidence','Phone screenshot and physical label','Response ASCII 0170675684 matches label 170675684.','User attachments, 11 October 2026','Screenshot lacks VIN. N20 classification follows the current user workbook.'],
 ['26-file programming audit','Local packet analysis','Two-pass tshark, HSFZ type 1, source F4, UDS reply flag 0; 1,840 decoded service occurrences.','Source inventory columns F:K; capture SHA-256 per row','No decoded 27/34/35/36/37. Dissector and file scope only; no blanket claim about all traffic or ECU access.'],
],100);
wb.recalculate();
console.log((await wb.inspect({kind:'table',range:"'Flashing research'!A5:E7",include:'values,formulas',tableMaxRows:3,tableMaxCols:5,maxChars:1800})).ndjson);
console.log((await wb.inspect({kind:'match',searchTerm:'#REF!|#DIV/0!|#VALUE!|#NAME\\?|#NUM!',options:{useRegex:true,maxResults:20},maxChars:1000})).ndjson);
for(const [sheet,range,name] of [['Flashing research','A1:E10','flash_preview'],['ECU comparison','A18:D20','serial_preview'],['Source inventory','F4:K9','audit_preview']]){
 const image=await wb.render({sheetName:sheet,range,scale:1,format:'png'});
 await fs.writeFile(`${dir}/${name}.png`,new Uint8Array(await image.arrayBuffer()));
}
const output=`${desktop}/PCAP_Reverse_v5_flashing_research.xlsx`;
await (await SpreadsheetFile.exportXlsx(wb)).save(output);
console.log(JSON.stringify({output,flashRows:flashRows.length,captureFiles:matched,newEvidence:ledgerRows.length}));

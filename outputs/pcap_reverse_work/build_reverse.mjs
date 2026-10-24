import fs from 'node:fs/promises';
import path from 'node:path';
import crypto from 'node:crypto';
import { execFileSync } from 'node:child_process';
import { FileBlob, SpreadsheetFile } from '@oai/artifact-tool';

const desktop = 'C:\\Users\\alper\\Desktop';
const original = path.join(desktop, 'PCAP_Reverse_v2.xlsx');
const output = path.join(desktop, 'PCAP_Reverse_v4_S55_N20_evidence.xlsx');
const sourceRoot = path.join(desktop, 'pcap');
const note = path.join(desktop, 'b1v', 'F82-S55-capture-BIN-b1v-analysis.md');
const tshark = 'C:\\Program Files\\Wireshark\\tshark.exe';

const wb = await SpreadsheetFile.importXlsx(await FileBlob.load(original));
const dark = '#172431', blue = '#235B82', light = '#EDF4F8', white = '#FFFFFF';

function col(n) { let s=''; while(n){n--;s=String.fromCharCode(65+n%26)+s;n=Math.floor(n/26)} return s; }
function addSheet(name, title, subtitle, headers, rows, widths) {
  const sh=wb.worksheets.add(name);
  sh.showGridLines=false;
  sh.tabColor=blue;
  const last=col(headers.length);
  sh.mergeCells(`A1:${last}1`);
  sh.getRange('A1').values=[[title]];
  sh.getRange(`A1:${last}1`).format={fill:dark,font:{name:'Aptos Display',size:17,bold:true,color:white}};
  sh.getRange(`A1:${last}1`).format.rowHeight=35;
  sh.mergeCells(`A2:${last}2`);
  sh.getRange('A2').values=[[subtitle]];
  sh.getRange(`A2:${last}2`).format={fill:light,font:{name:'Aptos',size:10,color:dark}};
  sh.getRange(`A2:${last}2`).format.rowHeight=30;
  sh.getRange(`A4:${last}4`).values=[headers];
  sh.getRange(`A4:${last}4`).format={fill:blue,font:{name:'Aptos',size:10,bold:true,color:white},wrapText:true};
  sh.getRange(`A4:${last}4`).format.rowHeight=30;
  if(rows.length) {
    sh.getRange(`A5:${last}${rows.length+4}`).values=rows;
    sh.getRange(`A5:${last}${rows.length+4}`).format.font={name:'Aptos',size:10,color:dark};
    sh.getRange(`A5:${last}${rows.length+4}`).format.wrapText=true;
    sh.getRange(`A5:${last}${rows.length+4}`).format.rowHeight=56;
  }
  widths.forEach((w,i)=>{sh.getRange(`${col(i+1)}:${col(i+1)}`).format.columnWidth=w;});
  sh.freezePanes.freezeRows(4);
  return sh;
}

const f82Mhd='MHD F82\\261003_MHD_binRead_F82\\261003_MHD_binRead_F82.pcap';
const f82Bm3='BM3 F82\\260911_BM3_ScanDeleteDMERead_S55.pcapng';
const f82Flap='BM3 F82\\260913_BM3_Flap_S55.pcapng';
const f82Flap2='BM3 F82\\260913_BM3_Flap2_S55.pcapng';
const f82Read='BM3 F82\\260913_BM3_DMERead_S55.pcapng';
const n20Mhd='MHD N20\\261002_MHD_binRead_N20Bench\\261002_MHD_binRead_N20Bench.pcap';
const n20Bm3Reset='BM3 N20\\261006_BM3_DMEReset_N20Bench.pcap';
const n20BscReset='BSC N20\\261007_BSC_DMEReset_N20Bench.pcap';
const n20Bm3Flap='BM3 N20\\261007_BM3_FlapControl_N20Bench.pcap';

const ledger=[
 ['S55-01','Identity','Observed','F101 actual SVK','22 F1 01','62 F1 01','29 / 33',f82Mhd,'Current HWEL 000019DE/0A1301, BTLD 00001A83/0A3B02, SWFL 00001A84/1D2801 and 0000260B/1D28FE, CAFD 00000B0A/007302.','F101 is an inventory, not a hardware serial or tune-state test.'],
 ['S55-02','Identity','Observed + mapping','F150 SGBD index','22 F1 50','62 F1 50 0F 1E A0','35 / 38',f82Mhd,'The three data bytes form index 0x0F1EA0. The PRG identification table maps address 12 + this index to S55 under G_MOTOR.','This identifies a diagnostic variant, not software version or unlock state.'],
 ['S55-03','Identity','Observed','Manufacturing date DID','22 F1 8B','62 F1 8B 14 08 07','46 / 49',f82Mhd,'B1V HERSTELLINFO_LESEN labels F18B manufacture data; likely 2014-08-07.','Date interpretation depends on B1V semantics for older target software.'],
 ['S55-04','Identity','Observed','F103 factory SVK','22 F1 03','62 F1 03','51 / 54',f82Mhd,'Factory record includes BTLD 00001A83/0A3B01, SWFL 00001A84/13C802 and 0000260B/13C8C7.','Different from F101; does not identify when or why software changed.'],
 ['S55-05','Identity','Observed','F102 supplier SVK','22 F1 02','62 F1 02','56 / 59',f82Mhd,'Supplier record includes BTLD 00001A83/0A3B01, SWFL 00001A84/13C802 and 00001A85/13C801.','Reference inventory, not current running software.'],
 ['S55-06','Identity','Observed','SWE metadata routine','31 01 02 05 08 00 00 26 0B 1D 28 FE','71 01 02 05 ...','61 / 65',f82Mhd,'Response contains MEVD17.2.G, 6MC9ED0B, and 510_S55_BG2_EU6_DKG_254 text.','Metadata is specific to the captured DME, not a compatibility guarantee.'],
 ['S55-07','Identity','Observed','Bootloader metadata routine','31 01 02 05 06 00 00 1A 83 0A 3B 02','71 01 02 05 ...','67 / 71',f82Mhd,'Bootloader metadata response corresponds to BTLD 00001A83/0A3B02.','Do not conflate software labels with hardware serial.'],
 ['S55-08','Identity','Observed','VIN','22 F1 90','62 F1 90 57 42 53 ...','73 / 76',f82Mhd,'ASCII VIN WBS3R92010K340307.','VIN must be paired with ECU/session provenance for a current car check.'],
 ['S55-09','Memory','Observed','Three MHD memory probes','23 24 80 1F FA 40 00 10; 23 24 D0 00 00 00 00 40; 23 24 80 1F FA 00 00 40','63 ...','78 / 83 / 88',f82Mhd,'MHD capture shows two short 0x801FFxxx reads and one 0xD0000000 read.','This traffic cannot reconstruct the supplied 4 MB BIN.'],
 ['S55-10','Memory','Analysis note','BM3 contiguous read window','23 24 ...','63 ...','128 requests',f82Read,'Existing offline note reports 523,264 returned bytes matching base BIN offsets 0x180000:0x1FFC00.','Reassembly comparison reported in note; remaining 4 MB image and later DME state are unproven.'],
 ['S55-11','DTC','Observed','Broadcast DTC clear','14 FF FF FF to DF','54 from DME 12; 7F 14 78 first','819 / 844 / 854',f82Bm3,'DME first sends response pending, then positive clear reply. Other modules also reply in this capture.','This is multi-ECU scope; a DME reply alone does not narrow the target.'],
 ['S55-12','Reset','Observed','Broadcast hard reset','11 01 to DF','51 01 from DME 12','2982 / 3001',f82Bm3,'DME acknowledges about 25 ms after request. Existing analysis counts 25 positive ECU source addresses.','Acknowledgement does not establish reboot completion or later identity.'],
 ['S55-13','Flap','Observed','IO control first duty','2F 60 FD 03 14 7A FA FF','6F 60 FD 03','156 / 158',f82Flap,'B1V factor suggests approximately 8% duty and 500 s timeout.','No measured physical flap position is in the capture.'],
 ['S55-14','Flap','Observed','Return control','2F 60 FD 00','6F 60 FD 00','171 / 173',f82Flap,'Stops the IO-control override in captured sequence.','Persistence after disconnect is not established.'],
 ['S55-15','Flap','Observed','IO control second duty','2F 60 FD 03 EB 85 FA FF','6F 60 FD 03','192 / 194',f82Flap2,'B1V factor suggests approximately 92% duty and 500 s timeout.','Physical open/closed meaning requires independent measurement.'],
 ['S55-16','Dynamic DID','Analysis note','F301 memory definition attempts','2C 02 F3 01 24 ...','7F 2C 31','25 attempts',f82Bm3,'Five candidate addresses tried five times; all definition attempts rejected out of range.','Positive 2C 03 clear does not mean F301 definition succeeded.'],
 ['S55-17','Capability','Analysis note','No observed programming sequence','27 / 34 / 36 / 37 search','none observed','all F82 captures','pcap\\BM3 F82 and pcap\\MHD F82','Supplied F82 traffic contains no observed SecurityAccess or transfer sequence.','Absence from these captures cannot establish unlock state or flash support.'],
 ['S55-18','B1V','Source-derived','SGBD target mismatch','s55-english.b1v header','6MC2EB2B versus captured 6MC9ED0B','B1V header / S55-06','b1v\\s55-english.b1v','B1V jobs provide strong candidate semantics for DIDs and control records.','Do not claim exact compatibility with the captured software.'],
 ['S55-19','B1V','Source-derived','Reset information candidate','22 40 99','expected 62 40 99','B1V _STATUS_RB_RESET_INFO','b1v\\s55-english.b1v','B1V describes reset history fields through response offset 0x2B.','No 224099 request or reply was found in supplied captures; support unverified.'],
 ['S55-20','B1V','Source-derived','Serial-number DID candidate','22 F1 8C','expected 62 F1 8C','B1V SERIENNUMMER_LESEN','b1v\\s55-english.b1v','Separate ECU serial-number job.','No F18C exchange in supplied F82 captures.'],
 ['S55-21','File','Calculated','Base versus mapswitch BIN','4,194,304-byte files','42,267 changed bytes','byte comparison','pcap\\MHD F82\\261003_MHD_binRead_F82','All differing positions lie in 0x1DBE8C:0x1E6457; changed base bytes are C3.','A file comparison does not establish that either variant was installed.'],
 ['S55-22','Interpretation','Inference','MHD file provenance','short read traffic + vendor FAQ','OEM reconstruction plausible','S55-09 + MHD FAQ',f82Mhd,'Vendor says third-party tuned map cannot be saved and OEM map can be restored without stock backup.','Exact internal MHD file-assembly method remains unknown.'],
 ['N20-01','Session','Observed','Tester present','3E 00','7E 00','7 / 11',n20Mhd,'MHD N20 session begins with tester-present request and DME positive response.','This is a protocol exchange, not a complete session-health check.'],
 ['N20-02','Identity','Observed','F101 actual SVK','22 F1 01','62 F1 01','13 / 17',n20Mhd,'Current HWEL 000019A6/011303, BTLD 00001901/013102, SWFL 00001C9F/1D9601 and 00001CDB/1D9603, CAFD 00000B0A/007803.','F101 is a versioned inventory; it is not a hardware serial or tune-state result.'],
 ['N20-03','Identity','Observed + mapping','F150 SGBD index','22 F1 50','62 F1 50 0F 18 10','19 / 22',n20Mhd,'Index 0x0F1810 maps address 12 to MEVD1724 under G_MOTOR in the PRG identification table.','Diagnostic description family; exact installed software comes from other reads.'],
 ['N20-04','Identity','Cross-capture observation','F150 consistency','22 F1 50','62 F1 50 0F 18 10','46 replies / 13 captures','pcap\\MHD N20; BM3 N20; BSC N20','All 46 complete DME-address-12 F150 replies found in 13 supplied N20 captures return 0F1810.','Other ECU addresses and accidental byte matches inside encrypted payloads excluded.'],
 ['N20-05','Identity','Observed','Manufacturing-date DID','22 F1 8B','62 F1 8B 15 03 17','30 / 33',n20Mhd,'B1V naming suggests ECU manufacturing date 2015-03-17.','Date interpretation follows B1V and is not vehicle build date.'],
 ['N20-06','Identity','Observed','F103 factory SVK','22 F1 03','62 F1 03','35 / 38',n20Mhd,'Factory inventory includes BTLD 00001901/013101 and SWFL 00001C9F/1D6E02 plus 00001CDB/1D6E09.','Different from actual inventory; change history and tune cause unproven.'],
 ['N20-07','Identity','Observed','F102 supplier SVK','22 F1 02','62 F1 02','40 / 43',n20Mhd,'Supplier inventory includes SWFL 00001C9F/1D6E02 and 00001CA1/1D6E00.','Reference inventory, not current running software.'],
 ['N20-08','Identity','Observed','SWE metadata routine','31 01 02 05 08 00 00 1C DB 1D 96 03','71 01 02 05 ...','45 / 49',n20Mhd,'Response contains MEVD17.2.9 and software text 9VT9G40B.','Read-only metadata; no programming or unlock status implied.'],
 ['N20-09','Identity','Observed','Bootloader metadata routine','31 01 02 05 06 00 00 19 01 01 31 02','71 01 02 05 ...','51 / 55',n20Mhd,'Bootloader metadata corresponds to current BTLD 00001901/013102.','Separate from the SGBD index.'],
 ['N20-10','Identity','Observed','VIN','22 F1 90','62 F1 90 57 42 41 ...','57 / 60',n20Mhd,'ASCII VIN WBA3A52010F360747.','Bench setup provenance should remain separate from F82 car.'],
 ['N20-11','Memory','Observed','Three short MHD memory probes','23 24 80 1F FA 40 00 10; 23 24 D0 00 00 00 00 40; 23 24 80 1F FA 00 00 40','63 ...','62 / 67 / 73; 65 / 71 / 77',n20Mhd,'Same three addresses and lengths as MHD F82 probe; both 0x801FFxxx N20 replies are C3 fill bytes.','These reads do not reconstruct the supplied 4 MB BIN.'],
 ['N20-12','Identity','Observed','CAFD identifier cross-check','22 33 50','62 33 50 05 00 00 0B 0A 00 78 03','95 / 98',n20Mhd,'CAFD identifier/version bytes agree with the F101 record.','Other 33xx response meanings need their own definitions.'],
 ['N20-13','Identity','Observed','Last seven VIN characters','22 37 FE','62 37 FE 46 33 36 30 37 34 37','106 / 109',n20Mhd,'ASCII F360747 matches the VIN suffix from F190.','Suffix is not a substitute for full VIN.'],
 ['N20-14','Reset','Observed','BM3 broadcast hard reset','11 01 to DF','51 01 from DME 12','159 / 167',n20Bm3Reset,'DME acknowledges about 28 ms after broadcast reset; other ECU addresses reply too.','Acknowledgement is not a verified post-reset identity or readiness check.'],
 ['N20-15','Reset','Observed','BSC broadcast hard reset','11 01 to DF','51 01 from DME 12','132 / 138',n20BscReset,'BSC capture also sends broadcast reset and receives DME plus other replies.','Operation scope exceeds DME despite its label in app.'],
 ['N20-16','Flap','Observed','IO control low duty','2F 60 FD 03 14 7A FA FF','6F 60 FD 03','364 / 367',n20Bm3Flap,'N20 bench accepts the same request bytes seen on F82.','Positive reply does not measure physical flap position.'],
 ['N20-17','Flap','Observed','IO control high duty','2F 60 FD 03 EB 85 FA FF','6F 60 FD 03','1441 / 1448',n20Bm3Flap,'N20 bench accepts alternate duty request.','Duty-to-position mapping not independently measured.'],
 ['N20-18','Flap','Observed','Return control','2F 60 FD 00','6F 60 FD 00','1489 / 1493',n20Bm3Flap,'Positive end-control response observed.','Persistence or mechanical outcome not shown.'],
 ['N20-19','Dynamic DID','Observed','F301 define by memory rejected','2C 02 F3 01 24 ...','7F 2C 31','591 / 594 and later',n20Bm3Flap,'BM3 address-definition attempt is rejected request-out-of-range; preceding 2C 03 clear succeeds.','No working F301 memory read is established.'],
 ['N20-20','B1V','Source-derived','Diagnostic definition scope','mevd1724.b1v header','MEVD1724 / MEVD1729; target 9VS2G01B','B1V header','b1v\\mevd1724.b1v','The B1V describes the N20-family diagnostic jobs and gives context to the capture.','Captured software text is 9VT9G40B; exact job compatibility still needs validation.'],
];
addSheet('Evidence ledger','S55 / N20 evidence ledger','Observations are bounded to the named captures; source-derived rows and inferences are explicitly labelled.',
 ['ID','Area','Evidence class','Finding','Request / input','Reply / output','Frame or location','Primary source','What the evidence supports','Limit / unresolved'],ledger,[12,15,17,28,45,34,21,64,85,70]);

const uds=[
 ['0x11','ECUReset','0x51','Reset request with subfunction, e.g. 11 01.','ISO 14229-1:2013, §9 ECUReset','Captured 11 01 targets DF; replies from many ECU addresses.'],
 ['0x14','ClearDiagnosticInformation','0x54','Three-byte groupOfDTC; FF FF FF selects all groups.','ISO 14229-1:2013, §11.2, PDF pp.183-185','Captured request is broadcast DF, so more than DME can clear.'],
 ['0x19','ReadDTCInformation','0x59','Subfunctions and status masks govern DTC reports.','ISO 14229-1:2013, §11.3','Capture-specific status fields need exact response parsing.'],
 ['0x22','ReadDataByIdentifier','0x62','Two-byte DID followed by manufacturer-defined record.','ISO 14229-1:2013, §10.2, PDF p.114','F101/F102/F103/F150/F18B/F190 have captured replies.'],
 ['0x23','ReadMemoryByAddress','0x63','AddressAndLengthFormatIdentifier high nibble=size bytes, low nibble=address bytes.','ISO 14229-1:2013, §10.3, PDF pp.121-124','23 24 uses 4 address bytes + 2 size bytes.'],
 ['0x2C','DynamicallyDefineDataIdentifier','0x6C','A dynamic DID may be defined or cleared.','ISO 14229-1:2013, §10.6','BM3 F301 memory-definition requests return 7F 2C 31.'],
 ['0x2E','WriteDataByIdentifier','0x6E','Write a manufacturer-defined record.','ISO 14229-1:2013, §10.7','BM3 F82 uses 2E 5F FD with DME acknowledgment.'],
 ['0x2F','InputOutputControlByIdentifier','0x6F','Control option and control state are DID-specific.','ISO 14229-1:2013, §12.2, PDF p.253','Flap 60FD duty meaning comes from B1V, not generic ISO.'],
 ['0x31','RoutineControl','0x71','Start/stop/request result subfunctions with routine ID.','ISO 14229-1:2013, §13.2','31 01 02 05 and 31 01 0F 06 need BMW-specific interpretation.'],
 ['0x7F','NegativeResponse','n/a','Carries rejected SID and NRC.','ISO 14229-1:2013, §7.5','7F 14 78 means response pending; 7F 2C 31 indicates out of range.'],
];
addSheet('UDS reference','UDS service crosswalk','ISO gives service structure; the B1V and packet evidence are needed for BMW-specific payload meaning.',
 ['Request SID','Service','Positive SID','Standard-level meaning','Reference','Capture-specific observation'],uds,[16,33,16,76,47,82]);

const b1v=[
 ['SVK_ID / PROZESSKLASSEN','F101 / F102 / F103','Actual / supplier / factory SVK and process classes.','F101, F102, F103 captured on S55.','Older B1V target 6MC2EB2B; field layout should be checked against actual DME.'],
 ['IDENT','22 F1 50','One unsigned big-endian 24-bit index per B1V parser.','0F1EA0 on S55; 0F1810 on N20.','The PRG table maps these to S55 and MEVD1724 diagnostic descriptions.'],
 ['HERSTELLINFO_LESEN','22 F1 8A / F1 8B','Supplier/manufacturing information.','F18B 14 08 07 captured.','F18A absent; date format inferred from B1V.'],
 ['SERIENNUMMER_LESEN','22 F1 8C','ECU serial number.','No F18C capture.','Do not treat HWEL or F18B as serial.'],
 ['SPEICHER_LESEN_ASCII','23 14 / 23 24','ReadMemoryByAddress; four-byte addresses in implementation.','BM3 S55 uses 23 24.','Text comment on 24-bit max conflicts with four-byte request and captured address.'],
 ['STEUERN_EL_AGK / STEUERN_ENDE_EL_AGK','2F 60 FD 03 / 2F 60 FD 00','Exhaust-flap IO-control and end-control.','Both captured with 6F replies.','Duty scaling is a candidate on captured 6MC9ED0B; physical position unmeasured.'],
 ['FS_LOESCHEN','14 FF FF FF','Clear all DTC group.','BM3 F82 sends it to DF.','B1V job may address DME directly; capture is broadcast.'],
 ['STEUERGERAETE_RESET','11 01','Hard reset.','BM3 F82 sends it to DF.','Direct DME request in B1V is not verified by supplied F82 capture.'],
 ['_STATUS_RB_RESET_INFO','22 40 99','Candidate reset-history DID, 44-byte parser span.','No captured exchange.','Development job; availability and cause codes unknown.'],
 ['N20 MEVD1724 B1V header','22 F1 50 / IDENT','N20/MEVD1724 and MEVD1729 diagnostic description.','Captured 0F1810 maps to MEVD1724.','B1V target software 9VS2G01B differs from captured 9VT9G40B.'],
];
addSheet('B1V crosswalk','S55 / N20 B1V crosswalk','Local SGBD descriptions are interpretation aids; captured software differs from the target noted in each B1V.',
 ['B1V job / table','UDS request','Meaning in source','Capture cross-check','Applicability limit'],b1v,[40,30,68,58,82]);

async function walk(dir) {
 const entries=await fs.readdir(dir,{withFileTypes:true});
 let files=[];
 for(const ent of entries){ const p=path.join(dir,ent.name); files.push(...(ent.isDirectory()?await walk(p):[p])); }
 return files;
}
const srcFiles=[...await walk(sourceRoot),...await walk(path.join(desktop,'b1v')),path.join(desktop,'ISO_14229-1_2013.en.PDF.pdf')];
const inventory=[];
for(const file of srcFiles){
 const bytes=await fs.readFile(file); const rel=path.relative(desktop,file);
 const ext=path.extname(file).toLowerCase();
 let frames=null;
 if(ext==='.pcap'||ext==='.pcapng'){
   const out=execFileSync(tshark,['-r',file,'-T','fields','-e','frame.number'],{encoding:'utf8',maxBuffer:32*1024*1024});
   frames=out.trim().split(/\r?\n/).length;
 }
 inventory.push([rel,ext.slice(1),bytes.length,frames,crypto.createHash('sha256').update(bytes).digest('hex')]);
}
addSheet('Source inventory','Source inventory','SHA-256 identifies the exact local files examined; packet counts describe whole capture files, not UDS message counts.',
 ['Desktop-relative source','Type','Bytes','Frames','SHA-256'],inventory,[85,12,18,16,68]);

const basePath=path.join(sourceRoot,'MHD F82','261003_MHD_binRead_F82','WBS3R92010K340307_00001A841D2801.bin');
const mapPath=path.join(sourceRoot,'MHD F82','261003_MHD_binRead_F82','WBS3R92010K340307_00001A841D2801_mapswitch.bin');
const base=await fs.readFile(basePath), map=await fs.readFile(mapPath);
if(base.length!==4194304||map.length!==4194304) throw new Error('Unexpected BIN size');
let changed=0, first=-1,last=-1, allC3=true;
for(let i=0;i<base.length;i++) if(base[i]!==map[i]){changed++;if(first<0)first=i;last=i;if(base[i]!==0xC3)allC3=false;}
const binRows=[
 ['Base BIN bytes',base.length,'Measured from source file','4 MB output size does not prove actual DME was entirely read.'],
 ['Mapswitch BIN bytes',map.length,'Measured from source file','Artifact label alone does not prove flash or function.'],
 ['Differing byte positions',changed,'Direct byte comparison','All positions counted once.'],
 ['First differing offset',`0x${first.toString(16).toUpperCase()} (hex)`,'Direct byte comparison','File offset; observed DME mapping only for captured read window.'],
 ['Last differing offset',`0x${last.toString(16).toUpperCase()} (hex)`,'Direct byte comparison','Inclusive end offset.'],
 ['Every changed base byte is C3',allC3?'Yes':'No','Direct byte comparison','Does not establish safe writable space.'],
 ['Captured BM3 read window','0x180000:0x1FFC00','Existing offline analysis note','523,264 bytes matching base BIN reported; not reassembled by this builder.'],
 ['F82 SGBD target software','6MC2EB2B','B1V header per analysis note','Different from captured 6MC9ED0B.'],
 ['Captured S55 software text','6MC9ED0B','MHD F82 frame 65','This is observed metadata, not flash/unlock evidence.'],
];
addSheet('BIN comparison','F82 BIN comparison','Comparison is of supplied files. No programming command, checksum validity, or installed tune state is inferred.',
 ['Measure','Value','Evidence','Boundary'],binRows,[40,35,55,96]);

const ecuRows=[
 ['F150 request','22 F1 50','22 F1 50','Both use the same ReadDataByIdentifier request to DME address 12.'],
 ['F150 data value','0F 1E A0','0F 18 10','Responses: 62 F1 50 + three data bytes. MHD F82 frames 35/38; MHD N20 frames 19/22.'],
 ['SGBD index','0F1EA0 (hex)','0F1810 (hex)','Big-endian 24-bit values.'],
 ['PRG mapping','S55 via G_MOTOR','MEVD1724 via G_MOTOR','Published PRG identification table maps address 12 plus index to diagnostic description.'],
 ['VIN','WBS3R92010K340307','WBA3A52010F360747','F190 positive replies; F82 frame 76, N20 frame 60.'],
 ['Current principal SWFL','00001A84 / 1D2801','00001C9F / 1D9601','F101 actual SVK; these are versioned software-element records.'],
 ['Current BTLD','00001A83 / 0A3B02','00001901 / 013102','F101 actual SVK; bootloader element.'],
 ['SWE metadata text','6MC9ED0B; MEVD17.2.G','9VT9G40B; MEVD17.2.9','Routine 31 01 02 05 response in each MHD capture.'],
 ['MHD 23 memory probes','801FFA40 / 16; D0000000 / 64; 801FFA00 / 64','Same three addresses and sizes','Short identification/probe reads; cannot establish full 4 MB BIN provenance.'],
 ['BM3 hard reset target','DF broadcast','DF broadcast','DME and other modules acknowledge; not DME-only operation.'],
 ['Flap IO control','2F 60 FD 03 ...; positive 6F','Same request forms; positive 6F','No physical position measurement in these captures.'],
 ['B1V target versus capture','6MC2EB2B vs 6MC9ED0B','9VS2G01B vs 9VT9G40B','B1V semantics need validation against the captured software versions.'],
 ['Unlock / flash state','Unverified','Unverified','F150 is a diagnostic variant selector, not a security or programming capability result.'],
];
addSheet('ECU comparison','S55 F82 and N20 bench','Direct comparison of the captured DME identities and operations. Values are tied to the named captures in Evidence ledger.',
 ['Field','S55 F82','N20 bench','Interpretation / limit'],ecuRows,[36,48,48,100]);

const research=[
 ['ISO 14229-1:2013','Local PDF','ISO service definitions, including §§10.2, 10.3, 11.2, 12.2.',path.relative(desktop,path.join(desktop,'ISO_14229-1_2013.en.PDF.pdf')),'Standard-level behavior; BMW record meaning remains separate.'],
 ['MHD FAQ','Vendor primary source','Vendor says third-party tuned map cannot be saved as backup and OEM map can be restored without stock backup.','https://mhdtuning.com/pages/faq','Supports reconstruction hypothesis, not proof of exact algorithm.'],
 ['EVC MEVD17.2.G listing','Tool vendor primary source','Lists S55 MEVD17.2.G, TC1797, 4 MB memory.','https://www.evc.de/en/product/bsl/ecu.asp?filtertyp=MEVD17.2.G','Family-level hardware clue; inspect actual ECU identity.'],
 ['Wireshark UDS fields','Project documentation','UDS display-filter field reference for independent packet inspection.','https://www.wireshark.org/docs/dfref/u/uds.html','Dissector coverage does not supply BMW-specific meaning.'],
 ['F82 offline analysis note','Local analysis','Existing capture, BIN and B1V interpretation with stated limits.',path.relative(desktop,note),'Source-derived ledger entries marked Analysis note.'],
 ['PRG identification table','Independent extraction','Address 12 + F150 index 0F1EA0 maps to S55; 0F1810 maps to MEVD1724, both under G_MOTOR.','https://www.bimmerguide.de/prg-identifikation-tabelle/','Maps diagnostic description selection; not software, calibration or unlock state.'],
];
addSheet('Research sources','Research and interpretation sources','Web pages checked 11 October 2026. Local file hashes are recorded in Source inventory.',
 ['Source','Kind','Used for','Location','Limit'],research,[34,26,90,105,75]);

wb.recalculate();
const preview=await wb.render({sheetName:'ECU comparison',range:'A1:D17',scale:1,format:'png'});
await fs.writeFile(path.join(path.dirname(import.meta.filename),'ecu_preview.png'),new Uint8Array(await preview.arrayBuffer()));
const exported=await SpreadsheetFile.exportXlsx(wb);
await exported.save(output);
console.log(JSON.stringify({output,sourceCount:inventory.length,ledgerCount:ledger.length,changed,first,last,allC3}));

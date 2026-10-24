import fs from 'node:fs/promises';
import path from 'node:path';
import { Workbook, SpreadsheetFile } from '@oai/artifact-tool';

const outputDir = path.dirname(new URL(import.meta.url).pathname.replace(/^\/(?:[A-Za-z]:)/, m => m.slice(1)));
const source = {
  s55: 'C:/Users/alper/Desktop/s55.b1v',
  s55English: 'C:/Users/alper/Desktop/s55-english.b1v',
  n20: 'C:/Users/alper/Desktop/mevd1724.b1v',
};

function parseTable(text, tableName) {
  const lines = text.split(/\r?\n/);
  const start = lines.findIndex(line => line === `TBEG "${tableName}"`);
  if (start < 0) throw new Error(`Missing ${tableName}`);
  const end = lines.findIndex((line, i) => i > start && line === 'TEND');
  if (end < 0) throw new Error(`Unclosed ${tableName}`);
  const result = new Map();
  for (let i = start + 2; i < end; i++) {
    if (!lines[i].startsWith('LINE ')) continue;
    const fields = [...lines[i].matchAll(/"((?:[^"]|"")*)"/g)].map(match => match[1].replaceAll('""', '"'));
    if (fields.length < 3) throw new Error(`Malformed source line ${i + 1}`);
    if (result.has(fields[0])) throw new Error(`Duplicate code ${fields[0]}`);
    result.set(fields[0], { fields, line: i + 1 });
  }
  return result;
}

const decoder = new TextDecoder('windows-1252');
async function loadTable(file) {
  return parseTable(decoder.decode(await fs.readFile(file)), 'FORTTEXTE');
}
const [s55, s55English, n20] = await Promise.all([
  loadTable(source.s55), loadTable(source.s55English), loadTable(source.n20),
]);
if (s55.size !== 1094 || n20.size !== 1269 || s55English.size !== s55.size) {
  throw new Error('Unexpected source table count');
}
for (const code of s55.keys()) if (!s55English.has(code)) throw new Error(`Missing English ${code}`);

const translatedN20 = [...n20].filter(([code, item]) =>
  s55.has(code) && s55.get(code).fields[1] === item.fields[1]).length;

const wb = Workbook.create();
const navy = '#14263A';
const blue = '#1768AC';
const light = '#EAF1F7';
const text = '#172B3A';

function makeSheet(name, title, note, sourceText, headers, rows, tableName, widths) {
  const sh = wb.worksheets.add(name);
  sh.showGridLines = false;
  sh.tabColor = blue;
  const last = String.fromCharCode(64 + headers.length);
  sh.mergeCells(`A1:${last}1`);
  sh.getRange('A1').values = [[title]];
  sh.getRange(`A1:${last}1`).format = {
    fill: navy, font: { name: 'Aptos Display', size: 17, bold: true, color: '#FFFFFF' },
    rowHeight: 36, verticalAlignment: 'center',
  };
  sh.mergeCells(`A2:${last}2`);
  sh.getRange('A2').values = [[note]];
  sh.getRange(`A2:${last}2`).format = {
    fill: light, font: { name: 'Aptos', size: 10, color: text },
    rowHeight: 30, verticalAlignment: 'center', wrapText: true,
  };
  sh.mergeCells(`A3:${last}3`);
  sh.getRange('A3').values = [[sourceText]];
  sh.getRange(`A3:${last}3`).format = {
    font: { name: 'Aptos', size: 9, color: '#526779' }, rowHeight: 25,
  };
  sh.getRange(`A5:${last}5`).values = [headers];
  sh.getRange(`A6:A${5 + rows.length}`).setNumberFormat('@');
  sh.getRange(`A6:${last}${5 + rows.length}`).values = rows;
  sh.getRange(`A5:${last}${5 + rows.length}`).format.font = { name: 'Aptos', size: 10, color: text };
  sh.getRange(`A5:${last}5`).format = {
    fill: navy, font: { name: 'Aptos', size: 10, bold: true, color: '#FFFFFF' },
    rowHeight: 26, verticalAlignment: 'center',
  };
  sh.getRange(`A6:${last}${5 + rows.length}`).format.rowHeight = 21;
  for (let i = 0; i < widths.length; i++)
    sh.getRange(`${String.fromCharCode(65 + i)}:${String.fromCharCode(65 + i)}`).format.columnWidth = widths[i];
  sh.tables.add(`A5:${last}${5 + rows.length}`, true, tableName);
  sh.freezePanes.freezeRows(5);
  return sh;
}

const s55Rows = [...s55].map(([code, item]) => [
  code,
  s55English.get(code).fields[1],
  item.fields[1],
  item.fields[2] === '0' ? 'No' : item.fields[2] === '1' ? 'Yes' : item.fields[2],
  item.fields[3] === '-' ? '' : item.fields[3],
  item.line,
]);
const n20Rows = [...n20].map(([code, item]) => [
  code,
  s55.has(code) && s55.get(code).fields[1] === item.fields[1]
    ? s55English.get(code).fields[1] : '',
  item.fields[1],
  item.fields[2] === '0' ? 'No' : item.fields[2] === '1' ? 'Yes' : item.fields[2],
  item.line,
]);

makeSheet('S55 DTCs', 'S55 DTC reference · 1,094 codes',
  'English is from a machine-translated reading copy. Blank fault class means none is supplied. Listed codes are definitions, not faults found on a car.',
  `Sources: ${source.s55} (FORTTEXTE, lines 1549–2645); ${source.s55English} (English labels).`,
  ['DTC code', 'Definition · English', 'Definition · German original', 'Event DTC', 'Fault class', 'Source line'],
  s55Rows, 'S55DtcTable', [16, 72, 72, 15, 16, 14]);
makeSheet('N20 DTCs', 'N20 DTC reference · 1,269 codes',
  `English is available for ${translatedN20} codes whose German text exactly matches S55; blanks remain untranslated. Listed codes are definitions, not faults found on a car.`,
  `Source: ${source.n20} (FORTTEXTE, lines 1020–2291). English matches use the S55 reading copy.`,
  ['DTC code', 'Definition · English when matched', 'Definition · German original', 'Event DTC', 'Source line'],
  n20Rows, 'N20DtcTable', [16, 72, 72, 15, 14]);

wb.recalculate();
for (const name of ['S55 DTCs', 'N20 DTCs']) {
  const result = await wb.inspect({ kind: 'region', sheetId: name, range: 'A1:F8', maxChars: 1700 });
  console.log(name, result.ndjson);
  const preview = await wb.render({ sheetName: name, range: 'A1:F9', scale: 1.2, format: 'png' });
  await fs.writeFile(path.join(outputDir, `${name.replaceAll(' ', '-')}.png`), new Uint8Array(await preview.arrayBuffer()));
}
const output = await SpreadsheetFile.exportXlsx(wb);
const outputPath = path.join(outputDir, 'BimmerScope-S55-N20-DTCs.xlsx');
await output.save(outputPath);
console.log(JSON.stringify({ outputPath, s55: s55Rows.length, n20: n20Rows.length, translatedN20 }));

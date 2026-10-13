# S55 and N20 DME fault catalog

The generated catalog in `lib/diagnostics/generated_dme_fault_definitions.dart` covers every non-sentinel code in `BimmerScope-S55-N20-DTCs.xlsx`: 1,093 S55 entries and 1,268 N20 entries, or 1,582 unique codes. `0xFFFFFF` is the source's unknown-fault placeholder and is excluded. Existing hand-written definitions in `fault_definitions.dart` take precedence, except for eight shared codes whose N20 descriptions differ from S55.

The workbook derives from `s55.b1v`, its English reading copy, and `mevd1724.b1v`. The generation script uses the original N20 `.b1v` FORTTEXTE table for N20-only entries because the workbook leaves their English column blank. It writes new, cautious English titles and explanations rather than copying the workbook wording. Generated summaries are reference text, not individually validated BMW test plans. The `.b1v` source software may differ from a connected vehicle's DME software, so the app uses generated entries only when the fault came from a DME and the vehicle engine is identified as S55 or N20. No FEM entries are derived from these DME files.

BMW's [Aftersales Online System guide](https://www.bmwtechinfo.com/tisUI/assets/site_information.pdf) identifies fault-code diagnosis and test plans as separate service resources. BMW's [N20/N26 bulletin for code 195002](https://static.nhtsa.gov/odi/tsbs/2015/MC-10147594-9999.pdf) illustrates why a code's terse label should not be treated as proof of a failed sensor: it calls for diagnosis and describes a harness-contact failure. The catalog does not assert a repair from the code alone.

Regenerate from the project root with:

```powershell
& 'C:\Users\alper\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe' tool\generate_dme_fault_catalog.py 'C:\Users\alper\Desktop\BimmerScope-S55-N20-DTCs.xlsx' 'C:\Users\alper\Desktop\mevd1724.b1v'
dart format lib\diagnostics\generated_dme_fault_definitions.dart
```

The generator requires `openpyxl`. Review generated wording and source applicability before shipping a release; the bulk summaries have not been checked individually against current BMW service information.

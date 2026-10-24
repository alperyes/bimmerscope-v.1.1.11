# REA analysis of MHD managed code

Analyzed 13 October 2026 using REA 6.4.0 and Node 24.20.0. This analysis reads the extracted assemblies without loading or executing MHD. App source and vehicle compatibility remain unverified.

## Working installation and budget override

REA is installed independently in `C:\Users\alper\Desktop\MHD\tools\rea-local`; no agent configuration was changed. The normal `inspect-managed-members` result for 5.30 is preserved as `REA_5_30_members.json` in this report directory. It reports unavailable inspection because the 64 MiB metadata representation budget is exceeded.

The local copy's `dist/dotnet/ManagedDecodeBudget.js` changes only `MAX_METADATA_REPRESENTATION_BYTES` from 64 MiB to 2 GiB. This is a conservative allowance used by the parser, not a claim about actual memory consumption. The DLL bytes are unchanged. Results from this modified analyzer must be identified as local REA 6.4.0 with that override.

To reproduce after installing `rea-agents@6.4.0` in the local directory and applying that one-line override:

```powershell
& 'C:\Users\alper\Desktop\MHD\tools\rea-local\node_modules\.bin\rea.cmd' inspect-managed-members 'C:\Users\alper\Desktop\MHD\tools\dlls-5.30\MHD_App.dll' --format json
```

The published CLI rejects `--type`. Its supported schema only accepts the assembly path; the focused selection described on the repository's current documentation is not available in this installed release.

## Evidence produced

Raw REA evidence is stored outside the app repository:

- `C:\Users\alper\Desktop\MHD\tools\rea-local\MHD_5_30_members.json`
- `C:\Users\alper\Desktop\MHD\tools\rea-local\MHD_5_29_members.json`
- `C:\Users\alper\Desktop\MHD\tools\rea-local\MHD_5_29_5_30_comparison.json`

The 5.30 result inventories 891 types, 3,990 methods, and 50,585 static call references. It observes 3,882 present CIL bodies and 108 absent bodies. Every present body reports equal total and decoded instruction counts. Signature coverage is partial: 3,757 method signatures decoded and 233 unsupported. For example, the generic return signature on `zz.b(bool, z0)` is unsupported (`element type 0x15`), although its CIL body is present. The ILSpy signature supplies additional interpretation; it must not be attributed to REA's signature decoder.

The inspected 5.30 assembly SHA-256 is `81f29b38c7785810f9ca9a3dccb13f2747e55345775852abf60e5d877a923501`. Its MVID is `c91871c9-10a1-4049-9d93-107053d761c4`. Every token below is meaningful only for this assembly identity.

## File preparation and programming have separate entry paths

REA independently confirms the following direct static references. Async state-machine relationships are interpreted using the corresponding ILSpy attributes and wrapper code; a missing direct call to `MoveNext` is normal for builder-driven dispatch and does not prove that the state machine cannot run.

| Role | Method token | Evidence |
| --- | --- | --- |
| Selected file entry | `0x06000466` | `zz.b(string, bool)` references `zz.bl`, token `0x06000467`. |
| Preparation wrapper | `0x06000467` | `zz.bl()` uses async state machine `zz.m`; ILSpy `zz.cs:25436-25463`. |
| Preparation body | `0x06000537` | `MoveNext` on declaring type `0x020000f5` references classifier token `0x06000462`; ILSpy `zz.cs:3085`. |
| UI write-start handler | `0x060009ac` | `w2.b(bool)` references `xn.a`, token `0x060008af`; ILSpy `w2.cs:2379-2401`. It copies selected flags and transmission type before starting. |
| View bridge | `0x060008af` | `xn.a()` references `zz.bj`, token `0x0600046b`; ILSpy `xn.cs:4286-4307`. |
| Programming entry | `0x0600046b` | `zz.bj()` references `zz.bi`, token `0x0600046c`. |
| Programming wrapper | `0x0600046c` | `zz.bi()` uses async state machine `zz.b1`; ILSpy `zz.cs:26403-26432`. |
| Programming body | `0x06000557` | `MoveNext` on declaring type `0x02000105` contains 6,293 decoded instructions and references authorization, erase, transfer, and status methods. |

Programming body `0x06000557` references `zz.v(ref string)` (`0x0600046e`), erase overload `zz.b(uint, int, F_UIF.SWLayer)` (`0x06000477`), transfer overload `zz.b(byte[], uint, int, uint, int, int, bool)` (`0x0600047a`), layer status method `zz.t(byte)` (`0x0600047b`), and section writers `0x06000469`/`0x0600046a`. These call references corroborate the controller previously identified in ILSpy. They do not establish the order or reachability of those calls for an S55 map.

`summarize_rea.cjs` produces `REA_5_30_focus.json`, preserving method identities, body digests, signatures, callers, and callees for these entry points. Nested names such as `m`, `h`, and `b1` occur more than once; declaring type tokens distinguish them. Names alone must not be used to identify a state machine.

## Cross-version comparison limits

With the override, REA completed a 5.29-to-5.30 comparison with partial coverage on both sides. Its aggregate summary reports 612 unchanged, 838 changed, 2,028 added, 1,997 removed, and 1,349 unknown member records. These are analyzer matching results across methods and fields, not a reliable release changelog. Renamed obfuscated types, changing tokens, unsupported signatures, and ambiguous structural matches can all prevent correspondence. In particular, those counts do not establish thousands of actual code additions or removals.

The focused JSON also retains exact call-site IL offsets. The next useful REA trace is to reconstruct the programming-controller branch conditions, map the relevant fields to `FlashWriteType`, `F_UIF.SWLayer`, and ECU identity, and compare the resulting conditional paths with the existing F82 read capture and any authorized programming capture. The complete S55 programming and recovery sequence remains unresolved.

## Write-type predicates and pass selection

REA identifies static field `zz.n` as token `0x04001c9d`, with a value-type signature. ILSpy supplies its `FlashWriteType` interpretation. REA confirms that predicates `an`, `am`, and `ak` each read that field and that `al` reads the field and calls `am`. Interpreting the explicit return conditions in `zz.cs:16482-16595` gives:

| Predicate | REA method token | True for write types |
| --- | --- | --- |
| `an()` | `0x06000423` | `Map_OEM`, `Full_OEM` |
| `am()` | `0x06000424` | `Map_Tuned`, `MapTwoPasses_Tuned` |
| `al()` | `0x06000425` | `Map_OEM`, `Map_Tuned`, `MapTwoPasses_Tuned` |
| `ak()` | `0x06000426` | `OnepassMHD`, `TwoPassMHD` |

The programming body sets its pass count `q` to 2 exactly for `TwoPassMHD` and `MapTwoPasses_Tuned`, otherwise 1 (`zz.cs:13623`). It initializes pass index `p` to zero and input selector `o` to `z0.z`. For a two-pass operation with `p == 0`, it changes `o` to `z0.a`; for a one-pass OEM operation (`an()` true), it changes `o` to `z0.b` (`zz.cs:13624-13688`). The enum declares `z0.b = 0`, `z0.a = 1`, `z0.z = 2`; these internal values are not diagnostic service identifiers. It then calls the file classifier/preparer again with `A_0: true` and the chosen `o`, and exits that path when the result is `FileInvalid` (`zz.cs:13689-13730`). Therefore the earlier preparation result is not the controller's only file-validation call.

These are conditional code findings. They do not identify the target car's selected write type, prove every pass executes, or establish a vehicle-side message sequence.

## S55 section selector and supplied BIN markers

REA method `0x06000383`, on declaring type `0x020000c9` (`as`), matches the eight-argument virtual section selector in ILSpy `as.cs:198`. The `yy` S55 subclass has only a constructor, so it inherits this implementation. The `zz` wrapper forwards layer, image, flags, unlock status, and other image arrays (`zz.cs:69882-69903`), but this base selector's body reads only its layer and primary image arguments.

For the PRG layer, the selector reads eight ASCII bytes at file offset 131,098 (`0x2001A`, `as.cs:567`). A static reconstruction of the string decoder at `LinearSportGauge.cs:706` reveals accepted markers including `MEVD172G`, `MEVD172H`, `MEVD172_`, `MEVD1724`, `MEVD1725`, `MEVD1726`, `MEVD1728`, `MEVD1729`, and `MEVD1784`. The `MEVD172G` match reaches the branch that returns four PRG sections. BTLD and CAL branches return two sections each (`as.cs:290-325`, `as.cs:352-357`). This is image-layout selection; a marker match does not prove that a file matches the connected ECU's software.

Read-only inspection of all 26 supplied BIN files in `F series N55 S55 N13` found 4 MiB images and a recognized marker at that offset in every file. Nine original/map-switch-base pairs have `MEVD172G`: `00001A841D1401`, `00001A841D2801`, `000021571D8202`, `000021571DAA01`, `000021571DBE01`, `00002DF2132801`, `00005BA8134601`, `00005BA8135001`, and `00005BA8135A01`. The other four pairs have `MEVD172_`, `MEVD1725`, or `MEVD1726` markers. This narrows the local corpus to candidates for the selector's G-layout branch; actual S55 software compatibility and stock-read provenance remain unverified.

`analyze_s55_selection.cjs` reproduces the decoder reconstruction and BIN inventory without executing MHD. `REA_S55_SELECTION.json` records file hashes, decoded literals with source line locations, the source hash, the selector's CIL evidence, and the predicate methods' field references. The full programming controller remains conditional on state and supplied image data.

## Software identifiers and the scope of mismatch checks

REA identifies the inherited `as.w`, `as.x`, and `as.v` methods as tokens `0x0600037e`, `0x06000380`, and `0x0600037f`. ILSpy shows their calls to the bounded hex formatter `x8.a(byte[], int, int, string)` and the constructor's offset assignments (`as.cs:49-60`, `as.cs:87-161`). `w` reads seven bytes at 131,109 (`0x20025`), with a sentinel fallback to `x`; `x` reads seven bytes at 2,096,527 (`0x1FFD8F`); `v` reads seven bytes at 2,096,385 (`0x1FFD01`). `t` reads only the first four bytes at the latter offset. These return hex strings rather than ASCII software names.

The seven-byte identifiers have the four-byte big-endian SGBM number plus three version bytes used by `XWE.ToHex`. `XWE.FromBin` additionally consumes a preceding process-class byte (`XWE.cs:526-547`); REA identifies those methods as `0x06000cb5` and `0x06000cbf`. They must not be confused with the eight-byte ASCII layout marker.

The classifier stores `bv.x(u)` in `text` (`zz.cs:7115`), later gets `bp()` into `t`, and returns `FileInvalid` when `t != text` (`zz.cs:7506-7531`). `bp`, REA token `0x06000451`, starts by reading `bv.w(u)` from the same primary image and has a conditional decompression fallback (`zz.cs:22256-22335`). Consequently this mismatch check compares identifiers inside the image; the `SOFT_MISMATCH` label alone does not establish a comparison with the connected ECU. Other mismatch branches use reference-file metadata (`ze2.y`), optional conversion logic, and ECU state; their reachability remains to be reconstructed.

All 26 local images have equal seven-byte values at `0x20025` and `0x1FFD8F`, matching the 14 hexadecimal digits in their filenames. At `0x1FFD01` they contain a separate identifier. All 13 original/map-switch-base pairs have different SHA-256 hashes but equal values at all three identifier locations. Thus unchanged software identifiers cannot establish an unmodified image or stock provenance.

For connected identity, a different code path sets `LatestSoftware = lastKnownPRG.ToHex()` (`zz.cs:50849`) after reading/processing ECU information. That is separate from the image coherence check above. Matching a captured PRG identifier, the image's identifiers, and the supported transition logic remains necessary before claiming compatibility; the current analysis has not established that full gate.

The expanded `REA_S55_SELECTION.json` preserves each file's three identifiers, parsed number/version components, SHA-256, and REA evidence for the formatter wrappers and XWE methods. The extraction script reads local bytes and never invokes MHD or a vehicle service.

## First classifier check: reject a short BIN

Start with one simple `FileInvalid` path in the async classifier, rather than trying to untangle its full obfuscated state machine. The REA evidence record is `ev_ccf2314d51ad3a4c4d8c3dc4a77aeb105878d3c8860d6c4a4b32cac14cf63c7c`. REA identifies the actual classifier body as `h.MoveNext`, method token `0x06000541` on type token `0x020000fa`; the body has 6,389 fully decoded CIL instructions. The 80-instruction method `zz.b(bool, z0)` (`0x06000462`) is only its async kickoff wrapper. In the REA body, field token `0x04001c34` is `zq.bz` (an `int`) and is read at IL offsets 5510 and 6609; these reads are consistent with the two minimum-length comparisons visible in ILSpy.

In ILSpy's decompilation, the first comparison is in `zz.cs` around lines 6894-6904: MHD reads the candidate path into `array3`, then checks `array3.Length < zz2.bv.bz`. When true, it reports `Res.WRONG_BINSIZE` and returns `FlashWriteType.FileInvalid` around lines 6914-6922. The F/G base ECU object is `as`, whose parent `yw` sets `bz` to 4,194,304 bytes (4 MiB); S55 class `yy` inherits that object. The supplied BINs in the local corpus are 4 MiB, so they clear this particular length floor. That does not mean they pass the classifier's later checks.

This is a useful first REA lesson: use the short wrapper to find the real async body, then use REA's method/field tokens to keep obfuscated names straight while consulting the decompiler for readable branch structure. The finding is static only. We have not proven which user action reaches this branch, whether every S55 file path uses it, or that passing the size check makes any file valid.

## Next classifier check: compare IDs from two images

After the length check, this path parses an XWE identifier from the candidate bytes. It then calls `zz.b(byte[], byte[], bool, bool)` (REA method `0x0600045b`) with the candidate and `zz.u`. If that helper does not accept the pair, the code reads each image's software ID through `zz2.bv.w(...)` and compares the strings (`zz.cs` around lines 6923-6966). A mismatch reaches `FileInvalid` around lines 6973-6981. REA's body for `h.MoveNext` includes the call to `0x0600045b` and accesses to the candidate/reference image fields; the same evidence record listed above covers those tokens. The F/G `w` implementation and its byte offsets are documented in the earlier software-identifier section.

In this path, `zz.u` is an in-memory reference image populated earlier by `zz2.a(true, a_7)` (`zz.cs` around lines 6657-6704). So this particular comparison is image-to-image. It is not a direct read of the car's ECU software ID. MHD does obtain a connected software identifier elsewhere, and separate mismatch branches may use it; this finding does not explain all compatibility checks. Also, `zz.b(...)` may accept some pairs before this fallback comparison, so we have not shown that every candidate is subject to this exact mismatch rejection.

## Reference image construction

The reference loader is `zz.a(bool, string)`, REA token `0x06000436`, decompiled at `zz.cs:18613`. It forwards vehicle VIN and software information (`Vin_CASFRM`, `ZBNR`, with conditional `factoryZBNR` fallback) to `zz.a(string, string, bool, string, bool)`, token `0x060004a8`, at `zz.cs:35848`. Options such as `ForceSW` can influence that selection; actual runtime values for the target car remain unknown.

The downstream loader selects a model-specific `zb` entry and image components, allocates `bv.bz` bytes, reads a base component into that array, and reads another component into the region described by `bv.b3` and `bv.b6` (`zz.cs:36162`, `36193`, `36211`, `36224`, `36246`). Components come through `yi.y(string)` (`0x060006de`), which searches registered `yk` stores by filename; `yk.a(string)` (`0x060006ec`) supports extraction/decompression into a stream (`yi.cs:424`, `yk.cs:586`). The exact bundle/cache origin and selected component names for an S55 run have not been established.

Thus the earlier image-to-image finding needs context: the reference can be selected using vehicle/software information. It is not an arbitrary second BIN. This code builds the comparison image from MHD's available image components; it does not establish that the reference is a fresh full ECU read or prove the target vehicle's compatibility. Method identities come from the same retained REA evidence record; readable selection and assembly logic come from ILSpy.

## F/G reference selection: corrected platform-specific trace

The generic component assembly described above is not the terminal F/G path. For `Platform.FG`, `zz.a(string,string,bool,string,bool)` delegates directly to `zz.b(string,string,bool,string,bool)`, REA token `0x060004e3` (`zz.cs:36132`, implementation at `54996`). Consequently the S55 reference selection must be traced through that separate loader.

That loader first records whether the supplied software string equals the current `ZBNR`. With no explicit override and no FEMTO-like state, it examines two hardcoded groups of hardware/program identifiers to choose a program override (`zz.cs:55033-55157`). Their decoded values and S55 applicability remain unresolved. An explicit override is parsed into an XWE using the recorded PRG process class. When the supplied software matches the current ZBNR and the caller uses `A_2=false` (the first attempt in the outer loader), it calls the static image constructor with `lastKnownCAL`, that optional program override, the F/G ECU object, and `lastKnownBTLD` (`zz.cs:55177-55190`). Alternate paths use the `z5` software catalog to find compatible component lists, or fall back to recorded CAL/PRG identifiers. These paths are conditional; no target-car selection has been observed.

The static constructor is REA token `0x060004de`, at `zz.cs:54192`. It allocates the full image and calibration buffers, obtains the calibration component by `A_0.toFilename()`, and extracts identifier information from that component. It obtains program components through XWE-derived filenames and combines buffers (`zz.cs:54486-54511`, `54590`, `54635`, `54682-54685`). Bootloader information also influences its branching. This supplies a concrete reason to obtain the target ECU's recorded CAL, PRG and BTLD identifiers, its hardware identifier, and the active software options before identifying a particular reference image. A model/year label or a local BIN filename alone does not resolve these choices.

REA evidence remains `ev_ccf2314d51ad3a4c4d8c3dc4a77aeb105878d3c8860d6c4a4b32cac14cf63c7c`; token identities are scoped to the recorded 5.30 assembly. No MHD code or vehicle service was executed for this trace.

## Catalog matching: exact identifiers and versions

Static string decoding reveals two SQLite queries in `z5`. Method `0x0600058f` (`z5.cs:337`) looks up an exact calibration SGBM number plus major, minor and patch version, then joins the CAL record to its PRG record through `CAL.PRG_ID = PRG.ID`. Method `0x06000590` (`z5.cs:518`) looks up an exact PRG number and all three version components, while requiring the requested CAL number; that second query does not constrain CAL version. Both return the selected PRG/CAL pair or null when no row is available. They do not match by model/year or by BIN size alone.

REA confirms calls from `zz.b(XWE)` (`0x060004e1`) to `0x0600058f` and from `zz.b(XWE,int)` (`0x060004e2`) to `0x06000590`. REA's generic signature parsing is unsupported for those catalog methods; their signatures and readable query construction are supplied by ILSpy. The decoder was reconstructed statically; the database was not queried and no catalog row was verified. `REA_CATALOG_SELECTION.json` retains decoded queries, source hash, method body hashes and the REA evidence identity; `analyze_catalog.cjs` reproduces that extraction.

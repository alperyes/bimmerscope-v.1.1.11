# F82 S55 capture, BIN, and SGBD analysis

11 October 2026. Offline analysis only; no vehicle requests were sent.

## Evidence and limits

- SGBD: `C:\Users\alper\Desktop\s55.b1v` and its descriptive English copy `s55-english.b1v`. Its header targets MEVD172G software `6MC2EB2B`.
- F82 captures: `C:\Users\alper\Desktop\pcap\BM3 F82\*.pcapng` and `C:\Users\alper\Desktop\pcap\MHD F82\261003_MHD_binRead_F82\261003_MHD_binRead_F82.pcap`.
- F82 base BIN: `WBS3R92010K340307_00001A841D2801.bin`, 4,194,304 bytes, SHA-256 `c545c36c91bd5e6159c026fd6734daf841ce474c5b5c95846d8b2f646f2ffae2`.
- Mapswitch BIN: `_mapswitch.bin`, 4,194,304 bytes, SHA-256 `ffe80b4d80975398e907c99f3156f0052c66a6eaf99d96a2d00c6c19f0726832`.
- The captured DME string is `6MC9ED0B`, different from the SGBD target. SGBD semantics are strong clues, not proof of every address or behavior on this software.

## Identity protocol

The MHD F82 capture sends from tester `F4` to DME `12`:

| Frames | Request / response | Observed result |
|---|---|---|
| 29 / 33 | `22 F1 01` / `62 F1 01` | Current SVK (`F101`). |
| 35 / 38 | `22 F1 50` / `62 F1 50` | Three response bytes `0F 1E A0`. |
| 46 / 49 | `22 F1 8B` / `62 F1 8B` | `14 08 07`; the SGBD calls this ECU manufacturing date, plausibly 2014-08-07. |
| 51 / 54 | `22 F1 03` / `62 F1 03` | Factory SVK per SGBD `SVK_ID` table. |
| 56 / 59 | `22 F1 02` / `62 F1 02` | Supplier SVK per SGBD `SVK_ID` table. |
| 61 / 65 | `31 01 02 05 08 00 00 26 0B 1D 28 FE` / `71 01 02 05 ...` | SWE metadata including `MEVD17.2.G`, `6MC9ED0B`, and `510_S55_BG2_EU6_DKG_254`. |
| 67 / 71 | `31 01 02 05 06 00 00 1A 83 0A 3B 02` / `71 01 02 05 ...` | Bootloader metadata string. |
| 73 / 76 | `22 F1 90` / `62 F1 90` | VIN `WBS3R92010K340307`. |

The F101 versioned records decode as:

| Process class | Identifier | Version bytes | Interpretation |
|---|---|---|---|
| HWEL (`01`) | `000019DE` | `0A 13 01` | Hardware element identifier/version; **not** a hardware serial number. |
| BTLD (`06`) | `00001A83` | `0A 3B 02` | Bootloader identifier/version. |
| SWFL (`08`) | `00001A84` | `1D 28 01` | Software flash element; matches BIN filename and embedded bytes. |
| SWFL (`08`) | `0000260B` | `1D 28 FE` | Another software flash element. |
| CAFD (`05`) | `00000B0A` | `00 73 02` | Coding data identifier/version. |

The SGBD `PROZESSKLASSEN` table at about line 328 maps the class bytes. The `SVK_ID` table at about line 360 maps `F101` actual, `F102` supplier, and `F103` factory. The latter two responses contain different software versions from F101; this supports a difference between the current and reference inventories, but does not establish when or why it changed. `SERIENNUMMER_LESEN` at about line 76721 uses `22 F1 8C` for the separate ECU serial number. That serial request is not shown in the MHD sequence above.

The three SVK replies have the same HWEL `000019DE/0A1301`, but different other records:

| SVK reply | BTLD `00001A83` | SWFL `00001A84` | Other SWFL | `PROG_DATUM` bytes |
|---|---|---|---|---|
| F101 actual (frame 33) | `0A3B02` | `1D2801` | `0000260B/1D28FE` | `19 06 03` → 03.06.19 |
| F103 factory (frame 54) | `0A3B01` | `13C802` | `0000260B/13C8C7` | `14 09 01` → 01.09.14 |
| F102 supplier (frame 59) | `0A3B01` | `13C802` | `00001A85/13C801` | `08 10 13` → 13.10.08 |

The dates follow the SGBD `SVK_LESEN` extraction at about lines 27740–27871; they describe fields in those SVK records, not an independently verified vehicle service history. The current-versus-factory versions are consistent with software having changed, but do not identify who made the change or whether it was a standard update or a tune.

Additional MHD identity reads at frames 100–126 include `22 33 50`, which replies `62 33 50 05 00 00 0B 0A 00 73 02`. The identifier/version bytes independently match the CAFD record in F101. `22 37 FE` replies with ASCII `K340307`, the last seven VIN characters. Reads of `33 00`, `33 20`, and `33 51` also succeed, but their full payload semantics are not established here. In the BM3 F82 scan/delete/read capture, `22 F1 86` returns `62 F1 86 01 81` (the SGBD labels F186 ActiveDiagnosticSession), while `22 40 98` is rejected with `7F 22 31`; the SGBD calls 4098 a startup-block ID. These outcomes should be recorded as observed rather than treated as universal DME support.

## Captured memory mapping

In `260913_BM3_DMERead_S55.pcapng`, BM3 issues 128 `23 24` requests. Address `0x80180000` is read first, then contiguous 0x0FFC-byte blocks through exclusive end `0x801FFC00`; the final block is 0x0DFC bytes. Total positive `0x63` data is **523,264 bytes** (`0x7FC00`). After TCP reassembly, that complete data equals the base BIN slice at file offsets `0x180000:0x1FFC00` byte for byte. `260911_BM3_ScanDeleteDMERead_S55.pcapng` contains two such sequences.

Thus the captured DME's *returned bytes in this 511 KiB window* matched the later supplied base BIN exactly at the time of the BM3 capture. This is stronger than merely matching identifiers and supports stock-like data in that window. It still cannot establish the rest of the 4 MB image, a hidden runtime overlay, whether the ECU was modified elsewhere, or the state at a later date.

All 42,267 base-versus-mapswitch differences fall **inside** this BM3-read window. Therefore the BM3 capture also establishes that the DME returned the base `C3` bytes at every one of those positions, not the mapswitch variant's inserted bytes, at capture time. It does not rule out a later flash, a separate memory bank, or a runtime overlay invisible to this request.

This proves the mapping `file offset = DME address - 0x80000000` **for this captured window**. It does not prove that mapping for all 4 MB, or explain how the whole MHD BIN was assembled.

The MHD capture itself has three short DME `0x23` reads per repeated connection: `0x801FFA40` (16 bytes), `0xD0000000` (64 bytes), and `0x801FFA00` (64 bytes), at frames 78, 83, 88. The two `0x801FFxxx` responses are `C3` bytes, matching the base BIN. `0xD0000000` lies outside the observed BIN address mapping. The capture contains insufficient read traffic to reconstruct a 4 MB file; the source of its other bytes remains unproven.

MHD's own [FAQ](https://mhdtuning.com/pages/faq) says it cannot save a third-party tuned map as a backup and can return to an OEM map without a stock backup. This vendor statement and the short-read-only capture make **OEM reconstruction from identity plus a software library** a strong explanation for this 4 MB file. This is an inference about the supplied file, not proof of the exact internal MHD workflow. In particular, the file's apparent stock bytes do **not** prove that all those bytes were installed on the captured DME or that the vehicle was untuned.

The MHD N20 bench BIN-read capture (`261002_MHD_binRead_N20Bench.pcap`) uses the **same three requests, addresses, and lengths**, in the same order (frames 62, 67, 73, repeated at 179, 184, 190). Both ECUs return `C3` for the two `0x801FFxxx` reads, matching the corresponding offsets in each BIN. Their 64-byte `0xD0000000` responses are nonzero and differ from one another. This repeated cross-ECU pattern makes a standard MHD identification/probe sequence more likely than an S55-specific extraction step. The role of `0xD0000000` has not been established for these exact ECUs.

Hardware-documentation clue: [EVC's MEVD17.2.G listing](https://www.evc.de/en/product/bsl/ecu.asp?filtertyp=MEVD17.2.G) names the TC1797 and 4 MB memory. [Infineon's TC1797 errata](https://www.infineon.com/dgdl/TC1797_AC_Errata_Sheet_v1_4_01961A.pdf?fileId=db3a3043271faefd01273e5e2dcc693e) calls address `D000000C` part of LDRAM and says its post-reset contents can be overwritten by user data. If that processor identification applies to this DME, the MHD `0xD0000000` read is from local RAM, not the 4 MB flash image. This is a supported architectural interpretation, not direct proof of what MHD does with the 64 returned bytes.

The SGBD `SPEICHER_LESEN_ASCII` job (about line 238545) describes UDS `0x23` and supports lengths 1 to 4095. Its instructions choose address-and-length format `0x14` for a one-byte length and `0x24` for a two-byte length. The BM3 0x0FFC reads use `0x24`, consistent with that format. The SGBD's DTC entries, such as `0x1B0A40`, are **fault codes**, not file offsets or flash addresses.

## BIN comparison: key finding

The two BINs differ at 42,267 individual byte positions, all from file offset `0x1DBE8C` through `0x1E6457` (corresponding to `0x801DBE8C` through `0x801E6457` within the observed mapping). **Every changed base byte is `C3`.** In fact the base BIN has one continuous `C3` region from `0x1DBE8C` through `0x1FFB0B`, 146,560 bytes. The mapswitch BIN fills the first ~42.4 KB of that region with structured data and leaves the remaining bytes and all other file positions identical to the base. The 42,444-byte span includes 177 bytes that remain `C3` by coincidence.

The inserted data has repeated blocks and 16-bit-looking sequences (for example `0B 86 0B 60 ...` and `33 0B` repeated near the end). This is consistent with tables or a generated payload, but no map name, axis, unit, or execution path has yet been established. A little-endian pointer to `0x801DBE8C`, the **start** of this region, already exists at file offsets `0x154BA4` and `0x1FFB70` in both BINs. The first is the last entry in an ascending address table that points into the preceding data, so it may mark that table's end. The second sits after a software identifier string. Neither reference proves the inserted content is used at runtime. No existing byte outside this `C3` area changes, so this comparison alone does not show a redirected code path or prove that mapswitch functionality is active. It also does not show that the variant was installed on the DME.

MHD's [S55 product description](https://mhdtuning.com/products/mhd-super-license-for-s55) says on-the-fly switching uses MHD+ custom code. This supplied `_mapswitch.bin` differs only in the calibration-region fill and contains repeated table payloads; it does not by itself document the custom-code installation. The file may be a generated preparation/reference artifact rather than a complete flashed DME image. The capture contains no programming transfer with which to settle that question.

The address-table interpretation has more support: following aligned 32-bit little-endian words backward from `0x154BA4` yields **627 monotonically increasing addresses** from file offset `0x1541DC` onward, ending at `0x801DBE8C`. The first 77 have an `A0` high byte and the next 550 have an `80` high byte; after normalizing that high-byte difference, their target addresses continue increasing. The preceding word is `0x9000A000`, not a continuation of that address sequence. The final entry points exactly one byte past the preceding populated data, consistent with an end boundary. Whether the DME's code uses this table and how it handles the `A0`/`80` distinction remain to be established.

Cross-image check: the N20 bench BIN has the same structural pattern. Its calibration-region data ends at file offset `0x1DA623`, followed by `C3` from `0x1DA624` to `0x1FFB0B`. The next address in its table (at `0x10E1C0`) and the footer word at `0x1FFB70` both contain the little-endian value `0x801DA624`, exactly that `C3` boundary. The S55 equivalents both contain `0x801DBE8C`. Both images also have a large `C3` run ending at `0x17FB0B` and another ending at `0x3FFB6F`. This repeated layout supports `C3` as deliberate image fill after populated sections; it does not by itself establish whether that fill is safely writable or how a programming tool would update it.

As a limited code check, Capstone in TriCore 1.3.1 mode decodes instructions in the BIN's populated code region near offset `0x400`, but decodes **no instruction** from `C3 C3 ...` at `0x1DBE8C`. That is consistent with filler rather than executable code; it is not a complete control-flow analysis.

An exact-substring search gives stronger evidence about the inserted content. At least **35,091 of the 42,267 changed bytes** lie in 64-byte-or-longer spans that also occur verbatim elsewhere in the base BIN (the scan sampled 32-byte anchors every 64 bytes, so this is a lower bound, not a full reconstruction). Examples:

| Existing base BIN source | Mapswitch BIN destinations | Exact repeated span |
|---|---|---:|
| `0x196012–0x196251` | Five consecutive copies starting `0x1DC2F6`, stride 578 bytes | 576 bytes each |
| `0x1B541E–0x1B55FD` | Five consecutive copies starting `0x1DE888`, stride 482 bytes | 480 bytes each |
| `0x1AFA86–0x1AFD4D` | Five consecutive copies starting `0x1E29E8`, stride 714 bytes | 712 bytes each |
| `0x1B005E–0x1B0369` | Five consecutive copies starting `0x1E532A`, stride 782 bytes | 780 bytes each |

Thus much of the mapswitch artifact duplicates existing calibration-region material rather than introducing wholly novel values. The five copies may represent a base/reference plus selectable slots, but that interpretation is **not proven** by byte repetition alone. MHD's own [S55 product description](https://mhdtuning.com/products/mhd-super-license-for-s55) says its on-the-fly map switching offers four slots, which makes that hypothesis worth testing against actual selection logic.

Five distinct copied payloads fit a concrete 16-bit grid layout. The first two source bytes give counts `X,Y`; the payload length is exactly `2 × (X + Y + X×Y)` bytes, and both decoded little-endian axes are monotonic. A scan of the base calibration window for candidate count bytes 4–32, monotonic axes, and at least four exact matches inside the inserted span found six source locations representing these five unique payloads:

| Base source header | Dimensions | Payload length | Destination copies | Axis observations |
|---|---:|---:|---|---|
| `0x1887B6`: `0A 08` | 10×8 | 196 | Start `0x1DE43C`, stride 198 | X = 1000–7500; Y raw = 65411–65506, possibly signed values. |
| `0x196010`: `10 10` | 16×16 | 576 | Start `0x1DC2F4`, stride 578 | X = 500–6900, Y = 1200–16000; all 256 values are `0x8000`. |
| `0x1AFA84`: `14 10` | 20×16 | 712 | Start `0x1E29E6`, stride 714 | X = 8274–26214, Y = 0–51008; grid values vary. |
| `0x1B005C`: `16 10` | 22×16 | 780 | Start `0x1E5328`, stride 782 | X = 8192–20480, Y = 550–8000; grid values vary. |
| `0x1B57D0` and `0x1B5AD0`: `06 06` | 6×6 | 96 | Ten exact payload matches starting `0x1E159C`, stride 98 | The two source tables are identical; X = 2000–12000, Y = 200–900. |

Each copied payload is **byte-identical** to its source payload in the listed repetitions, while the two bytes before the copy differ from the source header (usually `00 00`; one final 22×16 copy has `C3 C3`). This is stronger evidence for duplicated two-axis calibration data than repetition alone. It does **not** identify physical units, map purpose, or the meaning of the modified two-byte prefix. The scan's axis-count range and matching criteria limit what it can detect; other copied spans need their own structural checks.

A byte-by-byte scan of the inserted span found no literal 32-bit little-endian address pointing back inside that span. This only rules out that simple pointer representation; it cannot rule out relative offsets, encoded references, or code outside the supplied image.

The base BIN contains `6MC9ED0B` and `MEVD17.2.G` at multiple offsets, and ASCII `10SW018905` near offset `0x18001E`. Those strings are identifiers, not proof that the entire image is factory stock.

The 32 bytes following the pointer at `0x1FFB70` are identical in both files, despite the 42,267 changed bytes. Their purpose is unknown. MD5, SHA-1, and SHA-256 checks over 48 plausible section slices (144 hashes) found no direct match, including reversed digest bytes. This does not prove they are or are not an integrity field. Consequently the mapswitch BIN should not be assumed to be a flash-ready, integrity-correct image.

## Captured control and diagnostic state changes

| Capture / frame | Tester request | SGBD correspondence | What can be concluded |
|---|---|---|---|
| BM3 scan/delete/read, 819 | `F4 > DF: 14 FF FF FF` | `FS_LOESCHEN` (`ClearDiagnosticInformation`, all DTCs) | A fault-memory clear was requested; positive `54` replies include DME `12` at frame 854. |
| Same, 878 | `F4 > DF: 31 01 0F 06` | `IS_LOESCHEN` describes secondary DTC memory clearing | A separate routine was requested. |
| Same, 1050 / 1066 / 1083 | `F4 > 12: 2E 5F FD 01`, then `00`, `00` | `STEUERN_SOUNDTUNING_DEAK`, about line 573917 | SGBD says 1 deactivates sound tuning and 0 activates it. DME acknowledged with `6E 5F FD`. Persistence is not established by the capture. |
| Same, 2982 | `F4 > DF: 11 01` | `STEUERGERAETE_RESET`, hard reset | Broadcast reset was requested; 25 ECU addresses send positive replies, including DME `12` at frame 3001. The SGBD job addresses DME `12` directly. |
| BM3 flap capture, 156 / 171 | `2F 60 FD 03 14 7A FA FF`, then `2F 60 FD 00` | `STEUERN_EL_AGK` / `STEUERN_ENDE_EL_AGK`, about lines 597406 and 597174 | Exhaust flap input/output control then end control; `6F` acknowledgements observed. |
| BM3 flap2 capture, 192 | `2F 60 FD 03 EB 85 FA FF` | Same flap control job | Alternate duty value. |

The SGBD flap job for its listed software expresses duty ratio in percent with a factor `0.00152587890625` percent per count. Applying that definition to the captured `14 7A` and `EB 85` big-endian values gives approximately **8.00%** and **92.00%**. Its second argument is timeout in seconds, encoded at half the requested seconds; `FA` corresponds to **500 s**. The captured F82 runs a different software string, so this scaling remains a strong candidate rather than an independently verified measurement. The captures do not show which physical flap position each ratio produced.

In current BimmerScope Rust, mode `open` sends `2F 60 FD 03 14 7A FA FF` (about 8%, 500 s), while `closed` sends `2F 60 FD 03 EB 85 0A FF` (about 92%, **20 s**). Both are refreshed every five seconds by the shared vehicle loop, including while telemetry is paused. The BM3 flap2 capture uses `EB 85 FA FF` (92%, **500 s**), so BimmerScope's Closed timeout differs from that captured BM3 variant. `auto` sends `2F 60 FD 00` to end control. The app's Open/Closed names are a control convention; neither the `6F` acknowledgement nor these PCAPs supply a measured physical flap position to validate that naming.

Broadcast scope is concrete in the BM3 scan/delete/read capture. After frame 819's `14 FF FF FF`, **21 distinct ECU source addresses** send `54` positive replies before the next command; DME `12` first reports `7F 14 78` (response pending) at frame 844 and then `54` at frame 854. After frame 2982's `11 01`, **25 distinct ECU source addresses** send `51 01` positive replies, including DME `12` at frame 3001. A positive reply confirms that an ECU accepted the request, not that every ECU completed its reboot cleanly. This is a multi-ECU operation, not a DME-only request.

The current BimmerScope `reset_engine_dme` implementation in `rust/src/api/vehicle.rs` also sends `11 01` to broadcast `DF` and waits specifically for DME `12`'s acknowledgement. Its UI calls the action **Reset DME** and warns that the engine must be off. The implementation comment acknowledges that `DF` can reach multiple ECUs, but the button text does not convey the scope shown by the capture. Likewise, the app's clear-DTC profile targets broadcast `DF` before verifying DME faults directly; the capture shows other modules also acknowledge the clear. These are product-scope findings to resolve before relying on the actions on a car. The SGBD `STEUERGERAETE_RESET` job demonstrates a direct-to-`12` reset form, but the supplied captures do not prove how that direct form behaves on this F82.

The F82 DME's `51 01` reply arrives only **25 ms** after BM3 sends the broadcast reset (frames 2982/3001). BM3's next DME diagnostic request in this capture is about **7.5 s** later; a fresh F101 response succeeds about **7.78 s** after the reset. In the N20 bench reset capture, the DME replies `51 01` after **28 ms**, and a later F101 reply succeeds about **5.11 s** after reset. There are no intervening probes proving exactly when either DME became ready. These timings show that the positive reset reply is an acknowledgement, not a demonstrated post-reset identity check. BimmerScope currently returns success after that acknowledgement without re-identifying the DME.

### Identity jobs checked against every supplied F82 capture

`IDENT` in the S55 SGBD (about line 7053) sends `22 F1 50` and calls the result an **SGBD index for ECU variant detection**. In the MHD F82 BIN-read capture, the DME returns `62 F1 50 0F 1E A0` (frame 38, repeated at 157). The N20 bench MHD BIN-read capture returns `62 F1 50 0F 18 10` (frames 22 and 139). The actual SGBD parser at lines 7277–7331 computes `S3[3] << 16` + `S3[4] << 8` + `S3[5]`, so each response is **one unsigned, big-endian 24-bit index**, not three separate fields: F82 `0x0F1EA0` (990880 decimal), N20 `0x0F1810` (989200 decimal). These indexes are not DME serial numbers, flash addresses, or proof of tune state. No literal mapping for either index was found in this S55 B1V; their downstream variant-selection meaning remains open.

`SERIENNUMMER_LESEN` (about line 76721) sends `22 F1 8C` and labels the result **ECUSerialNumber**. `HERSTELLINFO_LESEN` (about line 140154) reads `22 F1 8A` for supplier and `22 F1 8B` for manufacture data. A scan of all supplied **F82** PCAP TCP payloads found `22 F1 8B` with positive `62 F1 8B 14 08 07` in both BM3 and MHD captures, but **no `22 F1 8A` or `22 F1 8C` requests or responses**. Thus the actual DME serial and the F18A supplier value cannot be recovered from these captures. `14 08 07` is the reported manufacture-date payload, not a unique hardware ID.

The `SPEICHER_LESEN_ASCII` comment describes `ADRESSE` as `0x00000000–0xFFFFFF` (about line 238553), yet its instruction sequence copies **four** address bytes and chooses UDS address/length formats `0x14` and `0x24`. The successful captured `23 24 80 18 ...` BM3 reads independently show a four-byte `0x8018....` address on this DME. Treat the comment's 24-bit maximum as stale or incomplete documentation for this job; it must not be used to truncate a captured flash address.

BM3 also issues `2C 03 F3 01` (clear a dynamic DID) followed by `2C 02 F3 01 24 ...` (attempt to define `F301` using a memory address). In the scan/delete/read capture, it tries each of five addresses five times: `0x807FFE50`, `0x0977FE4C`, `0x801FFDAC`, `0x8005FE1E`, and `0x8000FD9E`, each with length `0x00FF`. **Every one of the 25 define requests receives `7F 2C 31`** (request out of range); there is no `22 F3 01` read in that capture. The preceding `2C 03 F3 01` clear requests receive positive `6C 03 F3 01` replies. The SGBD `STATUS_BLOCK_LESEN` explicitly says its job does not support memory-address definition; these capture results show the same attempted path failing on this DME. These attempts did not create a usable data block and did not write flash.

The four supplied BM3 N20 bench captures show the same pattern: 29 `2C 02` define attempts in total, all rejected with `7F 2C 31`, while the corresponding clears succeed. This supports the interpretation that BM3 is probing a generic dynamic-memory method across ECU types rather than successfully reading an S55-specific map selector.

No F82 request for UDS `0x27` SecurityAccess or the programming transfer services `0x34/0x36/0x37` was found in these captures. This **does not establish** the DME's unlock state; it only limits what these captures demonstrate.

## Product implications and next offline experiments

### Reset-information DID `22 40 99` (11 October 2026 follow-up)

The English S55 B1V's `_STATUS_RB_RESET_INFO` job (line 492686 onward) is marked **Development** and sends `22 40 99` to DME address `12`, expecting a `62 40 99` response. Its parser indexes the diagnostic response **including** the three-byte positive-response header. It interprets multi-byte values in big-endian order. The layout implied by the parser is:

| Response byte offsets | Result | Width |
|---|---|---:|
| `0x00–0x02` | `62 40 99` header | 3 |
| `0x03` | power-on-reset type | 1 |
| `0x04–0x07` | power-on-reset result | 4 |
| `0x08–0x0B`, `0x0C–0x0F` | power-on-reset extra information 1 and 2 | 4 each |
| `0x10–0x1F` | reset history entries 0–7 | 2 each |
| `0x20–0x21` | recent reset cause/type | 2 |
| `0x22` | last-reset group | 1 |
| `0x23` | reset count since power-on, including power-on reset | 1 |
| `0x24–0x27`, `0x28–0x2B` | last-reset extra information 1 and 2 | 4 each |

This parser accesses through offset `0x2B`, implying at least **44 diagnostic response bytes** for all fields. The labels provide no cause-code lookup or timing units. A raw response would need its own length, header, and field validation before using these interpretations. The SGBD's older `6MC2EB2B` software target still makes the entire layout a candidate for the captured `6MC9ED0B` F82, not a confirmed F82 decoder.

I scanned TCP payloads in all **20 supplied F82 and N20 PCAP/PCAPNG files** with `tshark`, looking for either `22 40 99` or `62 40 99`; neither sequence occurred. This includes both BM3 N20 reset captures. The scan is packet-payload based, so a request split across TCP segments precisely within this short sequence could evade it; no positive evidence for the DID was found. The observed F82 and N20 `11 01` reset captures therefore cannot be paired with reset-history data. A future read-only, direct-to-DME probe could check support and capture an uninterpreted raw response, but nothing in the supplied traffic establishes support, decoded cause values, or reboot completion time.

### Current BimmerScope source check

`rust/src/api/vehicle.rs` currently formats each seven-byte SVK record as an eight-character hex identifier followed by **three zero-padded decimal byte values**. Therefore the F82's raw SWFL `00 00 1A 84 1D 28 01` becomes `00001A84029040001`, whereas the BIN filename uses the raw hex form `00001A841D2801`. Both represent the same identifier/version bytes in different notation.

The `Read DME 2` validation path compares the captured F82 VIN with `BM3_S55_READ_VIN`, then compares its decoded software with `BM3_S55_READ_SOFTWARE`. The latter is currently `00001C9F029150001`, which is the decoded **N20 bench** SWFL `00001C9F/1D9601`, not this F82's `00001A84/1D2801`. Consequently the captured F82 identity would fail this guard before any BM3-pattern memory read. This is a source-level mismatch, not a vehicle response failure. The current worktree has user changes in this Rust file, so any correction should be made deliberately in the app task and tested against the exact captured F101 bytes.

The same decoder assigns F101's second `08` process-class record (`0000260B/1D28FE`) to a field named `calibration`. The SGBD identifies **both** `00001A84` and `0000260B` as SWFL class `08`; the field name should not be treated as proof that `0000260B` is a specific calibration map. The factory and supplier decoders use the same field convention.

1. Preserve separate identity fields: VIN, F101 actual SVK, F102 supplier SVK, F103 factory SVK, `F18B` manufacturing date, optional `F18C` serial, and `31 01 02 05` software metadata. Never use `6MC9ED0B` or `000019DE` as a hardware serial.
2. Treat the base and mapswitch BINs as distinct immutable artifacts. Their common filename identifier and most shared bytes do not prove equivalent behavior.
3. Trace the two boundary references at file offsets `0x154BA4` and `0x1FFB70`, then inspect the inserted structures before naming them maps. Check whether any runtime selector or hook exists outside the compared 4 MB or is applied later by a flashing process.
4. Identify why BM3 probes those five `2C 02 F3 01` addresses despite repeated `7F 2C 31` replies, and whether it falls back to another supported telemetry path. Do not treat this failed dynamic-DID attempt as a working feature.
5. If a future actual-car session is available, collect read-only F101/F102/F103, F18A/F18B/F18C, VIN, and software metadata with timestamps and VIN-bound provenance. Do not infer unlock or flash capability from the offline files.

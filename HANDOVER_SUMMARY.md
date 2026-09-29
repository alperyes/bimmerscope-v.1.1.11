# BimmerScope `1.1.8-experimental.1+73` handover

## Current v1.1.8 state — 28 September 2026

- Workspace: `C:\Users\alper\Desktop\v1.1.8`
- Branch: `codex/experimental-v1.1.8`
- GitHub remote: `https://github.com/alperyes/bimmerscope-v1.1.8.git`
- Version: `1.1.8-experimental.1+73`; Tune package: `com.bmwenet.bmw_app.tune`.
- Target vehicle: user's stock 2014 BMW F82 M4 with DCT. Actual DME software
  and unlock state remain unverified.
- Latest Tune debug APK: `build\app\outputs\flutter-apk\BimmerScope-v1.1.8-experimental.1+73-tune-debug.apk`.
  Package metadata verified as `com.bmwenet.bmw_app.tune`, version code 73;
  SHA-256: `3EDC8DCA7F557097283131207AF5068D3964850E8EF9A167C87B7982E195B500`.
  It has not been copied to or installed on the phone; the user plans to test
  the revised live Open request later.
- This update includes Tune and diagnostics layout/content refinements, DME
  identity formatting, the Android hotspot-settings shortcut, a dedicated
  automatic pull-logging settings page, safer saved-log rename handling, and
  BM3-captured trailing bytes (`FA FF`) for live exhaust-flap Open requests.
- Sidebar/About version fallback in `lib/app/build_info.dart` and `pubspec.yaml`
  now identify build `1.1.8-experimental.1+73`.
- Live Open requests now use the BM3-captured `FA FF` trailing bytes; Close,
  Auto, and the separate experimental ISTA service-test request are unchanged.
  This is only protocol matching based on the capture, not confirmed flap
  behavior on the user's vehicle.
- Validation: `flutter analyze` passes with no issues; `flutter test` passes
  48/48; `cargo test --manifest-path rust\Cargo.toml` passes 68/68 (two
  existing dead-code warnings); `git diff --check` is clean. Tune APK build
  succeeded and its package/version were verified.
- Physical-vehicle reliability remains unverified. The user previously
  reported intermittent initial connection and flap commands that sometimes
  did not respond until cycling ignition and reconnecting, including an
  occurrence around 16:40–16:41. Screen-off connection drops were also
  reported. The current Rust live worker serializes flap requests and waits
  for DME acknowledgement, but this does not establish reliable car behavior.
- Continue bench/vehicle validation cautiously; inspect timestamped diagnostics
  around failed first connections and flap acknowledgements before altering
  transport recovery behavior.
- No ECU flashing, unlocking, coding, or calibration writing is enabled.

## Historical v1.1.7 and earlier handover notes

## Current v1.1.7 state — 18 September 2026

- Workspace: `C:\Users\alper\Desktop\v1.1.7`
- Branch: `codex/experimental-v1.1.7`
- Version: `1.1.7-experimental.1+49`
- Created from the complete v1.1.6 working tree, including its intentional
  uncommitted Flutter, Rust, diagnostics, safety, and UI changes.
- Generated `build` and `.dart_tool` directories were not copied initially;
  they were regenerated during verification. The v1.1.7 APK has not been
  installed on a phone.
- Fresh v1.1.7 verification: Flutter analysis passed and Flutter tests passed
  46/46. Rust tests were not rerun during workspace creation.
- The latest physical-phone installation remains v1.1.6 build 48 on device
  `HS621L001389`; its existing application data was preserved during install.
- Current UI baseline includes the unified status system, restored Clear DTCs
  availability after completed scans, and original flap controls with only a
  selected Open position highlighted orange.
- Header connection status is intentionally glanceable: the right-side chip
  uses a readable label, semantic icon, stronger contrast, and a compact pill
  rather than a dot-only indicator.
- Tune debug APK: `build\app\outputs\flutter-apk\BimmerScope-v1.1.7-experimental.1+49-tune-debug.apk`
- APK SHA-256: `6AF02A6CC7AED84A5A87419D2D7F81EF7ED4390C9D392DDA1326AC8078769F73`
- No ECU flashing, unlocking, coding, or calibration writing is enabled.

## v1.1.6 source baseline — 17 September 2026

- Workspace: `C:\Users\alper\Desktop\v1.1.6`
- Branch: `codex/experimental-v1.1.6`
- App diagnostics capture levels now control both Flutter session records and
  Rust ENET/HSFZ transport records when the next session starts.
- Normal records transport lifecycle, retries, errors, and timeouts. Detailed
  adds request/response metadata and correlation. Trace additionally records
  raw payload hex.
- Transport records include request ID, addressing, service, identifier,
  timing, correlation status, queue depth, and socket lifecycle information.
- Live telemetry now enforces a define/read/clear transaction state machine.
  Responses must match the expected HSFZ message type, ECU source, tester
  destination, UDS service, dynamic identifier, and transaction stage. Late,
  unrelated, echoed, and out-of-order frames are logged and ignored.
- ECU identity, DTC, calibration-read, and standalone flap response readers
  also enforce the requested ECU source and expected response prefix.
- Telemetry-gap records include the previous successful channel and timestamp,
  correlated poll transaction and age, reconnect count, socket state,
  per-channel sample ages, recovery action, and recovery result.
- Vehicle I/O now has one process-wide diagnostic owner. A live session and a
  standalone DTC, identity, calibration-read, or flap service can no longer
  open competing ENET sockets.
- Service handoff stops the live worker and waits up to five seconds for its
  socket and ownership lease to be released; the previous fixed delay is gone.
- Standalone services freshly read VIN and DME identity at address `0x12`
  immediately before proceeding and reject a mismatch with the active binding.
  Live flap position commands remain serialized through the live worker.
- The offline Rust programming boundary now requires sampled supply voltage,
  ignition state, and profile-required current evidence before mutation. It
  rejects missing, unstable, out-of-range, or stale evidence and journals the
  accepted sample count and measured ranges. No production hardware source or
  approved S55 write profile exists, so real writing remains disabled.
- Diagnostics now derives disconnected, discovering, connected, scanning,
  results, interrupted, and unsupported presentation from one view-state
  model. Monitoring and degraded live sessions correctly remain scan-capable,
  and empty-state instructions no longer contradict the connection status.
- The Diagnostics header now matches the shared centered BimmerScope mark,
  leading menu, and compact trailing connection-status pattern used elsewhere.
  Connection details and the read-only label sit with the scan task.
- Status colors now follow one semantic system across shared connection and
  Diagnostics UI: green means connected or verified, amber means degraded or
  incomplete, red means failure or unsafe, blue means active work, and grey
  means unavailable or not started. Statuses pair color with text and an icon;
  selectable connection controls no longer use success green.
- Clear DTCs remains available after every completed scan, including a clean
  result, and is disabled only while a clear request is already in progress.
- Flap controls retain their original layout and styling, except the selected
  Open position uses orange for quick recognition while driving.
- Bottom navigation now uses the standardized `Vehicle`, `Monitor`, `Diagnose`,
  `Logs`, and conditional `Tune` labels. Inactive items have higher contrast,
  selected items use a tinted shape indicator plus color and weight, and Tune
  remains available only in the Tune edition.
- Capture is bounded at 8 MiB for the Rust transport journal and 12 MiB for
  high-volume Flutter Trace records. Saved diagnostics retain at most 64 MiB
  overall and ten raw transport archives.
- Verification: Flutter analysis passed, Flutter tests passed 46/46, Rust
  tests passed 63/63, and the Tune debug APK rebuilt successfully.
- Last v1.1.6 APK: `C:\Users\alper\Desktop\v1.1.6\build\app\outputs\flutter-apk\BimmerScope-v1.1.6-experimental.1+48-tune-debug.apk`
- APK SHA-256: `5BFD3C237EE6556D86C580D2A114817392A255951D57E57F3500E9B9A8907C18`
- The APK has not been installed on a phone or tested against a vehicle.
- No ECU flashing, unlocking, coding, or calibration writing was added.

## Current v1.1.5 state — 16 September 2026

- Workspace: `C:\Users\alper\Desktop\v1.1.5`
- Branch: `codex/experimental-v1.1.5`
- Starting commit: `afd7a3b` (`Start experimental v1.1.5`)
- GitHub remote: not configured
- `.vscode/` remains an inherited untracked folder and is untouched.
- Flutter tests: 44/44 passed.
- Rust tests: 43/43 passed; two existing dead-code warnings remain.

The first v1.1.5 Tune APK was built successfully and was not installed:

- file: `build\app\outputs\flutter-apk\BimmerScope-v1.1.5-experimental.1+47-tune-debug.apk`
- package: `com.bmwenet.bmw_app.tune`
- application label: `BimmerScope Tune`
- version name / code: `1.1.5-experimental.1` / `47`
- minimum / target SDK: `24` / `36`
- SHA-256: `D2B0551F288B15B92BCC374A89A635C6E2925629ADBB9BF641DACB8AB1BAFBBA`
- signature: Android debug certificate, APK Signature Scheme v2 verified
- native architectures: ARM64, ARMv7, and x86-64; each contains the Rust core
- ZIP entries: 570; no unsafe archive paths detected

The experimental write-backend work remains disabled for real vehicles. It
contains an offline Dart transaction/journal prototype and a synthetic Rust
memory target with exact fingerprint binding, exclusive process-local access,
durable intent/result records, interruption classification, and explicit
synthetic recovery tests. No production S55 support profile is registered.

Static analysis of an authentic MHD F-Series v1.01 APK provided clean-room
architectural evidence for an F8x S55 programming lifecycle and software family
`00001A84`. That legacy application uses FTDI/serial BMW/KWP framing, not the
ENET/HSFZ transport used by BimmerScope. No MHD keys, licensing mechanisms,
patch bytes, or proprietary source were copied into this project.

The next hardware-dependent milestone is a complete, authorized packet capture
for the exact target DME/bootloader and a matching sacrificial bench DME with a
documented recovery route. Keep production writing, coding, flashing, and
unlocking disabled until that evidence exists.

## Earlier recovery history

This workspace is an experimental continuation of the previous BimmerScope
release. The known-good Git starting point is tagged
`v1.1.4-experimental-base`; ongoing work belongs on
`codex/experimental-v1.1.4`. The older v1.1.3 workspace remains a separate
fallback and is not modified by this repository.

## What this folder is

`C:\\Users\\alper\\Desktop\\BimmerScope-v1.1.0-dev+24` is a direct Flutter
project root recovered for the Tune APK installed on the phone.

The evidence APK is:

- package: `com.bmwenet.bmw_app.tune`
- version name / code: `1.1.0-dev` / `24`
- SHA-256: `1578F198F6CA6714821F62505808F62F200D75B97356264F7F57110D35DCF768`

## Recovery status

- The APK's debug `kernel_blob.bin` contained the original source text for 42
  application Dart files. Those 42 files in `lib/` are byte-for-byte verified
  against that embedded source.
- The 15 Flutter assets present in the APK were recovered and verified
  byte-for-byte against the APK.
- Android project files, `pubspec.yaml`, and tests originate from the
  `v1.0.0+18` baseline and are supporting reconstruction material. The Rust
  core starts from that baseline, then restores the v24 vehicle-event and
  read-only S55 identity bridge from the original pre-v24 construction-chat
  patches. It compiles against the APK-derived Dart bridge, but cannot be
  proven byte-for-byte original Rust because native source is not stored in
  the APK.
- No source from `+84`, `+87`, `+122`, `+123`, or `+124` was copied into this
  recovery.

## Validation performed locally

- `flutter analyze lib` — passed
- `flutter test` — 11/11 passed
- `cargo test --manifest-path rust\\Cargo.toml` — 16/16 passed
- `flutter build apk --debug --flavor tune --dart-define=BIMMERSCOPE_EDITION=tune`
  — passed locally. Use `tools\\build_android.ps1`, which injects the exact
  `pubspec.yaml` version into the sidebar/About build information and writes
  `build\\app\\outputs\\flutter-apk\\BimmerScope-v1.1.0-dev+24-tune-debug.apk`.
  Its SHA-256 is `159FB5FFEB430C69B45F7BACECC5EDD24A6F16C80A62B838B1FD72442CD35EEB`.

The local build was not installed on a phone or emulator and was not
vehicle-tested. It is a compilation check, not proof of a byte-identical APK
or vehicle behavior.

## Safety boundary

No ECU flashing, calibration writes, unlocking, or security-key guessing is
implemented or authorized. DTC clearing and experimental flap control remain
the only physical write-capable exceptions and require explicit user action.

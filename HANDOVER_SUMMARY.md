# BimmerScope `1.1.5-experimental.1+47` handover

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

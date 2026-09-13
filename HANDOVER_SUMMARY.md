# BimmerScope `1.1.4+1` experimental handover

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

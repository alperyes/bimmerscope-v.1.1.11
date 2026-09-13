# BimmerScope

## APK naming

The version source and APK naming rules are defined in [VERSIONING.md](VERSIONING.md). For this recovered source line, the version is `1.1.0-dev+24`.

Cross-platform Flutter dashboard with a Rust vehicle-protocol core for BMW F-series ENET live data. The first milestone is intentionally read-only and was ported from the `BMWENET3` Python desktop application.

## v24 recovery status

The Dart application layer and Flutter assets in this folder were recovered
directly from the known `1.1.0-dev+24` Tune debug APK. The native Rust core is
reconstructed from the `v1.0.0+18` baseline plus the original pre-v24
construction-chat patches for the v24 vehicle-event and read-only S55 identity
bridge; Android project files remain baseline reconstruction. See
[HANDOVER_SUMMARY.md](HANDOVER_SUMMARY.md) for the evidence and limits.

## Current features

Latest verified Android Tune build: `build/app/outputs/flutter-apk/BimmerScope-v1.0.0+18-tune-debug.apk`. Installed and checked on `emulator-5554`; all four simulator DME states and disconnected/demo isolation passed. See `BIMMERSCOPE_CONTEXT.md` for the artifact hash and verification limits. These checks do not constitute full-app or real-vehicle acceptance.

Recent Tune and reliability work includes VIN-scoped requests and logs, persistent drafts, immutable hash-traceable stock backups, complete tuner-package attachments, simulator DME-state parsing, session-provenance log metadata, a persistent vehicle garage, and timestamp-aware log charts. Flutter and Rust test suites currently pass; the Windows debug build is available under `build/windows/x64/runner/Debug/bmw_app.exe`.

Android build note: the project retains `shared_preferences_android` 2.4.18 as its verified dependency baseline. Use the unmodified pub.dev package, including its string-list deserialization guard. The earlier local `ObjectInputStream` workaround was removed; both examined upstream versions contain the guard source. Legacy JNI packaging remains enabled, and the Tune build was verified with Gradle limited to one worker.

- Android and iOS Flutter application
- Rust HSFZ packet framing and buffered TCP parsing
- Automatic discovery on the standard BMW ENET network and port
- UDS VIN request (`22 F190`)
- Sequential dynamic-DID polling (`2C 01 F300`, `22 F300`, `2C 03 F300`)
- Eleven N55 sensor definitions and calibration values from `BMWENET3/sensor.json`
- Automatic reconnect after connection loss, gateway reset, or a 500 ms ECU timeout
- Responsive live dashboard and session event log
- Core and Tune Android product flavors from one shared codebase
- Tune workspace with stock backups, read-only map comparison, tuner packages, and request history
- Tune vehicle check with simulator-published DME access states; real-car unlock status remains conservative and reports unable to verify until validated
- Log replay with health review flags, channel visibility, and pull interval marking
- Safe demo mode that does not require a vehicle
- Unit and widget tests

No ECU coding, flashing, or calibration-write commands are implemented. Diagnostic DTC clearing remains explicitly guarded and ECU-specific.

## Current handover

The production direction is direct BMW ENET/HSFZ, not generic ELM327/OBD-II or an ENET Wi-Fi bridge. Vgate iCar2 support was removed after hardware testing because it did not provide the BMW ECU transport required by the app. Wi-Fi adapter support is postponed. The Tune edition currently provides preparation and review workflows only; no flashing commands are implemented.

The latest connection work restores the last known stable startup behavior, keeps discovery Ethernet-only, and adds route diagnostics that distinguish a missing Ethernet interface from an unreachable BMW gateway. The current known-good Tune milestone caps live telemetry at four active gauges and serializes flap actuator traffic with sensor polling. The Tune debug APK was installed successfully on physical device `HS621L001389`.

The Diagnostics area includes a dedicated Flap Control page with experimental Open, Auto, Close, and cyclic service-test controls. Open/Closed state persists across transient reconnects and is refreshed through the shared live session until Auto or Disconnect.

The standalone simulator is at `C:\Users\alper\Desktop\BimmerScope Simulator`. It provides F-generation vehicle selection, publishes the selected profile to BimmerScope, and exposes test DME states: Unknown, Unlocked, Locked, and Bench unlock required. Its GUI uses the native Tkinter theme.

## Architecture

```text
Flutter UI  <--- typed event stream --->  Rust core
                                             |
                                      TCP / HSFZ / UDS
                                             |
                                      BMW gateway :6801
```

Flutter owns presentation and lifecycle. Rust owns binary protocol handling, the polling state machine, TCP recovery, sensor decoding, and demo simulation. Generated bridge files live under `lib/src/rust`; edit `rust/src/api/vehicle.rs`, then regenerate them.

## Run

Prerequisites: Flutter 3.38 or newer, Rust, an Android toolchain and/or macOS with Xcode for iOS.

```powershell
flutter pub get
flutter_rust_bridge_codegen generate
flutter run --flavor tune --dart-define=BIMMERSCOPE_EDITION=tune
```

For the Core edition, use `--flavor core --dart-define=BIMMERSCOPE_EDITION=core` instead.

Use **Demo** first. For a real vehicle, connect the phone using a compatible Ethernet adapter, switch on the ignition, and press **Find Vehicle**. BimmerScope checks the common BMW gateway addresses and scans the standard ENET subnet automatically. iOS will ask for local-network permission.

## Verification

```powershell
cargo test --manifest-path rust/Cargo.toml
flutter analyze
flutter test
flutter build apk --debug --flavor tune --dart-define=BIMMERSCOPE_EDITION=tune
flutter build windows --debug
```

The HSFZ tests cover desktop-compatible packet construction, partial/multiple TCP frame buffering, and big-endian sensor decoding.

## Safety roadmap

Diagnostics should be added as read-only services first: ECU discovery, identification, then DTC reading. Any future write, coding, or remapping subsystem must be isolated from the live-data session and require explicit ECU compatibility, voltage, backup, checksum, verification, and recovery controls. Test programming operations against a simulator and bench ECU before any vehicle.

DME unlock detection is read-only. Do not infer unlock state from basic connectivity alone, and do not implement security-key guessing or unlock writes. A real-car capability check must be validated against the exact supported DME family and software version before reporting anything other than `Unable to verify`.

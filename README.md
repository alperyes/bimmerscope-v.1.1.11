# BimmerScope

## APK naming

The version source and APK naming rules are defined in [VERSIONING.md](VERSIONING.md). This workspace is `1.1.8-experimental.1+53`.

Cross-platform Flutter dashboard with a Rust vehicle-protocol core for BMW F-series ENET live data. This is an experimental Tune workspace. Calibration flashing and writing remain disabled; BimmerScope is not a BM3 replacement.

## Release status

This repository contains the v1.1.8 experimental workspace snapshot. See [HANDOVER_SUMMARY.md](HANDOVER_SUMMARY.md) and
[BIMMERSCOPE_PRODUCT_ROADMAP.md](BIMMERSCOPE_PRODUCT_ROADMAP.md) for evidence,
scope, and limits.

## Current features

The v1.1.8 APK has not been built yet. Build and software tests do not constitute full-app or real-vehicle acceptance. Flap command completion waits for a positive DME acknowledgement; vehicle validation is still pending. See `BIMMERSCOPE_CONTEXT.md` and `HANDOVER_SUMMARY.md` for verification limits.

Recent Tune and reliability work includes VIN-scoped requests and logs, persistent drafts, immutable hash-traceable stock backups, complete tuner-package attachments, simulator DME-state parsing, session-provenance log metadata, a persistent vehicle garage, and timestamp-aware log charts. See the handover summary for the latest test evidence and known limitations.

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

Connection diagnostics distinguish local network-route failures from vehicle-session failures. Live telemetry is capped at four active gauges, and flap actuator traffic is serialized with sensor polling. An Android foreground service is used to preserve the vehicle session with the screen off; confirm behavior on the target phone and vehicle before relying on it.

The Diagnostics area includes a dedicated Flap Control page with experimental Open, Auto, and Close controls. Open/Closed state persists across transient reconnects and is refreshed through the shared live session until Auto or Disconnect. The UI reports a command as successful only after a positive DME acknowledgement.

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

# BimmerScope project context

## Known-good flap and telemetry milestone — 5 September 2026

- The latest Tune debug APK was built and installed successfully over USB on physical device `HS621L001389` (`com.bmwenet.bmw_app.tune`).
- Live telemetry is capped at four active gauges. The selected channels are sent to the Rust poller and simulator; selecting a fifth gauge is blocked.
- Flap Open/Closed commands share the live vehicle session, persist across transient reconnects, and are automatically reapplied until Auto or Disconnect.
- Flap IO-control requests are serialized with sensor polling and wait for the ECU `6F` acknowledgement before the next sensor request. Missing acknowledgements trigger reconnect handling.
- Verification: Rust tests `16/16`, Flutter tests `11/11`, and Tune APK build successful. This milestone is considered working for flap control and four-channel telemetry, pending further physical-vehicle soak testing.
- APK output: `C:\Users\alper\Desktop\BimmerScope\build\app\outputs\flutter-apk\app-tune-debug.apk`.

## Latest Android verification — 5 September 2026, 14:24 BST

- Tune `1.0.0+18` built successfully with one Gradle worker and pristine `shared_preferences_android` 2.4.18 sources. The local plain-`ObjectInputStream` workaround has been removed; the original deserialization guard is restored.
- Versioned APK: `build/app/outputs/flutter-apk/BimmerScope-v1.0.0+18-tune-debug.apk`.
- SHA-256: `50b3a8056e528038d877874d6003319123f91acc0e685a178ea640d2b448dabb`.
- Installed on `emulator-5554`; installed package hash matches the versioned APK. Package ID: `com.bmwenet.bmw_app.tune`. Signature verifies; Flutter and Rust libraries are present for ARM32, ARM64 and x86_64.
- Interactive checks on the final APK passed for Unknown, Unlocked, Locked and Bench unlock required. Disconnected and built-in demo sessions correctly report `Unable to verify` while the external simulator publishes `unlocked`. ECU fingerprint evidence remains unavailable in every state.
- Fixed Android Disconnect showing the connection-setup prompt and corrected the F82 demo year to 2014 to match the simulator fixture.
- Current tests: Flutter 11/11, Rust 16/16 (four warnings), simulator Python 14/14. Build/test logs and emulator screenshots/XML are in ignored `.dart_tool/tune_verification/`.
- This was an incremental Android rebuild, not a clean-machine build or full-app acceptance test. The Windows executable was not rebuilt after these two small Dart fixes. No physical Android device or vehicle was tested in this continuation.
- The user reports additional app issues; details are pending. Focus subsequent fixes on those reports. Real F82/S55 fingerprint/channel validation and programming-route decisions remain outstanding. No flashing, unlocking, calibration writing or security-key guessing was added.

## App review and tuning development priorities — 5 September 2026

Read [BimmerScope-review-2026-09-05.md](BimmerScope-review-2026-09-05.md) before planning further development. It contains source-linked findings, verification results, interface improvements and a staged route to validated ECU programming and recovery.

- User-confirmed first target: stock 2014 F82 M4 with DCT. Actual DME software and unlock state have not been verified.
- Prioritize session/simulator isolation, valid vehicle identity, immutable backup history, accurate timestamped logs, S55 channel validation and complete tuner-package attachments.
- Recommended next milestone: reliable identification and logging for the actual car, with a separate investigation into a licensed programming integration or specialist ECU programming development.
- The review records findings, not completed fixes. Check current source before assuming an issue is still present; older status notes below may be superseded by the review's evidence.

## Purpose

Flutter + Rust mobile/desktop app for BMW F-generation vehicles using ENET. Diagnostics, monitoring, and Tune preparation remain read-only by default. The Tune edition is being developed in the same repository as Core; no calibration flashing or writing is implemented.

## Repository

- Active source: `C:\Users\alper\Desktop\BimmerScope`
- GitHub: `https://github.com/alperyes/bimmerscope`
- Android application ID: `com.bmwenet.bmw_app`
- Android product flavors: `core` (`com.bmwenet.bmw_app`) and `tune` (`com.bmwenet.bmw_app.tune`); pass the matching `BIMMERSCOPE_EDITION` Dart define when building.
- Platforms: Android and Windows are enabled; iOS files exist but require macOS/Xcode to build and sign.

## Flutter structure

- `lib/app.dart`: app shell, themes, shared button/navigation styling.
- `lib/dashboard/dashboard_screen.dart`: Vehicle, Monitor, navigation, gauges, connection flow.
- `lib/diagnostics/diagnostics_screen.dart`: engine DTC scan, engine profile, and guarded clear-DTC UI.
- `lib/logging/logging_screen.dart`: CSV logging and sharing.
- `lib/tuning/tune_screen.dart`: Tune workspace, stock backups, map review, tuner packages, and request history.
- `lib/tuning/tune_guide_screen.dart`: Tune-specific workflow guidance.
- `lib/tuning/stock_file_store.dart`: Persistent stock-file backup storage.
- `lib/tuning/tuner_package.dart`: Structured tuner-package export.
- `lib/tuning/tuner_request.dart`: Saved tuner-request records and statuses.
- `lib/product/product_config.dart`: Core/Tune compile-time edition gate.
- `lib/onboarding/connection_guide_screen.dart`: direct ENET cable setup.
- `lib/design/app_palette.dart`: shared black, blue, amber, green, and neutral palette.
- `lib/design/gauge_tokens.dart`: shared gauge spacing, geometry, typography, range-label, and control constants.

## Rust/ENET

- `rust/src/api/vehicle.rs` contains HSFZ framing, TCP ENET transport, discovery, VIN/live-data polling, read-only DTC scanning, and the future guarded clear-DTC protocol path.
- Standard ENET port is `6801`.
- Discovery prioritizes the confirmed gateway `169.254.12.64` and scans link-local ENET subnets only. Wi-Fi bridge support is postponed.
- Current DTC scan targets the engine ECU/DME-DDE; it is not yet an ISTA-level all-module scanner.
- Current confirmed test vehicle: BMW F82 M4, S55, DCT (demo profile; demo VIN `DEMOF82S55MOBILE`).

## Diagnostic roadmap

1. Build structured engine profiles, starting with S55.
2. Add real DME identification (software/hardware/calibration data).
3. Expand read-only DME/DDE DTC, live-data, readiness, and report export support.
4. Validate and implement guarded DME/DDE clear-DTC support on the confirmed 2014 F82 M4/S55 test vehicle.
5. Add N20, N55, N47, N57, B47, B48, B57, and B58 profiles.
6. Consider EGS/TCU and other modules only after engine coverage is reliable.

## Design rules

- Keep black/dark backgrounds and neutral surfaces.
- Use one shared primary blue; amber is for performance highlights; green is connection status only.
- Use Instrument Sans for interface text and Geist Mono only for technical/live readings if present.
- Keep header controls, spacing, and button styles uniform across Vehicle, Monitor, Diagnostics, and Logs.
- Tune follows the same shared header and blue-card language, with a dedicated Tune help guide.
- Desktop uses compact controls and a centered max-width layout; mobile spacing remains touch-friendly.

## Verification

From the project root:

```powershell
flutter analyze
flutter test
flutter build windows --debug

flutter build apk --debug --flavor core --dart-define=BIMMERSCOPE_EDITION=core
flutter build apk --debug --flavor tune --dart-define=BIMMERSCOPE_EDITION=tune
```

Rust tests:

```powershell
cargo test --manifest-path rust\Cargo.toml
```

Windows executable:

`build\windows\x64\runner\Debug\bmw_app.exe`

## Working conventions

- Inspect current source and preserve user changes before editing.
- Use `apply_patch` for edits.
- Batch related changes and verify them before committing.
- Do not claim real-vehicle compatibility until tested on hardware.
- Any clear-DTC implementation must require deliberate user confirmation, target only the supported ECU, report the ECU response, and never run automatically or as part of scanning.
- APK filenames must use `BimmerScope-v<version>+<build>-<variant>.apk`, matching `pubspec.yaml`; keep an unversioned latest copy only as a convenience.

## Product status

- Core edition hides and blocks the Tune workspace.
- Tune edition includes vehicle capability profiles, persistent stock-file backups, SHA-256 map identity, read-only map comparison, tuner-package sharing, saved tuner requests, log review flags, selectable channels, and pull-interval marking.
- Both editions share the same Rust/Flutter core and can be installed side by side on Android.

## Latest APK

- Version: `1.0.0+18`
- Variant: debug
- Filename: `BimmerScope-v1.0.0+18-debug.apk`

## Current handover status — 5 September 2026

- Primary transport: BMW ENET/HSFZ over TCP port `6801`.
- Vgate iCar2 Mini and ELM327 support was intentionally removed after testing showed that generic OBD transport did not fit the BMW ECU-focused product direction.
- The Connection Guide is direct-ENET focused; Wi-Fi adapter support is postponed.
- The ECU remap roadmap remains documentation-only and read-only by design. No flashing or calibration-write commands are implemented.
- The source tree uses the stable connection-startup path from the last known-good Git version, with Ethernet-only discovery and expanded route diagnostics retained.
- Build 14 was compiled successfully but was not transferred because the phone was disconnected.
- Commit `1863f5b` (`Restore stable Ethernet connection startup`) was pushed to `main`.
- Latest phone testing showed Ethernet can identify the vehicle and receive ECU identities, but intermittent connection aborts remain under investigation.
- Scan, DTC clear, and flap operations now use isolated fresh ENET sockets; DTC verification filters for the DME response and the flap parser accepts the shorter DME acknowledgement.
- A dedicated Flap Control page now provides experimental Open, Auto, Close, and cyclic service-test controls. Persistent keep-alive behavior still requires vehicle validation.

## Recommended next work

1. Continue Tune UX refinement based on emulator review.
2. Persist modifications and selected logs with each tuner request.
3. Add a tuner-request detail/reopen screen and status actions.
4. Add vehicle-profile compatibility checks to map comparison.
5. Keep adapter capability and remapping safety requirements documented before adding any write path.

## Current handoff status — 30 August 2026

- Shared Flutter redesign applies to Android and Windows: circular BimmerScope branding, compact connection-status dots, rounded blue cards, responsive headers, denser minute-mode plots, and updated guide styling.
- The connection guide is a five-page flow: overview, hardware, ignition, network, and vehicle discovery, with Next/Done navigation and looping step illustrations.
- The Vehicle demo action is outside the blue connection card, directly below it, in both responsive layouts.
- Validation passes: `flutter test` passes all 5 tests. `flutter analyze` has one non-blocking interpolation style hint.
- Latest Windows debug executable: `C:\Users\alper\Desktop\BimmerScope\build\windows\x64\runner\Debug\bmw_app.exe`.
- Latest Android debug APK: `C:\Users\alper\Desktop\BimmerScope\build\app\outputs\flutter-apk\app-debug.apk`.
- The latest APK was installed successfully over USB on physical device `HS621L001389` and copied to `Downloads/BimmerScope-debug.apk`. An Android emulator is also connected as `emulator-5554`; always target the physical serial explicitly with ADB.
- The generated Rust bridge previously caused a hot-reload mismatch around `SensorDefinition` fields. A cold stop/restart is required after generated bindings change; current `dashboard_screen.dart` analysis has no errors.
- Recent gauge UI work: compact dials were enlarged, center reading backgrounds were removed, RPM values are kept white, readings are prevented from wrapping, min/max labels were restored and repositioned, and compact/fullscreen dial geometry and typography are centralized.
- GUI consistency work completed: shared spacing tokens, fixed 30px card header slots, centralized dial geometry, standardized range-label insets, typography constants, no-wrap readings, and shared control insets/icon sizing.
- `flutter analyze lib/dashboard/gauge_card.dart lib/design/gauge_tokens.dart` passes with no issues. Full app analysis may still show existing non-blocking warnings/deprecations.
- Current investigation: Windows and Android may fail to discover the car until ISTA connects first, although ISTA reaches `169.254.12.64:6801`. Rust discovery now probes that address plus additional link-local and Wi-Fi bridge candidates.
- Wireshark capture: `C:\Users\alper\Desktop\BMW Wireshark\DTC Clear Exhaust Flap.pcapng`. The user reports it includes startup traffic. Next step: compare ISTA startup packets with BimmerScope’s first HSFZ/TCP exchange and implement only a verified initialization sequence.

## Current handover status — 5 September 2026 (Tune and simulator)

### Latest implementation updates

- Tune readiness reads simulator DME status only for an active connected simulator session; real or disconnected sessions remain unable to verify.
- Unknown VINs no longer receive a generic F-series identity.
- Stock imports use immutable timestamped, hash-traceable artifact names.
- Logs record VIN, session ID, and source; session changes and connection errors stop active recording.
- Tuner packages include copied stock/log attachments, SHA-256 metadata, and portable relative paths.
- Tune requests and log attachments are scoped to the active VIN; unsent drafts persist locally.
- A visible vehicle garage supports persistent VIN-linked records, save/update/delete, and selection for offline review.
- Simulator DME status parsing is normalized and tested.
- Rust service operations reject invalid ECU VIN identity before proceeding.
- The log viewer uses robust CSV parsing and timestamp-aware chart positioning with value-only fallback.
- Current verification: Flutter tests pass (9), Rust tests pass (16), and the Windows debug executable has been rebuilt.
- Android Tune APK build notes (superseded by verification below): the project retains `shared_preferences_android` 2.4.18 and legacy JNI packaging. Both examined upstream package versions include `StringListObjectInputStream`; the local plain-`ObjectInputStream` patch was removed and the pristine package builds successfully with one Gradle worker. The earlier missing-publication diagnosis and claimed JNI strip-race mechanism were not established.

- Tune hero card now matches shared blue-card styling and includes a safe `Check vehicle` action.
- Tune page uses a simpler default flow; backup, map review, notes, logs, and history are grouped under Advanced tune workspace.
- Tune supports stock-backup SHA-256 and size display, backup history, read-only map comparison, vehicle-profile guards, tuner-package review before sharing, saved request detail/reopen, friendly request statuses, mark-as-sent, log select/clear controls, and clear empty states.
- Tune check reads simulator DME status from the simulator `/api/status` endpoint. Real-car unlock status remains `Unable to verify` until a validated F82/S55 read-only capability routine exists.
- Standalone simulator: `C:\Users\alper\Desktop\BimmerScope Simulator`.
- Simulator GUI uses native Tkinter defaults, provides F-generation vehicle selection (including 2014 F22 228i), publishes the selected vehicle, and supports DME states: Unknown, Unlocked, Locked, and Bench unlock required.
- No ECU unlock, security-key, flashing, or calibration-write workflow has been added.
- Latest verification: `flutter analyze lib/tuning/tune_screen.dart` and related transport code pass with no issues; Tune debug APK builds successfully.
- Windows is the same shared Flutter codebase and must be rebuilt from `C:\Users\alper\Desktop\BimmerScope` after source changes.

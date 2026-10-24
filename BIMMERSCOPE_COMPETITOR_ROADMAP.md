# BimmerScope competitor roadmap

## Product position

BimmerScope should become the trusted BMW ownership and calibration platform for enthusiasts and tuners: faster diagnostics than a generic scan tool, better data than a basic dashboard, and safer tuning workflows than an opaque one-click flasher.

The first target is the F-series enthusiast, with the F82/S55 as the reference vehicle. G-series and additional engines come after the transport and profile layers are proven.

## Capability map

### Phase 1 — Make the current foundation excellent

- Vehicle garage: VIN-linked vehicles, ECU inventory, hardware/mod list, notes, service history.
- Connection center: adapter detection, route diagnostics, connection quality, reconnect handling, and a clear “ready to drive” state.
- Diagnostics: full supported-ECU scan, freeze-frame/context where available, code history, exportable reports, and guarded clear-code flows.
- Live dashboard: configurable gauges, favorites, units, min/max/average, warnings, and saved dashboard layouts.
- Data logging: background-safe session recording, start/stop markers, CSV/JSON export, log metadata, and replay charts.
- Flap/service controls: command history, progress events, timeout cleanup, and explicit Auto restoration.

### Phase 2 — Build the tuner workflow without flashing

- Tune workspace with stock-file fingerprinting and immutable backups.
- Map catalog and map metadata: engine, fuel, transmission, hardware assumptions, revision, checksum, and compatibility status.
- Tune request workflow: attach a log, describe hardware/fuel, submit to a tuner, receive a revision, compare revisions, and approve installation.
- Calibration viewer: read-only tables and diffs first; no arbitrary write path.
- Preflight engine-health checks before any future write operation.

### Phase 3 — Controlled calibration delivery

- Signed, VIN/ECU-bound artifacts only.
- Offline recovery package and verified stock restore.
- Power stability checks, ignition/charger guidance, transport watchdog, resumable stages, and explicit user confirmation.
- Transaction journal: every read, write, response, failure, and recovery action is auditable.
- Feature flags by vehicle profile; unsupported vehicles must remain read-only.

### Phase 4 — Differentiators

- Log review assistant that flags boost deviation, timing correction, lambda error, rail pressure, and thermal risk.
- Map-slot profiles for street, track, and valet use where the ECU/profile supports it.
- Tuner portal and customer sharing with permissioned vehicle data.
- Community knowledge tied to exact engine, ECU, fuel, and hardware—not generic forum posts.

## Technical shape

1. `VehicleProfile` owns supported ECUs, addresses, sensors, services, capabilities, and safety limits.
2. `Transport` owns ENET/USB/network lifecycle and diagnostics; it must not know tuning semantics.
3. `DiagnosticSession` owns UDS state, pending responses, timeouts, and operation isolation.
4. `DataLogSession` consumes typed sensor events and writes a versioned local format.
5. `ArtifactStore` owns stock files, map files, hashes, signatures, and backups.
6. `OperationJournal` records all mutating and safety-relevant actions.
7. Flutter presents capability-aware flows; unsupported actions are unavailable, not merely hidden behind warnings.

## Immediate build slice

The next implementation should be the foundation of the tuner-grade experience without ECU writes:

- Add a persistent vehicle garage model.
- Replace the current one-off logger with a typed, versioned log format.
- Add configurable dashboard channels and saved layouts.
- Add operation progress events from Rust to Flutter.
- Add a capability matrix so each vehicle profile declares what is supported.
- Add tests for session isolation, log persistence, profile gating, and safe cleanup.

## Safety boundary

Until a vehicle-profile-specific read/backup/restore design has been validated on hardware, BimmerScope remains read-only for calibration. No generic “flash any BIN” feature should be added. A failed write can immobilize a car, so future flashing must be treated as a transaction and recovery product, not as another diagnostic button.

## Success criteria

- A new user can connect, identify the vehicle, scan it, configure a dashboard, record a pull, and export a tuner-ready log without guidance.
- A tuner can understand the vehicle state and exact log conditions from one exported package.
- Every write-capable feature is profile-gated, recoverable, auditable, and disabled by default.
- The S55/F82 path is reliable before expanding coverage.

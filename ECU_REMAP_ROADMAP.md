# ECU remap roadmap

This document defines a safety-first path for future ECU calibration features in BimmerScope. The first releases must remain read-only. No write or flash operation should be enabled until the adapter, ECU family, recovery path, and validation rules are proven for a specific vehicle.

## Phase 1 — identification only

- Detect transport: BMW ENET, supported BMW-capable adapter, or generic OBD adapter.
- Record VIN, ECU address, ECU display name, hardware number, software number, calibration ID, bootloader ID, and protocol capabilities.
- Store a timestamped session record and the raw diagnostic exchange.
- Show an explicit capability matrix rather than implying that every adapter supports every ECU.

## Phase 2 — read and backup

- Read only documented calibration regions for a supported ECU profile.
- Save the original image as an immutable backup with VIN, ECU identifiers, adapter, voltage, and temperature metadata.
- Calculate SHA-256 for the raw image and a separate checksum for each calibration region.
- Require two independent reads that produce identical hashes before accepting a backup.
- Never overwrite an existing backup automatically.

## Phase 3 — offline map inspection

- Decode maps through versioned ECU definitions, not guessed offsets.
- Display units, axes, limits, source addresses, and checksum regions.
- Keep original, working, and exported images separate.
- Record every change with author, time, old value, new value, and reason.
- Reject edits outside a definition’s safe range.

## Phase 4 — validation

- Validate image length, ECU identity, software compatibility, checksum coverage, calibration bounds, and required dependencies.
- Compare the target image against the immutable backup.
- Require a complete validation report before export.
- Mark unsupported, uncertain, or partially decoded maps as read-only.

## Phase 5 — programming, only after explicit approval

Programming must be a separate capability from diagnostics and disabled by default. Before any future implementation, it must include:

- A supported ECU/vehicle/adapter matrix.
- Stable external power monitoring and minimum-voltage abort rules.
- Ignition and vehicle-state checks.
- Resume/recovery behavior for interruption.
- A verified restore procedure using the original backup.
- Signed calibration packages and a clear confirmation showing VIN, ECU, file hash, and expected risks.
- A post-write identity/readback/checksum verification.

Generic OBD adapters should be treated as diagnostic/read-only until proven otherwise for a specific ECU. They must not be used for flashing by assumption.

## Proposed code boundaries

- `lib/remap/ecu_capability.dart` — immutable capability and support model.
- `lib/remap/ecu_identity.dart` — ECU identity record and serialization.
- `lib/remap/calibration_backup.dart` — backup metadata, hashes, and storage policy.
- `lib/remap/calibration_validator.dart` — offline validation only.
- `lib/remap/remap_screen.dart` — read-only UI initially.
- Rust transport layer — raw exchange and adapter-specific protocol implementations; no write command until the programming safety review is complete.

## Product rule

BimmerScope must never present a generic “Flash ECU” button. The UI should expose only the capabilities proven for the connected vehicle, ECU, transport, and calibration definition.

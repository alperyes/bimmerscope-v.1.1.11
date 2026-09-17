# S55 read-only bench validation checklist

This checklist applies to the guarded F82/S55 DME read path only. It does not authorize flashing, unlocking, calibration editing, or any ECU write operation.

## Fixture

- Matching S55 DME with known VIN, hardware, software, bootloader, and calibration identifiers.
- Stable bench supply, ignition-state control, wired ENET route, and captured transport trace.
- Independent read-only diagnostic reference available for comparison.

## Preconditions

- Confirm BimmerScope identifies the same VIN as the fixture record.
- Confirm the DME identity matches the expected MEVD17.2.G family.
- Confirm software, bootloader, calibration, and session evidence are present.
- Verify the capability matrix does not grant exact-only access when any VIN or identity evidence differs.
- Record app version, adapter details, device model, and bench supply voltage.

## Read-only validation

- Run three cold connection cycles and compare identity records for consistency.
- Run the guarded ECU read and verify progress, cancellation, timeout classification, and cleanup.
- Hash each resulting artifact and compare length, source metadata, and read profile.
- Compare a read against an independent reference only when both identify the same fixture/software level.
- Interrupt one read safely and confirm no write request was emitted and a new session can reconnect cleanly.

## Acceptance evidence

- Raw transport traces and sanitized diagnostic session records.
- Immutable ECU-read artifacts with metadata and SHA-256 hashes.
- Captured negative-response and timeout cases, if observed.
- A dated bench report stating exact DME/software/transport, observations, limitations, and reviewer.

## Stop conditions

Stop and keep the capability read-only if VIN/identity changes, a request is not understood, the route is unstable, the supply is outside the fixture requirement, or recovery behavior is unknown.

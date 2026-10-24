# BimmerScope product roadmap

## North star

BimmerScope should become the most trustworthy BMW diagnostics, logging, and tuner-collaboration platform for F-series owners. It should match the everyday clarity of BM3 and MHD while differentiating through traceable evidence, excellent log review, and explicit safety boundaries.

The first supported reference vehicle is the stock 2014 BMW F82 M4 DCT. All capability claims must be tied to an identified VIN, ECU fingerprint, software level, transport, and test evidence.

This roadmap does not imply that BimmerScope currently flashes, unlocks, or writes an ECU. Those capabilities remain disabled until the programming route and recovery process are proven.

## What parity means

| Area | BM3/MHD expectation | BimmerScope target |
|---|---|---|
| Connection | Fast setup, clear readiness, stable reconnect | Connection center with route diagnostics, adapter health, session ownership, and actionable recovery |
| Vehicle | VIN-linked support and compatibility | VIN + ECU fingerprint + software-specific capability matrix |
| Diagnostics | Read, clear, and export faults | Reliable supported-ECU scan, context, guarded clear, raw evidence, and reports |
| Dashboard | Configurable gauges and layouts | Saved layouts, validated S55 channels, units, limits, alerts, and four-channel reliability first |
| Logging | One-touch logs and tuner sharing | Timestamp-accurate logs, pull markers, missing-data visibility, replay, and complete packages |
| Maps | Catalog, revisions, editor, map switching | Read-only artifact catalog first; editing and switching only for a validated profile and route |
| Flashing | Guided checks, progress, backup, restore | Separate transaction engine with signed/profile-bound files, power checks, journal, recovery, and rollback proof |
| Ecosystem | Cloud/device sync and tuner workflow | Local-first evidence package, optional secure sync later, explicit privacy and provenance |

## Delivery phases

### Phase 0 — Product foundation and UX simplification

Goal: make the current read-only product easy to understand.

- Keep the Tune page as three primary steps: Check vehicle, Choose product, Prepare request.
- Move ECU evidence, backup history, map comparison, and backend notes into Advanced details.
- Use clear states: disconnected, connected, identified, supported, read-only, and ready for review.
- Remove clickable “coming soon” actions; show unavailable capabilities as explanatory status.
- Add empty, loading, error, cancellation, and retry states to every long-running operation.
- Keep simulator evidence visibly separate from live-vehicle evidence.

Acceptance: a new user can identify the next action without opening a technical dialog; all buttons either advance a supported task or explain why they are unavailable.

### Phase 1 — Trustworthy F82/S55 data foundation

Goal: establish the evidence needed for every later feature.

- Complete the real F82/S55 identity path: VIN, DME address, hardware, software, bootloader, calibration, coding, and session provenance.
- Validate the ISTA-pattern read profile on the bench later; until then keep it read-only and software-gated.
- Add read progress, cancellation, timeout classification, and resumable diagnostic-session cleanup.
- Require matching identity and VIN immediately before DTC, flap, logging, and ECU-read operations.
- Store immutable ECU-read artifacts with metadata, hashes, source, timestamp, and exact profile.
- Add a capability matrix keyed by vehicle, ECU, software, transport, and evidence status.

Acceptance: repeated connection cycles produce consistent identity records; unsupported or stale identity cannot enable a service; ECU-read artifacts are reproducible and auditable.

### Phase 2 — Tuner-grade logging and review

Goal: make BimmerScope valuable before it can flash.

- Create a versioned binary/JSON log format retaining acquisition time, receipt time, channel definition, units, gaps, and session ID.
- Validate S55 channel addresses, scaling, units, and rates against an independent reference.
- Add saved dashboard layouts, channel search, favorites, min/max/average, warnings, and pull markers.
- Build synchronized charts with target-versus-actual views, cursor inspection, and visible missing samples.
- Add health review for boost, lambda, fuel pressure, temperatures, timing correction, and thermal context.
- Keep heuristics separate from safety certification and tuning approval.

Acceptance: a tuner can understand a pull without guessing units, sample timing, vehicle identity, or missing data.

### Phase 3 — Professional tuner package workflow

Goal: make collaboration reliable and complete.

- Persist vehicle-scoped drafts, selected logs, fuel, hardware, mileage, and user notes.
- Add artifact types: imported file, ECU-read backup, stock reference, working map, and recovery material.
- Create a manifest containing VIN, ECU fingerprint, software, hashes, app/schema versions, channel definitions, and provenance.
- Export a verified archive with the selected stock/reference file and logs attached—not JSON alone.
- Add revision history, tuner comments, approve/reject actions, and before/after comparison.
- Add privacy controls for VIN, logs, and sharing destinations.

Acceptance: one exported package is sufficient for a tuner to identify the vehicle, inspect the evidence, and reproduce the requested work.

### Phase 4 — Offline calibration inspection

Goal: inspect files safely without pretending that a byte diff is a map diff.

- Introduce versioned S55 definitions for tables, axes, limits, units, and checksum regions.
- Display decoded tables only when the exact software definition matches.
- Keep original, working, exported, and recovery artifacts separate.
- Record every edit with author, time, old value, new value, and reason.
- Validate image length, software identity, calibration bounds, dependencies, checksums, and package signature.
- Reject or mark read-only any uncertain or partially decoded file.

Acceptance: unsupported files cannot be edited or exported as validated calibrations; every accepted artifact has a complete validation report.

### Phase 5 — Programming route decision and bench validation

Goal: choose a safe, supportable way to install one validated calibration.

- Investigate a documented licensed integration before reverse-engineering a programming engine.
- If no integration is viable, scope an independent Rust programming service for one exact ECU/software combination only.
- Define adapter, power-supply, ignition, bootloader, authorization, transfer, verification, and recovery requirements.
- Add a transaction journal with stage-specific responses and failure handling.
- Test interruption, app termination, network loss, bad files, negative responses, and stale identity on a matching spare DME.
- Prove return-to-stock and recovery independently before any vehicle write.

Acceptance: a bench report demonstrates successful programming, interruption handling, recovery, and post-write identity verification. No generic Flash button is permitted.

### Phase 6 — Controlled first vehicle release

Goal: release one narrow, supportable S55 product.

- One exact supported software level, wired ENET, stock hardware/fuel assumptions, and professionally validated calibration.
- Keep DCT software stock initially; validate engine/TCU torque interaction before expanding scope.
- Require preflight, immutable backup, signed/profile-bound artifact, progress, post-write verification, and recovery instructions.
- Use staged rollout, diagnostic logs, crash/error telemetry with consent, and an immediate kill switch for the write feature.

Acceptance: controlled vehicle validation confirms the expected identity, calibration state, drivability, logs, and return-to-stock path.

## Engineering order for the next 90 days

1. Finish the Tune UX simplification and advanced-details grouping.
2. Finish session ownership, identity gating, and operation progress/cancellation.
3. Validate and persist the S55 channel registry and versioned logs.
4. Complete tuner-package manifests and real attachments.
5. Build offline artifact validation and read-only map inspection.
6. Prepare the bench-test checklist and programming-route decision; do not enable writing before that evidence exists.

## Measures of success

- Time from app launch to a clear next action.
- Connection success and reconnect rate across repeated sessions.
- Percentage of logs with valid timestamps, units, identity, and no unexplained gaps.
- Percentage of tuner packages that pass manifest and attachment validation.
- Zero cross-vehicle artifact or log leakage in automated tests.
- Zero unsupported vehicle/ECU combinations exposed as write-capable.
- Bench programming success, interruption recovery, and return-to-stock success before vehicle release.

## Explicit non-goals

- No universal BIN flasher.
- No security-key guessing or unlock bypass.
- No map editing based on guessed offsets.
- No claim that BM3 or MHD support proves BimmerScope support.
- No live vehicle write path before the matching bench and recovery evidence exists.

## Reference basis

The feature comparison is based on the current official product descriptions for [bootmod3](https://www.bootmod3.com/), its [getting-started workflow](https://www.bootmod3.com/get-started), [map editor](https://www.bootmod3.com/map-editor), and [MHD Flasher](https://mhdtuning.com/pages/mhd-flasher). Those products demonstrate the expected breadth; they do not provide permission or a reusable programming engine for BimmerScope.

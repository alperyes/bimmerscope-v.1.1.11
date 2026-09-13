# BimmerScope design system

Locked Hallmark system for the Flutter app. Presentation changes must preserve vehicle communication, diagnostics, logging, and onboarding behavior.

## Genre

Atmospheric modern utility: a calm workshop instrument panel, not a generic dashboard.

## Macrostructure family

- App pages: Workbench — one active task zone, one compact context rail, and clear state hierarchy.
- Onboarding: Guided sequence — one instruction, one visual, one decisive action.
- Content: Review ledger — factual summaries first, detail on demand.

## Theme

- Background: `#000000` dark / `#F2F2F7` light
- Surface: `#1C1C1E` dark / white light
- Accent: `#2F8CFF` diagnostic blue
- Live state: `#30D158`
- Error: `#FF453A`
- Rule: `#38383A` dark / `#D1D1D6` light

## Typography

- Display/body: Instrument Sans, upright, weight 400–900
- Technical data: Geist Mono
- Avoid italic headings and decorative all-caps section labels.

## Spacing and shape

Use the existing 4-point rhythm. Cards use 18dp radius, sheets 24dp, controls 12dp. Prefer deliberate grouping and visible rules over nested floating glass panels.

## Motion

Use short ease-out transitions for state changes. Animate opacity and transform only. Reduced motion collapses to a short opacity transition. Success is quiet; errors explain the next action.

## What pages must share

The BimmerScope wordmark, cool blue accent, green live-state semantics, typography, control shapes, and explicit connection-state language.

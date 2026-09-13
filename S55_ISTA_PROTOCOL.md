# S55 read-only identity mapping

This source line uses the confirmed F82/S55 DME address `0x12` for identity
evidence. Gateway address `0x10` may answer generic requests but is not DME
software, calibration, or tuning-compatibility evidence.

Read-only requests documented during builds 20–24 include:

| Field | UDS request |
| --- | --- |
| VIN | `22 F1 90` |
| SGBD / DME identity | `22 F1 50` |
| BMW software reference | `22 40 1F` |
| Startup / boot block | `22 40 98` |
| Calibration / CVN | `22 40 3C` |
| Coding proof stamp | `22 37 FE` |
| Software vehicle key | `22 F1 01` |
| Physical hardware number, optional | `22 3F 41` |

Unsupported or negative responses remain unavailable; they must never be
guessed. These reads do not unlock, program, write, or modify an ECU.

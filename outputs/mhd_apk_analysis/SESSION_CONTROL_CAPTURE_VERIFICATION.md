# S55 session-control capture verification

Verified 12 October 2026 against `C:\Users\alper\Downloads\PCAPdroid_12_Oct_17_03_06.pcap` (SHA-256 `61787B4231A1F88088765224A56321DF30D214C20C8CC41AE327FE5602E8A1AC`). This note describes captured traffic, not MHD flashing behavior.

| Frame | Direction | HSFZ bytes | Interpretation |
| --- | --- | --- | --- |
| 65 | `F4` tester → `12` DME | `00 00 00 04 00 01 F4 12 10 03` | 4-byte HSFZ message (`F4 12 10 03`); UDS request `10 03` selects extended diagnostic session. |
| 68 | `12` DME → `F4` tester | `00 00 00 08 00 01 12 F4 50 03 00 32 01 F4` | Positive response `50 03`; P2 = `0x0032` = 50 ms; P2* = `0x01F4` × 10 ms = 5000 ms. |

The positive reply arrived 31.481 ms after the request by packet timestamps. The PCAP contains no decoded `3E`, `27`, `34`, `36`, or `37` UDS messages. Therefore it confirms an extended-session exchange, but neither a programming-session request nor a flash. The generic UDS meaning of `10 01`, `10 02`, `10 03`, and `3E 00` is documented at https://uds.readthedocs.io/en/stable/pages/knowledge_base/service.html .

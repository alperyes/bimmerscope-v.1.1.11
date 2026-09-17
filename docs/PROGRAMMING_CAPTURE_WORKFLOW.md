# Authorized programming-capture workflow

This workflow gathers evidence for a clean-room BimmerScope implementation. It
does not authorize programming a road vehicle and does not make an incomplete
capture safe to replay.

## Capture conditions

- Use a matching sacrificial DME, gateway/topology, regulated supply, and a
  documented independent recovery method.
- Record the DME label, hardware number, bootloader, software, calibration,
  VIN provenance, gateway, tool and tool version before the session.
- Capture the complete TCP connection from SYN through FIN/RST, including
  payload bytes. Flow summaries and CSV packet lists are insufficient.
- Start with identification and an authorized read-only session. A controlled
  write/restore capture belongs only on the recoverable bench.
- Preserve the original `.pcapng` as immutable evidence and calculate SHA-256
  before producing filtered or redacted derivatives.

## Useful display filters

For direct ENET/HSFZ traffic:

```text
tcp.port == 6801
```

For the previously observed bridge endpoint:

```text
ip.addr == 10.138.52.232 && tcp.port == 6801
```

Do not assume that endpoint is valid for another adapter or session. Record the
actual negotiated peers from each capture.

## Evidence to extract

For every HSFZ application frame retain:

- capture timestamp and TCP stream number;
- source and destination IP/port;
- HSFZ source and destination addresses;
- complete UDS payload;
- retransmission/out-of-order indicators;
- request/response relationship and elapsed time;
- exact negative-response code, including response pending (`0x78`).

The passive Rust classifier in `rust/src/capture_analysis.rs` recognizes the
standard lifecycle services without interpreting authentication material or
generating traffic. Unknown/truncated records remain unclassified. Presence of
download and transfer services is evidence that they were captured; absence is
not proof that they never occurred.

## Acceptance gate

A capture is not sufficient for backend implementation until all of these are
known for one exact DME/software combination:

1. fresh identity before mutation;
2. programming prerequisites and their failure responses;
3. session transition and authorization behavior;
4. erase regions and acknowledgements;
5. download format, block limits, counters and timing;
6. transfer-exit and ECU-side integrity verification;
7. reset, reconnect and post-reset identity verification;
8. behavior after interruption at each mutating stage;
9. independently demonstrated restoration/recovery.

Never infer missing state-changing commands from diagnostic traffic or from a
different ECU family. Do not put private keys, licensed tool assets, or customer
VINs in the repository.

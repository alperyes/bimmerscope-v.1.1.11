# N20 bench BIN-read evidence — 2 October 2026

The user supplied an MHD-produced 4,194,304-byte BIN, an MHD v5.30 log
preset CSV, and a PCAPdroid capture from the bench session. The source files
remain in the user's Downloads folder and are not committed here.

- BIN SHA-256: `A2B88727777C5DD01C888691F3D3EFF583C690E9EB6149B8CCDEAF06834B255B`
- PCAP SHA-256: `68339126DAFC446DE9B9A487FF93F56349B30DF1458B004CD298795A647CFD12`
- Filename/CSV ECU token: `00001C9F1D9601`
- BIN header marker at byte 26: `MEVD1729__`
- PCAP: 235 TCP packets, with HSFZ traffic on port 6801 over two flows.

The observed DME traffic includes VIN and identifier reads, routines `0x0205`,
and three short UDS `0x23` memory probes, repeated on the second connection.
The probes request 16 or 64 bytes at specific addresses and receive `0x63`
replies. The capture does not show a transfer covering the 4 MiB BIN. Its
relationship to the BIN's extraction route cannot be established from this
capture alone.

## Repeat capture — 3 October 2026

The second PCAPdroid capture (`PCAPdroid_03_Oct_09_36_26.pcap`) starts before
the second BIN is saved. It again shows two copies of the same DME transaction:
identity queries, two BMW-specific `0x0205` routines, and three `0x23` reads at
`0x801FFA40` (16 bytes), `0xD0000000` (64 bytes), and `0x801FFA00` (64 bytes).
Each TCP flow carries 1,379 response bytes in total, including transport and
identity data. The second 4,194,304-byte BIN has the same SHA-256 hash as the
first. One byte in the `0xD0000000` response differs between the two dates,
but neither version of that `0xD0000000` response appears verbatim in the BIN.

This supports the possibility of a reference file generated from ECU identity
or data outside the captured path; it does not prove how MHD produced this
specific file. The [MHD user guide](https://data.mhdtuning.com/downloads/MHD%20User%20Guide.pdf)
describes generating an OEM backup from unique DME identifiers. PCAPdroid's
[VPN-mode documentation](https://github.com/emanuele-f/PCAPdroid/blob/master/docs/how_it_works.md)
also warns that its dump does not expose the proxy-to-network side of a flow.

## N20 read decision gate

Do not label the supplied BIN as a physical DME read. The current capture
establishes exact identity responses and three bounded memory probes, not a
4 MiB extraction range, address-to-file mapping, or interruption behavior.
The S55-only 512 KiB ISTA profile must not be reused for this N20 software.
Before enabling a full N20 Read DME action, obtain independent evidence of
the memory regions and a complete bench read, then compare the result with a
reference for this exact VIN, HWEL, BTLD, SWFL, and CAFD combination.

BimmerScope may inspect and preserve the supplied file as an imported artifact.
The existing live S55 read profile covers another software token and a 512 KiB
region; its addresses and length cannot be reused for this N20 bench DME. A
bench ECU read requires a complete authorized capture from connection setup
through final read, with the exact DME fingerprint, read range, response
validation, interruption behavior, and output comparison established first.

# Programming backend preparation

## Existing read-artifact audit

The three `artifacts/bm3_s55_dme_read_0x80180000*.bin` files each contain
523,264 bytes and share SHA-256
`6D69C44CABD84EE66E2A3EA2124AB1BF9A6BDE3EC18CA537081569E7B7237259`.
This is 1,024 bytes fewer than the currently configured ISTA read region
(`0x80000` bytes starting at `0x80180000`). Matching files establish byte
agreement, not completeness or provenance. Their original extraction range
must be established before deciding whether this is intentional or missing
capture data. Do not pad or assume these files cover the configured region.
No evidence currently establishes these artifacts as full recovery material.

## UDS download codec

`rust/src/uds_download.rs` now constructs uncompressed/unencrypted 32-bit
RequestDownload messages, parses the ECU block limit, caps it to the caller's
transport limit, and manages numbered TransferData and RequestTransferExit
exchanges. Payload capacity subtracts the service and counter bytes; 251 bytes
is not a universal constant. Matching acknowledgements advance progress;
response-pending does not retransmit. Malformed, mismatched or negative replies
stop the transaction, as does an explicitly reported unknown outcome.

The codec now has an exchange runner using injected transport and journal
interfaces. It records request intent before send and replies before advancing,
uses one absolute deadline per exchange (including pending replies), and stops
on storage/transport/protocol failure without retry. Its terminal record means
transfer exit acknowledged, not ECU verification or full programming success.
Six focused tests pass, including failure at every journal append boundary.
The exchange runner now also accepts `FileExchangeJournal`, which creates a
new file, records a caller-supplied parent-manifest SHA-256 binding, and syncs
each numbered request/response record to disk before returning. Per-record
hashes support later corruption checks, not authenticity. Existing files cannot
be overwritten, storage errors permanently poison the writer, and appends
after transfer-exited are rejected. Two focused file-backed tests pass,
including a full download-runner exchange and an OS-rejected write.
Structural restart inspection now verifies schema, the expected manifest hash,
record numbering, canonical hex and per-record hashes. It rejects torn tails,
reordered records and records following a terminal marker. Three focused journal
tests pass. `inspect_download` additionally replays the saved protocol against
an independently supplied address, payload and transport limit. It requires
exact request bytes, matching counters, valid download limits and acknowledged
transfer exit before reporting TransferExited. Intact prefixes are Interrupted;
terminal negative replies are Rejected. These statuses never certify ECU flash
integrity or authorize resumption. Parent-manifest validation still remains,
as do directory-entry durability and
physical power-loss validation. The runner
is not yet connected to the existing synthetic operation runner or Flutter.
A private HSFZ socket adapter now implements the download transport interface
and is instantiated only in a loopback test. It uses explicit tester, target,
and expected response-source addresses, buffers fragmented TCP frames, skips
gateway echoes and other ECU replies, and preserves the absolute exchange
deadline through pending responses. The test completes download, two numbered
blocks and transfer exit over a local TCP socket. No production constructor,
discovery path or real-vehicle invocation is provided. Actual S55 gateway reply
routing must be established before exposing this adapter through an approved
procedure; the explicit source must not be guessed from the target address.
It does not perform erase, authentication or ECU verification. Optional OEM
transfer response records are rejected until a specific profile defines them.
Public wire-layout references: python-udsoncan RequestDownload and TransferData
service documentation. Rust suite: 49 tests passed, including partial final
blocks, counter wrap, pending responses, malformed limits and bad replies.
The previously built APK predates this codec.

## Clean-room protocol evidence from MHD F-Series v1.01

Static analysis of the authentic, signed legacy APK established the shape of
its F-series programming transaction without importing its source into
BimmerScope. The recovered application identifies an explicit F8x S55 path and
software family `00001A84`, but its active transport is an FTDI/serial adapter
using BMW/KWP framing rather than BimmerScope's ENET/HSFZ connection. Therefore
it is architectural evidence only, not a drop-in S55 backend or proof that the
same messages are safe over BimmerScope's transport.

The clean-room Dart transaction contract now records separate stages for fresh
identity, exact compatibility, programming preconditions, session preparation,
authentication, network quiescence, erase, download request, transfer, transfer
exit, verification, reset, and network restoration. These names describe the
required lifecycle; the simulated backend still performs no ECU I/O. No MHD
authentication keys, licensing mechanisms, patch bytes, or proprietary source
were copied into this project.

Rust now also contains a passive capture classifier. It accepts already
extracted UDS payloads and records session control, reset, security access,
communication control, routines, download, transfer, transfer exit, reads,
tester-present traffic, positive replies, negative replies, and response-pending
events. It never opens a socket or constructs a request. Its summary reports
only what was observed and deliberately does not claim that a capture is
complete or portable to another ECU/software version. Truncated negative
responses and unknown services are ignored conservatively. Three classifier
tests are included in the 46-test Rust suite.

The current Dart implementation is an offline transaction prototype. No real
S55 programming backend is registered. Production profiles do not grant write
capability. The simulated backend only emits stage events; it does not transfer
or verify bytes. Passing its tests does not establish ECU compatibility.

## Persistent operation evidence

Create a `FileWriteJournal` with the request, backend identifier, and explicit
simulation provenance; pass it to `CalibrationWriteService.write(journal: ...)`
and close it in a `finally` block. Each operation gets a new directory. Header
and stage records are flushed before returning. Completion is persisted only
after the backend returns successfully. The existing app does not start these
operations; the integration is exercised by tests.

`inspectWriteJournal` reports complete, failed, interrupted, or corrupt. It
rejects broken sequencing and torn records and never initiates recovery or
retries. Complete means a valid local stage sequence was recorded, not that an
ECU was verified. Headers contain caller-declared identifiers, the expected
hardware/software/calibration/bootloader fingerprint, and hashes. They do not
authenticate those declarations or validate artifact bytes.

This synchronous file implementation is for development. Production journaling
belongs with the Rust operation owner off the UI thread. Disk flushes are not a
guarantee against all hardware or filesystem power failures. Tests reopen files
and inject truncation; physical power-loss testing remains outstanding.

## Required before an S55 bench write

- Rust now has a process-wide access gate. Live sessions retain diagnostic
  leases through worker exit (including discovery/reconnect); calibration reads,
  DTC operations and flap requests also hold leases. A future programming owner
  must acquire the exclusive lease, which fails busy while any diagnostic lease
  exists. This is tested at the gate and actual diagnostic API entry points.
  There is no programming owner yet, no automatic polling suspension, and no
  cross-process protection against another diagnostic application.
- Requests now compare all recorded fingerprint fields against preflight and
  preflight compares the fingerprint against the exact resolved profile.
  Fresh acquisition, session provenance and artifact-byte binding remain open.
- Validate package authenticity, ECU integrity rules, memory regions and the
  distinction between backup bytes and independently usable recovery material.
- Define an evidenced ECU-specific procedure for entry, authorization,
  erase, transfer, verification and recovery. No such procedure is supplied by
  the simulator or inferred from read-only traffic.
- Journal operation intent and acknowledged results separately around each
  state-changing command. The current stage-only callback cannot establish
  whether a command took effect when the connection was lost.
- Define stage-specific interruption and supply-response policies. Do not
  implement blanket retries, cancellation or automatic resumption.
- Validate the exact procedure and recovery route on the matching spare DME,
  harness and supply, including process death and communication/power faults.

The optional Dart journal is not a mandatory production safety boundary. The
future real Rust backend must require durable operation evidence itself.

## Completion audit

The preparation goal remains incomplete. The Dart prototype is separate from
the Rust runner; there is no app integration or production programming adapter.
Backend descriptor validation is descriptive metadata, not an enforced support
registry. Power, signature and recovery preflight fields are caller assertions,
not measurements or cryptographic/recovery evidence. Persistent journals are
optional in the Dart prototype. No exact S55 write profile or recovery executor
has been implemented or verified.

`rust/src/programming.rs` now contains an offline Rust runner that acquires an
exclusive access lease, requires a new flushed journal, compares supplied
backup bytes with synthetic memory, transfers chunks and compares readback.
Tests cover partial final chunks, acknowledgement loss after each chunk,
readback corruption, mismatched backup and busy access. This module is internal
and currently exercised only by tests. Its journal has its own synthetic text
format, distinct from the Dart JSONL format.

The bound Rust entry point now requires an exact typed VIN/ECU hardware,
software, calibration and bootloader identity, an explicit support profile,
region and chunk sizes, and caller-declared SHA-256 values that Rust recomputes
from the payload and backup bytes. It writes those identifiers and hashes before
mutating intent. Mismatches leave the target untouched. The lower transfer
primitive is private to the module, preventing sibling modules from bypassing
binding. Support profiles are still constructed data; an approved immutable
registry boundary now exists, but contains zero production entries. A profile
also requires evidence and recovery identifiers. Synthetic profile construction
is compiled only for tests. No S55 combination is therefore selectable.

The Rust journal now has a conservative restart inspector. It checks UTF-8,
the final newline, contiguous sequence numbers, known events and terminal
placement. A journal ending before erase intent is classified as interrupted
before mutation. Erase intent or any later non-complete state requires recovery;
only a complete record immediately following matching-byte verification is
complete. Corrupt evidence remains a separate result. Inspection never resumes
or connects to a target.

Restart inspection also validates the persisted operation header structure,
safe identity/evidence tokens and both 64-character SHA-256 fields. A malformed
or edited header is corrupt evidence rather than an interrupted operation.

The Rust fixture now has a separate explicit recovery runner. It accepts only a
source journal classified as recovery-required, requires an exact match to the
original bound operation and support evidence, recomputes the backup SHA-256,
uses a new journal, restores chunks and verifies readback. A complete source
operation or wrong backup is rejected before mutation. Recovery journals have
their own conservative restart classification. This restores synthetic memory
only; it is not an S55 recovery procedure.

Recovery fault tests inject durable-storage failure at every record, lost
acknowledgement after each restored chunk, and mismatched verification readback.
They assert the exact resulting synthetic bytes, never record completion, and
classify mutation uncertainty as recovery-required. No automatic retry follows.

A pure stage-decision function now maps durable evidence to one of: no action,
abandon before mutation, inspect target state, reverify target, use the documented
recovery route, or manual evidence review. Transfer/restore intent without a
result requires target inspection; verification uncertainty requires readback;
other post-mutation states require the profile's recovery route. It performs no
I/O and contains no retry or resume action. Real S55 definitions for inspection,
verification and recovery remain absent until supported by bench evidence.

Transaction policy now runs against a Rust `ProgrammingTarget` interface for
preflight read, erase, chunk writes and verification readback. The in-memory
target is one implementation; a future S55 adapter must implement the same
contract. Target failures distinguish a confirmed pre-action rejection from an
unknown command outcome. A confirmed erase rejection records no mutation and
can be abandoned; acknowledgement loss after erase records recovery-required.
The interface itself contains no S55 service bytes or timing assumptions.

The target contract also requires a fresh identity read while Rust holds the
exclusive programming lease. All VIN, family, hardware, software, calibration
and bootloader fields must match the selected support profile before programming
or recovery mutates bytes. Caller-provided identity alone is insufficient.
Synthetic mismatch tests leave target bytes untouched and journals pre-mutation.

Next software work: define how bench evidence is reviewed into the immutable
registry and replace the abstract decisions with evidence-backed S55 procedures.
The fixture
procedure is deliberately synthetic. It cannot
supply the missing real S55 protocol, security access, memory map or integrity
rules. Completing the hardware adapter requires authoritative evidence for one
identified DME/software combination and a recoverable bench route.

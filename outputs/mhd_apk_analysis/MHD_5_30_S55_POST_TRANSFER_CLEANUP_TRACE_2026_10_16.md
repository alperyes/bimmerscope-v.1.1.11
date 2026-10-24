# MHD 5.30 S55 post-transfer cleanup trace — 16 October 2026

## Finding

Static inspection of `zz.cs` traces the post-CAL status branch for the S55/F/G writer. After `t(4)` succeeds, the non-EN55 branch waits 500 ms, invokes `bh()`, shows `Flash_ECUReboot`, invokes `bg()`, waits 3 seconds, and calls `k()` (`zz.cs:15270-15276`, `15283-15302`, `15508-15516`). The S55 `yy` path is F/G, so this is the relevant static branch when reached. Nothing here confirms a real ECU reset or reconnection.

- On F/G, `bh()` sends byte `20` using the shared request wrapper with 250 ms and two attempts. Its return is ignored (`zz.cs:16157-16184`, `26663-26718`).
- `bg()` sends `11 01` with 300 ms and four attempts (`zz.cs:26751-26769`).
- On F/G, `k()` calls `r()`, which sends `3E 80` via the transport helper and waits 50 ms (`zz.cs:26791-26819`, `52470-52491`).
- `a4()` on F/G sends `29 02` twice with 200 ms delays, calls `this.y.a(true)`, waits 200 ms, then sends `30 00` using the request wrapper with 300 ms, two attempts, and selector `0x17` (`zz.cs:19298-19380`). Its `30 00` response is not inspected in this method. The controller has separate `a4()` callsites at `zz.cs:15471-15476` and `15604-15606`; one fixed invocation count is not established.
- After transfer completion, `a1()` routes F/G to `s()`, whose “Clearing codes” UI path sends template fields `u` and `t`; if ECU-info slot 24 exists, it polls field `w`, parses the reply with `aw.b5`, and repeats the wait/clear polling loop when the parsed count exceeds 5 (`zz.cs:15471-15485`, `19473-19506`, `54036-54165`). For the `zt` transfer template, fields `u/t/w` are `14 FF FF FF`, `31 01 0F 06`, and `19 02 0C` (`zt.cs:5-32`). The write-time template selection and live ECU acceptance remain unverified.

## Limits

The byte meanings of `20`, `29 02`, and `30 00` are not inferred from these callsites. This static path does not establish that each branch executes for a given map/write type, verify the reboot, prove a reconnect, or show that DTC clearing succeeds. The supplied F82 capture covers a bin-read connection, not a programming session. No APK or vehicle commands were run.

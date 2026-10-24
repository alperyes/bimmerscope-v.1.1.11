"""Read-only scan of local HSFZ captures for MHD connection-probe payloads."""
from pathlib import Path
import subprocess

root = Path("C:/Users/alper/Desktop/pcap")
tshark = "C:/Program Files/Wireshark/tshark.exe"
wanted = {"1a80", "3e00", "5a80", "7e00"}
captures = sorted(p for p in root.rglob("*") if p.suffix.lower() in {".pcap", ".pcapng"})
hits = []
for path in captures:
    result = subprocess.run(
        [tshark, "-r", str(path), "-Y", "hsfz.ctrlword == 1", "-T", "fields",
         "-e", "frame.number", "-e", "tcp.payload"],
        capture_output=True, text=True, check=True,
    )
    for line in result.stdout.splitlines():
        frame, _, raw = line.partition("\t")
        packet = bytes.fromhex(raw.replace(":", "")) if raw else b""
        if len(packet) < 10 or packet[4:6] != b"\x00\x01":
            continue
        payload = packet[8:]
        if payload[:2].hex() in wanted:
            hits.append((str(path.relative_to(root)), frame, packet[6:8].hex(), payload.hex()))
print(f"captures={len(captures)} probe_matches={len(hits)}")
for hit in hits:
    print("\t".join(hit))

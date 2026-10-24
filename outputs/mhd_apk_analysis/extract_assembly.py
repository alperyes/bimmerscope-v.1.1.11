"""Read-only extractor for the XABA assembly store inside a MAUI APK."""
import pathlib
import struct
import sys
import zipfile

import lz4.block


def u16(b, p): return struct.unpack_from('<H', b, p)[0]
def u32(b, p): return struct.unpack_from('<I', b, p)[0]
def u64(b, p): return struct.unpack_from('<Q', b, p)[0]


apk = pathlib.Path(sys.argv[1])
out = pathlib.Path(sys.argv[2])
out.mkdir(parents=True, exist_ok=True)
with zipfile.ZipFile(apk) as z:
    data = z.read('lib/arm64-v8a/libassembly-store.so')
assert data[:4] == b'\x7fELF'
is64 = data[4] == 2
shoff = u64(data, 0x28) if is64 else u32(data, 0x20)
shentsz = u16(data, 0x3a if is64 else 0x2e)
shnum = u16(data, 0x3c if is64 else 0x30)
shstr = u16(data, 0x3e if is64 else 0x32)
offpos, sizepos = (0x18, 0x20) if is64 else (0x10, 0x14)
read = u64 if is64 else u32
strheader = shoff + shstr * shentsz
stroff = read(data, strheader + offpos)
payload = None
for i in range(shnum):
    h = shoff + i * shentsz
    namepos = stroff + u32(data, h)
    name = data[namepos:data.index(0, namepos)]
    if name == b'payload':
        start = read(data, h + offpos)
        payload = data[start:start + read(data, h + sizepos)]
        break
assert payload is not None and payload[:4] == b'XABA'
version, count, index_count, index_size = struct.unpack_from('<IIII', payload, 4)
dstart = 20 + index_size
npos = dstart + count * 28
names = []
for _ in range(count):
    length = u32(payload, npos)
    npos += 4
    names.append(payload[npos:npos + length].decode())
    npos += length
print(f'XABA version={version} entries={count} index_entries={index_count}')
for i, name in enumerate(names):
    mapping, offset, size, _, _, _, _ = struct.unpack_from('<7I', payload, dstart + i * 28)
    blob = payload[offset:offset + size]
    if blob[:4] == b'XALZ':
        raw = lz4.block.decompress(blob[12:], uncompressed_size=u32(blob, 8))
    else:
        raw = blob
    assert raw[:2] == b'MZ', name
    target = out / name
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_bytes(raw)
    if 'MHD' in name or 'Common' in name or 'Ridetune' in name:
        print(f'{name}: {len(raw)} bytes')

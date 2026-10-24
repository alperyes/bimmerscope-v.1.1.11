"""Decode literals in the image preparation method, without executing MHD."""
import json
from pathlib import Path
import re
import sys

sys.stdout.reconfigure(encoding="utf-8")

source = Path("C:/Users/alper/Desktop/MHD/tools/decompiled-5.30/zz.cs").read_text(encoding="utf-8-sig")
start = source.index("private void y()")
end = source.index("\n\t}", start)
method = source[start:end]
key = 623802178 + 17 + 5 + 39 + 66 + 86
for match in re.finditer(r'LinearSportGauge\.c\(("(?:[^"\\]|\\.)*")', method):
    encoded = json.loads(match.group(1))
    decoded = "".join(chr(((((ord(c) & 255) ^ (key + 2*i)) & 255) << 8)
                       | (((ord(c) >> 8) ^ (key + 2*i + 1)) & 255))
                      for i, c in enumerate(encoded))
    line = source[:start + match.start()].count("\n") + 1
    print(f"{line}: {decoded}")

"""Load the encrypted local resource bundle without Java or JAR execution.

Static reference: ResourceImgReader (mb), CryptoMain (lt), LicenseParser (lv),
and SecKeyRefParser (me) from the original implementation.
"""

from __future__ import annotations

import base64
import hashlib
import json
from pathlib import Path
import xml.etree.ElementTree as ET
import warnings

from Crypto.Cipher import AES, PKCS1_v1_5
from Crypto.PublicKey import RSA
from Crypto.Util.Padding import unpad
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.serialization import pkcs12
from PIL import Image


def _image_payload(path: Path) -> bytes:
    """Read the RGB low two bits, excluding the first row and column (lt.a)."""
    with Image.open(path) as image:
        rgb = image.convert("RGB")
        width, height = rgb.size
        characters = []
        pixels = rgb.load()
        for y in range(1, height):
            for x in range(1, width):
                red, green, blue = pixels[x, y]
                character = chr(32 + (red & 3) + ((green & 3) << 2) + ((blue & 3) << 4))
                if character == "_":
                    return bytes.fromhex("".join(characters))
                characters.append(character)
    raise ValueError(f"Resource payload terminator missing: {path.name}")


def load_session_key(resources_dir: Path) -> tuple[int, bytes]:
    """Decrypt the bundled session key in memory; return its type and raw bytes."""
    resources_dir = Path(resources_dir)
    reference = json.loads((resources_dir / "key_reference.json").read_text(encoding="utf-8"))
    encrypted_metadata = _image_payload(resources_dir / "image1.png")
    resource_key = _image_payload(resources_dir / "image2.png")
    metadata = unpad(AES.new(resource_key, AES.MODE_CBC, iv=bytes(16)).decrypt(encrypted_metadata), 16)
    document = ET.fromstring(metadata)
    password = next(
        ((element.text or "").strip().encode()
         for element in document.iter("passphrase")
         if element.get("id") == reference["passphrase_id"]),
        None,
    )
    if password is None:
        raise ValueError("Local resource passphrase is missing")
    # CryptoMain.lt.a hashes the resource phrase and hex-encodes in uppercase.
    license_password = hashlib.sha1(password).hexdigest().upper().encode("ascii")
    # This original PKCS12 uses BER. The dependency constraint retains the
    # tested BER-compatible reader; keep the original encrypted bytes intact.
    with warnings.catch_warnings():
        warnings.filterwarnings(
            "ignore", category=UserWarning,
            message=r"PKCS#12 bundle could not be parsed as DER, falling back to parsing as BER.*",
        )
        private_key, _certificate, _ = pkcs12.load_key_and_certificates(
            base64.b64decode(reference["pkcs12"]), license_password
        )
    if private_key is None:
        raise ValueError("Local license contains no private key")
    encoded_key = private_key.private_bytes(
        serialization.Encoding.DER,
        serialization.PrivateFormat.PKCS8,
        serialization.NoEncryption(),
    )
    key = RSA.import_key(encoded_key)
    sentinel = b"invalid wrapped session key"
    session_key = PKCS1_v1_5.new(key).decrypt(
        bytes.fromhex(reference["wrapped_session_key"]), sentinel
    )
    if session_key == sentinel:
        raise ValueError("Unable to unwrap local session key")
    return int(reference["session_key_type"]), session_key

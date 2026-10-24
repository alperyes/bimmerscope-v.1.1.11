"""Native equivalents of the BasicCrypto operations used by SecurityImpl."""

from __future__ import annotations

from hashlib import new as new_digest
from dataclasses import dataclass, field

from Crypto.Cipher import AES, DES, DES3
from Crypto.PublicKey import RSA
from Crypto.IO import PKCS8
from Crypto.Util.asn1 import DerSequence
from Crypto.Util.Padding import unpad


@dataclass(frozen=True, repr=False)
class RawRSAPrivateKey:
    """Java also accepts PKCS8 entries containing only modulus and exponent."""
    n: int = field(repr=False)
    d: int = field(repr=False)


class BasicCrypto:
    @staticmethod
    def digest(data: bytes, algorithm: str) -> bytes:
        if data is None:
            raise ValueError("Data must not be None.")
        # Java accepts both SHA1 and SHA-1; hashlib uses sha1, sha256, etc.
        name = algorithm.lower().replace("-", "").replace("_", "")
        if name in ("sha3224", "sha3256", "sha3384", "sha3512"):
            name = "sha3_" + name[4:]
        try:
            return new_digest(name, data).digest()
        except ValueError as exc:
            raise ValueError(f"Unsupported digest algorithm: {algorithm}.") from exc

    @staticmethod
    def _algorithm(key_type: int, material: bytes) -> str:
        length = len(material)
        if not length:
            raise ValueError("Key material is empty.")
        if key_type in (1, 2) or 8 <= key_type <= 19:
            algorithm, valid = "DES", length == 8
        elif key_type in (3, 4):
            algorithm, valid = "DESede", 16 <= length <= 24
        elif key_type in (5, 6, 7):
            algorithm, valid = "AES", 16 <= length <= 32
        elif 20 <= key_type <= 23:
            algorithm, valid = "RSA", length >= 64
        elif key_type == 0:
            if length > 64:
                algorithm = "RSA"
            elif 16 <= length <= 24:
                algorithm = "DESede"
            elif length == 8:
                algorithm = "DES"
            else:
                raise ValueError("Cannot infer key algorithm from its length.")
            valid = True
        else:
            raise ValueError(f"Key type {key_type} is not supported by the reference implementation.")
        if not valid:
            raise ValueError(f"Invalid key length for type {key_type}.")
        return algorithm

    @staticmethod
    def load_key_material(material: bytes | str, key_type: int) -> bytes | RSA.RsaKey | RawRSAPrivateKey:
        if isinstance(material, str):
            material = bytes.fromhex(material)
        algorithm = BasicCrypto._algorithm(key_type, material)
        if algorithm == "RSA":
            if not 20 <= key_type <= 23:
                raise ValueError("An explicit RSA key type is required.")
            try:
                oid, encoded, _ = PKCS8.unwrap(material)
                values = DerSequence().decode(encoded)
                if oid != "1.2.840.113549.1.1.1":
                    raise ValueError("Expected an RSA private key.")
                if len(values) == 9 and values[0] == 0 and values[2] == 0 and all(value == 0 for value in values[4:]):
                    modulus, exponent = values[1], values[3]
                    if modulus.bit_length() < 512 or modulus % 2 == 0 or not 0 < exponent < modulus:
                        raise ValueError("Invalid RSA modulus or private exponent.")
                    return RawRSAPrivateKey(modulus, exponent)
                key = RSA.import_key(material)
            except (ValueError, IndexError, TypeError, ZeroDivisionError) as exc:
                raise ValueError("Cannot decode RSA private key material.") from exc
            if not key.has_private():
                raise ValueError("RSA calculation requires a private key.")
            return key
        return material

    @staticmethod
    def decrypt_symmetric(encrypted: bytes, key: bytes, key_type: int) -> bytes:
        algorithm = BasicCrypto._algorithm(key_type, key)
        cipher_type = {"AES": AES, "DES": DES, "DESede": DES3}.get(algorithm)
        if cipher_type is None:
            raise ValueError("Expected a symmetric wrapping key.")
        try:
            cipher = cipher_type.new(key, cipher_type.MODE_CBC, iv=bytes(cipher_type.block_size))
            return unpad(cipher.decrypt(encrypted), cipher_type.block_size)
        except ValueError as exc:
            raise ValueError("Unable to decrypt key data with the local wrapping key.") from exc

    @staticmethod
    def transform(key_type: int, key: bytes | RSA.RsaKey | RawRSAPrivateKey, message: bytes, digest_name: str) -> bytes:
        if key_type < 20 and isinstance(key, bytes):
            return BasicCrypto.digest(key + message + key, digest_name)
        if not isinstance(key, (RSA.RsaKey, RawRSAPrivateKey)) or (isinstance(key, RSA.RsaKey) and not key.has_private()):
            raise ValueError("Expected an RSA private key for this key type.")
        digest = BasicCrypto.digest(message, digest_name)
        width = key.n.bit_length() // 8
        if len(digest) > width:
            raise ValueError("Digest is longer than the RSA modulus.")
        # Reference uses raw RSA, with the zero-padded digest block reversed.
        # This is intentionally not a standard PKCS#1 v1.5 signature operation.
        block = (digest + bytes(width - len(digest)))[::-1]
        value = int.from_bytes(block, "big")
        if value >= key.n:
            raise ValueError("RSA input block exceeds the modulus.")
        if isinstance(key, RSA.RsaKey):
            return key._decrypt_to_bytes(value)
        return pow(value, key.d, key.n).to_bytes(width, "big")

    @staticmethod
    def reverse_four_byte_blocks(data: bytes) -> bytes:
        if len(data) % 4:
            raise ValueError("Data length must be divisible by four.")
        return b"".join(data[offset:offset + 4] for offset in range(len(data) - 4, -1, -4))

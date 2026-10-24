"""Native implementation of the response assembly in SecurityImpl.java."""

from __future__ import annotations

from pathlib import Path

from basic_crypto import BasicCrypto
from crypto_main import CryptoMain
from sec_file_parser import SecFileParser
from security import Security
from sgbm_id import SGBMID


class SecurityImpl(Security):
    def __init__(self, parser: SecFileParser | None = None, crypto_service: CryptoMain | None = None) -> None:
        self._parser = parser
        self._crypto_service = crypto_service

    def initialize(self) -> None:
        if self._parser is None:
            self._parser = SecFileParser.from_xml(Path(__file__).with_name("image3.xml").read_bytes())
        if self._crypto_service is None:
            self._crypto_service = CryptoMain.get_instance()

    def create_response_for_id(self, provider_id: int, seed: bytes, bootloader_id: SGBMID) -> bytes:
        if provider_id != 3:
            raise ValueError(f"Unsupported security provider {provider_id}; this resource defines provider 3.")
        if not isinstance(seed, bytes) or not seed:
            raise ValueError("Seed must be a nonempty byte string.")
        self.initialize()
        config = self._parser.lookup_config(bootloader_id.id_hex)
        key = self._crypto_service.get_key(config)
        message = self.TESTER_ID + bytes.fromhex(bootloader_id.id_hex) + seed
        result = BasicCrypto.transform(config.key_type, key, message, config.digest_algorithm)
        if hasattr(key, "n"):
            return self._format_rsa_result(result)
        return result

    def create_response_from_id_bytes(self, ignored_provider_id: int, id_bytes: bytes, seed: bytes) -> bytes:
        if len(id_bytes) != 4:
            raise ValueError("SGBM ID must contain exactly four bytes.")
        bootloader_id = SGBMID.from_bytes(b"\x06" + id_bytes + b"\xff\xff\xff")
        # This overload in the reference always uses provider 3.
        return self.create_response_for_id(3, seed, bootloader_id)

    @staticmethod
    def _format_rsa_result(signature: bytes) -> bytes:
        if not signature or len(signature) % 4:
            raise ValueError("RSA result must contain a whole number of four-byte words.")
        return (len(signature) // 4).to_bytes(4, "big") + BasicCrypto.reverse_four_byte_blocks(signature)

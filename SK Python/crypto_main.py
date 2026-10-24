"""Local wrapping-key loading and XML configuration-key decoding."""

from __future__ import annotations

from pathlib import Path
from threading import Lock
from typing import ClassVar

from basic_crypto import BasicCrypto
from pdx_key import PdxKey


class CryptoMain:
    _instance: ClassVar["CryptoMain | None"] = None
    _instance_lock: ClassVar[Lock] = Lock()

    def __init__(self, resources_path: str | Path | None = None) -> None:
        self._resources_path = Path(resources_path) if resources_path else Path(__file__).with_name("resources")
        self._session_key: bytes | None = None
        self._session_key_type: int | None = None
        self._load_lock = Lock()

    @classmethod
    def get_instance(cls) -> "CryptoMain":
        with cls._instance_lock:
            if cls._instance is None:
                cls._instance = cls()
            return cls._instance

    def get_key(self, key_config: PdxKey) -> object:
        if not key_config.key_data:
            raise ValueError("No key data is available in this XML record.")
        if not 0 <= key_config.key_type <= 23:
            raise ValueError(f"Key type {key_config.key_type} is not supported by the reference implementation.")
        try:
            material = bytes.fromhex(key_config.key_data)
        except ValueError as exc:
            raise ValueError("XML key data is not valid hexadecimal.") from exc
        if not key_config.plain_key_data:
            self._load_session_key()
            material = BasicCrypto.decrypt_symmetric(material, self._session_key, self._session_key_type)
        return BasicCrypto.load_key_material(material, key_config.key_type)

    def _load_session_key(self) -> None:
        with self._load_lock:
            if self._session_key is not None:
                return
            from native_resource import load_session_key
            key_type, material = load_session_key(self._resources_path)
            decoded = BasicCrypto.load_key_material(material, key_type)
            if not isinstance(decoded, bytes):
                raise ValueError("The local resources do not contain a symmetric wrapping key.")
            self._session_key_type = key_type
            self._session_key = decoded

    def close(self) -> None:
        with self._load_lock:
            self._session_key = None
            self._session_key_type = None

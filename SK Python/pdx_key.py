"""Authentication configuration; key contents are excluded from repr."""

from __future__ import annotations

from dataclasses import dataclass, field
from sgbm_id import SGBMID


@dataclass
class PdxKey:
    # Directly observed Java fields: a boolean, positive type number, SGBMID,
    # a string containing keyData, and digestAlg (default MD5).
    plain_key_data: bool = False
    key_type: int = -1
    bootloader_id: SGBMID | None = None
    digest_algorithm: str = "MD5"
    has_key_data: bool = False
    key_data_length: int = 0
    key_data: str | None = field(default=None, repr=False)

    def set_key_type(self, value: int) -> None:
        if value <= 0:
            raise ValueError("key_type must be positive")
        self.key_type = value

    def set_bootloader_id(self, value: str | SGBMID) -> None:
        try:
            self.bootloader_id = value if isinstance(value, SGBMID) else SGBMID.from_string(value)
        except ValueError as exc:
            raise ValueError("invalid SGBMID format") from exc

    def set_digest_algorithm(self, value: str | None) -> None:
        if value:
            self.digest_algorithm = value.upper()

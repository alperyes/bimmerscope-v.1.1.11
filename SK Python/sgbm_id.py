"""Readable model for the Java SGBMID value type.

The Java class stores a process-class enum, a 32-bit ID, and three version
values. The enum mapping lives in omitted class `ma`.
"""

from __future__ import annotations

from dataclasses import dataclass


@dataclass(frozen=True, order=True)
class SGBMID:
    process_class: str
    bootloader_id: int
    main_version: int
    sub_version: int
    patch_version: int

    def __post_init__(self) -> None:
        if not self.process_class:
            raise ValueError("process_class must not be empty")
        if not 0 <= self.bootloader_id <= 0xFFFFFFFF:
            raise ValueError("bootloader_id must fit in an unsigned 32-bit value")
        for name in ("main_version", "sub_version", "patch_version"):
            if not 0 <= getattr(self, name) <= 0xFF:
                raise ValueError(f"{name} must fit in one byte")

    @classmethod
    def from_bytes(cls, data: bytes, *, process_class_name: str | None = None) -> "SGBMID":
        if len(data) != 8:
            raise ValueError("SGBMID byte representation must be exactly 8 bytes")
        process_class = process_class_name or f"0x{data[0]:02X}"
        return cls(
            process_class=process_class,
            bootloader_id=int.from_bytes(data[1:5], "big"),
            main_version=data[5],
            sub_version=data[6],
            patch_version=data[7],
        )

    @classmethod
    def from_string(cls, value: str) -> "SGBMID":
        # Mirrors the Java fixed offsets. Separators are not validated there.
        if len(value) not in (22, 25):
            raise ValueError("unexpected SGBMID string length")
        try:
            process_class = value[0:4]
            bootloader_id = int(value[5:13], 16)
            if len(value) == 22:
                main_version = int(value[14:16], 16)
                sub_version = int(value[17:19], 16)
                patch_version = int(value[20:22], 16)
            else:
                # The Java 25-character form parses version fields as decimal.
                main_version = int(value[14:17], 10)
                sub_version = int(value[18:21], 10)
                patch_version = int(value[22:25], 10)
        except ValueError as exc:
            raise ValueError("unexpected SGBMID string format") from exc
        return cls(process_class, bootloader_id, main_version, sub_version, patch_version)

    @property
    def id_hex(self) -> str:
        """The Java `b()` accessor: uppercase, zero-padded 8-hex-digit ID."""
        return f"{self.bootloader_id:08X}"

    def to_bytes(self, *, process_class_code: int | None = None) -> bytes:
        if process_class_code is None:
            if self.process_class.lower().startswith("0x"):
                process_class_code = int(self.process_class, 16)
            else:
                raise ValueError("process_class_code is required to serialize a named enum")
        if not 0 <= process_class_code <= 0xFF:
            raise ValueError("process_class_code must fit in one byte")
        return bytes((process_class_code,)) + self.bootloader_id.to_bytes(4, "big") + bytes(
            (self.main_version, self.sub_version, self.patch_version)
        )

    def __str__(self) -> str:
        return (
            f"{self.process_class}-{self.id_hex}-"
            f"{self.main_version:02X}.{self.sub_version:02X}.{self.patch_version:02X}"
        )

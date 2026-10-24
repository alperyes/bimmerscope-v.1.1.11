"""XML authentication records with a separate metadata-only loading path."""

from __future__ import annotations

from dataclasses import dataclass
from typing import Iterable
import re
import xml.etree.ElementTree as ET

from pdx_key import PdxKey
from sgbm_id import SGBMID


@dataclass(frozen=True)
class AuthenticationKeyMetadata:
    sgbm_id: str
    plain_key_data: bool
    key_type: int
    digest_algorithm: str
    has_key_data: bool
    key_data_length: int


class SecFileParser:
    def __init__(self, records: Iterable[AuthenticationKeyMetadata] = ()) -> None:
        # Java SecFileParser indexes entries by SGBMID.b(), the 8-digit ID.
        self._records = {record.sgbm_id: record for record in records}
        self._configs: dict[str, PdxKey] = {}

    @staticmethod
    def _normalize_id(raw_id: str) -> str:
        value = raw_id.strip()
        if re.fullmatch(r"[0-9A-Fa-f]{8}", value):
            return value.upper()
        return SGBMID.from_string(value).id_hex

    @classmethod
    def from_xml_metadata(cls, xml_data: bytes | str) -> "SecFileParser":
        """Load inventory without retaining key contents for display/export."""
        return cls._from_xml(xml_data, include_keys=False)

    @classmethod
    def from_xml(cls, xml_data: bytes | str) -> "SecFileParser":
        """Load the key configurations needed by the calculation service."""
        return cls._from_xml(xml_data, include_keys=True)

    @classmethod
    def _from_xml(cls, xml_data: bytes | str, *, include_keys: bool) -> "SecFileParser":
        root = ET.fromstring(xml_data)
        records: list[AuthenticationKeyMetadata] = []
        configs: dict[str, PdxKey] = {}
        for entry in root.iter("AuthenticationKey"):
            id_node = entry.find(".//BL_ID")
            key_data_node = entry.find(".//keyData")
            if id_node is None or not (id_node.text or "").strip():
                continue

            raw_data = (key_data_node.text or "").strip() if key_data_node is not None else ""
            raw_type = key_data_node.get("type") if key_data_node is not None else None
            digest_algorithm = (
                key_data_node.get("digestAlg", "MD5") if key_data_node is not None else "MD5"
            )
            try:
                records.append(
                    AuthenticationKeyMetadata(
                        sgbm_id=cls._normalize_id(id_node.text or ""),
                        plain_key_data=(entry.get("plain", "false").lower() == "true"),
                        key_type=int(raw_type) if raw_type is not None else -1,
                        digest_algorithm=digest_algorithm.upper(),
                        has_key_data=bool(raw_data),
                        key_data_length=len(raw_data),
                    )
                )
                if include_keys:
                    record = records[-1]
                    raw_id = (id_node.text or "").strip()
                    bootloader_id = (SGBMID.from_bytes(bytes.fromhex("06" + record.sgbm_id + "FFFFFF"))
                                     if re.fullmatch(r"[0-9a-fA-F]{8}", raw_id)
                                     else SGBMID.from_string(raw_id))
                    configs[record.sgbm_id] = PdxKey(
                        plain_key_data=record.plain_key_data, key_type=record.key_type,
                        bootloader_id=bootloader_id, digest_algorithm=record.digest_algorithm,
                        has_key_data=record.has_key_data, key_data_length=record.key_data_length,
                        key_data=raw_data,
                    )
            except ValueError as exc:
                raise ValueError("invalid non-secret authentication record metadata") from exc
            finally:
                del raw_data
        parser = cls(records)
        parser._configs = configs
        return parser

    def lookup_config(self, sgbm_id: str) -> PdxKey:
        key = self._normalize_id(sgbm_id)
        if key not in self._records:
            raise LookupError(f"No authentication record for SGBM ID {key}.")
        if key not in self._configs:
            raise ValueError("Keys were not loaded. Use SecFileParser.from_xml for calculation.")
        return self._configs[key]

    def lookup_metadata(self, sgbm_id: str) -> AuthenticationKeyMetadata:
        key = self._normalize_id(sgbm_id)
        try:
            return self._records[key]
        except KeyError as exc:
            raise LookupError("no authentication-key record for this SGBM ID") from exc

    def lookup_config_metadata(self, bootloader_id: SGBMID) -> PdxKey:
        record = self.lookup_metadata(bootloader_id.id_hex)
        return PdxKey(
            plain_key_data=record.plain_key_data,
            key_type=record.key_type,
            bootloader_id=bootloader_id,
            digest_algorithm=record.digest_algorithm,
            has_key_data=record.has_key_data,
            key_data_length=record.key_data_length,
        )

    @property
    def record_count(self) -> int:
        return len(self._records)

    def inventory(self) -> tuple[AuthenticationKeyMetadata, ...]:
        return tuple(self._records[key] for key in sorted(self._records))

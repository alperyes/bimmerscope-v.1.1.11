"""Readable counterpart to Java ByteArrayResponse (`fn`).

The original class also wraps an omitted transport object (`dd`/`dl`). This
module keeps only static behavior that can be established independently from
the supplied class file.
"""

from __future__ import annotations
import xml.etree.ElementTree as ET


class ByteArrayResponse:
    @staticmethod
    def hex_to_bytes(value: str) -> bytes:
        if value is None or value == "":
            raise ValueError("value must not be empty")
        if len(value) % 2:
            value = "0" + value
        try:
            return bytes.fromhex(value)
        except ValueError as exc:
            raise ValueError("value is not valid hexadecimal") from exc

    @staticmethod
    def bytes_to_hex(value: bytes) -> str:
        if value is None or len(value) == 0:
            raise ValueError("value must not be empty")
        return value.hex().upper()

    @staticmethod
    def parse_xml(value: bytes | str) -> ET.Element:
        return ET.fromstring(value)

    @classmethod
    def from_transport(cls, _transport_response: object) -> "ByteArrayResponse":
        raise NotImplementedError("the required Java transport classes were not supplied")

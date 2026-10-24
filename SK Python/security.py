"""Python interface corresponding to the Java Security interface."""

from __future__ import annotations
from abc import ABC, abstractmethod
from sgbm_id import SGBMID


class Security(ABC):
    TESTER_ID = b"\xFF\xFF\xFF\xFF"

    @abstractmethod
    def initialize(self) -> None:
        """Initialize the local security-provider state."""

    @abstractmethod
    def create_response_for_id(self, provider_id: int, seed: bytes, bootloader_id: SGBMID) -> bytes:
        """Java overload accepting an already parsed SGBMID."""

    @abstractmethod
    def create_response_from_id_bytes(self, ignored_provider_id: int, id_bytes: bytes, seed: bytes) -> bytes:
        """Java overload: builds an SGBMID from four ID bytes; provider 3 is fixed."""

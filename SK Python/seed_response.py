"""Native Python seed-response calculation; no Java or JAR runtime."""

from __future__ import annotations

from pathlib import Path
import re

from sec_file_parser import SecFileParser
from security_impl import SecurityImpl


def calculate_response(xml_path: str | Path, sgbm_id: str, seed: str) -> str:
    """Calculate using the selected XML and local key resources."""
    identifier = sgbm_id.strip().upper()
    seed = re.sub(r"\s+", "", seed.strip())
    if seed.lower().startswith("0x"):
        seed = seed[2:]
    if not re.fullmatch(r"[0-9A-F]{8}", identifier):
        raise ValueError("Enter the SGBM ID as exactly eight hexadecimal digits.")
    if not seed or len(seed) % 2 or not re.fullmatch(r"[0-9a-fA-F]+", seed):
        raise ValueError("Enter the seed as an even number of hexadecimal digits.")
    source = Path(xml_path).expanduser().resolve()
    if not source.is_file():
        raise ValueError("Load your XML authentication records first.")
    parser = SecFileParser.from_xml(source.read_bytes())
    parser.lookup_config(identifier)
    service = SecurityImpl(parser=parser)
    response = service.create_response_from_id_bytes(3, bytes.fromhex(identifier), bytes.fromhex(seed))
    return response.hex().upper()


def default_xml_path() -> str:
    """Return the bundled authentication record path for embedded callers."""
    return str(Path(__file__).with_name("image3.xml"))


def calculate_default_response(sgbm_id: str, seed: str) -> str:
    """Calculate against the bundled authentication records."""
    return calculate_response(default_xml_path(), sgbm_id, seed)


if __name__ == "__main__":
    import argparse

    cli = argparse.ArgumentParser(description="Calculate a local seed response")
    cli.add_argument("sgbm_id")
    cli.add_argument("seed")
    args = cli.parse_args()
    print(calculate_response(default_xml_path(), args.sgbm_id, args.seed))

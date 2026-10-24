"""Regression checks use a previously recorded synthetic result, not Java."""

import hashlib
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

from basic_crypto import BasicCrypto
from crypto_main import CryptoMain
from sec_file_parser import SecFileParser
from security_impl import SecurityImpl
from seed_response import calculate_response


PROJECT = Path(__file__).resolve().parents[1]
RECORDED_RESULT = (
    "000000201359C3BDDD1F45D6DED7F4E37680FD860BD0DB6C8A099543BE9A5AAD62CD9B9C"
    "DCE61B3766114DE7D622FAAF6E3CDFC7C81AF3F083E03F62F2986336CA1B23F83C056F8E4"
    "B8FACF1F0F89E00E413D60305E4A56C19675ED5373A162B7A0B4A4F3A7298FD53DA0C99A1"
    "973A87A3557001E45F85B95EF9B134680437285126C11F"
)


class NativeResponseTests(unittest.TestCase):
    def test_recorded_response_without_java_or_jar(self):
        CryptoMain._instance = None
        with patch("subprocess.Popen", side_effect=AssertionError("No external process allowed")), \
             patch("zipfile.ZipFile", side_effect=AssertionError("No JAR/archive access allowed")):
            result = calculate_response(PROJECT / "image3.xml", "00000003", "00" * 16)
        self.assertEqual(result, RECORDED_RESULT)
        self.assertEqual(len(bytes.fromhex(result)), 132)

    def test_plain_symmetric_xml_uses_selected_file(self):
        key = bytes(range(16))
        seed = bytes.fromhex("12345678")
        xml = ('<root><AuthenticationKey plain="true"><BL_ID>00000003</BL_ID>'
               f'<keyData type="3">{key.hex()}</keyData></AuthenticationKey></root>')
        with tempfile.TemporaryDirectory() as temporary:
            source = Path(temporary) / "custom.xml"
            source.write_text(xml, encoding="utf-8")
            actual = calculate_response(source, "00000003", seed.hex())
        message = bytes.fromhex("FFFFFFFF00000003") + seed
        self.assertEqual(actual, hashlib.md5(key + message + key).hexdigest().upper())

    def test_invalid_inputs_and_missing_record(self):
        for identifier, seed in [("BAD", "00"), ("00000003", "F"), ("00000003", "GG")]:
            with self.subTest(identifier=identifier, seed=seed), self.assertRaises(ValueError):
                calculate_response(PROJECT / "image3.xml", identifier, seed)
        with self.assertRaises(LookupError):
            calculate_response(PROJECT / "image3.xml", "FFFFFFFF", "00" * 16)

    def test_metadata_loader_does_not_retain_key_contents(self):
        parser = SecFileParser.from_xml_metadata((PROJECT / "image3.xml").read_bytes())
        self.assertEqual(parser.record_count, 1283)
        with self.assertRaises(ValueError):
            parser.lookup_config("00000003")

    def test_hex_whitespace_and_prefix(self):
        result = calculate_response(PROJECT / "image3.xml", "00000003", "0x" + "00 " * 16)
        self.assertEqual(result, RECORDED_RESULT)

    def test_response_word_count_and_byte_order(self):
        signature = bytes(range(128))
        result = SecurityImpl._format_rsa_result(signature)
        self.assertEqual(result[:4], bytes.fromhex("00000020"))
        self.assertEqual(result[4:8], bytes((124, 125, 126, 127)))
        self.assertEqual(result[-4:], bytes((0, 1, 2, 3)))
        self.assertEqual(BasicCrypto.digest(b"abc", "SHA-256"), hashlib.sha256(b"abc").digest())
        self.assertEqual(BasicCrypto.digest(b"abc", "SHA-384"), hashlib.sha384(b"abc").digest())
        self.assertEqual(BasicCrypto.digest(b"abc", "SHA3-512"), hashlib.sha3_512(b"abc").digest())

    def test_unimplemented_reference_type_is_explicit(self):
        with self.assertRaisesRegex(ValueError, "not supported"):
            BasicCrypto.load_key_material(bytes(64), 40)


if __name__ == "__main__":
    unittest.main()

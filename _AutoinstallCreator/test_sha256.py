import shutil
import unittest


class TestSha256(unittest.TestCase):
    def test_sha256_info(self):
        print(f"shasum: {shutil.which('shasum')}")
        print(f"sha256sum: {shutil.which('sha256sum')}")

#!/bin/bash

testVersion() {
  bsdtar_version_info="$("./.tmp/bsdtar.exe" --version)"
  assertContains "$bsdtar_version_info" "zlib/"
  assertContains "$bsdtar_version_info" "liblzma/"
  assertContains "$bsdtar_version_info" "libzstd/"
}

# Load and run shUnit2.
source "../.tests/shunit2/shunit2"

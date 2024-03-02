#!/bin/bash

testVersion() {
  version_info="$("./.tmp/zstd.exe")"
  assertContains "$version_info" "Zstandard CLI (64-bit)"
}

# Load and run shUnit2.
source "../.tests/shunit2/shunit2"

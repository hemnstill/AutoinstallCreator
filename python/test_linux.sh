#!/bin/bash

testVersion() {
  version_info="$("./Scripts/bin/python3" --version | head -c 9)"
  assertEquals "$version_info" "Python 3."
}

# Load and run shUnit2.
source "../.tests/shunit2/shunit2"

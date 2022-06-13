#!/bin/bash

testVersion() {
  bsdtar_version_info="$("./busybox.exe")"
  assertContains "$bsdtar_version_info" "BusyBox is a multi-call binary that combines many common Unix
utilities into a single executable."
}

# Load and run shUnit2.
source "../.tests/shunit2/shunit2"

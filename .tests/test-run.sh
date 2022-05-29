#!/bin/bash
dp0="$(realpath "$(dirname "$0")")"
dp0_tools="$dp0/../.tools" && source "$dp0_tools/env_tools.sh"
set -e
cd "$dp0"

testInternalCreate() {
  "$dp0_tools/batch_runner.sh" _ create || fail
}

testExternalCreate() {
  "$dp0_tools/batch_runner.sh" "" create || fail
}

# Load and run shUnit2.
source "./shunit2/shunit2"

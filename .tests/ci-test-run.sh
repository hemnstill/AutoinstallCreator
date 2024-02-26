#!/bin/bash
export CI=true
dp0="$(realpath "$(dirname "$0")")"
dp0_tools="$dp0/../.tools" && source "$dp0_tools/env_tools.sh"
set -e

"$dp0/test-linter.sh" || exit 1

"$dp0/test-tools.sh" || exit 1

cd "$dp0/../_AutoinstallCreator" && python3 -m unittest || exit 1

"$dp0/test-run.sh" -- testInternalCreate || exit 1

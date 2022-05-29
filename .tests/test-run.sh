#!/bin/bash
dp0="$(realpath "$(dirname "$0")")"
dp0_tools="$dp0/../.tools" && source "$dp0_tools/env_tools.sh"
set -e

if [[ "$is_windows_os" == true ]]; then
  "$dp0/test-run-bat.sh" -- testInternalCreate || exit 1
else
  "$dp0/test-run-sh.sh" -- testInternalCreate || exit 1
fi

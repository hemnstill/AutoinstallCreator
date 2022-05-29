#!/bin/bash
dp0="$(realpath "$(dirname "$0")")"
dp0_tools="$dp0/../.tools" && source "$dp0_tools/env_tools.sh"

echo ">> env:"
uname -a
echo is_windows: "$is_windows_os", is_alpine: "$is_alpine_os"

if [[ "$is_windows_os" == true ]]; then
  "./test_tools_windows.sh"
else
  "./test_tools_linux.sh"
fi

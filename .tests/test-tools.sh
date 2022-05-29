#!/bin/bash
dp0="$(realpath "$(dirname "$0")")"
set -e
cd "$dp0"

echo ">> env:"
uname -a
echo is_windows: "$is_windows_os", is_alpine: "$is_alpine_os"

if [[ "$is_windows_os" == true ]]; then
  "./test_tools_windows.sh"
else
  "./test_tools_linux.sh"
fi

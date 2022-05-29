#!/bin/bash
dp0="$(realpath "$(dirname "$0")")"
dp0_tools="$dp0/../.tools" && source "$dp0_tools/env_tools.sh"
set -e
cd "$dp0"

testShStartsWith() {
  for d in ../*/; do
    dir_name=${d:3}
    if [[ -f "${d}create_install.sh" ]]; then
      echo ">> Test $dir_name"
      local etalon_head="$(printf '#!/bin/bash
dp0="$(realpath "$(dirname "$0")")"
dp0_tools="$dp0/../.tools" && source "$dp0_tools/env_tools.sh"
set -e
cd "$dp0"
')"
      assertEquals  "$etalon_head" "$(cat "${d}create_install.sh" | dos2unix | head -6)"
    fi
  done
}

testBatStartsWith() {
  for d in ../*/; do
    dir_name=${d:3}
    if [[ -f "${d}create_install.bat" && -f "${d}create_install.sh" ]]; then
      echo ">> Test $dir_name"
      local etalon_head="$(printf '@echo off
"%%~dp0..\\.tools\\busybox64.exe" bash "%%~dp0create_install.sh"
')"
      assertEquals  "$etalon_head" "$(cat "${d}create_install.bat" | dos2unix | head -3)"
    fi
  done
}

testBatEndsWith() {
  for d in ../*/; do
    dir_name=${d:3}
    if [[ -f "${d}create_install.bat" ]]; then
      echo ">> Test $dir_name"
      local etalon_head="$(echo "
exit /b %errorlevel%")"
      assertEquals  "$etalon_head" "$(cat "${d}create_install.bat" | dos2unix | tail -2)"
    fi
  done
}

# Load and run shUnit2.
source "../.tests/shunit2/shunit2"

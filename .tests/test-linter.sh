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
      assertEquals  "$etalon_head" "$(cat "${d}create_install.sh" | head -6)"
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
      assertEquals  "$etalon_head" "$(cat "${d}create_install.bat" | tail -2 | dos2unix)"
    fi
  done
}

# Load and run shUnit2.
source "../.tests/shunit2/shunit2"

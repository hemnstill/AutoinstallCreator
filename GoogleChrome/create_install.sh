#!/bin/bash
dp0="$(realpath "$(dirname "$0")")"
dp0_tools="$dp0/../.tools" && source "$dp0_tools/env_tools.sh"
set -e
cd "$dp0"

download_url='https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb'
$curl --location $download_url --remote-name
errorlevel=$?
if [[ $errorlevel -ne 0 ]]; then exit $errorlevel; fi

{
  printf '#!/bin/bash
cd "$(realpath "$(dirname "$0")")" || exit
apt install ./%s' "$(basename -- "$download_url")"
} >autoinstall.sh
chmod +x ./autoinstall.sh

echo Done.

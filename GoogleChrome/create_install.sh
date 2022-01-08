#!/bin/bash
cd "$(dirname "${BASH_SOURCE[0]}")"
source ../.src/env_tools.sh

download_url='https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb'
$curl --location $download_url --remote-name
errorlevel=$?; if [[ $errorlevel -ne 0 ]]; then exit $errorlevel; fi

{ printf '#!/bin/bash
cd "$(dirname "${BASH_SOURCE[0]}")"
apt install ./%s' "$(basename -- "$download_url")"
} > autoinstall.sh
chmod +x ./autoinstall.sh

echo Done.

#!/bin/bash
cd "$(dirname "${BASH_SOURCE[0]}")"
curl="../curl --fail --cacert ../curl-ca-bundle.crt" && [[ $(uname) == MINGW64* ]] && curl="../curl.exe --fail"

download_url='https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb'
$curl --location $download_url --remote-name
errorlevel=$?; if [[ $errorlevel -ne 0 ]]; then exit $errorlevel; fi

{ printf '#!/bin/bash
cd "$(dirname "${BASH_SOURCE[0]}")"
apt install ./%s' "$(basename -- "$download_url")"
} > autoinstall.sh
chmod +x ./autoinstall.sh

echo Done.

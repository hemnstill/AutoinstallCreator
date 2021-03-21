#!/bin/bash
cd "$(dirname "${BASH_SOURCE[0]}")"
export LC_ALL=en_US.UTF-8
curl="../curl --fail --cacert ../curl-ca-bundle.crt" && [[ $(uname) == MINGW64* ]] && curl="../curl.exe --fail"
grep="grep" && [[ $(uname) == MINGW64* ]] && grep="../grep.exe"

latest_version=https://api.github.com/repos/dtschan/curl-static/releases/latest
echo Get latest version: $latest_version ...
download_url=$($curl --silent --location "$latest_version" | "$grep" -Po '(?<="browser_download_url":\s").*curl(?=")')
$curl --location "$download_url" --remote-name
errorlevel=$?; if [[ $errorlevel -ne 0 ]]; then exit $errorlevel; fi

{ printf '#!/bin/bash
cd "$(dirname "${BASH_SOURCE[0]}")"
tar cf - ./curl | (cd ..; tar xvf -)
chmod +x ../curl'
} > autoinstall.sh
chmod +x ./autoinstall.sh

echo Done.

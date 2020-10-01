#!/bin/bash
cd "$(dirname "${BASH_SOURCE[0]}")"
export LC_ALL=en_US.UTF-8
curl="../curl --fail --cacert ../curl-ca-bundle.crt" && [[ $(uname) == MINGW64* ]] && curl="../curl.exe --fail"
grep="grep" && [[ $(uname) == MINGW64* ]] && grep="../grep.exe"

api_url='https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release'
echo Get latest version: $api_url ...
download_url=$($curl --location "$api_url" | "$grep" -Po "(?<=\"link\":\")[^,]+tar.gz(?=\")")
echo Downloading: $download_url ...
$curl --location $download_url --remote-name
errorlevel=$?; if [[ $errorlevel -ne 0 ]]; then exit $errorlevel; fi

tar -xzf $(basename -- "$download_url") --strip-components 1
errorlevel=$?; if [[ $errorlevel -ne 0 ]]; then exit $errorlevel; fi

{
  echo '#!/bin/bash'
  echo 'cd "$(dirname "${BASH_SOURCE[0]}")"'
  echo ./jetbrains-toolbox
} > autoinstall.sh
chmod +x ./autoinstall.sh

echo Done.
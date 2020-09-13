#!/bin/bash
cd "$(dirname "${BASH_SOURCE[0]}")"
export LC_ALL=en_US.UTF-8
function curl() { if [[ $(uname) == MINGW64* ]];then ../curl.exe --fail $@; else ../curl --fail --cacert ../curl-ca-bundle.crt $@; fi }
function grep() { if [[ $(uname) == MINGW64* ]];then ../grep.exe $@; else /usr/bin/grep $@; fi }

latest_version=https://api.github.com/repos/dtschan/curl-static/releases/latest
echo Get latest version: $latest_version ...
downloadurl=$(curl --silent --location "$latest_version" | grep -Po '(?<="browser_download_url":\s").*curl(?=")')
curl --location "$downloadurl" --remote-name

{
  echo '#!/bin/bash'
  echo 'cd "$(dirname "${BASH_SOURCE[0]}")"'
  echo 'function cp() { if [[ $(uname) == MINGW64* ]];then ../cp.exe $@; else /usr/bin/cp $@; fi }'
  echo 'cp -fv ./curl ../curl'
  echo 'chmod +x ../curl'
} > autoinstall.sh
chmod +x ./autoinstall.sh

echo Done.
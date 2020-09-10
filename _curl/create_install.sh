#!/bin/bash
cd "$(dirname "${BASH_SOURCE[0]}")"
function curl() { if [[ $(uname) == CYGWIN* ]];then ../curl.exe --fail $@; else ../curl --fail --cacert ../curl-ca-bundle.crt $@; fi }

latest_version=https://api.github.com/repos/dtschan/curl-static/releases/latest
echo Get latest version: $latest_version ...
curl --location "$latest_version" > raw_download_str.tmp
downloadurl=$(grep -Po "(?<=\"browser_download_url\": \").*curl(?=\")" raw_download_str.tmp)
curl --location "$downloadurl" --remote-name

{
  echo '#!/bin/bash'
  echo 'cd "$(dirname "${BASH_SOURCE[0]}")"'
  echo 'function cp() { if [[ $(uname) == CYGWIN* ]];then ../cp.exe $@; else /usr/bin/cp $@; fi }'
  echo 'cp -f ./curl ../curl'
  echo 'chmod +x ../curl'
} > autoinstall.sh
chmod +x ./autoinstall.sh

echo Done.
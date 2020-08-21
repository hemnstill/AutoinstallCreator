#!/bin/bash
cd "$(dirname "${BASH_SOURCE[0]}")"
function curl() { if [[ $(uname) == CYGWIN* ]]; then ../curl.exe $@; else ../curl --cacert ../curl-ca-bundle.crt $@; fi }

codename=$(if [[ $(command -v lsb_release) == '' ]]; then echo $1; else echo $(lsb_release -cs); fi)
if [[ $codename == '' ]]; then echo 'Cannot get codename'; exit; else echo $codename; fi

launchpad_api_url='https://api.launchpad.net/1.0'
published_sources_url="$launchpad_api_url/~far2l-team/+archive/ubuntu/ppa?ws.op=getPublishedSources&distro_series=$launchpad_api_url/ubuntu/$codename&pocket=Release"
curl --fail --location "$published_sources_url" > raw_download_str.tmp
sourcepub_url=$(grep -Po "(?<=\"self_link\": \")[^,]*(?=\")" raw_download_str.tmp | head -1)
download_url=$(curl --location $sourcepub_url'?ws.op=binaryFileUrls' | grep -Po "(?<=\")[^,]+amd64.deb(?=\")" | head -1 )
curl --fail --location $download_url --remote-name
{
  echo '#!/bin/bash'
  echo 'cd "$(dirname "${BASH_SOURCE[0]}")"'
  echo dpkg -i $(basename -- "$download_url")
} > autoinstall.sh
chmod +x ./autoinstall.sh

echo Done.

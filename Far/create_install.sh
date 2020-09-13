#!/bin/bash
cd "$(dirname "${BASH_SOURCE[0]}")"
export LC_ALL=en_US.UTF-8
function curl() { if [[ $(uname) == MINGW64* ]];then ../curl.exe --fail $@; else ../curl --fail --cacert ../curl-ca-bundle.crt $@; fi }
function grep() { if [[ $(uname) == MINGW64* ]];then ../grep.exe $@; else /usr/bin/grep $@; fi }


codename=$(if [[ $(command -v lsb_release) == '' ]]; then echo $1; else echo $(lsb_release -cs); fi)
if [[ $codename == '' ]]; then echo 'Cannot get codename'; exit $?; else echo $codename; fi

launchpad_api_url='https://api.launchpad.net/1.0'
published_sources_url="$launchpad_api_url/~far2l-team/+archive/ubuntu/ppa?ws.op=getPublishedSources&distro_series=$launchpad_api_url/ubuntu/$codename&pocket=Release"
curl --location "$published_sources_url" > raw_download_str.tmp
sourcepub_url=$(grep -Po "(?<=\"self_link\":\s\")[^,]*(?=\")" raw_download_str.tmp | head -1)
download_url=$(curl --location $sourcepub_url'?ws.op=binaryFileUrls' | grep -Po "(?<=\")[^,]+amd64.deb(?=\")" | head -1 )
echo Downloading: $download_url ...
curl --location $download_url --remote-name

{
  echo '#!/bin/bash'
  echo 'cd "$(dirname "${BASH_SOURCE[0]}")"'
  echo dpkg -i $(basename -- "$download_url")
} > autoinstall.sh
chmod +x ./autoinstall.sh

echo Done.

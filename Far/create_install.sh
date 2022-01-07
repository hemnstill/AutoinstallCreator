#!/bin/bash
cd "$(dirname "${BASH_SOURCE[0]}")"
export LC_ALL=en_US.UTF-8
curl="../curl-amd64 --fail --cacert ../curl-ca-bundle.crt" && [[ $(uname) == MINGW64* ]] && curl="../curl.exe --fail"
grep="grep" && [[ $(uname) == MINGW64* ]] && grep="../grep.exe"

codename="$1"
[[ -z "$codename" ]] && [[ -n $(command -v lsb_release) ]] && {
  echo "get ubuntu codename from lsb_release";
  codename="$(lsb_release -cs)";
}
[[ -z "$codename" ]] && {
  ubuntu_releases_url='https://wiki.ubuntu.com/Releases?action=raw';
  echo "get latest ubuntu codename from: $ubuntu_releases_url";
  ubuntu_lts_codename=$($curl --silent --location "$ubuntu_releases_url" | $grep -F " LTS" | $grep -Po '(?<=|)\w+(?=\s\w+]])' | head -1);
  codename=${ubuntu_lts_codename,,};
}
[[ -z $codename ]] && { echo 'Cannot get codename'; exit 1; }

launchpad_api_url='https://api.launchpad.net/1.0'
published_sources_url="$launchpad_api_url/~far2l-team/+archive/ubuntu/ppa?ws.op=getPublishedSources&distro_series=$launchpad_api_url/ubuntu/$codename&pocket=Release"
echo "Get last release: $published_sources_url" ...
sourcepub_self_link=$($curl --silent --location "$published_sources_url" | $grep -Po "(?<=\"self_link\":\s\")[^,]*(?=\")" | head -1)
[[ -z $sourcepub_self_link ]] && { echo "Cannot get sourcepub_self_link"; exit 1; }

echo "get binaryFileUrls from sourcepub_self_link: $sourcepub_self_link ..."
download_url=$($curl --silent --location "$sourcepub_self_link"'?ws.op=binaryFileUrls' | $grep -Po "(?<=\")[^,]+amd64.deb(?=\")" | head -1 )
[[ -z $download_url ]] && { echo "Cannot get download_url"; exit 1; }

echo "Downloading: $download_url ..."
$curl --location "$download_url" --remote-name
errorlevel=$?; if [[ $errorlevel -ne 0 ]]; then exit $errorlevel; fi

{ printf '#!/bin/bash
cd "$(dirname "${BASH_SOURCE[0]}")"
apt install ./%s' "$(basename -- "$download_url")"
} > autoinstall.sh
chmod +x ./autoinstall.sh

echo Done.

#!/bin/bash
dp0="$(realpath "$(dirname "$0")")"
dp0_tools="$dp0/../.tools" && source "$dp0_tools/env_tools.sh"
set -e
cd "$dp0"

api_url='https://api.github.com/repos/moparisthebest/static-curl/releases/latest'
echo Get latest version: "$api_url" ...
download_url=$($curl --silent --location "$api_url" | "$grep" --only-matching '(?<="browser_download_url":\s")[^,]+curl-amd64(?=")' | head -n 1)
[[ -z "$download_url" ]] && {
  echo "curl-amd64: Cannot get release version"
  exit 1
}

echo "Downloading: $download_url ..."
$curl --location "$download_url" --remote-name

download_url_win=https://curl.se/windows/latest.cgi?p=win64-mingw.zip
echo "Downloading: $download_url_win ..."
$curl --location "$download_url_win" --output win64-mingw.zip

"$p7z" e "win64-mingw.zip" "-o.tmp" *.exe *.crt -aoa -r
cp -rfv "$dp0/curl-amd64" ".tmp/"


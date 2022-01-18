#!/bin/bash
cd "$(dirname "${BASH_SOURCE[0]}")"
source ../.src/env_tools.sh

api_url='https://api.github.com/repos/libarchive/libarchive/releases/latest'
echo Get latest version: $api_url ...
download_url=$($curl --silent --location "$api_url" | "$grep" -Po '(?<="browser_download_url":\s")[^,]+win64\.zip(?=")' | head -1)
[[ -z "$download_url" ]] && {
  echo "Cannot get release version"
  exit 1
}

echo "Downloading: $download_url ..."
$curl --location "$download_url" --remote-name
errorlevel=$?
if [[ $errorlevel -ne 0 ]]; then exit $errorlevel; fi

zip_file_name="$(basename -- "$download_url")"
"$p7zip" e "$zip_file_name" "-o." bsdtar.exe -aoa -r

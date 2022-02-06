#!/bin/bash
dp0="$(realpath "$(dirname "$0")")"
dp0_tools="$dp0/../.tools" && source "$dp0_tools/env_tools.sh"
cd "$dp0" || exit

api_url='https://api.github.com/repos/facebook/zstd/releases/latest'
echo Get latest version: $api_url ...
download_url=$($curl --silent --location "$api_url" | "$grep" --only-matching '(?<="browser_download_url":\s")[^,]+win64\.zip(?=")' | head -1)
[[ -z "$download_url" ]] && {
  echo "Cannot get release version"
  exit 1
}

echo "Downloading: $download_url ..."
$curl --location "$download_url" --remote-name
errorlevel=$?
if [[ $errorlevel -ne 0 ]]; then exit $errorlevel; fi

zip_file_name="$(basename -- "$download_url")"
"$p7z" e "$zip_file_name" "-o." zstd.exe -aoa -r

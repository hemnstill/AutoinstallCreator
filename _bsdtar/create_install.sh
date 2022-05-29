#!/bin/bash
set -e
dp0="$(realpath "$(dirname "$0")")"
dp0_tools="$dp0/../.tools" && source "$dp0_tools/env_tools.sh"
cd "$dp0"

api_url='https://api.github.com/repos/hemnstill/StandaloneTools/releases?per_page=100'
echo Get latest version: "$api_url" ...
download_url=$($curl --silent --location "$api_url" | "$grep" --only-matching '(?<="browser_download_url":\s")[^,]+bsdtar-[^,]+build-mingw\.tar\.gz(?=")' | head -1)
[[ -z "$download_url" ]] && {
  echo "Cannot get release version"
  exit 1
}

echo "Downloading: $download_url ..."
$curl --location "$download_url" --remote-name

zip_file_name="$(basename -- "$download_url")"
"$p7z" e "$zip_file_name" -so | "$p7z" e -si -ttar "-o." bsdtar.exe -aoa -r

if [[ "$is_windows_os" == true ]]; then
  ./test_windows.sh;
fi


#!/bin/bash
dp0="$(realpath "$(dirname "$0")")"
dp0_tools="$dp0/../.tools" && source "$dp0_tools/env_tools.sh"
set -e
cd "$dp0"

api_url='https://api.github.com/repos/hemnstill/StandaloneTools/releases?per_page=100'
echo Get latest version: $api_url ...
download_url=$($curl --silent --location "$api_url" | "$grep" --only-matching '(?<="browser_download_url":\s")[^,]+zstd-[^,]+build-mingw\.tar\.gz(?=")' | head -1)
[[ -z "$download_url" ]] && {
  echo "build-mingw: Cannot get release version"
  exit 1
}
echo "Downloading: $download_url ..."
$curl --location "$download_url" --remote-name

download_url_musl=$($curl --silent --location "$api_url" | "$grep" --only-matching '(?<="browser_download_url":\s")[^,]+zstd-[^,]+build-musl\.tar\.gz(?=")' | head -1)
[[ -z "$download_url_musl" ]] && {
  echo "build-musl: Cannot get release version"
  exit 1
}
echo "Downloading: $download_url_musl ..."
$curl --location "$download_url_musl" --remote-name

zip_file_name="$(basename -- "$download_url")"
"$p7z" e "$zip_file_name" -so | "$p7z" e -si -ttar "-o.tmp" zstd.exe -aoa -r

zip_file_name_musl="$(basename -- "$download_url_musl")"
"$p7z" e "$zip_file_name_musl" -so | "$p7z" e -si -ttar "-o.tmp" zstd -aoa -r


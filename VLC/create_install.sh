#!/bin/bash
dp0="$(realpath "$(dirname "$0")")"
dp0_tools="$dp0/../.tools" && source "$dp0_tools/env_tools.sh"
set -e
cd "$dp0"

latest_version=https://www.videolan.org/vlc/download-windows.html
echo Get latest version: "$latest_version" ...
latest_version_str=$($curl --silent --location "$latest_version" | "$grep" --only-matching '(?<=href=")[^\s]+win64/vlc-[^\s]+(?=-win64\.exe")' | "$grep" --only-matching '[^-]+$' | head -n1)
[[ -z "$latest_version_str" ]] && {
  echo "Cannot get mirror link"
  exit 1
}

download_url="https://download.videolan.org/pub/videolan/vlc/$latest_version_str/win64/vlc-$latest_version_str-win64.zip"
filename="$(basename -- "$download_url")"
echo "Downloading: $download_url ..."
$curl --location "$download_url" --remote-name

echo Extracting ...
"$p7z" x "$filename" "-o." -aoa -r

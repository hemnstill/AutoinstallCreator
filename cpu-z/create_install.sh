#!/bin/bash
dp0="$(realpath "$(dirname "$0")")"
dp0_tools="$dp0/../.tools" && source "$dp0_tools/env_tools.sh"
set -e
cd "$dp0"

latest_version=https://www.cpuid.com/softwares/cpu-z.html
echo Get latest version: "$latest_version" ...
download_url=$($curl --silent --location "$latest_version" | "$grep" --only-matching '(?<=href=")[^\s]+cpu-z/cpu-z[^\s]+-en\.zip(?=")' | head -n1)
[[ -z "$download_url" ]] && {
  echo "Cannot get release version"
  exit 1
}

filename="$(basename -- "$download_url")"
download_url="https://download.cpuid.com/cpu-z/$filename"
echo "Downloading: $download_url ..."
$curl --location "$download_url" --remote-name

echo Extracting ...
"$p7z" e "$filename" "-o." *_x64.exe -aoa -r

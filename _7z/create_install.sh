#!/bin/bash
dp0="$(realpath "$(dirname "$0")")"
dp0_tools="$dp0/../.tools" && source "$dp0_tools/env_tools.sh"
set -e
cd "$dp0"

rm -f .tmp/*
mkdir -p .tmp

latest_version=https://www.7-zip.org/download.html

echo Get latest windows version: "$latest_version" ...
download_url=$($curl --silent --location "$latest_version" | "$grep" --only-matching '(?<=href=")[^\s]+-x64\.exe(?=")' | head -n1)
[[ -z "$download_url" ]] && {
  echo "Cannot get release version"
  exit 1
}

download_url="https://www.7-zip.org/$download_url"
echo "Downloading: $download_url ..."
$curl --location "$download_url" --remote-name

"$p7z" e "$(basename -- "$download_url")" "-o.tmp" 7z.exe 7z.dll -aoa -r

echo Get latest linux version: "$latest_version" ...
download_url=$($curl --silent --location "$latest_version" | "$grep" --only-matching '(?<=href=")[^\s]+-linux-x64\.tar\.xz(?=")' | head -n1)
[[ -z "$download_url" ]] && {
  echo "Cannot get release version"
  exit 1
}

download_url="https://www.7-zip.org/$download_url"
echo "Downloading: $download_url ..."
$curl --location "$download_url" --remote-name

"$p7z" e "$(basename -- "$download_url")" -so | "$p7z" e -si -ttar "-o.tmp" 7zzs -aoa -r

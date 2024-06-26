#!/bin/bash
dp0="$(realpath "$(dirname "$0")")"
dp0_tools="$dp0/../.tools" && source "$dp0_tools/env_tools.sh"
set -e
cd "$dp0"

latest_version=https://api.github.com/repos/balena-io/etcher/releases/latest
echo Get latest version: "$latest_version" ...
download_url=$($curl --silent --location "$latest_version" | "$grep" --only-matching '(?<="browser_download_url":\s")[^,]+balenaEtcher-win32-x64-[^,-]+\.zip(?=")' | head -n1)
[[ -z "$download_url" ]] && {
  echo "Cannot get release version"
  exit 1
}

echo "Downloading: $download_url ..."
$curl --location "$download_url" --remote-name


filename="$(basename -- "$download_url")"
echo Extracting '$filename' ...
"$p7z" x "$filename" "-obalenaEtcher" -aoa -r

#!/bin/bash
dp0="$(realpath "$(dirname "$0")")"
dp0_tools="$dp0/../.tools" && source "$dp0_tools/env_tools.sh"
set -e
cd "$dp0"

latest_version=https://www.7-zip.org/download.html
echo Get latest version: "$latest_version" ...
download_url=$($curl --silent --location "$latest_version" | "$grep" --only-matching '(?<=href=")[^\s]+-x64\.msi(?=")' | head -n1)
[[ -z "$download_url" ]] && {
  echo "Cannot get release version"
  exit 1
}

download_url="https://www.7-zip.org/$download_url"
echo "Downloading: $download_url ..."
$curl --location "$download_url" --remote-name

echo Generating autoinstall ...
# shellcheck disable=SC2016
{
  printf '#!/bin/bash
cd "$(realpath "$(dirname "$0")")" || exit 1
set -v
msiexec.exe /i "%s" /passive
' "$(basename -- "$download_url")"
} >autoinstall.sh
chmod +x ./autoinstall.sh

{
  printf '@echo off
"%%~dp0..\\.tools\\busybox.exe" bash "%%~dp0autoinstall.sh"
exit /b %%errorlevel%%
'
} >autoinstall.bat

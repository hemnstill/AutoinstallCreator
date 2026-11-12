#!/bin/bash
dp0="$(realpath "$(dirname "$0")")"
dp0_tools="$dp0/../.tools" && source "$dp0_tools/env_tools.sh"
set -e
cd "$dp0"

latest_version="https://slack.com/api/desktop.latestRelease?arch=x64&variant=exe"
echo Get latest version: "$latest_version" ...
download_url=$($curl --silent --location "$latest_version" | "$grep" --only-matching '(?<="download_url":")[^"]+\.exe(?=")' | tr -d '\\')
[[ -z "$download_url" ]] && {
  echo "Cannot get release version"
  exit 1
}

echo "Downloading: $download_url ..."
$curl --location "$download_url" --remote-name

echo Generating autoinstall ...
# shellcheck disable=SC2016
{
  printf '#!/bin/bash
cd "$(realpath "$(dirname "$0")")" || exit 1
set -v
"./%s" --silent
' "$(basename -- "$download_url")"
} >autoinstall.sh
chmod +x ./autoinstall.sh

{
  printf '@echo off
"%%~dp0..\\.tools\\busybox.exe" bash "%%~dp0autoinstall.sh"
exit /b %%errorlevel%%
'
} >autoinstall.bat

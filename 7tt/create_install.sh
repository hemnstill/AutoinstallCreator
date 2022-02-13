#!/bin/bash
dp0="$(realpath "$(dirname "$0")")"
dp0_tools="$dp0/../.tools" && source "$dp0_tools/env_tools.sh"
cd "$dp0" || exit 1

download_url="https://rammichael.com/downloads/7tt_setup.exe"
echo "Downloading: $download_url ..."
$curl --location "$download_url" --remote-name
errorlevel=$?
if [[ $errorlevel -ne 0 ]]; then exit $errorlevel; fi

latest_filename="$(basename -- "$download_url")"
{
  printf '"%s" /S' "%~dp0$latest_filename"
} >autoinstall.bat

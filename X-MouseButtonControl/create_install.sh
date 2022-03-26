#!/bin/bash
dp0="$(realpath "$(dirname "$0")")"
dp0_tools="$dp0/../.tools" && source "$dp0_tools/env_tools.sh"
cd "$dp0" || exit 1

latest_filename="X-MouseButtonControlSetup.exe"
download_url="https://www.highrez.co.uk/scripts/download.asp?package=XMouse"

echo "Downloading: $download_url ..."
$curl --location "$download_url" --output "$latest_filename"
errorlevel=$?
if [[ $errorlevel -ne 0 ]]; then exit $errorlevel; fi

{ printf '"%s" /S
' "%~dp0$latest_filename"
} >autoinstall.bat

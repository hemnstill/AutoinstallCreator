#!/bin/bash
dp0="$(realpath "$(dirname "$0")")"
dp0_tools="$dp0/../.tools" && source "$dp0_tools/env_tools.sh"
set -e
cd "$dp0"

download_url="https://ramensoftware.com/downloads/7tt_setup.exe"
echo "Downloading: $download_url ..."
$curl --location "$download_url" --remote-name

{ printf '#!/bin/bash
cd "$(realpath "$(dirname "$0")")" || exit 1
set -v
"./%s" /S' "$(basename -- "$download_url")"
} >autoinstall.sh
chmod +x ./autoinstall.sh

{ printf '@echo off
"%%~dp0..\\.tools\\busybox64.exe" bash "%%~dp0autoinstall.sh"
exit /b %%errorlevel%%'
} >autoinstall.bat

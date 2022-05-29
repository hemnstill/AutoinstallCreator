#!/bin/bash
dp0="$(realpath "$(dirname "$0")")"
dp0_tools="$dp0/../.tools" && source "$dp0_tools/env_tools.sh"
cd "$dp0" || exit 1

html_url='https://electrum.org/panel-download.html'
echo Get latest version: $html_url ...
download_url=$($curl --silent --location "$html_url" | "$grep" --only-matching '(?<=href=")[^,]+-setup\.exe(?=")' | head -1)
[[ -z "$download_url" ]] && {
  echo "Cannot get release version"
  exit 1
}

echo "Downloading: $download_url ..."
$curl --location "$download_url" --remote-name
errorlevel=$?
if [[ $errorlevel -ne 0 ]]; then exit $errorlevel; fi

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

echo Done.


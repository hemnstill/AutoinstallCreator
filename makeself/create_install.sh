#!/bin/bash
dp0="$(realpath "$(dirname "$0")")"
dp0_tools="$dp0/../.tools" && source "$dp0_tools/env_tools.sh"
set -e
cd "$dp0"

api_url='https://api.github.com/repos/megastep/makeself/releases/latest'
echo Get latest version: $api_url ...
download_url=$($curl --silent --location "$api_url" | "$grep" --only-matching '(?<="browser_download_url":\s")[^,]+makeself-[^,]+\.run(?=")' | head -1)
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
"./%s"
' "$(basename -- "$download_url")"
} >autoinstall.sh
chmod +x ./autoinstall.sh

{ printf '@echo off
"%%~dp0..\\.tools\\busybox.exe" bash "%%~dp0autoinstall.sh"
exit /b %%errorlevel%%'
} >autoinstall.bat
#!/bin/bash
dp0="$(realpath "$(dirname "$0")")"
dp0_tools="$dp0/../.tools" && source "$dp0_tools/env_tools.sh"
set -e
cd "$dp0"

version_rule=$1

api_url='https://api.github.com/repos/megastep/makeself/releases?per_page=100'
match_rule="$(printf '(?<="browser_download_url":\s")[^,]+makeself-%s[^,]*\.run(?=")' "$version_rule" )"
echo Get latest version: "'$api_url'" with "'$match_rule'" ...
download_url=$($curl --silent --location "$api_url" | "$grep" --only-matching "$match_rule" | head -1)
[[ -z "$download_url" ]] && {
  echo "Cannot get release version"
  exit 1
}

echo "Downloading: $download_url ..."
$curl --location "$download_url" --remote-name
errorlevel=$?
if [[ $errorlevel -ne 0 ]]; then exit $errorlevel; fi

chmod +x "$(basename -- "$download_url")"

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

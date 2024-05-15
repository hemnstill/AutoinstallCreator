#!/bin/bash
dp0="$(realpath "$(dirname "$0")")"
dp0_tools="$dp0/../.tools" && source "$dp0_tools/env_tools.sh"
set -e
cd "$dp0"

api_url='https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release'
echo Get latest version: $api_url ...
download_url=$($curl --location "$api_url" | "$grep" --only-matching "(?<=\"link\":\")[^,]+tar.gz(?=\")" | tail -n 1 | head -n 1)
echo Downloading: $download_url ...
$curl --location $download_url --remote-name
errorlevel=$?
if [[ $errorlevel -ne 0 ]]; then exit $errorlevel; fi

tar -xzf $(basename -- "$download_url") --strip-components 1
errorlevel=$?
if [[ $errorlevel -ne 0 ]]; then exit $errorlevel; fi

{
  printf '#!/bin/bash
cd "$(realpath "$(dirname "$0")")" || exit
./jetbrains-toolbox'
} >autoinstall.sh
chmod +x ./autoinstall.sh

echo Done.

#!/bin/bash
dp0="$(realpath "$(dirname "$0")")"
dp0_tools="$dp0/../.tools" && source "$dp0_tools/env_tools.sh"
set -e
cd "$dp0"

api_url='https://data.services.jetbrains.com/products/releases?code=RS%2CRSU%2CRSCLT%2CDCCLT%2CDMCLP%2CDPCLT&latest=true&type=release'
echo Get latest version: "$api_url" ...
download_url=$($curl --location "$api_url" | "$grep" --only-matching "(?<=\"link\":\")[^,]+\.ReSharper\.CommandLineTools\.[^,]+\.zip(?=\")" | head -n1)
echo Downloading: "$download_url" ...
$curl --location "$download_url" --remote-name
errorlevel=$?
if [[ $errorlevel -ne 0 ]]; then exit $errorlevel; fi

echo Done.

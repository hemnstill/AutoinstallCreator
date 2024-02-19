#!/bin/bash
dp0="$(realpath "$(dirname "$0")")"
dp0_tools="$dp0/.tools" && source "$dp0_tools/env_tools.sh"
set -e
cd "$dp0"


latest_version=https://api.github.com/repos/hemnstill/AutoinstallCreator/releases/tags/latest-master
echo Get latest version: "$latest_version" ...
download_url=$($curl --silent --location "$latest_version" | "$grep" --only-matching '(?<="body":\s")[^,]+.(?=\\n")' | head -n1)
echo "$download_url"

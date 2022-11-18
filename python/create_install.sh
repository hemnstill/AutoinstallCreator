#!/bin/bash
dp0="$(realpath "$(dirname "$0")")"
dp0_tools="$dp0/../.tools" && source "$dp0_tools/env_tools.sh"
set -e
cd "$dp0"


api_url='https://api.github.com/repos/hemnstill/StandaloneTools/releases?per_page=100'
echo Get latest version: "$api_url" ...

runtime_toolset_rule="/build-musl" && $is_windows_os && runtime_toolset_rule="/build-msvc"
matching_rule="$(printf '(?<="browser_download_url":\s")[^,]+python-[^,]+%s\.tar\.gz(?=")' "$runtime_toolset_rule")"
download_url="$($curl --silent --location "$api_url" | "$grep" --only-matching "$matching_rule" | head -1)"
[[ -z "$download_url" ]] && {
  echo "Cannot get release version from $matching_rule"
  exit 1
}

echo "Downloading: $download_url ..."
$curl --location "$download_url" --remote-name

#!/bin/bash
dp0="$(realpath "$(dirname "$0")")"
dp0_tools="$dp0/.tools" && source "$dp0_tools/env_tools.sh"
set -e
cd "$dp0"

self_name=AutoinstallCreator
latest_version=https://api.github.com/repos/hemnstill/$self_name/releases/tags/latest-master
echo Get latest version: "$latest_version" ...
version_body=$($curl --silent --location "$latest_version" | "$grep" --only-matching '(?<="body":\s")[^,]+.(?=\\n")' | head -n 1)
echo "version_body: $version_body"
[[ -z "$version_body" ]] && {
  echo "Cannot get 'version_body'"
  exit 1
}

version_count=$(echo "$version_body" | "$grep" --only-matching "(?<=$self_name\.)[^\s]+.(?=\.)" | head -n 1)
[[ -z "$version_count" ]] && {
  echo "Cannot get 'version_count' from $version_body"
  exit 1
}

version_hash=$(echo "$version_body" | "$grep" --only-matching "(?<=$self_name\.$version_count\.)[^\s]+." | head -n 1)
[[ -z "$version_hash" ]] && {
  echo "Cannot get 'version_hash' from $version_body"
  exit 1
}


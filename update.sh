#!/bin/bash
dp0="$(realpath "$(dirname "$0")")"
dp0_tools="$dp0/.tools" && source "$dp0_tools/env_tools.sh"
set -e
cd "$dp0"

self_name=AutoinstallCreator
relative_own_files_filepath="_$self_name/own_files.txt"

# Finishing update process. Stage 2
self_package_filepath=$1
update_path=$2
if [[ ! -z "$self_package_filepath" ]] || [[ ! -z "$update_path" ]]; then
  self_package_filepath=$(realpath "$self_package_filepath")
  update_path=$(realpath "$update_path")
  echo "update_path: $update_path"

  if [[ $update_path == $dp0 ]]; then
    echo "update failed. Cannot update to current directory"
    exit 1
  fi

  if [[ ! -f "$self_package_filepath" ]]; then
    echo "update failed. Self package not found: '$update_path/$self_package_filepath'"
    exit 1
  fi

  if [[ ! -f "$update_path/$relative_own_files_filepath" ]]; then
    echo "update failed. File not found: '$update_path/$relative_own_files_filepath'"
    exit 1
  fi

  echo "Finishing update process"

  exit 0
fi

# Starting update process. Stage 1
self_version_body=$(head -n 1 "$dp0/_$self_name/version.txt")
echo "self_version_body: $self_version_body"
[[ -z "$self_version_body" ]] && {
  echo "Cannot get 'self_version_body'"
  exit 1
}
self_version_count=$(echo "$self_version_body" | "$grep" --only-matching "(?<=$self_name\.)[^\s]+.(?=\.)" | head -n 1)
[[ -z "$self_version_count" ]] && {
  echo "Cannot get 'self_version_count' from $self_version_body"
  exit 1
}
self_version_hash=$(echo "$self_version_body" | "$grep" --only-matching "(?<=$self_name\.$self_version_count\.)[^\s]+." | head -n 1)
[[ -z "$self_version_hash" ]] && {
  echo "Cannot get 'self_version_hash' from $self_version_body"
  exit 1
}

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

if [[ $self_version_count -gt $version_count ]]; then
  echo "nothing to do. self_version_count: $self_version_count, version_count: $version_count"
  exit 2
fi

if [[ $self_version_count -eq $version_count ]] && [[ $self_version_hash == $version_hash ]]; then
  echo "version is up to date"
  exit 0
fi

echo "found new version: $self_version_count.$self_version_hash -> $version_count.$version_hash"
download_url=$($curl --silent --location "$latest_version" | "$grep" --only-matching '(?<="browser_download_url":\s")[^,]+.\.sh(?=")' | head -1)
[[ -z "$download_url" ]] && {
  echo "Cannot get release version"
  exit 1
}

echo "Downloading: $download_url ..."
$curl --location "$download_url" --output "$dp0/_$self_name/$self_name.sh"

echo "extracting to: $dp0/_$self_name/$version_body"
(cd "$dp0/_$self_name" && bash "./$self_name.sh")

bash "$dp0/_$self_name/$version_body/update.sh" "$dp0/_$self_name/$self_name.sh" "$dp0"

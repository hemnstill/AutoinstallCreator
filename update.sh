#!/bin/bash
dp0="$(realpath "$(dirname "$0")")"
dp0_tools="$dp0/.tools" && source "$dp0_tools/env_tools.sh"
set -e
cd "$dp0"

self_name=AutoinstallCreator
relative_version_filepath="_$self_name/version.txt"
package_ext=".sh" && $is_windows_os && package_ext=".sh.bat"
package_grep_ext="\.sh" && $is_windows_os && package_grep_ext="\.sh\.bat"

# Finishing update process. Stage 2
#self_package_filepath=$1
target_path=$1
if [[ ! -z "$target_path" ]]; then
  target_path=$(realpath "$target_path")

  echo "Finishing update from: $dp0"
  echo "Target path: $target_path"

  if [[ $target_path == $dp0 ]]; then
    echo "Update failed. Cannot update to current directory"
    exit 1
  fi

  if [[ ! -f "$target_path/$relative_version_filepath" ]]; then
    echo "Update failed. Version not found: '$target_path/$relative_version_filepath'"
    exit 1
  fi

  echo "Copying new files"
  find "$dp0" -mindepth 1 -maxdepth 1 ! -name "tmp_*" \
    -exec cp -rf "{}" "$target_path/" +

  echo "Removing orphaned files"
  orphaned_files=$(cat $dp0/_$self_name/orphaned_files.txt)
  for orphaned_file in $orphaned_files
  do
    rm -f "$dp0/$orphaned_file"
  done

  echo "Update complete: $(cat $target_path/_$self_name/version.txt)"
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

github_tag=$MOCK_AUTOINSTALLCREATOR_GITHUB_TAG
if [[ -z $MOCK_AUTOINSTALLCREATOR_GITHUB_TAG ]]; then
  github_tag=latest-master
fi

latest_version="https://api.github.com/repos/hemnstill/$self_name/releases/tags/$github_tag"
echo Get latest version: "$latest_version" ...
version_body="$MOCK_AUTOINSTALLCREATOR_VERSION_BODY"
if [[ -z $version_body ]]; then
  version_body=$($curl --location "$latest_version" | "$grep" --only-matching '(?<="body":\s")[^,]+.' | cut -d '\r\n' -f 1 | head -n 1)
fi
echo "Version_body: $version_body"
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
  echo "Nothing to do. self_version_count: $self_version_count, version_count: $version_count"
  exit 2
fi

if [[ $self_version_count -eq $version_count ]] && [[ $self_version_hash == $version_hash ]]; then
  echo "Version is up to date"
  exit 0
fi

echo "Found new version: $self_version_body -> $version_body"
grep_pattern="(?<=\"browser_download_url\":\s\")[^,]+.$package_grep_ext(?=\")"
download_url=$($curl --silent --location "$latest_version" | "$grep" --only-matching $grep_pattern | head -n 1)
[[ -z "$download_url" ]] && {
  echo "Cannot get release version"
  exit 1
}

echo "Downloading: $download_url ..."
package_filepath="$MOCK_AUTOINSTALLCREATOR_PACKAGE_FILEPATH"
if [[ -z $MOCK_AUTOINSTALLCREATOR_PACKAGE_FILEPATH ]]; then
  package_filepath="$dp0/_$self_name/$self_name$package_ext"
  $curl --location "$download_url" --output "$package_filepath"
fi

echo "Extracting to: $dp0/_$self_name/$version_body"
(bash "$package_filepath" --target "$dp0/_$self_name/tmp_$version_body")

echo "Running extracted 'update.sh'"
bash "$dp0/_$self_name/tmp_$version_body/update.sh" "$dp0" >& $dp0/_update.log



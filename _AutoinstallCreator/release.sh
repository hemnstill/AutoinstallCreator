#!/bin/bash
dp0="$(realpath "$(dirname "$0")")"
dp0_tools="$dp0/../.tools" && source "$dp0_tools/env_tools.sh"
set -e
cd "$dp0"

self_name=AutoinstallCreator
self_count="$(cd "$dp0/.." && git rev-list --count HEAD)"
self_hash="$(cd "$dp0/.." && git show --abbrev=10 --no-patch --pretty=%h HEAD)"

self_version=$self_name.$self_count.$self_hash

tool_version=cmd-header
download_url="https://github.com/hemnstill/makeself/archive/refs/heads/$tool_version.tar.gz"

makeself_version_path="$dp0/tool-$tool_version.tar.gz"
makeself_target_path="$dp0/makeself-$tool_version"
makeself_sh_path="$makeself_target_path/makeself.sh"

[[ ! -f "$makeself_version_path" ]] && {
  echo "::group::prepare sources $download_url"
  wget "$download_url" -O "$makeself_version_path"
  tar -xf "$makeself_version_path"
}

temp_dir_path="$dp0/.tmp"
rm -rf "$temp_dir_path" && mkdir -p "$temp_dir_path"

release_version_dirpath="$temp_dir_path/$self_version"
tmp_version_path="$temp_dir_path/tmp_version.zip"
(cd "$dp0/.." && git archive --format zip -1 --output "$tmp_version_path" HEAD)

"$p7z" x "$tmp_version_path" "-o$release_version_dirpath"

export BB_OVERRIDE_APPLETS=tar
export TMPDIR="$temp_dir_path"

artifact_file_path="$dp0/$self_name.sh" && $is_windows_os && artifact_file_path="$dp0/$self_name.sh.bat"
header_arg="" && $is_windows_os && {
  "$makeself_target_path/cmd-header.sh"
  header_arg="--header $makeself_target_path/makeself-cmd-header.sh"
}

"$makeself_sh_path" $header_arg \
  --notemp --sha256 --nomd5 --nocrc \
  "$release_version_dirpath" \
  "$artifact_file_path" \
  "$self_name" \
  echo "$self_version has extracted itself"

echo version "'$self_version'" created.
echo "$self_version" > "$dp0/../body.md"

echo "::set-output name=artifact_path::$artifact_file_path"
echo "::set-output name=artifact_version::$self_name"

#!/bin/bash
dp0="$(realpath "$(dirname "$0")")"
dp0_tools="$dp0/../.tools" && source "$dp0_tools/env_tools.sh"
set -e
cd "$dp0"

self_name=AutoinstallCreator
self_count="$(cd "$dp0/.." && git rev-list --count HEAD)"
self_hash="$(cd "$dp0/.." && git show --abbrev=10 --no-patch --pretty=%h HEAD)"

self_version=$self_name.$self_count.$self_hash

makeself_version="2.4.5"
makeself_version_rule="${makeself_version//./'\.'}"
makeself_version_path="$dp0/../makeself/makeself-$makeself_version.run"
makeself_target_path="$dp0/makeself"
makeself_sh_path="$makeself_target_path/makeself.sh"

[[ ! -f "$makeself_version_path" ]] && "$dp0/../makeself/create_install.sh" "$makeself_version_rule"
[[ ! -f "$makeself_sh_path" ]] && "$makeself_version_path" --target "$makeself_target_path"

temp_dir_path="$dp0/.tmp"
rm -rf "$temp_dir_path" && mkdir -p "$temp_dir_path"

release_version_dirpath="$temp_dir_path/$self_version"
tmp_version_path="$temp_dir_path/tmp_version.zip"
(cd "$dp0/.." && git archive --format zip -1 --output "$tmp_version_path" HEAD)

"$p7z" x "$tmp_version_path" "-o$release_version_dirpath"

artifact_file_path="$dp0/$self_name.sh" && $is_windows_os && artifact_file_path="$dp0/$self_name.bat"

export BB_OVERRIDE_APPLETS=tar
export TMPDIR="$temp_dir_path"

"$makeself_sh_path" \
--notemp --sha256 --nomd5 --nocrc \
"$release_version_dirpath" \
"$artifact_file_path" \
"$self_name" \
echo "$self_version has extracted itself"

echo version "'$self_version'" created.
echo "$self_version" > "$dp0/../body.md"

echo "::set-output name=artifact_path::$artifact_file_path"
echo "::set-output name=artifact_version::$self_name"

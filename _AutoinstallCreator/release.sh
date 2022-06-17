#!/bin/bash
dp0="$(realpath "$(dirname "$0")")"
dp0_tools="$dp0/../.tools" && source "$dp0_tools/env_tools.sh"
set -e
cd "$dp0"

makeself_version="2.4.5"
makeself_version_rule="${makeself_version//./'\.'}"
makeself_version_path="$dp0/../makeself/makeself-$makeself_version.run"
makeself_target_path="$dp0/makeself"
makeself_sh_path="$makeself_target_path/makeself.sh"

[[ ! -f "$makeself_version_path" ]] && "$dp0/../makeself/create_install.sh" "$makeself_version_rule"
[[ ! -f "$makeself_sh_path" ]] && "$makeself_version_path" --target "$makeself_target_path"

release_version_dirpath="$dp0/release_version"
tmp_version_path="$release_version_dirpath.zip"
(cd "$dp0/.." && git archive --format zip -1 --output "$tmp_version_path" HEAD)

rm -rf "$release_version_dirpath"
"$p7z" x "$tmp_version_path" "-o$release_version_dirpath"

release_version_path="$dp0/release_version.run"

"$makeself_sh_path" \
--current \
"$release_version_dirpath" \
"$release_version_path" \
AutoinstallCreator \
echo "AutoinstallCreator has extracted itself"

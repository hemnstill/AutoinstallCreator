#!/bin/bash
cd "$(dirname "${BASH_SOURCE[0]}")"
export LC_ALL=en_US.UTF-8
curl="../curl --fail --cacert ../curl-ca-bundle.crt" && [[ $(uname) == MINGW64* ]] && curl="../curl.exe --fail"
grep="grep" && [[ $(uname) == MINGW64* ]] && grep="../grep.exe"
p7zip="../7z" && [[ $(uname) == MINGW64* ]] && p7zip="../7z.exe"
zstd="zstd" && [[ $(uname) == MINGW64* ]] && {
  zstd="../_zstd/zstd.exe";
  [[ ! -f "$zstd" ]] && { "../_zstd/create_install.sh"; cd "$(dirname "${BASH_SOURCE[0]}")"; };
}
[[ $(command -v $zstd) == '' ]] && { echo "zstd is not available. Try 'sudo apt install zstd'"; exit 1; }

bsdtar="bsdtar" && [[ $(uname) == MINGW64* ]] && {
  bsdtar="../_bsdtar/bsdtar.exe";
  [[ ! -f "$bsdtar" ]] && { "../_bsdtar/create_install.sh"; cd "$(dirname "${BASH_SOURCE[0]}")"; };
}
[[ $(command -v $bsdtar) == '' ]] && { echo "bsdtar is not available. Try 'sudo apt install libarchive-tools'"; exit 1; }

python_version=$1
if [[ -z "$python_version" ]]; then
  latest_version_url='https://www.python.org/doc/versions/'
  echo "python_version does not set. get latest from: $latest_version_url ..."
  python_version=$($curl --silent --location "$latest_version_url" | "$grep" -Po '(?<=href="http://docs\.python\.org/release/)[\d\.]+(?=/")' | head -1)
fi
[[ -z $python_version ]] && { echo 'Cannot get python_version'; exit 1; }

echo "-> $python_version"

api_url='https://api.github.com/repos/indygreg/python-build-standalone/releases'
echo Get latest portable version: $api_url ...
download_url=$($curl --silent --location "$api_url" | "$grep" -Po '(?<="browser_download_url":\s")[^,]+linux-musl-debug[^,]+tar\.zst(?=")' \
| "$grep" -F -- "-$python_version" | head -1)
[[ -z "$download_url" ]] && { echo "Cannot get release version"; exit 1; }

echo "Downloading: $download_url ..."
$curl --location "$download_url" --remote-name
errorlevel=$?; if [[ $errorlevel -ne 0 ]]; then exit $errorlevel; fi

gz_file_name="cpython-$python_version-linux-musl.tar.gz"
zst_file_name="$(basename -- "$download_url")"
tar_file_name="${zst_file_name%.*}"

"$zstd" -df "$zst_file_name"
errorlevel=$?; if [[ $errorlevel -ne 0 ]]; then exit $errorlevel; fi

"$bsdtar" -cf - --include='python/install' @"$tar_file_name" \
| cat - \
| tar f - --wildcards \
--delete "*/config-*" \
--delete "*/test/*" \
--delete "*/tests/*" \
--delete "*/idle_test/*" \
--delete "*/site-packages/*" \
--delete "*.whl" \
--delete "*.exe" \
| "$p7zip" u "$gz_file_name" -uq0 -si
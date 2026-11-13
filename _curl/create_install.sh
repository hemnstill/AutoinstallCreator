#!/bin/bash
dp0="$(realpath "$(dirname "$0")")"
dp0_tools="$dp0/../.tools" && source "$dp0_tools/env_tools.sh"
set -e
cd "$dp0"

api_url='https://api.github.com/repos/stunnel/static-curl/releases/latest'
echo Get latest version: "$api_url" ...
release_json=$($curl --silent --location "$api_url")
asset_re='curl-linux-x86_64-musl-[0-9.]+(?:-[0-9]+)?\.tar\.xz'
download_url=$(echo "$release_json" | "$grep" --only-matching "(?<=\"browser_download_url\":\s\")[^\"]+/$asset_re(?=\")" | head -n 1)
[[ -z "$download_url" ]] && {
  echo "curl-amd64: Cannot get release version"
  exit 1
}
expected_sha256=$(echo "$release_json" | "$grep" --multiline --only-matching "(?<=\"digest\":\s\"sha256:)[0-9a-f]{64}(?=\",(?:(?!\"digest\")[\s\S])*?\"browser_download_url\":\s\"[^\"]+/$asset_re\")" | head -n 1)
[[ -z "$expected_sha256" ]] && {
  echo "curl-amd64: Cannot get release digest"
  exit 1
}

archive_name="$(basename -- "$download_url")"
echo "Downloading: $download_url ..."
$curl --location "$download_url" --output "$archive_name"

echo "$expected_sha256  $archive_name" | $busybox sha256sum -c -

rm -rf ".tmp/curl-amd64" ".tmp/SHA256SUMS"
mkdir -p ".tmp"
"$p7z" e "$archive_name" -so | "$p7z" e -si -ttar "-o.tmp" curl SHA256SUMS -aoa -r
(cd ".tmp" && "$grep" '\scurl$' SHA256SUMS | $busybox sha256sum -c - && mv -f curl curl-amd64 && rm -f SHA256SUMS)

download_url_win=https://curl.se/windows/latest.cgi?p=win64-mingw.zip
echo "Downloading: $download_url_win ..."
$curl --location "$download_url_win" --output win64-mingw.zip

"$p7z" e "win64-mingw.zip" "-o.tmp" curl.exe -aoa -r

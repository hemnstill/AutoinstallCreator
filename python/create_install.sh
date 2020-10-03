#!/bin/bash
cd "$(dirname "${BASH_SOURCE[0]}")"
export LC_ALL=en_US.UTF-8
curl="../curl --fail --cacert ../curl-ca-bundle.crt" && [[ $(uname) == MINGW64* ]] && curl="../curl.exe --fail"
grep="grep" && [[ $(uname) == MINGW64* ]] && grep="../grep.exe"

python_version=$1
if [[ -z "$python_version" ]]; then
  latest_version_url='https://www.python.org/doc/versions/'
  echo "python_version does not set. get latest from: $latest_version_url ..."
  python_version=$($curl --silent --location "$latest_version_url" | "$grep" -Po '(?<=href="http://docs\.python\.org/release/)[\d\.]+(?=/")' | head -1)
fi
echo "-> $python_version"

api_url='https://api.github.com/repos/indygreg/python-build-standalone/releases'
echo Get latest portable version: $api_url ...
download_url=$($curl --silent --location "$api_url" | "$grep" -Po '(?<="browser_download_url":\s")[^,]+linux-musl-debug[^,]+tar\.zst(?=")' \
| "$grep" -F -- "-$python_version" | head -1)
[[ -z "$download_url" ]] && { echo "Cannot get release version"; exit 1; }

echo Downloading: $download_url ...
$curl --location $download_url --remote-name
errorlevel=$?; if [[ $errorlevel -ne 0 ]]; then exit $errorlevel; fi

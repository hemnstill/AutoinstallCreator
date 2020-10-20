#!/bin/bash
cd "$(dirname "${BASH_SOURCE[0]}")"
export LC_ALL=en_US.UTF-8
curl="../curl --fail --cacert ../curl-ca-bundle.crt" && [[ $(uname) == MINGW64* ]] && curl="../curl.exe --fail"
grep="grep" && [[ $(uname) == MINGW64* ]] && grep="../grep.exe"

api_url='https://www.virtualbox.org/wiki/Downloads'
echo Get latest version: $api_url ...
download_url=$($curl --silent --location "$api_url" | "$grep" -Po '(?<=href=")[^,]+Win\.exe(?=")' | head -1 )
[[ -z "$download_url" ]] && { echo "Cannot get release version"; exit 1; }

vbox_file_name='VirtualBox.tmp.exe'
echo "Downloading: $download_url ..."
$curl --location "$download_url" --output $vbox_file_name
errorlevel=$?; if [[ $errorlevel -ne 0 ]]; then exit $errorlevel; fi

echo "Remove *.msi && extracting from: $vbox_file_name ..."
rm -f *.msi && ./$vbox_file_name --silent --extract --path .
errorlevel=$?; if [[ $errorlevel -ne 0 ]]; then exit $errorlevel; fi

msi_file_name="%~dp0$(ls *.msi)"
{ printf '"%s" /passive /norestart
exit /b %%errorlevel%%' "$msi_file_name"
} > autoinstall.bat
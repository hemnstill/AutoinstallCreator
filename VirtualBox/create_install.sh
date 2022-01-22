#!/bin/bash
cd "$(dirname "$0")"
source ../.src/env_tools.sh

api_url='https://www.virtualbox.org/wiki/Downloads'
echo Get latest version: $api_url ...
download_url=$($curl --silent --location "$api_url" | "$grep" --only-matching '(?<=href=")[^,]+Win\.exe(?=")' | head -1)
[[ -z "$download_url" ]] && {
  echo "Cannot get release version"
  exit 1
}

vbox_file_name='VirtualBox.tmp.exe'
echo "Downloading: $download_url ..."
$curl --location "$download_url" --output $vbox_file_name
errorlevel=$?
if [[ $errorlevel -ne 0 ]]; then exit $errorlevel; fi

[[ $(uname) != MINGW64* ]] && {
  echo "Done. MINGW64 required for create autoinstall.bat"
  exit
}
echo "Remove *.msi && extracting from: $vbox_file_name ..."
rm -f *.msi && ./$vbox_file_name --silent --extract --path .
errorlevel=$?
if [[ $errorlevel -ne 0 ]]; then exit $errorlevel; fi

msi_file_name="%~dp0$(ls ./*.msi)"
{
  printf '"%s" /passive /norestart
exit /b %%errorlevel%%' "$msi_file_name"
} >autoinstall.bat

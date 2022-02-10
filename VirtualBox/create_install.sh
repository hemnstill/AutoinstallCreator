#!/bin/bash
dp0="$(realpath "$(dirname "$0")")"
dp0_tools="$dp0/../.tools" && source "$dp0_tools/env_tools.sh"
cd "$dp0" || exit 1

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

if [[ "$is_windows_os" != true ]]; then
  echo "Done. Windows is required for create autoinstall.bat"
  exit 1
fi

echo "Remove *.msi && extracting from: $vbox_file_name ..."
rm -f *.msi && ./$vbox_file_name --silent --extract --path .
errorlevel=$?
if [[ $errorlevel -ne 0 ]]; then exit $errorlevel; fi

msi_file_name="%~dp0$(ls ./*.msi)"
{
  printf '"%s" /passive /norestart
exit /b %%errorlevel%%' "$msi_file_name"
} >autoinstall.bat

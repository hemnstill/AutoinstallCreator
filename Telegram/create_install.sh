#!/bin/bash
cd "$(dirname "${BASH_SOURCE[0]}")"
function curl() { if [[ $(uname) == MINGW64* ]];then ../curl.exe --fail $@; else ../curl --fail --cacert ../curl-ca-bundle.crt $@; fi }
function p7zip() { if [[ $(uname) == MINGW64* ]];then ../7z.exe $@; else ../7z $@; fi }

targz_name=tsetup.tar.xz
tar_name=tsetup.tar

download_url='https://telegram.org/dl/desktop/linux'
curl --location $download_url --output $targz_name
errorlevel=$?; if [[ $errorlevel -ne 0 ]]; then exit $errorlevel; fi

p7zip e ./$targz_name -aoa
p7zip e ./$tar_name -aoa
errorlevel=$?; if [[ $errorlevel -ne 0 ]]; then exit $errorlevel; fi
chmod +x ./Telegram

{
  echo '#!/bin/bash'
  echo 'cd "$(dirname "${BASH_SOURCE[0]}")"'
  echo ./Telegram
} > autoinstall.sh
chmod +x ./autoinstall.sh

echo Done.

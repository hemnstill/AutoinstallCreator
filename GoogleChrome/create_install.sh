#!/bin/bash
cd "$(dirname "${BASH_SOURCE[0]}")"
function curl() { if [[ $(uname) == MINGW64* ]];then ../curl.exe --fail $@; else ../curl --fail --cacert ../curl-ca-bundle.crt $@; fi }

download_url='https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb'
curl --location $download_url --remote-name
{
  echo '#!/bin/bash'
  echo 'cd "$(dirname "${BASH_SOURCE[0]}")"'
  echo dpkg -i $(basename -- "$download_url")
} > autoinstall.sh
chmod +x ./autoinstall.sh

echo Done.

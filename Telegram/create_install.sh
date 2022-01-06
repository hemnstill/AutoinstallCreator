#!/bin/bash
cd "$(dirname "${BASH_SOURCE[0]}")"
curl="../curl --fail --cacert ../curl-ca-bundle.crt" && [[ $(uname) == MINGW64* ]] && curl="../curl.exe --fail"
p7zip="../7zzs" && [[ $(uname) == MINGW64* ]] && p7zip="../7z.exe"

tarxz_name=tsetup.tar.xz
tar_name=tsetup.tar

download_url='https://telegram.org/dl/desktop/linux'
$curl --location $download_url --output $tarxz_name
errorlevel=$?; if [[ $errorlevel -ne 0 ]]; then exit $errorlevel; fi

$p7zip e ./$tarxz_name -aoa
$p7zip e ./$tar_name -aoa
errorlevel=$?; if [[ $errorlevel -ne 0 ]]; then exit $errorlevel; fi
chmod +x ./Telegram

{ printf '#!/bin/bash
cd "$(dirname "${BASH_SOURCE[0]}")"
./Telegram'
} > autoinstall.sh
chmod +x ./autoinstall.sh

echo Done.

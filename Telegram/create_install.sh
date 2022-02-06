#!/bin/bash
dp0="$(realpath "$(dirname "$0")")"
dp0_tools="$dp0/../.tools" && source "$dp0_tools/env_tools.sh"
cd "$dp0" || exit

tarxz_name=tsetup.tar.xz
tar_name=tsetup.tar

download_url='https://telegram.org/dl/desktop/linux'
$curl --location $download_url --output $tarxz_name
errorlevel=$?
if [[ $errorlevel -ne 0 ]]; then exit $errorlevel; fi

$p7z e ./$tarxz_name -aoa
$p7z e ./$tar_name -aoa
errorlevel=$?
if [[ $errorlevel -ne 0 ]]; then exit $errorlevel; fi
chmod +x ./Telegram

{
  printf '#!/bin/bash
cd "$(realpath "$(dirname "$0")")" || exit
./Telegram'
} >autoinstall.sh
chmod +x ./autoinstall.sh

echo Done.

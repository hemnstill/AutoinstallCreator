#!/bin/bash
cd "$(dirname "${BASH_SOURCE[0]}")"
export LC_ALL=en_US.UTF-8
function curl() { if [[ $(uname) == MINGW64* ]];then ../curl.exe --fail $@; else ../curl --fail --cacert ../curl-ca-bundle.crt $@; fi }
function grep() { if [[ $(uname) == MINGW64* ]];then ../grep.exe $@; else /bin/grep $@; fi }

latest_versions_url=https://mirrors.edge.kernel.org/debian/pool/main/p/p7zip/
tar_name=data.tar
echo getting version list from $latest_versions_url ...
download_url=$(curl $latest_versions_url | grep -Po "(?<=\")[^,]+amd64.deb(?=\")" | head -1)
curl --location $latest_versions_url$download_url --remote-name
errorlevel=$?; if [[ $errorlevel -ne 0 ]]; then exit $errorlevel; fi

{
  echo '#!/bin/bash'
  echo 'cd "$(dirname "${BASH_SOURCE[0]}")"'
  echo 'function p7zip() { if [[ $(uname) == MINGW64* ]];then ../7z.exe $@; else ../7z $@; fi }'
  echo 'function cp() { if [[ $(uname) == MINGW64* ]];then ../cp.exe -v $@; else /bin/cp -v $@; fi }'
  echo "p7zip e ./$download_url "-o." -aoa -r"
  echo "p7zip e ./$tar_name "-o." 7z 7z.so -aoa -r"
  echo 'cp -v ./{7z,7z.so} ../'  
  echo 'chmod +x ../7z'  
} > autoinstall.sh 
chmod +x ./autoinstall.sh

echo Done.
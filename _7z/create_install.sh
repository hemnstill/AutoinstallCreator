#!/bin/bash
cd "$(dirname "${BASH_SOURCE[0]}")"
function curl() { if [[ $(uname) == CYGWIN* ]];then ../curl.exe --fail $@; else ../curl --fail --cacert ../curl-ca-bundle.crt $@; fi }

latest_versions_url=https://mirrors.edge.kernel.org/debian/pool/main/p/p7zip/
tar_name=data.tar
echo getting version list from $latest_versions_url ...
download_url=$(curl -s $latest_versions_url | grep -Po "(?<=\")[^,]+amd64.deb(?=\")" | head -1)
curl --location $latest_versions_url$download_url --remote-name
echo Done.

{
  echo '#!/bin/bash'
  echo 'cd "$(dirname "${BASH_SOURCE[0]}")"'
  echo 'function p7zip() { if [[ $(uname) == CYGWIN* ]];then ../7z.exe $@; else ../7z $@; fi }'
  echo 'function cp() { if [[ $(uname) == CYGWIN* ]];then ../cp.exe -v $@; else /usr/bin/cp -v $@; fi }'
  echo 'chmod +x ../7z'
  echo "p7zip e ./$download_url "-o." -aoa -r"
  echo "p7zip e ./$tar_name "-o." 7z 7z.so -aoa -r"
  echo 'cp -f ./{7z,7z.so} ../'  
} > autoinstall.sh 
chmod +x ./autoinstall.sh
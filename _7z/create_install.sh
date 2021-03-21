#!/bin/bash
cd "$(dirname "${BASH_SOURCE[0]}")"
export LC_ALL=en_US.UTF-8
curl="../curl --fail --cacert ../curl-ca-bundle.crt" && [[ $(uname) == MINGW64* ]] && curl="../curl.exe --fail"
grep="grep" && [[ $(uname) == MINGW64* ]] && grep="../grep.exe"

latest_versions_url=https://mirrors.edge.kernel.org/debian/pool/main/p/p7zip/
echo "getting version list from $latest_versions_url ..."
download_url=$($curl $latest_versions_url | "$grep" -Po "(?<=\")[^,]+amd64.deb(?=\")" | head -1)
$curl --location $latest_versions_url"$download_url" --remote-name
errorlevel=$?; if [[ $errorlevel -ne 0 ]]; then exit $errorlevel; fi

{ printf '#!/bin/bash
cd "$(dirname "${BASH_SOURCE[0]}")"
p7zip="../7z" && [[ $(uname) == MINGW64* ]] && p7zip="../7z.exe"
"$p7zip" e %s -o. -aoa -r
"$p7zip" e data.tar "-o.." 7z 7z.so -aoa -r
chmod +x ../7z' "$download_url"
} > autoinstall.sh
chmod +x ./autoinstall.sh

echo Done.

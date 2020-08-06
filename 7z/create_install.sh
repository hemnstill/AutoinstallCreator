#!/bin/bash
function curl() { if [[ $(uname) == CYGWIN* ]];then ../curl.exe $@; else ../curl --cacert ../curl-ca-bundle.crt $@; fi }

sourceforge_url=https://sourceforge.net/
relative_path=projects/p7zip/files/p7zip
echo "getting version list from $sourceforge_url$relative_path ..."
curl -L "$sourceforge_url$relative_path" > raw_download_str.tmp
last_version=$(grep -Po -m 1 "(?<=href=\")[^\"]+$relative_path[^\"]+/(?=\")" raw_download_str.tmp)
echo "getting download link for $last_version ..."
curl -L "$sourceforge_url$last_version" > raw_download_str.tmp
downloadurl=$(grep -Po -m 1 "(?<=href=\")[^\"]+linux_bin\.tar\.bz2[^\"]+(?=\")" raw_download_str.tmp)
echo "download last version from: $downloadurl"
curl -L "$downloadurl" --output "p7zip.tar.bz2"
echo Done.
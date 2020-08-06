#!/bin/bash
function curl() { if [[ $(uname) == CYGWIN* ]];then ../curl.exe $@; else ../curl --cacert ../curl-ca-bundle.crt $@; fi }

latest_version=https://api.github.com/repos/dtschan/curl-static/releases/latest
echo Get latest version: $latest_version ...
curl --fail -L "$latest_version" > raw_download_str.tmp
downloadurl=$(grep -Po "(?<=\"browser_download_url\": \").*curl(?=\")" raw_download_str.tmp)
curl --fail -L "$downloadurl" --remote-name


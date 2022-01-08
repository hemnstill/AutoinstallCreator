export LC_ALL=en_US.UTF-8
curl="../curl --fail --cacert ../curl-ca-bundle.crt" && [[ $(uname) == MINGW64* ]] && curl="../curl.exe --fail"
grep="grep" && [[ $(uname) == MINGW64* ]] && grep="../grep.exe"
p7zip="../7zzs" && [[ $(uname) == MINGW64* ]] && p7zip="../7z.exe"

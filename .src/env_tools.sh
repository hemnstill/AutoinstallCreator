export LC_ALL=en_US.UTF-8
curl="../curl-amd64 --fail --cacert ../curl-ca-bundle.crt" && [[ $(uname) == MINGW64* ]] && curl="../curl.exe --fail"
if [[ -n "$CI" ]]; then
  curl="../curl-amd64 --fail --silent --show-error --cacert ../curl-ca-bundle.crt" && [[ $(uname) == MINGW64* ]] && curl="../curl.exe --fail --silent --show-error"
fi
grep="pcre2grep" && [[ $(uname) == MINGW64* ]] && grep="../grep.exe"
p7zip="../7zzs" && [[ $(uname) == MINGW64* ]] && p7zip="../7z.exe"

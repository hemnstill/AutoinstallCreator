export LC_ALL=en_US.UTF-8
is_windows_os=false && [[ $(uname) == Windows_NT* ]] && is_windows_os=true
curl="$dp0_tools/curl-amd64 --fail --cacert $dp0_tools/curl-ca-bundle.crt" && $is_windows_os && curl="$dp0_tools/curl.exe --fail"
if [[ -n "$CI" ]]; then
  curl="$dp0_tools/curl-amd64 --fail --silent --show-error --cacert $dp0_tools/curl-ca-bundle.crt" && $is_windows_os && curl="$dp0_tools/curl.exe --fail --silent --show-error"
fi
grep="pcre2grep" && $is_windows_os && grep="$dp0_tools/pcre2grep.exe"
p7zip="$dp0_tools/7zzs" && $is_windows_os && p7zip="$dp0_tools/7z.exe"

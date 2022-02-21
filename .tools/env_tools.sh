export LC_ALL=en_US.UTF-8
is_windows_os=false && [[ $(uname) == Windows_NT* ]] && is_windows_os=true
is_alpine_os=false && [[ -f "/etc/alpine-release" ]] && is_alpine_os=true

curl="$dp0_tools/curl-amd64 --fail --cacert $dp0_tools/curl-ca-bundle.crt" && $is_windows_os && curl="$dp0_tools/curl.exe --fail"
if [[ -n "$CI" ]]; then
  curl="$curl --silent --show-error"
fi
grep="$dp0_tools/pcre2grep" && $is_windows_os && grep="$dp0_tools/pcre2grep.exe"
p7z="$dp0_tools/7zzs" && $is_windows_os && p7z="$dp0_tools/7z.exe"
busybox="busybox" && $is_windows_os && busybox="$dp0_tools/busybox64.exe"

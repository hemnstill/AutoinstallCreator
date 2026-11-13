is_windows_os=false && [[ $(uname) == Windows_NT* ]] && is_windows_os=true
is_alpine_os=false && [[ -f "/etc/alpine-release" ]] && is_alpine_os=true

curl="$dp0_tools/curl-amd64 --fail" && $is_windows_os && curl="$dp0_tools/curl.exe --fail"
if [[ -n "$CI" ]]; then
  curl="$curl --silent --show-error"
  # authenticate api.github.com only (netrc is per-host) to avoid anonymous rate limit
  if [[ -n "$GITHUB_TOKEN" && -n "$RUNNER_TEMP" ]]; then
    printf 'machine api.github.com login x-access-token password %s\n' "$GITHUB_TOKEN" >"$RUNNER_TEMP/github.netrc"
    curl="$curl --netrc-file $RUNNER_TEMP/github.netrc"
  fi
fi
grep="$dp0_tools/pcre2grep" && $is_windows_os && grep="$dp0_tools/pcre2grep.exe"
p7z="$dp0_tools/7zz" && $is_windows_os && p7z="$dp0_tools/7zz.exe"
busybox="busybox" && $is_windows_os && busybox="$dp0_tools/busybox.exe"

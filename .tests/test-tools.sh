#!/bin/bash
dp0="$(realpath "$(dirname "$0")")"
dp0_tools="$dp0/../.tools" && source "$dp0_tools/env_tools.sh"

errors_count=0

function test_stdout() {
  local runtime_name="$1"
  echo ">> Test ($runtime_name)"
  local etalon_log="$(echo -e "$2")"
  local actual_log="$($1)"

  # crlf fix
  $is_windows_os && actual_log=$(echo "$actual_log" | dos2unix)
  if [[ -z "$actual_log" ]] || [[ "$etalon_log" != "$actual_log" ]]; then
    errors_count=$((errors_count + 1))
    echo "<< Failed ($runtime_name)"
    echo expected: "$etalon_log"
    echo actual: "$actual_log"
  else
    echo "<< Passed ($runtime_name)"
  fi
}

echo ">> env:"
uname -a
echo is_windows: "$is_windows_os", is_alpine: "$is_alpine_os"

if [[ "$is_windows_os" == true ]]; then
  test_stdout "$curl --version" "curl 7.81.0 (x86_64-pc-win32) libcurl/7.81.0 OpenSSL/3.0.1 (Schannel) zlib/1.2.11 brotli/1.0.9 libidn2/2.3.2 libssh2/1.10.0 nghttp2/1.46.0 libgsasl/1.10.0
Release-Date: 2022-01-05
Protocols: dict file ftp ftps gopher gophers http https imap imaps ldap ldaps mqtt pop3 pop3s rtsp scp sftp smb smbs smtp smtps telnet tftp \nFeatures: alt-svc AsynchDNS brotli gsasl HSTS HTTP2 HTTPS-proxy IDN IPv6 Kerberos Largefile libz MultiSSL NTLM SPNEGO SSL SSPI TLS-SRP UnixSockets"

  test_stdout "$grep --version" "pcre2grep version 10.39 2021-10-29"
  test_stdout "$p7zip --" "
7-Zip 21.07 (x64) : Copyright (c) 1999-2021 Igor Pavlov : 2021-12-26"
  test_stdout "$busybox tar --version" "tar (busybox) 1.35.0-FRP-4487-gd239d2d52"
else
  test_stdout "$curl --version" "curl 7.81.0 (x86_64-pc-linux-musl) libcurl/7.81.0 OpenSSL/1.1.1l zlib/1.2.11 libssh2/1.9.0 nghttp2/1.43.0
Release-Date: 2022-01-05
Protocols: dict file ftp ftps gopher gophers http https imap imaps mqtt pop3 pop3s rtsp scp sftp smb smbs smtp smtps telnet tftp \nFeatures: alt-svc AsynchDNS HSTS HTTP2 HTTPS-proxy IPv6 Largefile libz NTLM NTLM_WB SSL TLS-SRP UnixSockets"

  test_stdout "$grep --version" "pcre2grep version 10.39 2021-10-29"

  if [[ "$is_alpine_os" == true ]]; then
    test_stdout "$p7zip --" "
7-Zip (z) 21.07 (x64) : Copyright (c) 1999-2021 Igor Pavlov : 2021-12-26
 64-bit locale=C UTF8=- Threads:2, ASM"
    test_stdout "$busybox tar --version" "tar (busybox) 1.34.1"
  else
    test_stdout "$p7zip --" "
7-Zip (z) 21.07 (x64) : Copyright (c) 1999-2021 Igor Pavlov : 2021-12-26
 64-bit locale=en_US.UTF-8 Threads:2, ASM"
  fi
fi

echo Errors: $errors_count
exit $errors_count

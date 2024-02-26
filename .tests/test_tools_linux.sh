#!/bin/bash
dp0="$(realpath "$(dirname "$0")")"
dp0_tools="$dp0/../.tools" && source "$dp0_tools/env_tools.sh"

testCurlVersion() {
  local etalon_log="$(echo -e "curl 7.81.0 (x86_64-pc-linux-musl) libcurl/7.81.0 OpenSSL/1.1.1l zlib/1.2.11 libssh2/1.9.0 nghttp2/1.43.0
Release-Date: 2022-01-05
Protocols: dict file ftp ftps gopher gophers http https imap imaps mqtt pop3 pop3s rtsp scp sftp smb smbs smtp smtps telnet tftp \nFeatures: alt-svc AsynchDNS HSTS HTTP2 HTTPS-proxy IPv6 Largefile libz NTLM NTLM_WB SSL TLS-SRP UnixSockets")"
  assertEquals "$etalon_log" "$($curl --version)"
}

testGrepVersion() {
  assertEquals "pcre2grep version 10.40 2022-04-14" "$("$grep" --version)"
}

test7zVersion() {
  actual_version="$("$p7z" | head -3)"
  if [[ "$is_alpine_os" == true ]]; then
    assertEquals "
7-Zip (z) 21.07 (x64) : Copyright (c) 1999-2021 Igor Pavlov : 2021-12-26
 64-bit locale=C UTF8=- Threads:4, ASM" "$actual_version" # editorconfig-checker-disable-line
  else
    assertEquals "
7-Zip (z) 21.07 (x64) : Copyright (c) 1999-2021 Igor Pavlov : 2021-12-26
 64-bit locale=C.UTF-8 Threads:4, ASM" "$actual_version" # editorconfig-checker-disable-line
 fi
}

testBusyboxVersion() {
  if [[ "$is_alpine_os" == true ]]; then
    assertEquals "tar (busybox) 1.34.1" "$("$busybox" tar --version)"
  else
    assertEquals "tar (busybox) 1.30.1" "$("$busybox" tar --version)"
  fi
}

# Load and run shUnit2.
source "../.tests/shunit2/shunit2"

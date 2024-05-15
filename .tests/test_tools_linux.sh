#!/bin/bash
dp0="$(realpath "$(dirname "$0")")"
dp0_tools="$dp0/../.tools" && source "$dp0_tools/env_tools.sh"

testCurlVersion() {
  local etalon_log="$(echo -e "curl 8.7.1 (x86_64-pc-linux-musl) libcurl/8.7.1 OpenSSL/3.1.4 zlib/1.3.1 libssh2/1.11.0 nghttp2/1.58.0
Release-Date: 2024-03-27
Protocols: dict file ftp ftps gopher gophers http https imap imaps ipfs ipns mqtt pop3 pop3s rtsp scp sftp smb smbs smtp smtps telnet tftp
Features: alt-svc AsynchDNS HSTS HTTP2 HTTPS-proxy IPv6 Largefile libz NTLM SSL threadsafe TLS-SRP UnixSockets")"
  assertEquals "$etalon_log" "$($curl --version)"
}

testGrepVersion() {
  assertEquals "pcre2grep version 10.40 2022-04-14" "$("$grep" --version)"
}

test7zVersion() {
  assertEquals "
7-Zip (z) 24.05 (x64) : Copyright (c) 1999-2024 Igor Pavlov : 2024-05-14" "$("$p7z" | head -2)"
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

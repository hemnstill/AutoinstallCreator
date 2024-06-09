#!/bin/bash
dp0="$(realpath "$(dirname "$0")")"
dp0_tools="$dp0/../.tools" && source "$dp0_tools/env_tools.sh"

testCurlVersion() {
  local etalon_log="$(echo -e "curl 8.7.1 (x86_64-w64-mingw32) libcurl/8.7.1 LibreSSL/3.8.3 zlib/1.3.1 brotli/1.1.0 zstd/1.5.5 WinIDN libpsl/0.21.5 libssh2/1.11.0 nghttp2/1.60.0 ngtcp2/1.4.0 nghttp3/1.2.0
Release-Date: 2024-03-27
Protocols: dict file ftp ftps gopher gophers http https imap imaps ipfs ipns ldap ldaps mqtt pop3 pop3s rtsp scp sftp smb smbs smtp smtps telnet tftp ws wss
Features: alt-svc AsynchDNS brotli HSTS HTTP2 HTTP3 HTTPS-proxy IDN IPv6 Kerberos Largefile libz NTLM PSL SPNEGO SSL SSPI threadsafe UnixSockets zstd")"
  assertEquals "$etalon_log" "$($curl --version | dos2unix)"
}

testGrepVersion() {
  assertEquals "pcre2grep version 10.44 2024-06-07" "$("$grep" --version)"
}

test7zVersion() {
  assertEquals "
7-Zip (z) 24.06 (x64) : Copyright (c) 1999-2024 Igor Pavlov : 2024-05-26" "$("$p7z" | dos2unix | head -2)"
}

testBusyboxVersion() {
  assertEquals "tar (busybox) 1.36.0.git" "$("$busybox" tar --version)"
}

# Load and run shUnit2.
source "../.tests/shunit2/shunit2"

#!/bin/bash
dp0="$(realpath "$(dirname "$0")")"
dp0_tools="$dp0/../.tools" && source "$dp0_tools/env_tools.sh"

testCurlVersion() {
  local etalon_log="$(echo -e "curl 8.23.0 (x86_64-w64-mingw32) libcurl/8.23.0 LibreSSL/4.4.1 zlib/1.3.1.zlib-ng brotli/1.2.1 zstd/1.5.7 WinIDN libpsl/0.23.3 libssh2/1.11.1 nghttp2/1.71.0 ngtcp2/1.26.0 nghttp3/1.19.0 WinLDAP
Release-Date: 2026-10-14
Protocols: dict file ftp ftps gopher gophers http https imap imaps ipfs ipns ldap ldaps mqtt mqtts pop3 pop3s rtsp scp sftp smtp smtps telnet tftp ws wss
Features: alt-svc AsynchDNS brotli HSTS HTTP2 HTTP3 HTTPS-proxy HTTPSIG HTTPSRR IDN IPv6 Kerberos Largefile libz NativeCA proxy-HTTP3 PSL SPNEGO SSL SSPI threadsafe UnixSockets zstd")"
  assertEquals "$etalon_log" "$($curl --version | dos2unix)"
}

testGrepVersion() {
  assertEquals "pcre2grep version 10.49 2026-09-28" "$("$grep" --version)"
}

test7zVersion() {
  assertEquals "
7-Zip (z) 26.06 (x64) : Copyright (c) 1999-2026 Igor Pavlov : 2026-11-06" "$("$p7z" | dos2unix | head -2)"
}

testBusyboxVersion() {
  assertEquals "tar (busybox) 1.39.0.git-6354-g5f09fb446" "$("$busybox" tar --version)"
}

# Load and run shUnit2.
source "../.tests/shunit2/shunit2"

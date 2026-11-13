#!/bin/bash
dp0="$(realpath "$(dirname "$0")")"
dp0_tools="$dp0/../.tools" && source "$dp0_tools/env_tools.sh"

testCurlVersion() {
  local etalon_log="$(echo -e "curl 8.23.0 (x86_64-pc-linux-gnu) libcurl/8.23.0 OpenSSL/4.0.3 zlib/1.3.1.zlib-ng brotli/1.2.1 zstd/1.5.7 c-ares/1.34.9 libidn2/2.3.8 libpsl/0.23.3 libssh2/1.11.1 nghttp2/1.70.0 ngtcp2/1.25.0 nghttp3/1.18.0
Release-Date: 2026-10-14
Protocols: dict file ftp ftps gopher gophers http https imap imaps ipfs ipns mqtt mqtts pop3 pop3s rtsp scp sftp smtp smtps telnet tftp ws wss
Features: alt-svc asyn-rr AsynchDNS brotli CAcert ECH HSTS HTTP2 HTTP3 HTTPS-proxy HTTPSIG HTTPSRR IDN IPv6 Largefile libz NTLM proxy-HTTP3 PSL SSL SSLS-EXPORT threadsafe UnixSockets zstd")"
  assertEquals "$etalon_log" "$($curl --version)"
}

testGrepVersion() {
  assertEquals "pcre2grep version 10.49 2026-09-28" "$("$grep" --version)"
}

test7zVersion() {
  assertEquals "
7-Zip (z) 26.06 (x64) : Copyright (c) 1999-2026 Igor Pavlov : 2026-11-06" "$("$p7z" | head -2)"
}

testBusyboxVersion() {
  if [[ "$is_alpine_os" == true ]]; then
    assertEquals "tar (busybox) 1.36.1" "$("$busybox" tar --version)"
  else
    assertEquals "tar (busybox) 1.30.1" "$("$busybox" tar --version)"
  fi
}

# Load and run shUnit2.
source "../.tests/shunit2/shunit2"

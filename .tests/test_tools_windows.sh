#!/bin/bash
dp0="$(realpath "$(dirname "$0")")"
dp0_tools="$dp0/../.tools" && source "$dp0_tools/env_tools.sh"

testCurlVersion() {
  local etalon_log="$(echo -e "curl 7.81.0 (x86_64-pc-win32) libcurl/7.81.0 OpenSSL/3.0.1 (Schannel) zlib/1.2.11 brotli/1.0.9 libidn2/2.3.2 libssh2/1.10.0 nghttp2/1.46.0 libgsasl/1.10.0
Release-Date: 2022-01-05
Protocols: dict file ftp ftps gopher gophers http https imap imaps ldap ldaps mqtt pop3 pop3s rtsp scp sftp smb smbs smtp smtps telnet tftp \nFeatures: alt-svc AsynchDNS brotli gsasl HSTS HTTP2 HTTPS-proxy IDN IPv6 Kerberos Largefile libz MultiSSL NTLM SPNEGO SSL SSPI TLS-SRP UnixSockets")"
  assertEquals "$etalon_log" "$($curl --version | dos2unix)"
}

testGrepVersion() {
  assertEquals "pcre2grep version 10.40 2022-04-14" "$("$grep" --version)"
}

test7zVersion() {
  assertEquals "
7-Zip 21.07 (x64) : Copyright (c) 1999-2021 Igor Pavlov : 2021-12-26" "$("$p7z" | dos2unix | head -2)"
}

testBusyboxVersion() {
  assertEquals "tar (busybox) 1.36.0.git" "$("$busybox" tar --version)"
}

# Load and run shUnit2.
source "../.tests/shunit2/shunit2"

@echo off
set curl="%~dp0curl" --fail
if not "%CI%" == "" (
  set curl="%~dp0\curl" --fail --silent --show-error
)
set p7z="%~dp0\7z.exe"
set grep="%~dp0pcre2grep.exe"
set busybox="%~dp0busybox64.exe"
set head=%busybox% head

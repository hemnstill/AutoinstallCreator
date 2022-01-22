@echo off
set curl=..\curl --fail
if not "%CI%" == "" (
  set curl=..\curl --fail --silent --show-error
)
set p7z=..\7z.exe
set grep=..\pcre2grep.exe
set busybox=..\busybox64.exe
set head=%busybox% head

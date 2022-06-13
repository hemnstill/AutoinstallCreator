@echo off
set curl="%~dp0curl" --fail
if not "%CI%" == "" (
  set curl="%~dp0curl" --fail --silent --show-error
)
set p7z="%~dp07z.exe"
set grep="%~dp0pcre2grep.exe"
set busybox="%~dp0busybox.exe"
set head=%busybox% head
set batch_runner="%~dp0batch_runner.bat"

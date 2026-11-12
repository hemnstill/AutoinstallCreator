@echo off
set curl="%~dp0curl" --fail
if not "%CI%" == "" (
  set curl="%~dp0curl" --fail --silent --show-error
)
rem authenticate api.github.com only (netrc is per-host) to avoid anonymous rate limit
if not "%CI%" == "" if not "%GITHUB_TOKEN%" == "" if not "%RUNNER_TEMP%" == "" (
  >"%RUNNER_TEMP%\github.netrc" echo machine api.github.com login x-access-token password %GITHUB_TOKEN%
  set curl=%curl% --netrc-file "%RUNNER_TEMP%\github.netrc"
)
set p7z="%~dp07zz.exe"
set grep="%~dp0pcre2grep.exe"
set busybox="%~dp0busybox.exe"
set head=%busybox% head
set batch_runner="%~dp0batch_runner.bat"

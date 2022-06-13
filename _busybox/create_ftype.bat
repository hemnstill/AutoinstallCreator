@echo off

net session >nul 2>&1
if %errorLevel% neq 0 (
  echo Need Administrator elevated priveleges
  exit /b
)

assoc .sh=_bash_file
ftype _bash_file="%~dp0..\.tools\busybox.exe" bash "%%1" %%*

exit /b %errorlevel%

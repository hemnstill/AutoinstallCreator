@echo off
"%~dp0..\.tools\busybox64.exe" bash "%~dp0create_install.sh"

assoc .sh=_bash_file
ftype _bash_file="%busybox%" bash "%%1" %%*

exit /b %errorlevel%

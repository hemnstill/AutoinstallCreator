@echo off
assoc .sh=_bash_file
ftype _bash_file="%~dp0busybox64.exe" bash "%%1" %%*

exit /b %errorlevel%

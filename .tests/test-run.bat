@echo off
"%~dp0..\.tools\busybox64.exe" bash "%~dp0test-run-bat.sh" %*

exit /b %errorlevel%

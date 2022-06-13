@echo off
"%~dp0..\.tools\busybox.exe" bash "%~dp0test-run-bat.sh" %*

exit /b %errorlevel%

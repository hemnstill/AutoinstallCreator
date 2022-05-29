@echo off
"%~dp0..\.tools\busybox64.exe" bash "%~dp0ci-test-run.sh" %*

exit /b %errorlevel%

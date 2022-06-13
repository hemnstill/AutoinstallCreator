@echo off
"%~dp0..\.tools\busybox.exe" bash "%~dp0ci-test-run.sh" %*

exit /b %errorlevel%

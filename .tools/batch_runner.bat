@echo off
"%~dp0..\.tools\busybox64.exe" bash "%~dp0batch_runner.sh" %*

exit /b %errorlevel%

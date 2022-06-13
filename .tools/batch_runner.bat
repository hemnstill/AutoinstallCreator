@echo off
"%~dp0..\.tools\busybox.exe" bash "%~dp0batch_runner.sh" %*

exit /b %errorlevel%

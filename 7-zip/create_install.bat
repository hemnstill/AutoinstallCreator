@echo off
"%~dp0..\.tools\busybox64.exe" bash "%~dp0create_install.sh"

exit /b %errorlevel%

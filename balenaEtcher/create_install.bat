@echo off
"%~dp0..\.tools\busybox.exe" bash "%~dp0create_install.sh"

exit /b %errorlevel%

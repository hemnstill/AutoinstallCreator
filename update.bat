@echo off
"%~dp0.tools\busybox.exe" bash "%~dp0update.sh"

exit /b %errorlevel%

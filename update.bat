@echo off
echo f | xcopy /Y /Q /R "%~dp0update.sh" "%~dp0update_old.tmp"
echo f | xcopy /Y /Q /R "%~dp0.tools\busybox.exe" "%~dp0.tools\busybox_old.exe"
"%~dp0.tools\busybox_old.exe" bash "%~dp0update_old.tmp" %*

exit /b %errorlevel%


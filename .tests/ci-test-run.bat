@echo off

if exist "%~dp0\ci-init.bat" call "%~dp0\ci-init.bat"

"%~dp0..\.tools\busybox.exe" bash "%~dp0ci-test-run.sh" %*

exit /b %errorlevel%

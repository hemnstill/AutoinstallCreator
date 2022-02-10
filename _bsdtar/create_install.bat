@echo off
call "%~dp0..\.tools\env_tools.bat"
%bash% "%~dp0create_install.sh"
exit /b %errorlevel%

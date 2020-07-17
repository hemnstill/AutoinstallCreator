@echo off
cd /d "%~dp0"
set latest_filename=XMouseButtonControlSetup.exe
set downloadurl=https://www.highrez.co.uk/scripts/download.asp?package=XMouse
echo Downloading: %latest_filename% %downloadurl% ...
..\curl --fail --location %downloadurl% --output %latest_filename%
IF %ERRORLEVEL% NEQ 0 ( 
	exit
) 
echo Done.

echo Generating %latest_filename% autoinstall.bat
echo %%~dp0%latest_filename% /S > autoinstall.bat
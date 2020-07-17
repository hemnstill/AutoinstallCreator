@echo off
cd /d "%~dp0"
set latest_filename=SlackSetup.msi
set downloadurl=https://slack.com/ssb/download-win64-msi-legacy
echo Downloading: %latest_filename% %downloadurl% ...
..\curl --fail --location %downloadurl% --output %latest_filename%
IF %ERRORLEVEL% NEQ 0 ( 
	exit
) 
echo Done.

echo Generating %latest_filename% autoinstall.bat
echo %%~dp0%latest_filename% /S > autoinstall.bat
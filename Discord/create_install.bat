@echo off
pushd "%~dp0"
set curl=..\curl --fail

set latest_filename=DiscordSetup.exe
set downloadurl=https://discord.com/api/download?platform=win
echo Downloading: %latest_filename% %downloadurl% ...
%curl% --location %downloadurl% --output %latest_filename%
IF %ERRORLEVEL% NEQ 0 ( exit /b %ERRORLEVEL% ) 
echo Done.

echo Generating %latest_filename% autoinstall.bat
echo "%%~dp0%latest_filename%" > autoinstall.bat
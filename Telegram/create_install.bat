@echo off
pushd "%~dp0"
set curl=..\curl --fail

set latest_filename=telegramsetup.exe
set downloadurl=https://telegram.org/dl/desktop/win
echo Downloading: %downloadurl% ...
%curl% --location %downloadurl% --output %latest_filename%
IF %ERRORLEVEL% NEQ 0 ( exit /b %ERRORLEVEL% ) 
echo Done.

echo Generating %latest_filename% autoinstall.bat
echo "%%~dp0%latest_filename%" /VERYSILENT > autoinstall.bat
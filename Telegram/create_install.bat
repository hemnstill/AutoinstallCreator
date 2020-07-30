@echo off
pushd "%~dp0"
set latest_filename=telegramsetup.exe
set downloadurl=https://telegram.org/dl/desktop/win
echo Downloading: %downloadurl% ...
..\curl --fail --location %downloadurl% --output %latest_filename%
IF %ERRORLEVEL% NEQ 0 ( 
	exit
) 
echo Done.

echo Generating %latest_filename% autoinstall.bat
echo "%%~dp0%latest_filename%" /VERYSILENT > autoinstall.bat
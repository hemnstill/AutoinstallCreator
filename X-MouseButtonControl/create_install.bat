@echo off
pushd "%~dp0"
set curl=..\curl --fail

set latest_filename=X-MouseButtonControlSetup.exe
set download_url="https://www.highrez.co.uk/scripts/download.asp?package=XMouse"
echo Downloading: %latest_filename% %download_url% ...
%curl% --location %download_url% --output %latest_filename%
if %errorlevel% neq 0 ( exit /b %errorlevel% )
echo Done.

echo Generating %latest_filename% autoinstall.bat
echo "%%~dp0%latest_filename%" /S > "%~dp0autoinstall.bat"

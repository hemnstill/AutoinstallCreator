@echo off
pushd "%~dp0"
set curl=..\curl --fail

set latest_filename=BuildTools_Full.exe
set download_url="https://go.microsoft.com/fwlink/?LinkId=615458"
echo Downloading: %latest_filename% %download_url% ...
%curl% --fail --location %download_url% --output %latest_filename%
if %errorlevel% neq 0 ( exit /b %errorlevel% )
echo Done.

echo Generating %latest_filename% autoinstall.bat
echo "%%~dp0%latest_filename%" /passive > autoinstall.bat

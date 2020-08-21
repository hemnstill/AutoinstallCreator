@echo off
pushd "%~dp0"
set curl=..\curl --fail

set latest_filename=BuildTools_Full.exe
set downloadurl=https://go.microsoft.com/fwlink/?LinkId=615458
echo Downloading: %latest_filename% %downloadurl% ...
%curl% --fail --location %downloadurl% --output %latest_filename%
IF %ERRORLEVEL% NEQ 0 ( exit ) 
echo Done.

echo Generating %latest_filename% autoinstall.bat
echo "%%~dp0%latest_filename%" /passive > autoinstall.bat
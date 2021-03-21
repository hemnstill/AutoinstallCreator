@echo off
pushd "%~dp0"
set curl=..\curl --fail

set download_url="https://schinagl.priv.at/nt/hardlinkshellext/HardLinkShellExt_X64.exe"
echo Downloading: %download_url% ...
%curl% --location %download_url% --remote-name
if %errorlevel% neq 0 ( exit /b %errorlevel% )
echo Done.

for %%i in (%download_url%) do (
	set latest_filename=%%~ni%%~xi
)

echo Generating %latest_filename% autoinstall.bat
echo "%%~dp0%latest_filename%" /S /noredist > "%~dp0autoinstall.bat"

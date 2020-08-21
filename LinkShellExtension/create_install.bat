@echo off
pushd "%~dp0"
set curl=..\curl --fail

set downloadurl=https://schinagl.priv.at/nt/hardlinkshellext/HardLinkShellExt_X64.exe
echo Downloading: %downloadurl% ...
%curl% --location %downloadurl% --remote-name
IF %ERRORLEVEL% NEQ 0 ( exit ) 
echo Done.

FOR %%i IN ("%downloadurl%") DO (
	set latest_filename=%%~ni%%~xi
)

echo Generating %latest_filename% autoinstall.bat
echo "%%~dp0%latest_filename%" /S /noredist > "%~dp0autoinstall.bat"
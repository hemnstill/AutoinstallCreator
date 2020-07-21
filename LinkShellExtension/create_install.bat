@echo off
pushd "%~dp0"
set downloadurl=https://schinagl.priv.at/nt/hardlinkshellext/HardLinkShellExt_X64.exe
echo Downloading: %downloadurl% ...
..\curl --fail --location %downloadurl% -O
IF %ERRORLEVEL% NEQ 0 ( 
	exit
) 
echo Done.
FOR %%i IN ("%downloadurl%") DO (
	set latest_filename=%%~ni%%~xi
)

echo Generating %latest_filename% autoinstall.bat
echo "%%~dp0%latest_filename%" /S /noredist > "%~dp0autoinstall.bat"
@echo off
pushd "%~dp0"
set downloadurl=https://rammichael.com/downloads/7tt_setup.exe
echo Downloading: %downloadurl% ...
..\curl --fail --remote-name --location %downloadurl%
IF %ERRORLEVEL% NEQ 0 ( 
	exit
) 
echo Done.

FOR %%i IN ("%downloadurl%") DO (
	set latest_filename=%%~ni%%~xi
)
echo Generating %latest_filename% autoinstall.bat
echo "%%~dp0%latest_filename%" /S > "%~dp0autoinstall.bat"
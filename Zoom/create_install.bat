@echo off
pushd "%~dp0"
set downloadurl=https://zoom.us/client/latest/ZoomInstaller.exe
echo Downloading: %latest_filename% %downloadurl% ...
..\curl --fail --location %downloadurl% --remote-name
IF %ERRORLEVEL% NEQ 0 ( 
	exit
) 
echo Done.

FOR %%i IN ("%downloadurl%") DO (
	set latest_filename=%%~ni%%~xi
)
echo Generating %latest_filename% autoinstall.bat
echo "%%~dp0%latest_filename%" /passive > "%~dp0autoinstall.bat"
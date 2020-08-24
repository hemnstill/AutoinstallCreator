@echo off
pushd "%~dp0"
set curl=..\curl --fail

set downloadurl=https://www.rapidee.com/download/RapidEE_setup.exe
echo Downloading: %downloadurl% ...
%curl% --location %downloadurl% --remote-name
IF %ERRORLEVEL% NEQ 0 ( exit /b %ERRORLEVEL% ) 
echo Done.

FOR %%i IN ("%downloadurl%") DO (
	set latest_filename=%%~ni%%~xi
)

echo Generating %latest_filename% autoinstall.bat
echo "%%~dp0%latest_filename%" /SILENT > "%~dp0autoinstall.bat"
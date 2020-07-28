@echo off
pushd "%~dp0"
set downloadurl=https://dl.google.com/chrome/install/GoogleChromeStandaloneEnterprise64.msi
echo Downloading: %downloadurl% ...
..\curl --fail --remote-name --location %downloadurl% -O
IF %ERRORLEVEL% NEQ 0 ( 
	exit
) 
echo Done.
FOR %%i IN ("%downloadurl%") DO (
	set latest_filename=%%~ni%%~xi
)
echo Generating %latest_filename% autoinstall.bat
echo "%%~dp0%latest_filename%" /passive > autoinstall.bat
@echo off
pushd "%~dp0"

set latest_version=https://tortoisegit.org/download/
>raw_download_str.tmp (
  ..\curl -s %latest_version% | ..\grep --only-matching "download[^ ]*64bit.msi"
)
IF %ERRORLEVEL% NEQ 0 ( 
  echo Cannot get latest version 
  exit
) 

set /p downloadurl=< raw_download_str.tmp
set downloadurl=https://%downloadurl%
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
echo "%%~dp0%latest_filename%" /passive > autoinstall.bat
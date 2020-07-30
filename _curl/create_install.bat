@echo off
pushd "%~dp0"

set latest_version=https://curl.haxx.se/windows/
>raw_download_str.tmp (
  ..\curl -s %latest_version% | ..\grep --only-matching "dl[^ ]*win64-mingw.zip"
)
IF %ERRORLEVEL% NEQ 0 ( 
  echo Cannot get latest version 
  exit
) 

set /p downloadurl=< raw_download_str.tmp
set downloadurl=%latest_version%%downloadurl%
echo Downloading: %downloadurl% ...
..\curl --fail --remote-name --location %downloadurl%
IF %ERRORLEVEL% NEQ 0 ( 
	exit
) 
echo Done.
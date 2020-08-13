@echo off
pushd "%~dp0"

set base_url=https://www.dotpdn.com/downloads
>raw_download_str.tmp (
  ..\curl -s %base_url%/pdn.html | ..\grep --only-matching """[^ ]*install.zip"""
)
IF %ERRORLEVEL% NEQ 0 ( 
  echo Cannot get latest version 
  exit
) 

set /p downloadurl=< raw_download_str.tmp
call set downloadurl=%%downloadurl:"=%%
set downloadurl=%base_url%/%downloadurl%
echo Downloading: %downloadurl% ...
..\curl --fail --remote-name --location %downloadurl%
IF %ERRORLEVEL% NEQ 0 ( 
	exit
) 
echo Done.

FOR %%i IN ("%downloadurl%") DO (
	set latest_filename=%%~ni%%~xi
)
..\7za e %latest_filename% -aoa

FOR %%i IN ("%downloadurl%") DO (
	set latest_filename=%%~ni.exe
)
echo Generating %latest_filename% autoinstall.bat
echo "%%~dp0%latest_filename%" /auto > autoinstall.bat
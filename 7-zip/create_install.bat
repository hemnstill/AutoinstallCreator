@echo off
pushd "%~dp0"
set curl=..\curl --fail
set grep=..\grep

set latest_version=https://www.7-zip.org/download.html
>raw_download_str.tmp (
  %curl% %latest_version% | %grep% --only-matching "[^ ]*x64.msi"
)
IF %ERRORLEVEL% NEQ 0 ( 
  echo Cannot get latest version 
  exit
) 

set /p downloadurl=< raw_download_str.tmp
set downloadurl=https://www.7-zip.org/%downloadurl:~6%
echo Downloading: %downloadurl% ...
%curl% --remote-name --location %downloadurl%
IF %ERRORLEVEL% NEQ 0 ( exit )
echo Done.

FOR %%i IN ("%downloadurl%") DO (
	set latest_filename=%%~ni%%~xi
)
echo Generating %latest_filename% autoinstall.bat
echo "%%~dp0%latest_filename%" /passive > autoinstall.bat
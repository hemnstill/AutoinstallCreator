@echo off
pushd "%~dp0"
set curl=..\curl --fail
set grep=..\grep
set p7z=..\7z

set latest_version=https://curl.haxx.se/windows/
>raw_download_str.tmp (
  %curl% %latest_version% | %grep% --only-matching "dl[^ ]*win64-mingw.zip"
)
IF %ERRORLEVEL% NEQ 0 ( 
  echo Cannot get latest version 
  exit /b %ERRORLEVEL%
) 

set /p downloadurl=< raw_download_str.tmp
set downloadurl=%latest_version%%downloadurl%
echo Downloading: %downloadurl% ...
%curl% --remote-name --location %downloadurl%
IF %ERRORLEVEL% NEQ 0 ( exit /b %ERRORLEVEL% ) 
echo Done.

FOR %%i IN ("%downloadurl%") DO (
  set latest_filename=%%~ni%%~xi
)

echo Generating %latest_filename% autoinstall.bat
>autoinstall.bat (
  echo pushd "%%~dp0"
  echo "%p7z%" e "%latest_filename%" "-o.." *.exe *.crt -aoa -r
  echo exit /b %%errorlevel%%
)
echo Done.
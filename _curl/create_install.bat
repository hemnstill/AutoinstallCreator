@echo off
pushd "%~dp0"
set curl=..\curl --fail
set grep=..\grep
set p7z=..\7z

set latest_version=https://curl.haxx.se/windows/
>raw_download_str.tmp (
  %curl% %latest_version% | %grep% --only-matching "dl[^ ]*win64-mingw.zip"
)
if %errorlevel% neq 0 ( 
  echo Cannot get latest version 
  exit /b %errorlevel%
) 

set /p download_url=< raw_download_str.tmp
set download_url=%latest_version%%download_url%
echo Downloading: %download_url% ...
%curl% --remote-name --location %download_url%
if %errorlevel% neq 0 ( exit /b %errorlevel% ) 
echo Done.

for %%i in ("%download_url%") do (
  set latest_filename=%%~ni%%~xi
)

echo Generating %latest_filename% autoinstall.bat
>autoinstall.bat (
  echo pushd "%%~dp0"
  echo "%p7z%" e "%latest_filename%" "-o.." *.exe *.crt -aoa -r
  echo exit /b %%errorlevel%%
)
echo Done.
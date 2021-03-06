@echo off
pushd "%~dp0"

set curl=..\curl --fail
set p7z=..\7z.exe
set LC_ALL=en_US.UTF-8
set grep=..\grep

set latest_version="https://cryptomator.org/downloads/win/thanks"
echo Downloading: %latest_version% ...
>raw_download_str.tmp (
    %curl% --location %latest_version% | %grep% -Po "(?<=href="")[^\s]*\.exe(?="")"
)
if %errorlevel% neq 0 (
  echo Cannot download latest version
  exit /b %errorlevel%
)

set /p download_url= < raw_download_str.tmp
echo Downloading: %download_url% ...
%curl% --remote-name --location %download_url%
if %errorlevel% neq 0 (
  echo Cannot download latest version
  exit /b %errorlevel%
)

for %%i in (%download_url%) do (
  set latest_filename=%%~ni%%~xi
)

echo Done.

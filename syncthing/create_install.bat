@echo off
pushd "%~dp0"

set curl=..\curl --fail
set p7z=..\7z.exe
set grep=..\grep

set latest_version=https://api.github.com/repos/syncthing/syncthing/releases/latest
echo Get latest version: %latest_version% ...
>raw_download_str.tmp (
    %curl% %latest_version% | %grep% """browser_download_url""" | %grep% --only-matching "[^"" ]*windows-amd64[^"" ]*\.zip"
)
if %errorlevel% neq 0 (
  echo Cannot get latest version
  exit /b %errorlevel%
)

set /p download_url= < raw_download_str.tmp
echo Downloading: %download_url% ...
%curl% --remote-name --location %download_url%
if %errorlevel% neq 0 (
  echo Cannot download latest version
  exit /b %errorlevel%
)

echo Done.

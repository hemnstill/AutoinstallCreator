@echo off
pushd "%~dp0"

set curl=..\curl --fail
set p7z=..\7z.exe
set LC_ALL=en_US.UTF-8
set grep=..\grep

set golang_version_pattern=%~1
if "%golang_version_pattern%" == "" (
  set golang_version_pattern=".windows-amd64"
) else (
  set golang_version_pattern="go%golang_version_pattern%.windows-amd64"
)

set latest_version="https://golang.org/dl"
echo Get version from %latest_version% ...
>raw_download_str.tmp (
    %curl% --location %latest_version% | %grep% -Po "(?<=href="")[^\s]*\.msi(?="")" | %grep% -F -- "%golang_version_pattern%"
)
if %errorlevel% neq 0 (
  echo Cannot get latest version
  exit /b %errorlevel%
)

set /p download_url= < raw_download_str.tmp
set download_url=https://golang.org%download_url%
set download_url="%download_url%"
echo Downloading: %download_url% ...
%curl% --remote-name --location %download_url%
if %errorlevel% neq 0 (
  echo Cannot download latest version
  exit /b %errorlevel%
)

for %%i in (%download_url%) do (
  set latest_filename=%%~ni%%~xi
)

echo Generating %latest_filename% autoinstall.bat
echo "%%~dp0%latest_filename%" /passive > autoinstall.bat

echo Done.

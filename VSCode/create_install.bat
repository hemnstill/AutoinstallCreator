@echo off
pushd "%~dp0"

set curl=..\curl --fail
set p7z=..\7z.exe
set LC_ALL=en_US.UTF-8
set grep=..\grep


set latest_filename=VSCodeUserSetup.exe
set download_url="https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user"
echo Downloading: %download_url% ...
%curl% --location %download_url% --output "%latest_filename%"
if %errorlevel% neq 0 (
  echo Cannot download latest version
  exit /b %errorlevel%
)

echo Generating autoinstall.bat
> autoinstall.bat (
  echo "%%~dp0%latest_filename%" /SILENT /NORESTART"
)

echo Done.

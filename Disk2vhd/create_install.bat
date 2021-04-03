@echo off
pushd "%~dp0"

set curl=..\curl --fail
set p7z=..\7z.exe
set LC_ALL=en_US.UTF-8
set grep=..\grep

set download_url="https://download.sysinternals.com/files/Disk2vhd.zip"
echo Downloading: %download_url% ...
%curl% --remote-name --location %download_url%
if %errorlevel% neq 0 (
  echo Cannot download latest version
  exit /b %errorlevel%
)


for %%i in (%download_url%) do (
  set latest_filename=%%~ni%%~xi
)

"%p7z%" e "%latest_filename%" "-o." *.exe -aoa -r
if %errorlevel% neq 0 ( exit /b %errorlevel% )

echo Done.

@pushd "%~dp0"
@call ../.src/env_tools.bat

set latest_version=https://api.github.com/repos/git-for-windows/git/releases/latest
echo Get latest version: %latest_version% ...
>raw_download_str.tmp (
    %curl% %latest_version% | %grep% """browser_download_url""" | %grep% --only-matching "[^"" ]*64-bit\.exe"
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

for %%i in ("%download_url%") do (
    set git_latest_filename=%%~ni%%~xi
)

echo Generating autoinstall.bat
> autoinstall.bat (
  echo "%%~dp0%git_latest_filename%" /SILENT /NORESTART /CLOSEAPPLICATIONS /LOADINF="%%~dp0git.ini"
)

echo Done.

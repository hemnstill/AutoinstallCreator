@pushd "%~dp0"
@call ..\.src\env_tools.bat

set latest_version=https://sourceforge.net/projects/keepass/best_release.json
echo Get latest version: %latest_version% ...
>raw_download_str.tmp (
    %curl% %latest_version% | %grep% -P --only-matching "(?<=""url""\:\s"")[^\s]*(?=/download"",)" | %head% -n1
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
  set latest_filename=%%~ni%%~xi
)

echo Generating autoinstall.bat
> autoinstall.bat (
  echo "%latest_filename%" /SILENT /NORESTART
)

echo Done.
exit /b %errorlevel%

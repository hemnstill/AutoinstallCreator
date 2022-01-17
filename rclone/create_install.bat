@pushd "%~dp0"
@call ..\.src\env_tools.bat

set latest_version=https://api.github.com/repos/rclone/rclone/releases/latest
echo Get latest version: %latest_version% ...
>raw_download_str.tmp (
  %curl% %latest_version% | %grep% """browser_download_url""" | %grep% --only-matching "[^"" ]*windows-amd64\.zip" | find "" /V
)
if %errorlevel% neq 0 (
  echo Cannot get latest version
  exit /b %errorlevel%
)

set /p download_url= < raw_download_str.tmp
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
  echo "%p7z%" e "%latest_filename%" "-o." rclone.exe -aoa -r
  echo exit /b %%errorlevel%%
)

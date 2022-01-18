@pushd "%~dp0"
@call ..\.src\env_tools.bat

set latest_version=https://api.github.com/repos/paintdotnet/release/releases/latest
echo Get latest version: %latest_version% ...
>raw_download_str.tmp (
    %curl% %latest_version% | %grep% """browser_download_url""" | %grep% --only-matching "[^"" ]*winmsi\.x64\.zip" | find "" /V
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
  set latest_filename=%%~ni.zip
)

%p7z% e %latest_filename% -aoa
if %errorlevel% neq 0 (
  echo Cannot extract from %latest_filename%
  exit /b %errorlevel%
)

echo Generating %latest_filename% autoinstall.bat
> autoinstall.bat (
    echo "%%~dp0%latest_filename%" /passive
    echo exit /b %%errorlevel%%
)

echo Done.
exit /b %errorlevel%

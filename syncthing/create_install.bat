@pushd "%~dp0"
@call "%~dp0..\.tools\env_tools.bat"

set latest_version=https://api.github.com/repos/syncthing/syncthing/releases/latest
echo Get latest version: %latest_version% ...
>raw_download_str.tmp (
    %curl% %latest_version% | %grep% """browser_download_url""" | %grep% --only-matching "[^"" ]*windows-amd64[^"" ]*\.zip" | %head% -n1
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

"%p7z%" e "%latest_filename%" "-o." *.exe -aoa -r
if %errorlevel% neq 0 ( exit /b %errorlevel% )


echo Done.
exit /b %errorlevel%

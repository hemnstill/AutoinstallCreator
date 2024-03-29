@pushd "%~dp0"
@call "%~dp0..\.tools\env_tools.bat"

set latest_version=https://api.github.com/repos/MyEtherWallet/MyEtherWallet/releases
echo Get latest version: %latest_version% ...
>raw_download_str.tmp (
    %curl% %latest_version% | %grep% """browser_download_url""" | %grep% --only-matching "[^"" ]*MyEtherWallet-[^"" ]*\.zip" | %head% -n1
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

for %%i in (%download_url%) do (
  set latest_filename=%%~ni%%~xi
  set latest_dirname=%%~ni
)

echo Generating %latest_filename% autoinstall.bat
> autoinstall.bat (
  echo "%%~dp0%p7z%" x "%%~dp0%latest_filename%" "-o%%~dp0%latest_dirname%" -aoa -r
  echo exit /b %%errorlevel%%
)

echo Done.

exit /b %errorlevel%

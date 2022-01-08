@pushd "%~dp0"
@call ../.src/env_tools.bat

set download_url="https://aka.ms/vs/17/release/vc_redist.x64.exe"
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
> autoinstall.bat (
    echo "%%~dp0%latest_filename%" /passive
    echo exit /b %%errorlevel%%
)

echo Done.

@pushd "%~dp0"
@call "%~dp0..\.tools\env_tools.bat"

set latest_version="https://www.isunshare.com/clonego"
echo Downloading: %latest_version% ...
>raw_download_str.tmp (
    %curl% --location %latest_version% | %grep% --only-matching "(?<=href="")[^\s]*\.exe(?="")" | %head% -n1
)
if %errorlevel% neq 0 (
  echo Cannot download latest version
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
)

echo Generating %latest_filename% autoinstall.bat
echo "%%~dp0%latest_filename%" /S > autoinstall.bat

echo Done.
exit /b %errorlevel%

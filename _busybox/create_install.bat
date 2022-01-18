@pushd "%~dp0"
@call ..\.src\env_tools.bat

set download_url="https://frippery.org/files/busybox/busybox64.exe"
echo Downloading: %download_url% ...
%curl% --remote-name --location "%download_url%"
if %errorlevel% neq 0 (
  echo Cannot download latest version
  exit /b %errorlevel%
)

for %%i in (%download_url%) do (
  set latest_filename=%%~ni%%~xi
)

echo %latest_filename% Done.
exit /b %errorlevel%

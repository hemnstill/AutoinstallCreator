@pushd "%~dp0"
@call ..\.src\env_tools.bat

set latest_version=https://api.github.com/repos/notepad-plus-plus/notepad-plus-plus/releases/latest
echo Get latest version: %latest_version% ...
>raw_download_str.tmp (
  %curl% %latest_version% | findstr /r /c:"browser_download_url.*\.x64\.exe\""
)
if %errorlevel% neq 0 (
  echo Cannot get latest version
  exit /b %errorlevel%
)

set /p download_url= < raw_download_str.tmp
call set download_url=%%download_url:"browser_download_url":=%%
call set download_url=%%download_url:"=%%
echo Downloading: %download_url% ...
%curl% --remote-name --location %download_url%
if %errorlevel% neq 0 ( exit /b %errorlevel% )
echo Done.

for %%i in ("%download_url%") do (
  set latest_filename=%%~ni%%~xi
)
echo Generating %latest_filename% autoinstall.bat
echo "%%~dp0%latest_filename%" /S > autoinstall.bat

exit /b %errorlevel%

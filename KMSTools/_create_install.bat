@pushd "%~dp0"
@call "%~dp0..\.tools\env_tools.bat"

set latest_folder_version="https://www.solidfiles.com/folder/bd7165a0d4/"
echo Downloading: %latest_folder_version% ...
>raw_download_str.tmp (
    %curl% --location %latest_folder_version% | %grep% "KMS Tools Portable" | %grep% --only-matching "(?<=<a\shref="")[^\s]*(?="")" | %head% -n1
)
if %errorlevel% neq 0 (
  echo Cannot download latest version
  exit /b %errorlevel%
)

set /p latest_relative_version= < raw_download_str.tmp
set latest_version="https://www.solidfiles.com%latest_relative_version%"
echo Downloading: %latest_version% ...
>raw_download_str.tmp (
    %curl% --location %latest_version%  | %grep% --only-matching "(?<=""downloadUrl"":"")[^\s]*\.7z(?="")" | %head% -n1
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

echo Done.
exit /b %errorlevel%

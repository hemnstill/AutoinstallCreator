@pushd "%~dp0"
@call "%~dp0..\.tools\env_tools.bat"

set api_url="https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release"
echo Get latest version: %api_url% ...
>raw_download_str.tmp (
  %curl% %api_url% | %grep% --only-matching "(?<=""link"":"")[^,]+\.exe(?="")" | %head% -n1
)

if %errorlevel% neq 0 (
  echo Cannot get latest version
  exit /b %errorlevel%
)

set /p download_url=< raw_download_str.tmp
echo Downloading: %download_url% ...
%curl% --location "%download_url%" --remote-name
if %errorlevel% neq 0 ( exit /b %errorlevel% )
echo Done.

for %%i in ("%download_url%") do (
  set latest_filename=%%~ni%%~xi
)
echo Generating %latest_filename% autoinstall.bat
echo "%%~dp0%latest_filename%" /S > autoinstall.bat

exit /b %errorlevel%

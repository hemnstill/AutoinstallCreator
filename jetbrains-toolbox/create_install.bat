@echo off
pushd "%~dp0"
set LC_ALL=en_US.UTF-8
set curl=..\curl --fail
set grep=..\grep

set api_url="https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release"
echo Get latest version: %api_url% ...
>raw_download_str.tmp (
  %curl% %api_url% | %grep% -Po "(?<=""link"":"")[^,]+\.exe(?="")
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

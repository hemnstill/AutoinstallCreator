@pushd "%~dp0"
@call ..\.src\env_tools.bat

set latest_version=https://www.iis.net/downloads/microsoft/url-rewrite
>raw_download_str.tmp (
  %curl% %latest_version% | %grep% --only-matching """[^ ]*amd64_en-US.msi""" | find "" /V
)
if %errorlevel% neq 0 (
  echo Cannot get latest version
  exit /b %errorlevel%
)

set /p download_url=< raw_download_str.tmp
call set download_url=%%download_url:"=%%
echo Downloading: %download_url% ...
%curl% --remote-name --location %download_url%
if %errorlevel% neq 0 ( exit /b %errorlevel% )
echo Done.

for %%i in ("%download_url%") do (
	set latest_filename=%%~ni%%~xi
)

echo Generating %latest_filename% autoinstall.bat
> autoinstall.bat (
	echo "%%~dp0%latest_filename%" /passive
	echo exit /b %%errorlevel%%
)

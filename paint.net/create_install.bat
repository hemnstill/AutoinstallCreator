@pushd "%~dp0"
@call ../.src/env_tools.bat

set base_url=https://www.dotpdn.com/downloads
>raw_download_str.tmp (
  %curl% %base_url%/pdn.html | %grep% --only-matching """[^ ]*install.zip"""
)
if %errorlevel% neq 0 (
  echo Cannot get latest version
  exit /b %errorlevel%
)

set /p download_url=< raw_download_str.tmp
call set download_url=%%download_url:"=%%
set download_url=%base_url%/%download_url%
echo Downloading: %download_url% ...
%curl% --remote-name --location %download_url%
if %errorlevel% neq 0 ( exit /b %errorlevel% )
echo Done.

for %%i in ("%download_url%") do (
	set latest_filename=%%~ni%%~xi
)
%p7z% e %latest_filename% -aoa

for %%i in ("%download_url%") do (
	set latest_filename=%%~ni.exe
)
echo Generating %latest_filename% autoinstall.bat
echo "%%~dp0%latest_filename%" /auto > autoinstall.bat

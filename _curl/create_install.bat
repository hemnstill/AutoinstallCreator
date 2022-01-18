@pushd "%~dp0"
@call ..\.src\env_tools.bat

set busybox=..\_busybox\busybox64.exe
if not exist %busybox% (
  call ..\.tests\test-run.bat _busybox create
  if %errorlevel% neq 0 ( exit /b %errorlevel% )
  pushd "%~dp0"
)

set for_linux=%1

set search_pattern=--only-matching "dl[^ ]*win64-mingw\.zip" ^| find "" /V
set latest_version=https://curl.se/windows/
if not "%for_linux%" == "" (
  set search_pattern="""browser_download_url""" ^| %grep% --only-matching "[^"" ]*curl-amd64"
  set latest_version=https://api.github.com/repos/moparisthebest/static-curl/releases/latest
)

>raw_download_str.tmp (
  %curl% %latest_version% | %grep% %search_pattern%
)
if %errorlevel% neq 0 (
  echo Cannot get latest version
  exit /b %errorlevel%
)

set /p download_url=< raw_download_str.tmp
if "%for_linux%" == "" (
  set download_url=%latest_version%%download_url%
)

echo Downloading: %download_url% ...
%curl% --remote-name --location %download_url%
if %errorlevel% neq 0 ( exit /b %errorlevel% )
echo Done.

for %%i in ("%download_url%") do (
  set latest_filename=%%~ni%%~xi
)

set extract_command="%p7z%" e "%latest_filename%" "-o.." *.exe *.crt -aoa -r
if not "%for_linux%" == "" (
  set extract_command=%busybox% cp -v %latest_filename% ..
)

echo Generating %latest_filename% autoinstall.bat
>autoinstall.bat (
  echo pushd "%%~dp0"
  echo %extract_command%
  echo exit /b %%errorlevel%%
)

echo Done.
exit /b %errorlevel%

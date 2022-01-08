@pushd "%~dp0"
@call ..\.src\env_tools.bat

set busybox=..\_busybox\busybox64.exe
if not exist %busybox% (
	call ..\.tests\test-run.bat _busybox create
	if %errorlevel% neq 0 ( exit /b %errorlevel% )
	pushd "%~dp0"
)

set latest_version=https://api.github.com/repos/libarchive/libarchive/releases/latest
echo Get latest version: %latest_version% ...
>raw_download_str.tmp (
    %curl% %latest_version% | %grep% """browser_download_url""" | %grep% -P --only-matching "(?<=""browser_download_url"":\s"")[^,]+win64\.zip(?="")"
)
if %errorlevel% neq 0 (
  echo Cannot get latest version
  exit /b %errorlevel%
)

set /p download_url= < raw_download_str.tmp
echo Downloading: %download_url% ...
%curl% --remote-name --location %download_url%
if %errorlevel% neq 0 (
  echo Cannot download latest version
  exit /b %errorlevel%
)

for %%i in ("%download_url%") do (
	set latest_filename=%%~ni%%~xi
)

%busybox% unzip %latest_filename% -j -o -d ./.tmp
%busybox% cp -v .tmp/bsdtar.exe .

echo Done.

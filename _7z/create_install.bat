@pushd "%~dp0"
@call "%~dp0..\.tools\env_tools.bat"

set bsdtar=..\_bsdtar\bsdtar.exe
if not exist %bsdtar% (
  %busybox% bash ..\_bsdtar\create_install.sh || exit /b %errorlevel%
)

set for_linux=%1

set search_pattern=x64\.exe
if not "%for_linux%" == "" (
  set search_pattern=linux-x64\.tar\.xz
)

set latest_version=https://www.7-zip.org/download.html
>raw_download_str.tmp (
  %curl% %latest_version% | %grep% --only-matching "[^ ]*%search_pattern%" | %head% -n1
)
if %errorlevel% neq 0 (
  echo Cannot get latest version
  exit /b %errorlevel%
)

set /p download_url=< raw_download_str.tmp
set download_url=https://www.7-zip.org/%download_url:~6%
echo Downloading: %download_url% ...
%curl% --remote-name --location %download_url%
if %errorlevel% neq 0 ( exit /b %errorlevel% )

for %%i in ("%download_url%") do (
  set latest_filename=%%~ni%%~xi
)

set extract_command="%p7z%" e "%latest_filename%" "-o.tmp" 7z.exe 7z.dll -aoa -r
if not "%for_linux%" == "" (
  set extract_command="..\_bsdtar\bsdtar.exe" -xf "%latest_filename%" -C .tmp 7zzs
)

%busybox% rm -f .tmp/*
%busybox% mkdir -p .tmp
%extract_command%

echo Done.

exit /b %errorlevel%

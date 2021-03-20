@echo off
pushd "%~dp0"
set curl=..\curl --fail
set grep=..\grep
set p7z=..\7z.exe
set p7za=7za.exe

set bsdtar=..\_bsdtar\bsdtar.exe
if not exist %bsdtar% (
	call ..\.tests\test-run.bat _bsdtar create
	if %errorlevel% neq 0 ( exit /b %errorlevel% )
	pushd "%~dp0"
)

set latest_version=https://www.7-zip.org/download.html
>raw_download_str.tmp (
  %curl% %latest_version% | %grep% --only-matching "[^ ]*x64.exe"
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
echo Done.

for %%i in ("%download_url%") do (
	set p7z_sfx_latest_filename=%%~ni%%~xi
)

set latest_version=https://www.7-zip.org/download.html
>raw_download_str.tmp (
  %curl% %latest_version% | %grep% --only-matching "[^ ]*extra.7z"
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
echo Done.

for %%i in ("%download_url%") do (
	set latest_filename=%%~ni%%~xi
)

"%bsdtar%" --strip-components=1 -xf %latest_filename% x64
if %errorlevel% neq 0 ( exit /b %errorlevel% )

echo Generating %latest_filename% autoinstall.bat
>autoinstall.bat (
  echo pushd "%%~dp0"
  echo "%p7za%" e "%p7z_sfx_latest_filename%" "-o.." 7z.exe 7z.dll -aoa -r
  echo exit /b %%errorlevel%%
)

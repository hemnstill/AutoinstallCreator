@pushd "%~dp0"
@call ..\.src\env_tools.bat

set p7za=7za.exe
if not exist %p7za% (
	call _7za.bat
	if %errorlevel% neq 0 ( exit /b %errorlevel% )
	pushd "%~dp0"
)

set for_linux=%1

set search_pattern=x64\.exe
if not "%for_linux%" == "" (
  set search_pattern=linux-x64\.tar\.xz
)

set latest_version=https://www.7-zip.org/download.html
>raw_download_str.tmp (
  %curl% %latest_version% | %grep% --only-matching "[^ ]*%search_pattern%"
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

set extract_command="%p7za%" e "%latest_filename%" "-o.." 7z.exe 7z.dll -aoa -r
if not "%for_linux%" == "" (
  set extract_command="..\_bsdtar\bsdtar.exe" -xf "%latest_filename%" -C .. 7zzs
)

echo Generating %latest_filename% autoinstall.bat
>autoinstall.bat (
  echo pushd "%%~dp0"
  echo %extract_command%
  echo exit /b %%errorlevel%%
)

echo Done.

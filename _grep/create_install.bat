@pushd "%~dp0"
@call ..\.src\env_tools.bat

set busybox=..\_busybox\busybox64.exe
if not exist %busybox% (
  call ..\.tests\test-run.bat _busybox create
  if %errorlevel% neq 0 ( exit /b %errorlevel% )
  pushd "%~dp0"
)

set base_url=https://github.com/git-for-windows/git-sdk-64/raw/main/usr/bin
%curl% --location %base_url%/msys-2.0.dll --remote-name
%curl% --location %base_url%/msys-iconv-2.dll --remote-name
%curl% --location %base_url%/msys-intl-8.dll --remote-name
%curl% --location %base_url%/msys-pcre-1.dll --remote-name
%curl% --location %base_url%/grep.exe --remote-name

if %errorlevel% neq 0 (
  echo Cannot get latest version
  exit /b %errorlevel%
)

echo Generating %latest_filename% autoinstall.bat
>autoinstall.bat (
  echo pushd "%%~dp0"
  echo "%busybox%" cp -v msys-*.dll ../
  echo "%busybox%" cp -v grep.exe ../
  echo exit /b %%errorlevel%%
)

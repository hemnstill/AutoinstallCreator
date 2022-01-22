@pushd "%~dp0"
@call ..\.src\env_tools.bat

set base_url=https://github.com/git-for-windows/git-sdk-64/raw/main/usr/bin
%curl% --location %base_url%/msys-2.0.dll --remote-name
%curl% --location %base_url%/msys-iconv-2.dll --remote-name
%curl% --location %base_url%/msys-intl-8.dll --remote-name
%curl% --location %base_url%/msys-pcre-1.dll --remote-name
%curl% --location %base_url%/tar.exe --remote-name

if %errorlevel% neq 0 (
  echo Cannot get latest version
  exit /b %errorlevel%
)

exit /b %errorlevel%

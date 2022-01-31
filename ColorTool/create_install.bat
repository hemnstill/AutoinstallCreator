@pushd "%~dp0"
@call "%~dp0..\.tools\env_tools.bat"

set download_url="https://github.com/microsoft/terminal/releases/download/1904.29002/ColorTool.zip"
echo Downloading: %download_url% ...
%curl% --remote-name --location %download_url%
if %errorlevel% neq 0 (
  echo Cannot download latest version
  exit /b %errorlevel%
)

for %%i in (%download_url%) do (
  set latest_filename=%%~ni%%~xi
)

"%p7z%" e "%latest_filename%" "-o." ColorTool.exe -aoa -r
if %errorlevel% neq 0 (
  echo Cannot extract from "%latest_filename%"
  exit /b %errorlevel%
)

echo Done.
exit /b %errorlevel%

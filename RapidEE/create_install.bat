@pushd "%~dp0"
@call ..\.src\env_tools.bat

set download_url="https://www.rapidee.com/download/RapidEE_setup.exe"
echo Downloading: %download_url% ...
%curl% --location %download_url% --remote-name
if %errorlevel% neq 0 ( exit /b %errorlevel% )
echo Done.

for %%i in (%download_url%) do (
  set latest_filename=%%~ni%%~xi
)

echo Generating %latest_filename% autoinstall.bat
echo "%%~dp0%latest_filename%" /SILENT > "%~dp0autoinstall.bat"

exit /b %errorlevel%

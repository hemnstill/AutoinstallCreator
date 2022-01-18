@pushd "%~dp0"
@call ..\.src\env_tools.bat

set latest_filename=SlackSetup.msi
set download_url="https://slack.com/ssb/download-win64-msi-legacy"
echo Downloading: %latest_filename% %download_url% ...
%curl% --location %download_url% --output %latest_filename%
if %errorlevel% neq 0 ( exit /b %errorlevel% )
echo Done.

echo Generating %latest_filename% autoinstall.bat
echo "%%~dp0%latest_filename%" /S > autoinstall.bat

exit /b %errorlevel%

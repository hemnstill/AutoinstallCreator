@pushd "%~dp0"
@call "%~dp0..\.tools\env_tools.bat"

set latest_filename=DiscordSetup.exe
set download_url="https://discord.com/api/download?platform=win"
echo Downloading: %latest_filename% %download_url% ...
%curl% --location %download_url% --output %latest_filename%
if %errorlevel% neq 0 ( exit /b %errorlevel% )
echo Done.

echo Generating %latest_filename% autoinstall.bat
echo "%%~dp0%latest_filename%" > autoinstall.bat

exit /b %errorlevel%

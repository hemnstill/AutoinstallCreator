@pushd "%~dp0"
@call "%~dp0..\.tools\env_tools.bat"

set latest_filename=telegramsetup.exe
set download_url="https://telegram.org/dl/desktop/win"
echo Downloading: %download_url% ...
%curl% --location %download_url% --output %latest_filename%
if %errorlevel% neq 0 ( exit /b %errorlevel% )
echo Done.

echo Generating %latest_filename% autoinstall.bat
echo "%%~dp0%latest_filename%" /VERYSILENT > autoinstall.bat

exit /b %errorlevel%

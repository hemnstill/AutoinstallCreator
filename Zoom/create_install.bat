@pushd "%~dp0"
@call ..\.src\env_tools.bat

set download_url="https://zoom.us/client/latest/ZoomInstaller.exe"
echo Downloading: %latest_filename% %download_url% ...
%curl% --location %download_url% --remote-name
if %errorlevel% neq 0 ( exit /b %errorlevel% )
echo Done.

for %%i in (%download_url%) do (
	set latest_filename=%%~ni%%~xi
)
echo Generating %latest_filename% autoinstall.bat
echo "%%~dp0%latest_filename%" /passive > "%~dp0autoinstall.bat"

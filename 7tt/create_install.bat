@pushd "%~dp0"
@call ..\.src\env_tools.bat

set download_url="https://rammichael.com/downloads/7tt_setup.exe"
echo Downloading: %download_url% ...
%curl% --remote-name --location %download_url%
if %errorlevel% neq 0 ( exit /b %errorlevel% )
echo Done.

for %%i in (%download_url%) do (
	set latest_filename=%%~ni%%~xi
)
echo Generating %latest_filename% autoinstall.bat
echo "%%~dp0%latest_filename%" /S > "%~dp0autoinstall.bat"

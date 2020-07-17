@echo off
set latest_filename=X-MouseButtonControlSetup.exe
set downloadurl=https://www.highrez.co.uk/scripts/download.asp?package=XMouse
echo Downloading: %latest_filename% %downloadurl% ...
"%~dp0..\curl" --fail --location %downloadurl% --output "%~dp0%latest_filename%"
IF %ERRORLEVEL% NEQ 0 ( 
	exit
) 
echo Done.

echo Generating %latest_filename% autoinstall.bat
echo "%%~dp0%latest_filename%" /S > "%~dp0autoinstall.bat"
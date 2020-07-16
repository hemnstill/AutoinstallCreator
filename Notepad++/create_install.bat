@echo off
cd /d "%~dp0"
set latest_version=https://api.github.com/repos/notepad-plus-plus/notepad-plus-plus/releases/latest
echo Get latest version: %latest_version% ...
>raw_download_str.tmp (
	..\curl -s %latest_version% | findstr /c:"browser_download_url" | findstr /c:".x64.exe\""
)
IF %ERRORLEVEL% NEQ 0 ( 
	echo Cannot get latest version 
	exit
) 

set /p downloadurl= < raw_download_str.tmp
call set downloadurl=%%downloadurl:"browser_download_url":=%%
call set downloadurl=%%downloadurl:"=%%
echo Downloading: %downloadurl% ...
..\curl --fail --remote-name --location %downloadurl%
IF %ERRORLEVEL% NEQ 0 ( 
	exit
) 
echo Done.
FOR %%i IN ("%downloadurl%") DO (
	set latest_filename=%%~ni%%~xi
)
echo Generating %latest_filename% autoinstall.bat
echo %%~dp0%latest_filename% /S > autoinstall.bat
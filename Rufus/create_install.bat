@echo off
pushd "%~dp0"
set LC_ALL=en_US.UTF-8
set curl=..\curl --fail
set grep=..\grep

set latest_version=https://api.github.com/repos/pbatard/rufus/releases/latest
echo Get latest version: %latest_version% ...
>raw_download_str.tmp (
	%curl% %latest_version% | %grep% """browser_download_url""" | %grep% -P --only-matching "(?<="")[^\s]*rufus-[\d\.]*exe(?="")"
)
IF %ERRORLEVEL% NEQ 0 ( 
	echo Cannot get latest version 
	exit /b %ERRORLEVEL%
)

set /p downloadurl= < raw_download_str.tmp
echo Downloading: %downloadurl% ...
%curl% --remote-name --location %downloadurl%
IF %ERRORLEVEL% NEQ 0 ( exit /b %ERRORLEVEL% ) 
echo Done.
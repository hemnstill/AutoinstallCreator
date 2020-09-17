@echo off
pushd "%~dp0"
set curl=..\curl --fail
set grep=..\grep

set latest_version=https://www.iis.net/downloads/microsoft/url-rewrite
>raw_download_str.tmp (
  %curl% %latest_version% | %grep% --only-matching """[^ ]*amd64_en-US.msi"""
)
IF %ERRORLEVEL% NEQ 0 ( 
  echo Cannot get latest version 
  exit /b %ERRORLEVEL%
) 

set /p downloadurl=< raw_download_str.tmp
call set downloadurl=%%downloadurl:"=%%
echo Downloading: %downloadurl% ...
%curl% --remote-name --location %downloadurl%
IF %ERRORLEVEL% NEQ 0 ( exit /b %ERRORLEVEL% ) 
echo Done.

FOR %%i IN ("%downloadurl%") DO (
	set latest_filename=%%~ni%%~xi
)

echo Generating %latest_filename% autoinstall.bat
> autoinstall.bat (
	echo "%%~dp0%latest_filename%" /passive
	echo exit /b %%errorlevel%%
)
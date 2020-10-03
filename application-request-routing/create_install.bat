@echo off
pushd "%~dp0"
set LC_ALL=en_US.UTF-8
set curl=..\curl --fail
set grep=..\grep

set latest_version=https://www.iis.net/downloads/microsoft/application-request-routing
>raw_download_str.tmp (
  %curl% %latest_version% | %grep% -Po "(?<=<a\shref="")[^\s]*(?="">x64)
)
if %errorlevel% neq 0 ( 
  echo Cannot get latest version 
  exit /b %errorlevel%
) 

set /p download_url=< raw_download_str.tmp
set latest_filename=requestRouter_amd64.msi
echo Downloading: %download_url% ...
%curl% --location "%download_url%" --output %latest_filename%
if %errorlevel% neq 0 ( exit /b %errorlevel% ) 
echo Done.

echo Generating %latest_filename% autoinstall.bat
> autoinstall.bat (
	echo "%%~dp0%latest_filename%" /passive
	echo exit /b %%errorlevel%%
)
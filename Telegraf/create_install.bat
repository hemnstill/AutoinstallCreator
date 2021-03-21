@echo off
pushd "%~dp0"
set curl=..\curl --fail

set latest_version=https://api.github.com/repos/influxdata/telegraf/releases/latest
echo Get latest version: %latest_version% ...
>raw_download_str.tmp (
	%curl% %latest_version% | findstr /r /c:"\"tag_name\":"
)
if %errorlevel% neq 0 (
	echo Cannot get latest version
	exit /b %errorlevel%
)

set /p telegraf_version= < raw_download_str.tmp
call set telegraf_version=%%telegraf_version:  "tag_name": "v=%%
call set telegraf_version=%%telegraf_version:"=%%
call set telegraf_version=%%telegraf_version:,=%%

set download_url="https://dl.influxdata.com/telegraf/releases/telegraf-%telegraf_version%_windows_amd64.zip"
echo Downloading: %download_url% ...
%curl% --location %download_url% --remote-name
if %errorlevel% neq 0 ( exit /b %errorlevel% )
echo Done.

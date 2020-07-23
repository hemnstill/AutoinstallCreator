@echo off
pushd "%~dp0"
set latest_version=https://api.github.com/repos/influxdata/telegraf/releases/latest
echo Get latest version: %latest_version% ...
>raw_download_str.tmp (
	..\curl -s %latest_version% | findstr /r /c:"\"tag_name\":"
)
IF %ERRORLEVEL% NEQ 0 ( 
	echo Cannot get latest version 
	exit
) 

set /p telegraf_version= < raw_download_str.tmp
call set telegraf_version=%%telegraf_version:  "tag_name": "v=%%
call set telegraf_version=%%telegraf_version:"=%%
call set telegraf_version=%%telegraf_version:,=%%

set downloadurl=https://dl.influxdata.com/telegraf/releases/telegraf-%telegraf_version%_windows_amd64.zip
echo Downloading: %downloadurl% ...
..\curl --fail --location %downloadurl% -O
IF %ERRORLEVEL% NEQ 0 ( 
	exit
) 
echo Done.
FOR %%i IN ("%downloadurl%") DO (
	set latest_filename=%%~ni%%~xi
)
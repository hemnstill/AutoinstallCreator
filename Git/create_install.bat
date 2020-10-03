@echo off
pushd "%~dp0"
set curl=..\curl --fail

set latest_version=https://api.github.com/repos/git-for-windows/git/releases/latest
echo Get latest version: %latest_version% ...
>raw_download_str.tmp (
	%curl% %latest_version% | findstr /r /c:"browser_download_url.*64-bit.exe\""
)
if %errorlevel% neq 0 ( 
	echo Cannot get latest version 
	exit /b %errorlevel%
) 

set /p download_url= < raw_download_str.tmp
call set download_url=%%download_url:"browser_download_url":=%%
call set download_url=%%download_url:"=%%
echo Downloading: %download_url% ...
%curl% --remote-name --location %download_url%
if %errorlevel% neq 0 ( exit /b %errorlevel% ) 
echo Done.

for %%i in ("%download_url%") do ( 
    set git_latest_filename=%%~ni%%~xi
)

set latest_version=https://api.github.com/repos/microsoft/Git-Credential-Manager-for-Windows/releases/latest
echo Get latest version: %latest_version% ...
>raw_download_str.tmp (
	%curl% %latest_version% | findstr /r /c:"browser_download_url.*.exe\""
)
if %errorlevel% neq 0 ( 
	echo Cannot get latest version 
	exit /b %errorlevel%
) 

set /p download_url= < raw_download_str.tmp
call set download_url=%%download_url:"browser_download_url":=%%
call set download_url=%%download_url:"=%%
echo Downloading: %download_url% ...
%curl% --remote-name --location %download_url%
if %errorlevel% neq 0 ( exit /b %errorlevel% ) 
echo Done.

for %%i in ("%download_url%") do ( 
    set gcmw_latest_filename=%%~ni%%~xi
)

echo Generating autoinstall.bat
> autoinstall.bat (
  echo "%%~dp0%git_latest_filename%" /SILENT /NORESTART /CLOSEAPPLICATIONS /LOADINF="%%~dp0git.ini"
  echo "%%~dp0%gcmw_latest_filename%" /SILENT /NORESTART /CLOSEAPPLICATIONS
)
  
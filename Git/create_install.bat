@echo off
pushd "%~dp0"
set latest_version=https://api.github.com/repos/git-for-windows/git/releases/latest
echo Get latest version: %latest_version% ...
>raw_download_str.tmp (
	..\curl -s %latest_version% | findstr /r /c:"browser_download_url.*64-bit.exe\""
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
    set git_latest_filename=%%~ni%%~xi 
)


set latest_version=https://api.github.com/repos/microsoft/Git-Credential-Manager-for-Windows/releases/latest
echo Get latest version: %latest_version% ...
>raw_download_str.tmp (
	..\curl -s %latest_version% | findstr /r /c:"browser_download_url.*.exe\""
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
    set gcmw_latest_filename=%%~ni%%~xi 
)

echo Generating autoinstall.bat
> autoinstall.bat (
  echo "%%~dp0%git_latest_filename%" /SILENT /NORESTART /CLOSEAPPLICATIONS /LOADINF="%%~dp0git.ini"
  echo "%%~dp0%gcmw_latest_filename%" /SILENT /NORESTART /CLOSEAPPLICATIONS
)
  
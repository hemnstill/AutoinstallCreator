@echo off
pushd "%~dp0"
set curl=..\curl --fail
set p7z=..\7z.exe
set grep=..\grep

set latest_version=https://api.github.com/repos/rclone/rclone/releases/latest
echo Get latest version: %latest_version% ...
>raw_download_str.tmp (
	%curl% %latest_version% | %grep% """browser_download_url""" | %grep% --only-matching "[^"" ]*windows-amd64\.zip"
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

FOR %%i IN ("%downloadurl%") DO (
  set latest_filename=%%~ni%%~xi
)

echo Generating %latest_filename% autoinstall.bat
>autoinstall.bat (
  echo pushd "%%~dp0"
  echo "%p7z%" e "%latest_filename%" "-o." rclone.exe -aoa -r
  echo exit /b %%errorlevel%%
)
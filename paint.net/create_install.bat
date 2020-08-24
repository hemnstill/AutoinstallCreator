@echo off
pushd "%~dp0"
set curl=..\curl --fail
set grep=..\grep
set p7z=..\7z

set base_url=https://www.dotpdn.com/downloads
>raw_download_str.tmp (
  %curl% %base_url%/pdn.html | %grep% --only-matching """[^ ]*install.zip"""
)
IF %ERRORLEVEL% NEQ 0 ( 
  echo Cannot get latest version 
  exit /b %ERRORLEVEL%
) 

set /p downloadurl=< raw_download_str.tmp
call set downloadurl=%%downloadurl:"=%%
set downloadurl=%base_url%/%downloadurl%
echo Downloading: %downloadurl% ...
%curl% --remote-name --location %downloadurl%
IF %ERRORLEVEL% NEQ 0 ( exit /b %ERRORLEVEL% ) 
echo Done.

FOR %%i IN ("%downloadurl%") DO (
	set latest_filename=%%~ni%%~xi
)
%p7z% e %latest_filename% -aoa

FOR %%i IN ("%downloadurl%") DO (
	set latest_filename=%%~ni.exe
)
echo Generating %latest_filename% autoinstall.bat
echo "%%~dp0%latest_filename%" /auto > autoinstall.bat
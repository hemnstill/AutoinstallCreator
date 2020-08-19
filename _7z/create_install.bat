@echo off
pushd "%~dp0"
set p7z=..\7z.exe
set cp=..\cp.exe

set latest_version=https://www.7-zip.org/download.html
>raw_download_str.tmp (
  ..\curl -s %latest_version% | ..\grep --only-matching "[^ ]*x64.exe"
)
IF %ERRORLEVEL% NEQ 0 ( 
  echo Cannot get latest version 
  exit
) 

set /p downloadurl=< raw_download_str.tmp
set downloadurl=https://www.7-zip.org/%downloadurl:~6%
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
>autoinstall.bat (
  echo "%%~dp0%p7z%" e "%latest_filename%" "-o%%~dp0" 7z.exe 7z.dll -aoa -r
  echo "%%~dp0%cp%" -v 7z.* ../
)
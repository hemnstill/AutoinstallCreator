@echo off
pushd "%~dp0"
set curl=..\curl --fail
set grep=..\grep
set p7z=..\7z.exe
set cp=..\cp.exe

set latest_version=https://www.7-zip.org/download.html
>raw_download_str.tmp (
  %curl% %latest_version% | %grep% --only-matching "[^ ]*x64.exe"
)
if %errorlevel% neq 0 ( 
  echo Cannot get latest version 
  exit /b %errorlevel%
) 

set /p download_url=< raw_download_str.tmp
set download_url=https://www.7-zip.org/%download_url:~6%
echo Downloading: %download_url% ...
%curl% --remote-name --location %download_url%
if %errorlevel% neq 0 ( exit /b %errorlevel% ) 
echo Done.

for %%i in ("%download_url%") do (
	set latest_filename=%%~ni%%~xi
)
echo Generating %latest_filename% autoinstall.bat
>autoinstall.bat (
  echo pushd "%%~dp0"
  echo "%p7z%" e "%latest_filename%" "-o." 7z.exe 7z.dll -aoa -r
  echo "%cp%" -v 7z.* ../
  echo exit /b %%errorlevel%%
)
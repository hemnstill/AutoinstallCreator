@echo off
pushd "%~dp0"
set curl=..\curl --fail
set cp=..\cp.exe

set base_url=https://github.com/git-for-windows/git-sdk-64/raw/main/usr/bin
%curl% --location %base_url%/msys-2.0.dll --remote-name
%curl% --location %base_url%/msys-iconv-2.dll --remote-name
%curl% --location %base_url%/msys-intl-8.dll --remote-name
%curl% --location %base_url%/msys-pcre-1.dll --remote-name
%curl% --location %base_url%/grep.exe --remote-name

IF %ERRORLEVEL% NEQ 0 ( 
  echo Cannot get latest version 
  exit /b %ERRORLEVEL%
) 

echo Generating %latest_filename% autoinstall.bat
>autoinstall.bat (
  echo pushd "%%~dp0"
  echo "%cp%" -v msys-*.dll ../
  echo "%cp%" -v grep.exe ../
  echo exit /b %%errorlevel%%
)

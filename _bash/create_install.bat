@echo off
pushd "%~dp0"
set curl=..\curl --fail

if not exist tmp mkdir tmp\
type NUL > tmp\.empty
if not exist mingw64\bin\ mkdir mingw64\bin\
type NUL > mingw64\bin\.empty
if not exist bin\ mkdir bin\
if not exist usr\bin\ mkdir usr\bin\
IF %ERRORLEVEL% NEQ 0 ( exit /b %ERRORLEVEL% ) 

set base_url=https://github.com/git-for-windows/git-sdk-64/raw/main/usr/bin
%curl% --location %base_url%/msys-2.0.dll --output usr\bin\msys-2.0.dll
%curl% --location %base_url%/msys-iconv-2.dll  --output usr\bin\msys-iconv-2.dll
%curl% --location %base_url%/msys-intl-8.dll --output usr\bin\msys-intl-8.dll
%curl% --location %base_url%/uname.exe --output usr\bin\uname.exe
%curl% --location %base_url%/ls.exe --output usr\bin\ls.exe
%curl% --location %base_url%/dirname.exe --output usr\bin\dirname.exe
%curl% --location %base_url%/chmod.exe --output usr\bin\chmod.exe
%curl% --location %base_url%/head.exe --output usr\bin\head.exe
%curl% --location %base_url%/basename.exe --output usr\bin\basename.exe
%curl% --location %base_url%/sort.exe --output usr\bin\sort.exe

%curl% --location %base_url%/bash.exe --output usr\bin\bash.exe
%curl% --location %base_url%/../../mingw64/share/git/compat-bash.exe --output bin\bash.exe

exit /b %ERRORLEVEL%

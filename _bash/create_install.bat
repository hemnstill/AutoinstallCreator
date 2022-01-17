@pushd "%~dp0"
@call ..\.src\env_tools.bat

set busybox=..\_busybox\busybox64.exe
if not exist %busybox% (
  call ..\.tests\test-run.bat _busybox create
  if %errorlevel% neq 0 ( exit /b %errorlevel% )
  pushd "%~dp0"
)

if not exist tmp mkdir tmp\
type NUL > tmp\.empty
if not exist mingw64\bin\ mkdir mingw64\bin\
type NUL > mingw64\bin\.empty
if not exist bin\ mkdir bin\
if not exist usr\bin\ mkdir usr\bin\
if %errorlevel% neq 0 ( exit /b %errorlevel% )

set base_url=https://github.com/git-for-windows/git-sdk-64/raw/main/usr/bin
%busybox% cp -v ..\msys-*.dll usr\bin\
%curl% --location %base_url%/uname.exe --output usr\bin\uname.exe
%curl% --location %base_url%/ls.exe --output usr\bin\ls.exe
%curl% --location %base_url%/dirname.exe --output usr\bin\dirname.exe
%curl% --location %base_url%/chmod.exe --output usr\bin\chmod.exe
%curl% --location %base_url%/head.exe --output usr\bin\head.exe
%curl% --location %base_url%/basename.exe --output usr\bin\basename.exe
%curl% --location %base_url%/sort.exe --output usr\bin\sort.exe
%curl% --location %base_url%/cat.exe --output usr\bin\cat.exe
%curl% --location %base_url%/tar.exe --output usr\bin\tar.exe
%curl% --location %base_url%/rm.exe --output usr\bin\rm.exe

%curl% --location %base_url%/bash.exe --output usr\bin\bash.exe
%curl% --location %base_url%/../../mingw64/share/git/compat-bash.exe --output bin\bash.exe

exit /b %errorlevel%

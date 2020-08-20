@echo off
pushd "%~dp0"
set curl=..\curl --fail
set p7z=..\7z

set latest_filename_bin=coreutils-bin-zip.php
set latest_filename_dep=coreutils-dep-zip.php

set downloadurl_bin=http://gnuwin32.sourceforge.net/downlinks/%latest_filename_bin%
set downloadurl_dep=http://gnuwin32.sourceforge.net/downlinks/%latest_filename_dep%
%curl% -L %downloadurl_bin% --remote-name
IF %ERRORLEVEL% NEQ 0 ( 
  echo Cannot get latest version 
  exit
) 
%curl% -L %downloadurl_dep% --remote-name
IF %ERRORLEVEL% NEQ 0 ( 
  echo Cannot get latest version 
  exit
) 
echo Done.

echo Generating %latest_filename_bin% autoinstall.bat
>autoinstall.bat (
  echo "%%~dp0%p7z%" e "%latest_filename_bin%" "-o%%~dp0.." cp.exe -aoa -r
  echo "%%~dp0%p7z%" e "%latest_filename_dep%" "-o%%~dp0.." *.dll -aoa -r
)
echo Done.
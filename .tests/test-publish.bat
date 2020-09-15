@echo off
pushd "%~dp0"
set rclone=..\rclone\rclone.exe
if not exist %rclone% (
	call test-run.bat rclone checkinstall
	IF %ERRORLEVEL% NEQ 0 ( exit /b %ERRORLEVEL% )
	pushd "%~dp0"
)
set sort=..\_bash\usr\bin\sort.exe
if not exist %sort% (
	call test-run.bat _bash create
	IF %ERRORLEVEL% NEQ 0 ( exit /b %ERRORLEVEL% )
	pushd "%~dp0"
)

set grep=..\grep

set access_token=%~1
set refresh_token=%~2
set branch=%~3
if "%branch%"=="" (
  echo branch does not set
  set errorlevel=1
  exit /b %errorlevel%
)

set version=%~4
if "%version%"=="" (
  set version=1.0.0
)

set root_dir=%~5
if "%root_dir%"=="" (
  set root_dir=builds
)

set storage_provider=google-drive
set rclone_config_name=rclone.conf.tmp
>%rclone_config_name% (
  echo [%storage_provider%]
  echo type = drive
  echo token = {"access_token":"%access_token%", "refresh_token":"%refresh_token%"}
)

echo publish to %version%_%branch% ...
%rclone% --verbose --stats-one-line purge %storage_provider%:%root_dir%/%version%_%branch%/ --config %rclone_config_name%
%rclone% --verbose --stats-one-line --exclude-from .rclone-exclude  copy ../ %storage_provider%:%root_dir%/%version%_%branch%/ --config %rclone_config_name%
IF %ERRORLEVEL% NEQ 0 ( exit /b %ERRORLEVEL% ) 

echo copy %version%_%branch% to latest_%branch% ...
%rclone% --verbose --stats-one-line delete --rmdirs %storage_provider%:%root_dir%/latest_%branch%/ --config %rclone_config_name%
%rclone% --verbose --stats-one-line copy %storage_provider%:%root_dir%/%version%_%branch%/ %storage_provider%:%root_dir%/latest_%branch%/ --config %rclone_config_name%
IF %ERRORLEVEL% NEQ 0 ( exit /b %ERRORLEVEL% ) 

set obsolete_dirs=obsolete_dirs.tmp
>%obsolete_dirs% (
	%rclone% --verbose lsf %storage_provider%:%root_dir%/ --config %rclone_config_name% | %grep% "1\.0\." | %sort% --version-sort --reverse | more +6
)
for /f "tokens=*" %%a in (%obsolete_dirs%) do (
  if not "%%a"=="" (
	echo purge obsolete version: %%a
	%rclone% --verbose --stats-one-line purge %storage_provider%:%root_dir%/%%a --config %rclone_config_name%
  )
)

echo cleanup
%rclone% cleanup %storage_provider%: --config %rclone_config_name%

exit /b %errorlevel%
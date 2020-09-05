@echo off
pushd "%~dp0"
set rclone=..\rclone\rclone.exe
if not exist %rclone% (
	call test-run.bat rclone checkinstall
	IF %ERRORLEVEL% NEQ 0 ( exit /b %ERRORLEVEL% )
	pushd "%~dp0"
)

set access_token=%~1
set refresh_token=%~2
set branch=%~3
set version=%~4

if "%branch%"=="" (
  echo branch does not set
  set errorlevel=1
  exit /b %errorlevel%
)

>rclone.conf.tmp (
  echo [yandex-disk]
  echo type = yandex
  echo token = {"access_token":"%access_token%", "refresh_token":"%refresh_token%"}
)

echo publish to latest_%branch% ...
%rclone% --verbose --stats-one-line delete yandex-disk:builds/latest_%branch%/ --rmdirs --config rclone.conf
%rclone% --verbose --stats-one-line --exclude .*/ --exclude *.tmp --exclude create_install.* copy ../ yandex-disk:builds/latest_%branch%/ --config rclone.conf.tmp

if not "%version%"=="" ( 
  echo publish to %version%_%branch% ...
  %rclone% --verbose --stats-one-line purge yandex-disk:builds/%version%_%branch%/ --config rclone.conf
  %rclone% --verbose --stats-one-line copy yandex-disk:builds/latest_%branch%/ yandex-disk:builds/%version%_%branch%/ --config rclone.conf.tmp
)

exit /b %errorlevel%
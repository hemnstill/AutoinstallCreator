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

>rclone.conf (
  echo [yandex-disk]
  echo type = yandex
  echo token = {"access_token":"%access_token%", "refresh_token":"%refresh_token%"}
)

%rclone% --verbose --stats-one-line delete yandex-disk:current/ --rmdirs --config rclone.conf
%rclone% --verbose --stats-one-line --exclude .*/ --exclude rclone.conf copy ../ yandex-disk:current/ --config rclone.conf

exit /b %errorlevel%
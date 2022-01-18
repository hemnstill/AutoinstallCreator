@pushd "%~dp0"
@call ..\.src\env_tools.bat

set rclone=..\rclone\rclone.exe
if not exist %rclone% (
  call test-run.bat rclone checkinstall
  if %errorlevel% neq 0 ( exit /b %errorlevel% )
  pushd "%~dp0"
)
set sort=..\_bash\usr\bin\sort.exe
if not exist %sort% (
  call test-run.bat _bash create
  if %errorlevel% neq 0 ( exit /b %errorlevel% )
  pushd "%~dp0"
)

set client_id=%~1
set client_secret=%~2
set refresh_token=%~3
set branch=%~4
if "%branch%"=="" (
  echo branch does not set
  set errorlevel=1
  exit /b %errorlevel%
)

set version=%~5
if "%version%"=="" (
  set version=1.0.0
)

set root_dir=%~6
if "%root_dir%"=="" (
  set root_dir=builds
)

set storage_provider=google-drive
set rclone_config_name=rclone.conf.tmp
echo get access_token ...
>%rclone_config_name% ( %curl% --silent --request POST ^
--data "client_id=%client_id%&client_secret=%client_secret%&refresh_token=%refresh_token%&grant_type=refresh_token" ^
https://accounts.google.com/o/oauth2/token | %grep% -Po "(?<=""access_token"":\s"")[^,]+(?="")
)
if %errorlevel% neq 0 ( exit /b %errorlevel% )

echo generate %rclone_config_name% ...
set /p access_token=< %rclone_config_name%
>%rclone_config_name% (
  echo [%storage_provider%]
  echo type = drive
  echo token = {"access_token":"%access_token%"}
)

echo publish to %version%_%branch% ...
%rclone% --verbose --stats-one-line purge %storage_provider%:%root_dir%/%version%_%branch%/ --config %rclone_config_name%
%rclone% --verbose --stats-one-line --exclude-from .rclone-exclude  copy ../ %storage_provider%:%root_dir%/%version%_%branch%/ --config %rclone_config_name%
if %errorlevel% neq 0 ( exit /b %errorlevel% )

echo copy %version%_%branch% to latest_%branch% ...
%rclone% --verbose --stats-one-line delete --rmdirs %storage_provider%:%root_dir%/latest_%branch%/ --config %rclone_config_name%
%rclone% --verbose --stats-one-line copy %storage_provider%:%root_dir%/%version%_%branch%/ %storage_provider%:%root_dir%/latest_%branch%/ --config %rclone_config_name%
if %errorlevel% neq 0 ( exit /b %errorlevel% )

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

@echo off
pushd "%~dp0.."

set errors_count=0
set "why_not= "
set startswith=%1
set action=%2
set "need_check="
set external_args=%3

if "%startswith%" == "!" (
  set why_not=not
  set startswith=%2
  set action=%3
  set external_args=%4
)
if "%startswith%" == "" (
  echo "startswith" does not set. Try: '%~nx0 _' or '%~nx0 ! _'
  echo Include syntax: '%~nx0 ^<startswith^> ^<command^>'
  echo Exclude syntax: '%~nx0 ! ^<startswith^> ^<command^>'
  echo Available commands: create, install, checkinstall, show
)

if not "%action%" == "create" ^
if not "%action%" == "install" ^
if not "%action%" == "checkinstall" ^
if not "%action%" == "show" ^
if not "%action%" == "" (
  echo wrong "action": %action%
  set errorlevel=1
  exit /b %errorlevel%
)

if "%action%" == "checkinstall" (
  set "need_check=y"
)

for /D %%I in ("%~dp0..\*") do (
  set dirname=%%~nxI
  setlocal EnableDelayedExpansion
  set matched_dirname=%startswith%!dirname:%startswith%=!
  if not "!dirname:~0,1!" == "." if %why_not% "!matched_dirname!" == "!dirname!" (
    if exist "%%~fI\create_install.bat" (
      endlocal
      echo ^>^> Test %%~fI
      if "%action%" == "create" (
        call "%%~fI\create_install.bat" %external_args% && call :passed_test || call :failed_test
      ) else if "%action%" == "install" (
        call "%%~fI\autoinstall.bat" && call :passed_test || call :failed_test
      ) else if "%action%" == "checkinstall" (
        call "%%~fI\create_install.bat" %external_args% && call "%%~fI\autoinstall.bat" && call :passed_test || call :failed_test
      )
    ) else ( endlocal )
  ) else ( endlocal )
)

if defined need_check call :git_check

goto :log_errors

:git_check
  pushd "%~dp0"
  git status --porcelain | find "" /V > git_status.txt
  set /p first_char_diff=< git_status.txt
  if not "%first_char_diff%" == "" (
    type git_status.txt
    set /A "errors_count+=1"
  )
  exit /b

:passed_test
  echo ^<^< Passed.
  exit /b

:failed_test
  echo ^<^< Failed.
  set /A "errors_count+=1"
  exit /b

:log_errors
  echo Errors: %errors_count%
  exit /b %errors_count%


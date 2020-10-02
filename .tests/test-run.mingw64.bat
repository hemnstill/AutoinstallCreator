@echo off
set test_run_bat="%~dp0..\.tests\test-run.bat"
set test_run_sh="%~dp0..\.tests\test-run.sh"

set bash="%~dp0..\_bash\bin\bash.exe"
if not exist %bash% (
	call %test_run_bat% _bash create
	IF %ERRORLEVEL% NEQ 0 ( exit /b %ERRORLEVEL% )
)

set grep="%~dp0..\_grep\grep.exe"
if not exist %grep% (
	call %test_run_bat% _grep create
	call %test_run_bat% _grep install
	IF %ERRORLEVEL% NEQ 0 ( exit /b %ERRORLEVEL% )
)

%bash% %test_run_sh% %*
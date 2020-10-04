@echo off
set test_run_bat="%~dp0..\.tests\test-run.bat"
set test_run_sh="%~dp0..\.tests\test-run.sh"

set bash="%~dp0..\_bash\bin\bash.exe"
if not exist %bash% (
	call %test_run_bat% _bash create
	if %errorlevel% neq 0 ( exit /b %errorlevel% )
)

%bash% %test_run_sh% %*
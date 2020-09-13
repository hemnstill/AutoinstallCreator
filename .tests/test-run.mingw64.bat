@echo off
pushd "%~dp0"
set bash=..\_bash\bin\bash.exe
if not exist %bash% (
	call ..\.tests\test-run.bat _bash create
	IF %ERRORLEVEL% NEQ 0 ( exit /b %ERRORLEVEL% )
	pushd "%~dp0"
)

%bash% test-run.sh %*
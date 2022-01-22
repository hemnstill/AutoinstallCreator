@pushd "%~dp0"
@call create_install.bat
if %errorlevel% neq 0 ( exit /b %errorlevel% )
@call create_install.bat 1
if %errorlevel% neq 0 ( exit /b %errorlevel% )

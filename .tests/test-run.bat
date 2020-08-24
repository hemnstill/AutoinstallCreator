@echo off
pushd "%~dp0.."
set errors_count=0

for /D %%I in ("%~dp0..\*") do (
	set dirname=%%~nxI	
	setlocal EnableDelayedExpansion
	if not "!dirname:~0,1!" == "." (
		set entry_point="%%~fI\create_install.bat"
		if exist !entry_point! (			
			for /f "delims=" %%E in (!entry_point!) do (
				endlocal 	
				echo ^>^> Test %%E
				call %%E && call :passed_test || call :failed_test
			)
		) else ( endlocal )
	) else ( endlocal )
)
goto :log_errors

:passed_test
  echo ^<^< Passed.
  exit /b

:failed_test
  echo ^<^< Failed.
  SET /A "errors_count+=1"
  exit /b
  
:log_errors
  echo Errors: %errors_count%
  exit /b %errors_count%
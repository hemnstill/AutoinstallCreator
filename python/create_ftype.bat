@echo off
assoc .py=_python_file
ftype _python_file="%~dp0..\.tools\Scripts\python.exe" "%%1" %%*

exit /b %errorlevel%

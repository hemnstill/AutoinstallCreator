@echo off
assoc .sh=_bash_file
ftype _bash_file="%~dp0bin\bash.exe" "%%1" %%*


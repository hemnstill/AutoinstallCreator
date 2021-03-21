@echo off
assoc .=_no_extension
ftype _no_extension="%ProgramFiles%\Notepad++\notepad++.exe" "%%1" %%*

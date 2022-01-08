@echo off
set curl=..\curl --fail
if not "%CI%" == "" (
  set curl=..\curl --fail --silent --show-error
)
set p7z=..\7z.exe
set LC_ALL=en_US.UTF-8
set grep=..\grep

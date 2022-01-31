@echo off
set test_run_sh="%~dp0..\.tests\test-run.sh"
set bash="%~dp0..\.tools\busybox64.exe" bash

%bash% %test_run_sh% %*

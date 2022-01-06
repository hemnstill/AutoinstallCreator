@echo off
pushd "%~dp0"

set curl=..\curl --fail
set p7z=..\7z.exe
set LC_ALL=en_US.UTF-8
set grep=..\grep

set bsdtar=..\_bsdtar\bsdtar.exe
if not exist %bsdtar% (
	call ..\.tests\test-run.bat _bsdtar create
	if %errorlevel% neq 0 ( exit /b %errorlevel% )
	pushd "%~dp0"
)

set self_base_api=https://api.github.com/repos/hemnstill/AutoinstallCreator
set self_base=https://github.com/hemnstill/AutoinstallCreator

set latest_commits="%self_base_api%/commits?sha=master"
>latest_commits.txt (
  %curl% %latest_commits% | %grep% -Po "(?<=""sha"":\s"")[^,]+(?="")"
)
if %errorlevel% neq 0 (
  echo Cannot get latest_commits
  exit /b %errorlevel%
)

set /p latest_commit=< latest_commits.txt
set latest_commit=%latest_commit%

set download_url="%self_base%/archive/%latest_commit%.tar.gz"
echo Downloading: %download_url% ...
%curl% --output latest_archive.tar.gz --location %download_url%
if %errorlevel% neq 0 (
  echo Cannot download latest version
  exit /b %errorlevel%
)

%bsdtar% -tf latest_archive.tar.gz >latest_files.txt

>autoinstall.bat (
  echo pushd "%%~dp0"
  echo "..\_bsdtar\bsdtar.exe" --strip-components 1 -xf latest_archive.tar.gz -C ..
)

echo Done.

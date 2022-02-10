@pushd "%~dp0"
@call "%~dp0..\.tools\env_tools.bat"

set bsdtar=..\_bsdtar\bsdtar.exe
if not exist %bsdtar% (
  %busybox% bash ..\_bsdtar\create_install.sh || exit /b %errorlevel%
)

set self_base_api=https://api.github.com/repos/hemnstill/AutoinstallCreator
set self_base=https://github.com/hemnstill/AutoinstallCreator

set latest_commits="%self_base_api%/commits?sha=master"
echo get latest_commits %latest_commits% ...
>latest_commits.txt (
  %curl% %latest_commits% | %grep% --only-matching "(?<=""sha"":\s"")[^,]+(?="")" | %head% -n1
)
if %errorlevel% neq 0 (
  echo Cannot get latest_commits
  exit /b %errorlevel%
)

set /p latest_commit=< latest_commits.txt
set download_url="%self_base%/archive/%latest_commit%.tar.gz"
echo Downloading: %download_url% ...
%curl% --output latest_archive.tar.gz --location %download_url%
if %errorlevel% neq 0 (
  echo Cannot download latest version
  exit /b %errorlevel%
)

"%~dp0%bsdtar%" -tf latest_archive.tar.gz >latest_files.txt

echo Generating autoupdate from latest_archive.tar.gz
>autoinstall.bat (
  echo pushd "%%~dp0"
  echo "..\_bsdtar\bsdtar.exe" --strip-components 1 -xf latest_archive.tar.gz -C ..
)

echo Done.
exit /b %errorlevel%

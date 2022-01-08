@pushd "%~dp0"
@call ..\.src\env_tools.bat

set busybox=..\_busybox\busybox64.exe
if not exist %busybox% (
	call ..\.tests\test-run.bat _busybox create
	if %errorlevel% neq 0 ( exit /b %errorlevel% )
	pushd "%~dp0"
)
set aria2c=..\aria2\aria2c.exe
if not exist %aria2c% (
	call ..\.tests\test-run.bat aria2 checkinstall
	if %errorlevel% neq 0 ( exit /b %errorlevel% )
	pushd "%~dp0"
)

set latest_version=https://antizapret.prostovpn.org/proxy.pac
echo Get proxy from %latest_version%
>raw_download_str.tmp (
  %curl% --location %latest_version% | %grep% "return ""PROXY" | %grep% --only-matching "[^ ]*;" | find "" /V
)

if %errorlevel% neq 0 (
  echo Cannot get proxy
  exit /b %errorlevel%
)

set /p proxy_from_vpn= < raw_download_str.tmp
call set proxy_from_vpn=%%proxy_from_vpn:;=%%
set download_url="https://rutracker.org/forum/viewtopic.php?t=5181383"
echo Download topic %download_url% using proxy: %proxy_from_vpn%
>raw_download_str.tmp (
  %curl% %download_url% --proxy %proxy_from_vpn% | %grep% --only-matching """magnet:?xt[^ ]*""" | find "" /V
)

if %errorlevel% neq 0 (
  echo Cannot get proxy
  exit /b %errorlevel%
)

set /p download_url=< raw_download_str.tmp
call set download_url=%%download_url:"=%%
echo Download uTorrent from %download_url%
%aria2c% --allow-overwrite=true --seed-time=0 --dir=.tmp %download_url%

echo Generating %latest_filename% autoinstall.bat

>file_paths_list.tmp (
  dir /s/b .tmp\uTorrent.exe
)
set /p first_file_path=< file_paths_list.tmp
for %%I in (%first_file_path%) do (
	%busybox% cp -v %%~dpI%%~nI.* .
)
if %errorlevel% neq 0 ( exit /b %errorlevel% )

>autoinstall.bat (
    echo pushd "%%~dp0"
	echo uTorrent.exe /S
)

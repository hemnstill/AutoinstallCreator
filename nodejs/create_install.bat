@echo off
pushd "%~dp0"
set curl=..\curl --fail

set latest_version=https://nodejs.org/dist/index.json
echo Get latest lts versions: %latest_version% ...
>raw_download_str.tmp (
  if "%~1"=="" (
    %curl% %latest_version% | findstr /v /c:"\"lts\":false" | findstr /c:"\"win-x64-msi\""
  ) else (
    %curl% %latest_version% | findstr /v /c:"\"lts\":false" | findstr /c:"\"win-x64-msi\"" | findstr /c:"\"version\":\"v%~1\""
  )
)

set /p download_str= < raw_download_str.tmp
for /f "tokens=2 delims=:," %%A in ("%download_str%") do (
 set node_version=%%A
 call set node_version=%%node_version:"=%%
)

if "%node_version%" == "" (
  echo version "%~1" not found
  exit /b %errorlevel%
)

set download_url="https://nodejs.org/dist/%node_version%/node-%node_version%-x64.msi"
echo Downloading: %download_url% ...
%curl% --location %download_url% --remote-name
if %errorlevel% neq 0 ( exit /b %errorlevel% )
echo Done.

for %%i in (%download_url%) do (
	set latest_filename=%%~ni%%~xi
)

echo Generating %latest_filename% autoinstall.bat
echo "%%~dp0%latest_filename%" /passive > "%~dp0autoinstall.bat"

@pushd "%~dp0"
@call ..\.src\env_tools.bat

for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "datestamp=%dt:~0,10%"

set download_token_url="https://www.msi.com/api/v1/get_token?date=%datestamp%"
echo Downloading: %download_token_url% ...
>raw_download_str.tmp (
    %curl% --location %download_token_url% | %grep% -Po "(?<=\["")[^\s]*(?=""\])" | %head% -n1
)
if %errorlevel% neq 0 (
  echo Cannot download_token
  exit /b %errorlevel%
)

set latest_filename=MSIAfterburnerSetup.zip
set /p download_token= < raw_download_str.tmp
call set download_token=%%download_token:\=%%
set download_url="https://download.msi.com/uti_exe/vga/%latest_filename%?__token__=%download_token%"
echo Downloading: %download_url% ...
%curl% --output %latest_filename% --location %download_url%
if %errorlevel% neq 0 (
  echo Cannot download latest version
  exit /b %errorlevel%
)

"%p7z%" e "%latest_filename%" "-o." *.exe -aoa -r
if %errorlevel% neq 0 ( exit /b %errorlevel% )

for /r . %%a in (MSIAfterburnerSetup*.exe) do set "latest_filepath=%%a"
for %%i in ("%latest_filepath%") do (
  set latest_filename=%%~ni%%~xi
)

echo Generating %latest_filename% autoinstall.bat
echo "%%~dp0%latest_filename%" /S > autoinstall.bat

echo Done.
exit /b %errorlevel%

@pushd "%~dp0"
@call ..\.src\env_tools.bat

set lang=en-us
rem dhc mode.
set dtc_id=0
set product_series_typeid=2
set os_typeid=4
set lookup_base_url=https://www.nvidia.com/Download/API/lookupValueSearch.aspx?TypeID=
set find_base_url=https://www.nvidia.com/Download/processDriver.aspx?
set download_base_url=https://us.download.nvidia.com

set os_name=Windows 10 64-bit
set product_series=%~1
if "%~1"=="" (
  echo product_series does not set:
  >raw_download_str.tmp (
  %curl% -s %lookup_base_url%%product_series_typeid% | %grep% -P --only-matching "(?s).*?(\r\n|\r|\n)" | %grep% -v "LookupValue" | find "" /V
  )
  type raw_download_str.tmp
  exit /b %errorlevel%
)

>raw_download_str.tmp (
  %curl% -s %lookup_base_url%%os_typeid% ^
  | %grep% -P --only-matching "(?s)<Name>Windows 10 64-bit</Name>.*?</Value>" | %grep% -P --only-matching "(?<=<Value>).+(?=</Value>)" ^
  | find "" /V
)
if %errorlevel% neq 0 (
  echo Cannot find os_id
  exit /b %errorlevel%
)
set /p os_id=< raw_download_str.tmp
echo "%os_name%" os_id: "%os_id%"

>raw_download_str.tmp (
  %curl% -s %lookup_base_url%%product_series_typeid% ^
  | %grep% -P --only-matching "(?s)<Name>%product_series%</Name>.*?</Value>" | %grep% -P --only-matching "(?<=<Value>).+(?=</Value>)" ^
  | find "" /V
)
if %errorlevel% neq 0 (
  echo Cannot find ps_id
  exit /b %errorlevel%
)
set /p ps_id=< raw_download_str.tmp
echo "%product_series%" ps_id: "%ps_id%"

set search_query="%find_base_url%osid=%os_id%&psid=%ps_id%&dtcid=%dtc_id%"
echo Get query: %search_query%

>raw_download_str.tmp (
  %curl% --location %search_query%
)
set /p result_url=< raw_download_str.tmp
echo Get direct link from: "%result_url%"
>result_url.tmp (
  %curl% --location %result_url% | %grep% --only-matching "[^&]*whql.exe" | %grep% -P --only-matching "(?<=url=).*" | find "" /V
)
set /p download_url=< result_url.tmp
echo Download driver: "%download_base_url%%download_url%"
%curl% --location %download_base_url%%download_url% --remote-name

for %%i in ("%download_url%") do (
  set latest_filename=%%~ni%%~xi
)

echo Generating %latest_filename% autoinstall.bat
>autoinstall.bat (
  echo pushd "%%~dp0"
  echo "%latest_filename%" -s
  echo exit /b %%errorlevel%%
)

echo Done.
exit /b %errorlevel%

@pushd "%~dp0"
@call ../.src/env_tools.bat

set tar=..\_bash\usr\bin\tar.exe
if not exist %tar% (
	call ..\.tests\test-run.bat _bash create
	if %errorlevel% neq 0 ( exit /b %errorlevel% )
	pushd "%~dp0"
)

set zstd=..\_zstd\zstd.exe
if not exist %zstd% (
	call ..\.tests\test-run.mingw64.bat _zstd create
	if %errorlevel% neq 0 ( exit /b %errorlevel% )
	pushd "%~dp0"
)

set python_version=%~1
set latest_version_url=https://www.python.org/doc/versions/
if "%python_version%" == "" (
  echo python_version does not set. get latest from: %latest_version_url% ...
  >python_latest_version.tmp (
    %curl% --silent --location %latest_version_url% | %grep% -Po "(?<=href=""http://docs\.python\.org/release/)[\d\.]+(?=/"")" | find "" /V
  )
  set /p python_version= < python_latest_version.tmp
)

if "%python_version%" == "" (
  echo Cannot get python_version
  exit /b 1
)
echo -^> %python_version%

echo set latest python to 3.10.0 (temp workaround)
set python_version=3.10.0

set api_url=https://api.github.com/repos/indygreg/python-build-standalone/releases
echo Get latest portable version: %api_url% ...
>raw_download_str.tmp (
%curl% --silent --location %api_url% | %grep% -Po "(?<=""browser_download_url"":\s"")[^,]+x86_64[^,]+windows-msvc-static[^,]+tar\.zst(?="")" | %grep% -F -- "-%python_version%" | find "" /V
)

set download_url=
set /p download_url= < raw_download_str.tmp

set tar_file_name=cpython-%python_version%-windows-msvc.tar
set p7z_file_name=cpython-%python_version%-windows-msvc.7z
set zst_file_name=%tar_file_name%.zst

echo Downloading: %download_url% ...
%curl% --output %zst_file_name% --location "%download_url%"
if %errorlevel% neq 0 ( exit /b %errorlevel% )

echo Extracting from: %zst_file_name% to .tar ...
%zstd% -df %zst_file_name%
if %errorlevel% neq 0 ( exit /b %errorlevel% )


if exist python (
  echo Removing 'python' folder...
  rmdir python /s /q
)

echo Extracting from tar: %tar_file_name% ...
%tar% -xf %tar_file_name% python/install ^
--exclude="__pycache__" ^
--exclude="test" ^
--exclude="tests" ^
--exclude="idle_test" ^
--exclude="site-packages" ^
--exclude="venv" ^
--exclude="Scripts" ^
--exclude="*.pdb" ^
--exclude="*.whl" ^
--exclude="*.lib" ^
--exclude="*.pickle" ^
--exclude="pythonw.exe" ^
--exclude="python/install/include"
if %errorlevel% neq 0 ( exit /b %errorlevel% )

echo Creating archive %p7z_file_name%
%p7zip% u %p7z_file_name% -uq0 python
if %errorlevel% neq 0 ( exit /b %errorlevel% )

echo Removing 'python' folder...
rmdir python /s /q
if %errorlevel% neq 0 ( exit /b %errorlevel% )

echo Done.

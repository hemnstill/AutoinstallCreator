@echo off

mkdir -p C:\Python && cd C:\Python
curl --location "https://github.com/hemnstill/StandaloneTools/releases/download/python-3.12.1/build-msvc.tar.gz" --output "python.tar.gz"
tar -xf "python.tar.gz" --strip-components 2
echo f | xcopy /Y /Q /R "python.exe" "python3.exe"

mkdir -p C:\git && cd C:\git
curl --location https://github.com/git-for-windows/git/releases/download/v2.44.0.windows.1/MinGit-2.44.0-busybox-64-bit.zip --output "git.zip"
tar -xf "git.zip"

C:\git\mingw64\bin\git config --global --add safe.directory "*"

"%~dp0..\.tools\busybox.exe" bash "%~dp0ci-test-run.sh" %*

exit /b %errorlevel%

import argparse
import os
import pathlib

_current_script_path: str = os.path.dirname(os.path.realpath(__file__))


_batch_header = r"""@echo off
pushd "%~dp0"

"""

_tools = r"""set curl=..\curl --fail
set p7z=..\7z.exe
set LC_ALL=en_US.UTF-8
set grep=..\grep

"""


def _get_latest_version_download_url(name: str):
    return rf'''set latest_version=https://sourceforge.net/projects/keepass/best_release.json
echo Get latest version: %latest_version% ...
>raw_download_str.tmp (
    %curl% %latest_version% | %grep% -P --only-matching "(?<=""url""\:\s"")[^\s]*(?=/download"",)"
)
{_check_errorlevel("Cannot get latest version")}
'''


def _download_latest_version():
    return rf"""set /p download_url= < raw_download_str.tmp
echo Downloading: %download_url% ...
%curl% --remote-name --location %download_url%
{_check_errorlevel("Cannot download latest version")}
echo Done.
"""


def _check_errorlevel(message: str):
    return rf"""if %errorlevel% neq 0 (
  echo {message}
  exit /b %errorlevel%
)
"""


def save_to(file_path: str, content: str):
    with open(file_path, 'w') as f:
        f.write(content)
    print(f"Saved to: {file_path}")


def generate_batch(name: str):
    result = _batch_header
    result += _tools
    result += _get_latest_version_download_url(name)
    result += _download_latest_version()
    return result


def main(name: str):
    batch_content = generate_batch(name)
    create_install_path = os.path.join(os.path.dirname(_current_script_path), name, 'create_install.bat')
    pathlib.Path(create_install_path).parent.mkdir(parents=True, exist_ok=True)
    save_to(create_install_path, batch_content)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Generate batch script.')
    parser.add_argument('name')
    args = parser.parse_args()
    main(args.name)

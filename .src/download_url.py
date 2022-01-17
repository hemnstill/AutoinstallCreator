import argparse
import os
import pathlib

_current_script_path: str = os.path.dirname(os.path.realpath(__file__))

_batch_header_with_tools = r"""@pushd "%~dp0"
@call ..\.src\env_tools.bat

"""


def _download_url(url):
    return rf"""set download_url="{url}"
echo Downloading: %download_url% ...
%curl% --remote-name --location %download_url%
{_check_errorlevel("Cannot download latest version")}
{_latest_filename()}
"""


def _autoinstall():
    return rf"""echo Generating %latest_filename% autoinstall.bat
> autoinstall.bat (
    echo "%%~dp0%latest_filename%" /passive
    echo exit /b %%errorlevel%%
)

echo Done.
"""


def _latest_filename():
    return r"""for %%i in (%download_url%) do (
    set latest_filename=%%~ni%%~xi
)
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


def generate_batch(url: str):
    result = _batch_header_with_tools
    result += _download_url(url)
    result += _autoinstall()
    return result


def main(url: str):
    batch_content = generate_batch(url)
    name = pathlib.Path(url).stem
    create_install_path = os.path.join(os.path.dirname(_current_script_path), name, 'create_install.bat')
    pathlib.Path(create_install_path).parent.mkdir(parents=True, exist_ok=True)
    save_to(create_install_path, batch_content)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Generate batch script.')
    parser.add_argument('url')
    args = parser.parse_args()
    main(args.url)

import os
import pathlib
import shutil
import subprocess
import sys
import unittest

_self_path: str = os.path.dirname(os.path.realpath(__file__))

_self_body_path = os.path.join(os.path.dirname(_self_path), 'body.md')

_self_tmp_path: str = os.path.join(_self_path, '.tmp')
_root_path: str = os.path.dirname(_self_path)
_tools_path: str = os.path.join(_root_path, '.tools')

busybox_exe_path_arg: list[str] = []
update_script_name: str = 'update.sh'
package_name = 'AutoinstallCreator.sh'
mock_xterm = ''
if sys.platform.startswith('win'):
    busybox_exe_path_arg = [os.path.join(_tools_path, 'busybox.exe'), 'bash']
    update_script_name = 'update.bat'
    package_name = 'AutoinstallCreator.sh.bat'

if _root_path not in sys.path:
    sys.path.append(_root_path)

from _AutoinstallCreator import io_tools  # noqa: E402


def update_completed(update_log_path: str, version_str: str) -> bool:
    update_log = io_tools.read_text(update_log_path)
    return update_log.endswith(f'\nUpdate complete: {version_str}\n')


def version_is_up_to_date(update_log_path: str, version_str: str) -> bool:
    update_log = io_tools.read_text(update_log_path).strip()
    return update_log == f'Version is up to date: {version_str}'


class TestUpdate(unittest.TestCase):
    version_str: str

    @classmethod
    def setUpClass(cls) -> None:
        global busybox_exe_path_arg, mock_xterm

        pathlib.Path(os.path.join(_self_path, 'AutoinstallCreator.sh')).unlink(missing_ok=True)
        pathlib.Path(os.path.join(_self_path, 'AutoinstallCreator.sh.bat')).unlink(missing_ok=True)
        pathlib.Path(_self_body_path).unlink(missing_ok=True)

        if not sys.platform.startswith('win'):
            if shutil.which('gnome-terminal'):
                busybox_exe_path_arg = ['gnome-terminal', '--wait', '--']
                mock_xterm = 'gnome-terminal --wait -- '

        subprocess.run(busybox_exe_path_arg + [os.path.join(_self_path, 'release.sh')],
                       check=True)
        cls.version_str = io_tools.read_text(_self_body_path).strip('\r\n')
        if not cls.version_str:
            raise ValueError('cannot get version from release.sh')

    def setUp(self):
        self.test_old_version = 'AutoinstallCreator.11.test_old_version'
        self.assertTrue(self.version_str.startswith('AutoinstallCreator.'))
        self.assertTrue(io_tools.try_create_or_clean_dir(_self_tmp_path))
        self.package_filepath = os.path.join(_self_tmp_path, package_name)
        self.old_update_log_filepath = os.path.join(_self_tmp_path, self.test_old_version, '_update.log')
        self.update_log_filepath = os.path.join(_self_tmp_path, self.version_str, '_update.log')
        shutil.copy2(os.path.join(_self_path, package_name), self.package_filepath)

        pathlib.Path(self.old_update_log_filepath).unlink(missing_ok=True)
        pathlib.Path(self.update_log_filepath).unlink(missing_ok=True)

    def test_version_up_to_date(self):
        subprocess.run(busybox_exe_path_arg + [self.package_filepath],
                       cwd=_self_tmp_path,
                       check=True)

        subprocess.run([os.path.join(_self_tmp_path, self.version_str, update_script_name)],
                       env={
                           **os.environ,
                           'MOCK_AUTOINSTALLCREATOR_VERSION_BODY': self.version_str,
                           'MOCK_AUTOINSTALLCREATOR_PACKAGE_FILEPATH': self.package_filepath,
                           'MOCK_AUTOINSTALLCREATOR_XTERM': mock_xterm
                       },
                       check=True)
        self.assertTrue(version_is_up_to_date(self.update_log_filepath, self.version_str))

    @unittest.skipIf(sys.platform.startswith('win') and not os.path.exists(r'C:\Windows\notepad.exe'), 'disable in nanoserver')
    def test_update_to_new_version(self):
        subprocess.run(busybox_exe_path_arg + [self.package_filepath, '--target', self.test_old_version],
                       cwd=_self_tmp_path,
                       check=True)

        io_tools.write_text(os.path.join(_self_tmp_path, self.test_old_version, '_AutoinstallCreator', 'version.txt'),
                            self.test_old_version)

        subprocess.run([os.path.join(_self_tmp_path, self.test_old_version, update_script_name)],
                       env={
                           **os.environ,
                           'MOCK_AUTOINSTALLCREATOR_VERSION_BODY': self.version_str,
                           'MOCK_AUTOINSTALLCREATOR_PACKAGE_FILEPATH': self.package_filepath,
                           'MOCK_AUTOINSTALLCREATOR_XTERM': mock_xterm
                       },
                       check=True)

        self.assertTrue(io_tools.wait_for(lambda: update_completed(self.old_update_log_filepath, self.version_str),
                                          err_message='Update failed',
                                          timeout=10,
                                          retry_timeout=0.5,
                                          exception=OSError))

    def tearDown(self):
        if os.path.isfile(self.old_update_log_filepath):
            print(f'''old_update_log_filepath:
{io_tools.read_text(self.old_update_log_filepath)}''')

        if os.path.isfile(self.update_log_filepath):
            print(f'''update_log_filepath:
{io_tools.read_text(self.update_log_filepath)}''')

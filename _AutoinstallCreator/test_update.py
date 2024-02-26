import os
import pathlib
import shutil
import subprocess
import sys
import unittest

_self_path: str = os.path.dirname(os.path.realpath(__file__))

_self_tmp_path: str = os.path.join(_self_path, '.tmp')
_root_path: str = os.path.dirname(_self_path)
_tools_path: str = os.path.join(_root_path, '.tools')

busybox_exe_path_arg: list[str] = []
update_script_name: str = 'update.sh'
package_name = 'AutoinstallCreator.sh'
if sys.platform.startswith('win'):
    busybox_exe_path_arg = [os.path.join(_tools_path, 'busybox.exe')]
    update_script_name = 'update.bat'
    package_name = 'AutoinstallCreator.sh.bat'

if _root_path not in sys.path:
    sys.path.append(_root_path)

from _AutoinstallCreator import io_tools


def get_version_from_stdout(b_stdout: bytes) -> str:
    for b_line in b_stdout.splitlines():
        if b_line.startswith(b'version created:'):
            version_line = b_line.decode().strip()
            prefix, _, raw_version = version_line.partition(':')
            return raw_version.strip()


def update_completed(update_log_path: str, version_str: str) -> bool:
    update_log = io_tools.read_text(update_log_path)
    return update_log.endswith(f'\nUpdate complete: {version_str}\n')


class TestUpdate(unittest.TestCase):

    @classmethod
    def setUpClass(cls) -> None:
        pathlib.Path(os.path.join(_self_path, 'AutoinstallCreator.sh')).unlink(missing_ok=True)
        pathlib.Path(os.path.join(_self_path, 'AutoinstallCreator.sh.bat')).unlink(missing_ok=True)

        result = subprocess.run(busybox_exe_path_arg + ['bash', os.path.join(_self_path, 'release.sh')],
                                env={
                                    **os.environ,
                                    'BB_OVERRIDE_APPLETS': 'tar'
                                },
                                check=True, stdout=subprocess.PIPE)
        cls.version_str = get_version_from_stdout(result.stdout)

    def setUp(self):
        self.test_old_version = 'AutoinstallCreator.11.test_old_version'
        self.assertTrue(self.version_str.startswith('AutoinstallCreator.'))
        self.assertTrue(io_tools.try_create_or_clean_dir(_self_tmp_path))
        self.package_filepath = os.path.join(_self_tmp_path, package_name)
        shutil.copyfile(os.path.join(_self_path, package_name), self.package_filepath)

    def test_version_up_to_date(self):
        subprocess.run(busybox_exe_path_arg + ['bash', self.package_filepath],
                       env={
                           **os.environ,
                           'BB_OVERRIDE_APPLETS': 'tar'
                       },
                       cwd=_self_tmp_path)

        result = subprocess.run(busybox_exe_path_arg + ['bash', os.path.join(_self_tmp_path, self.version_str, 'update.sh')],
                                env={
                                    **os.environ,
                                    'MOCK_AUTOINSTALLCREATOR_VERSION_BODY': self.version_str,
                                    'MOCK_AUTOINSTALLCREATOR_PACKAGE_FILEPATH': self.package_filepath
                                },
                                check=True, stdout=subprocess.PIPE)
        self.assertTrue(result.stdout.endswith(b'\nVersion is up to date\n'))

    @unittest.skip('dbg')
    def test_update_to_new_version(self):
        subprocess.run(busybox_exe_path_arg + ['bash', self.package_filepath, '--target', self.test_old_version],
                       cwd=_self_tmp_path,
                       env={
                           **os.environ,
                           'BB_OVERRIDE_APPLETS': 'tar'
                       },
                       )

        io_tools.write_text(os.path.join(_self_tmp_path, self.test_old_version, '_AutoinstallCreator', 'version.txt'),
                            self.test_old_version)

        result = subprocess.run([os.path.join(_self_tmp_path, self.test_old_version, update_script_name)],
                                env={
                                    **os.environ,
                                    'MOCK_AUTOINSTALLCREATOR_VERSION_BODY': self.version_str,
                                    'MOCK_AUTOINSTALLCREATOR_PACKAGE_FILEPATH': self.package_filepath
                                },
                                check=True, stdout=subprocess.PIPE)

        self.assertIn(f'\nFound new version: {self.test_old_version} -> {self.version_str}\n'.encode(), result.stdout)

        update_log_filepath = os.path.join(_self_tmp_path, self.test_old_version, '_update.log')
        self.assertTrue(io_tools.wait_for(lambda: update_completed(update_log_filepath, self.version_str),
                                          err_message='Update failed',
                                          timeout=10,
                                          retry_timeout=0.5,
                                          exception=OSError))

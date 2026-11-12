# [![GitHub release (by tag)](https://img.shields.io/github/downloads/hemnstill/AutoinstallCreator/latest-master/total?label=⭳%20latest-master)](https://github.com/hemnstill/AutoinstallCreator/releases/tag/latest-master) AutoinstallCreator

[![MegaLinter](https://github.com/hemnstill/AutoinstallCreator/actions/workflows/mega-linter.yml/badge.svg)](https://github.com/hemnstill/AutoinstallCreator/actions/workflows/mega-linter.yml)
[![ci build](https://github.com/hemnstill/AutoinstallCreator/actions/workflows/ci-test-run.yml/badge.svg)](https://github.com/hemnstill/AutoinstallCreator/actions/workflows/ci-test-run.yml)

Download the latest version and create autoinstall script for silent installation.

## How to create autoinstall.bat
* run `<Application>/create_install.bat`. Batch script downloads latest version and creates autoinstall.bat.

## How to auto install
run `<Application>/autoinstall.bat`

## Tools used
* 7zz 24.06 <https://www.7-zip.org/>
* curl 8.7.1 <https://curl.se/windows/>
* pcre2grep 10.44 <https://github.com/PCRE2Project/pcre2>
* busybox 1.37.0-FRP-5398 <https://frippery.org/busybox/>

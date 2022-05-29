#!/bin/bash
export CI=true
dp0="$(realpath "$(dirname "$0")")"
set -e

"$dp0/test-linter.sh" || exit 1

"$dp0/test-tools.sh" || exit 1

"$dp0/test-run.sh" -- testInternalCreate || exit 1

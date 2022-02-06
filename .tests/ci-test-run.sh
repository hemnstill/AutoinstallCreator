#!/bin/bash
dp0="$(dirname "$0")"
dp0_tools="$dp0/../.tools" && source "$dp0_tools/env_tools.sh"

cd "$dp0"

export CI=true

./test-tools.sh

./test-run.sh _ create

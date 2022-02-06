#!/bin/bash
dp0="$(dirname "$0")"
export CI=true
dp0_tools="$dp0/../.tools" && source "$dp0_tools/env_tools.sh"

"$dp0/test-tools.sh" || exit

"$dp0/test-run.sh" _ create || exit 

#!/usr/bin/env bash
set -Eeu -o pipefail

# Linter checks.
# Updated 2019-09-27.

KOOPA_HOME="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." \
    >/dev/null 2>&1 && pwd -P)"
export KOOPA_HOME

linter_dir="${KOOPA_HOME}/system/linter"
for file in "${linter_dir}/"*".sh"
do
    # shellcheck source=/dev/null
    [ -f "$file" ] && "$file"
done

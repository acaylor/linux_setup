#!/usr/bin/env bash
# Compatibility entrypoint; workstation-bootstrap.sh is OS-independent.

set -euo pipefail
script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
exec "$script_dir/workstation-bootstrap.sh" "$@"

#!/usr/bin/env bash
set -euo pipefail
mkdir -p docs/out
mmdc -i docs/arch.mmd -o docs/out/arch.png
echo "Rendered docs/out/arch.png"

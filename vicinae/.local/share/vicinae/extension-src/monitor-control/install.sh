#!/usr/bin/env bash
# Build the extension straight into Vicinae's extension directory.
# Run once after cloning the dotfiles, and again after editing anything in src/.
set -euo pipefail

cd "$(dirname "$(readlink -f "$0")")"

npm install
./node_modules/.bin/vici build

echo
echo "Installed. Restart the launcher with 'vicinae server' (or just log in again)"
echo "for a newly added command to show up."

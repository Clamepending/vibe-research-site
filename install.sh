#!/usr/bin/env bash
set -euo pipefail

REMOTE_VIBES_INSTALLER_URL="${REMOTE_VIBES_INSTALLER_URL:-https://raw.githubusercontent.com/Clamepending/remote-vibes/main/install.sh}"

if command -v curl >/dev/null 2>&1; then
  curl -fsSL "$REMOTE_VIBES_INSTALLER_URL" | bash
elif command -v wget >/dev/null 2>&1; then
  wget -qO- "$REMOTE_VIBES_INSTALLER_URL" | bash
else
  printf '[vibe-research-install] Missing curl or wget. Install curl, then rerun this command.\n' >&2
  exit 1
fi

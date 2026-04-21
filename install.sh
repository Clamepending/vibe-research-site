#!/usr/bin/env bash
set -euo pipefail

REMOTE_VIBES_REPO_SLUG="${REMOTE_VIBES_REPO_SLUG:-Clamepending/remote-vibes}"
REMOTE_VIBES_INSTALLER_URL="${REMOTE_VIBES_INSTALLER_URL:-}"

fetch_url() {
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$1"
    return
  fi

  if command -v wget >/dev/null 2>&1; then
    wget -qO- "$1"
    return
  fi

  printf '[vibe-research-install] Missing curl or wget. Install curl, then rerun this command.\n' >&2
  exit 1
}

if [ -z "$REMOTE_VIBES_INSTALLER_URL" ]; then
  latest_tag="$(
    fetch_url "https://api.github.com/repos/${REMOTE_VIBES_REPO_SLUG}/releases/latest" |
      sed -n 's/.*"tag_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' |
      head -n 1
  )"

  if [ -z "$latest_tag" ]; then
    printf '[vibe-research-install] Could not resolve the latest Remote Vibes release.\n' >&2
    exit 1
  fi

  REMOTE_VIBES_INSTALLER_URL="https://raw.githubusercontent.com/${REMOTE_VIBES_REPO_SLUG}/${latest_tag}/install.sh"
fi

fetch_url "$REMOTE_VIBES_INSTALLER_URL" | bash

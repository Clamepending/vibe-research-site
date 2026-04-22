#!/usr/bin/env bash
set -euo pipefail

VIBE_RESEARCH_REPO_SLUG="${VIBE_RESEARCH_REPO_SLUG:-${REMOTE_VIBES_REPO_SLUG:-Clamepending/vibe-research}}"
VIBE_RESEARCH_INSTALLER_URL="${VIBE_RESEARCH_INSTALLER_URL:-${REMOTE_VIBES_INSTALLER_URL:-}}"

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

if [ -z "$VIBE_RESEARCH_INSTALLER_URL" ]; then
  latest_tag="$(
    fetch_url "https://api.github.com/repos/${VIBE_RESEARCH_REPO_SLUG}/releases/latest" |
      sed -n 's/.*"tag_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' |
      head -n 1
  )"

  if [ -z "$latest_tag" ]; then
    printf '[vibe-research-install] Could not resolve the latest Vibe Research release.\n' >&2
    exit 1
  fi

  VIBE_RESEARCH_INSTALLER_URL="https://raw.githubusercontent.com/${VIBE_RESEARCH_REPO_SLUG}/${latest_tag}/install.sh"
fi

fetch_url "$VIBE_RESEARCH_INSTALLER_URL" | bash

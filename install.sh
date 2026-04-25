#!/usr/bin/env bash
# vibe-research.net/install.sh — thin bootstrap that downloads the real
# installer from main and pipes it to bash. Tracks main HEAD so merges
# land on fresh installs without waiting on a release tag.
set -euo pipefail

VIBE_RESEARCH_REPO_SLUG="${VIBE_RESEARCH_REPO_SLUG:-${REMOTE_VIBES_REPO_SLUG:-Clamepending/vibe-research}}"
VIBE_RESEARCH_REF="${VIBE_RESEARCH_REF:-${REMOTE_VIBES_REF:-main}}"
VIBE_RESEARCH_INSTALLER_URL="${VIBE_RESEARCH_INSTALLER_URL:-${REMOTE_VIBES_INSTALLER_URL:-https://raw.githubusercontent.com/${VIBE_RESEARCH_REPO_SLUG}/${VIBE_RESEARCH_REF}/install.sh}}"

fetch_installer() {
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$VIBE_RESEARCH_INSTALLER_URL"
    return
  fi

  if command -v wget >/dev/null 2>&1; then
    wget -qO- "$VIBE_RESEARCH_INSTALLER_URL"
    return
  fi

  printf '[vibe-research-install] Missing curl or wget. Install curl, then rerun this command.\n' >&2
  exit 1
}

installer="$(fetch_installer)"
if [ -z "$installer" ]; then
  printf '[vibe-research-install] Empty response from %s\n' "$VIBE_RESEARCH_INSTALLER_URL" >&2
  exit 1
fi

printf '%s\n' "$installer" | bash

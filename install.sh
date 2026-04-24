#!/usr/bin/env bash
# vibe-research.net/install.sh — thin bootstrap that downloads the real
# installer from the latest GitHub release asset and pipes it to bash.
# We prefer the release-download URL (served from GitHub's CDN) over the
# GitHub API / raw.githubusercontent.com because those endpoints are
# aggressively IP rate-limited and 403 for a lot of users.
set -euo pipefail

VIBE_RESEARCH_REPO_SLUG="${VIBE_RESEARCH_REPO_SLUG:-${REMOTE_VIBES_REPO_SLUG:-Clamepending/vibe-research}}"
VIBE_RESEARCH_INSTALLER_URL="${VIBE_RESEARCH_INSTALLER_URL:-${REMOTE_VIBES_INSTALLER_URL:-https://github.com/${VIBE_RESEARCH_REPO_SLUG}/releases/latest/download/install.sh}}"

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

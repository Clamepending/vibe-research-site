# Vibe Research Site

Static website and installer endpoint for `vibe-research.net`.

The public installer command is:

```bash
curl -fsSL https://vibe-research.net/install.sh | bash
```

`install.sh` resolves the latest Vibe Research GitHub Release from
`Clamepending/vibe-research`, then delegates to that release's installer.

For testing, override the release source with `VIBE_RESEARCH_REPO_SLUG` or
`VIBE_RESEARCH_INSTALLER_URL`. The old `REMOTE_VIBES_*` override names still
work as compatibility aliases.

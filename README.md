# Swarmlab Site

Static website and installer endpoint for `swarmlab.vibe-research.net`.

Swarmlab is a project within the Vibe Research lab. The lab homepage lives at
`vibe-research.net`; this repo is the Swarmlab project site.

The public installer command is:

```bash
curl -fsSL https://swarmlab.vibe-research.net/install.sh | bash
```

`install.sh` resolves the latest Swarmlab GitHub Release from
`Clamepending/swarmlab`, then delegates to that release's installer.

For testing, override the release source with `VIBE_RESEARCH_REPO_SLUG` or
`VIBE_RESEARCH_INSTALLER_URL`. The old `REMOTE_VIBES_*` override names still
work as compatibility aliases. (Env var names retain the `VIBE_RESEARCH_`
prefix because they're shared with the underlying product repo.)

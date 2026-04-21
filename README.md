# Vibe Research Site

Static website and installer endpoint for `vibe-research.net`.

The public installer command is:

```bash
curl -fsSL https://vibe-research.net/install.sh | bash
```

`install.sh` resolves the latest Remote Vibes GitHub Release, then delegates to
that release's installer.

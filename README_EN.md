# Claude Desktop + DeepSeek Configuration Tool

One-click setup for running Claude Desktop with DeepSeek as a third-party inference provider.

## What This Does

Claude Desktop only supports Anthropic's API by default. This project uses Claude Desktop's Developer Mode to route it through DeepSeek's Anthropic-compatible API, allowing you to use DeepSeek models with Claude Desktop (both Cowork and Code modes).

## Prerequisites

- macOS
- A [DeepSeek API Key](https://platform.deepseek.com/api_keys)
- Claude Desktop 1.6608.2 (released May 10, 2026 — newer versions restrict third-party inference)

## Quick Start

### 1. Install Claude Desktop

Make sure `/Applications/Claude.app` is installed. You need version 1.6608.2.

> This version is no longer available from official channels. Contact: mrliu7219@gmail.com

### 2. Run the Setup Script

```bash
chmod +x install-deepseek.command
./install-deepseek.command
```

The script will guide you through:

| Step | Action | Method |
|------|--------|--------|
| 1 | Enter DeepSeek API Key | Automatic (saved for reuse) |
| 2 | Verify Claude installation | Automatic |
| 3 | Disable auto-update | Automatic |
| 4 | Enable Developer Mode | Manual |
| 5 | Quit Claude → Set env var | Manual quit, then automatic |
| 6 | Launch Claude → Configure Gateway | Manual (UI fields) |
| 7 | Set permission mode | Manual |

Takes about 5 minutes.

### 3. Verify

Send a message. If you get a reply, you're all set.

## How It Works

Newer Claude Desktop versions block custom model names. Setting `NODE_ENV=production` bypasses this restriction.

```
Claude Desktop
    │
    ├─ deploymentMode: "3p"        → Third-party inference mode
    │
    ├─ LaunchAgent
    │   └─ NODE_ENV=production     → Enables DeepSeek model names
    │
    └─ Gateway: api.deepseek.com/anthropic
        └─ Models configured in UI:
            deepseek-v4-pro   → Opus tier
            deepseek-v4-flash → Sonnet tier
```

## Reinstall

Just double-click `install-deepseek.command` again. Your API key is saved in `~/.claude-deepseek.env`.

## Important Notes

- **Don't upgrade Claude Desktop** — newer versions restrict third-party inference
- **Don't sign in to your Anthropic account** — messages will be routed through Anthropic's servers
- Code mode requires a VPN/proxy on first launch to download the Claude Code CLI
- Cowork mode doesn't need a proxy

## Files

```
├── install-deepseek.command   # Setup script (double-click to run)
└── README.md                  # This file
```

## Related

- [DeepSeek API Docs](https://api-docs.deepseek.com/)
- [claude-desktop-zh-cn](https://github.com/javaht/claude-desktop-zh-cn) — Chinese localization for Claude Desktop

## License

MIT

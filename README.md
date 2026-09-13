# personalization-template

The starting point for **your** personalization plugin — copied once by
`/retroloop:setup` to `~/.retroloop/plugins/my`, and from that moment it's
yours: only your AI writes it, and it evolves one retro at a time. The plugin
is named `my`, so everything it adds loads under that prefix (`/my:<skill>`);
the `plugins/` folder is the local marketplace it installs from.

This is a standard Claude Code plugin. Fixes land as whatever artifact the
approved solution calls for:

- `skills/` — how the AI works with you (an example skill shows the shape)
- `instructions/global.md` — short curated instruction lines
- `hooks/` — rules that always run, when guidance isn't enough
- plus agents, monitors, executables, and MCP config as your fixes need them

It ships nearly empty on purpose: Retroloop builds only from things that
actually happened in your sessions — nothing speculative, nothing generic.

Created by [Retroloop](https://github.com/retroloop/retroloop). License: MIT.

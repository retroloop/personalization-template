# Retroloop

Choices recorded by /retroloop:setup. Plain lines; edit them by hand or run setup again.

tracking: this tool only
model: fable
subagent model: opus

`tracking:` is `this tool only` — the default, where the resolve lane applies the
approved records and nothing is exported by anything — or `elsewhere`, where the
session that closes a review runs this plugin's `/my:file-issues` skill, which you
adapt to your tracker. `model:` runs the manager and each tech lead, and takes any
value `claude --model` accepts; `subagent model:` runs their workers and reviewers.

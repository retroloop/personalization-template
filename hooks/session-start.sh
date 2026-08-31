#!/usr/bin/env bash
# my-plugin SessionStart hook — the delivery mechanism for L1 (words-only)
# fixes: injects the curated instruction surfaces, under hard budgets.
# Over budget = loud refusal, never truncation: a silently trimmed rule is
# a rule the AI half-follows, which is worse than the loud failure.

set -u

ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
GLOBAL="$ROOT/instructions/global.md"
GLOBAL_BUDGET=3000
PROJECT_BUDGET=1500

# The hook's stdin is JSON carrying the session's cwd.
input="$(cat 2>/dev/null || true)"
cwd="$(printf '%s' "$input" | sed -n 's/.*"cwd"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')"
project_file=""
if [ -n "$cwd" ]; then
  project_file="$ROOT/instructions/projects/$(basename "$cwd").md"
fi

refuse() {
  echo "my-plugin: REFUSING to inject $1 — $2 chars, budget $3. Trim it; truncation would half-apply rules silently." >&2
  exit 1
}

if [ -f "$GLOBAL" ]; then
  size=$(wc -c <"$GLOBAL" | tr -d ' ')
  [ "$size" -le "$GLOBAL_BUDGET" ] || refuse "instructions/global.md" "$size" "$GLOBAL_BUDGET"
fi
if [ -n "$project_file" ] && [ -f "$project_file" ]; then
  size=$(wc -c <"$project_file" | tr -d ' ')
  [ "$size" -le "$PROJECT_BUDGET" ] || refuse "instructions/projects/$(basename "$project_file")" "$size" "$PROJECT_BUDGET"
fi

echo "[my-plugin active]"
[ -f "$GLOBAL" ] && cat "$GLOBAL"
[ -n "$project_file" ] && [ -f "$project_file" ] && cat "$project_file"

exit 0

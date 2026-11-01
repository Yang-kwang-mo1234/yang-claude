#!/bin/bash
# Install the global Claude Code setup from global/ into ~/.claude.
# Only adds what is missing: existing skills, hooks and CLAUDE.md are left as they are,
# and settings.json is merged (existing values win, the hook is added once).
set -euo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)/global"
DEST="${CLAUDE_HOME:-$HOME/.claude}"

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required (brew install jq)" >&2
  exit 1
fi

mkdir -p "$DEST/skills" "$DEST/hooks"

# Skills
for dir in "$SRC"/skills/*/; do
  name="$(basename "$dir")"
  if [ -e "$DEST/skills/$name" ]; then
    echo "skip   skill $name (already installed)"
  else
    cp -R "$dir" "$DEST/skills/$name"
    echo "added  skill $name"
  fi
done

# Hooks
for file in "$SRC"/hooks/*; do
  name="$(basename "$file")"
  if [ -e "$DEST/hooks/$name" ]; then
    echo "skip   hook $name (already installed)"
  else
    cp "$file" "$DEST/hooks/$name"
    chmod +x "$DEST/hooks/$name"
    echo "added  hook $name"
  fi
done

# CLAUDE.md
if [ -e "$DEST/CLAUDE.md" ]; then
  if cmp -s "$SRC/CLAUDE.md" "$DEST/CLAUDE.md"; then
    echo "skip   CLAUDE.md (same)"
  else
    echo "skip   CLAUDE.md (differs; compare with $SRC/CLAUDE.md)"
  fi
else
  cp "$SRC/CLAUDE.md" "$DEST/CLAUDE.md"
  echo "added  CLAUDE.md"
fi

# settings.json
if [ -e "$DEST/settings.json" ]; then
  cp "$DEST/settings.json" "$DEST/settings.json.bak"
  tmp="$(mktemp)"
  jq --slurpfile f "$SRC/settings.json" '
    $f[0] as $frag
    | (($frag | del(.hooks)) * .)
    | reduce ($frag.hooks // {} | to_entries[]) as $ev (.;
        reduce $ev.value[] as $grp (.;
          if ([.hooks[$ev.key][]?.hooks[]?.command] | index($grp.hooks[0].command))
          then .
          else .hooks[$ev.key] += [$grp]
          end))
  ' "$DEST/settings.json" > "$tmp"
  mv "$tmp" "$DEST/settings.json"
  echo "merged settings.json (backup: settings.json.bak)"
else
  cp "$SRC/settings.json" "$DEST/settings.json"
  echo "added  settings.json"
fi

echo "Done. Restart Claude Code to load the new skills, hooks and plugins."

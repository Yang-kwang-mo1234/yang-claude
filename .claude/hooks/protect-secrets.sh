#!/bin/bash
# PreToolUse hook: block Claude from editing secret files (.env, keys, certificates).
# Exit code 2 blocks the tool call and shows the stderr message to Claude.

input=$(cat)
file_path=$(printf '%s' "$input" | python3 -c 'import json,sys; print(json.load(sys.stdin).get("tool_input",{}).get("file_path",""))' 2>/dev/null)

[ -z "$file_path" ] && exit 0

name=$(basename "$file_path")

case "$name" in
  .env.example|.env.sample|.env.template)
    exit 0 ;;
  .env|.env.*|*.pem|*.key|*.p12|*.pfx|id_rsa*|id_ed25519*|credentials.json|secrets.*)
    echo "Blocked: '$file_path' is a secret file. Ask the user to edit it manually." >&2
    exit 2 ;;
esac

exit 0

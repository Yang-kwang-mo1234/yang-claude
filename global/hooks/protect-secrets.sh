#!/bin/bash
# PreToolUse hook (Edit, Write, MultiEdit, NotebookEdit):
# - blocks edits to secret files (.env, keys, certificates, credential files)
# - asks before edits to Claude Code settings, hook scripts and MCP config, so the guards can't be turned off silently
# Exit code 2 blocks the tool call and shows the stderr message to Claude.

input=$(cat)
# Edit/Write/MultiEdit send file_path; NotebookEdit sends notebook_path
file_path=$(printf '%s' "$input" | python3 -c 'import json,sys; t=json.load(sys.stdin).get("tool_input",{}); print(t.get("file_path") or t.get("notebook_path") or "")' 2>/dev/null)

[ -z "$file_path" ] && exit 0

name=$(basename "$file_path")

block() {
  echo "Blocked: '$file_path' is a secret file. Ask the user to edit it manually." >&2
  exit 2
}

case "$name" in
  .env.example|.env.sample|.env.template)
    ;;
  .env|.env.*|.envrc|*.pem|*.key|*.p12|*.pfx|*.jks|*.keystore|id_rsa*|id_ecdsa*|id_ed25519*|credentials|credentials.json|service-account*.json|secrets.*|.netrc|.npmrc|.pypirc|.git-credentials|kubeconfig)
    block ;;
esac

case "$file_path" in
  */.ssh/*|*/.aws/*|*/.kube/*|*/.gnupg/*|*/.docker/config.json)
    block ;;
esac

# Guard files: allowed, but only after the user says yes
case "$file_path" in
  */.claude/settings.json|*/.claude/settings.local.json|*/.claude/hooks/*|*/.claude.json|*/.mcp.json)
    printf '%s' "{\"hookSpecificOutput\":{\"hookEventName\":\"PreToolUse\",\"permissionDecision\":\"ask\",\"permissionDecisionReason\":\"Changes Claude Code settings, hooks or MCP config. Allow only if you want this edit.\"}}"
    exit 0 ;;
esac

exit 0

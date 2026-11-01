#!/bin/bash

INPUT=$(cat)
# Without jq, match against the raw JSON so the guard still works
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command' 2>/dev/null) || COMMAND="$INPUT"

# "git" plus any global options before the subcommand: -C <path>, -c <key=value>, --no-pager ...
GIT="git( +(-[Cc]|--git-dir|--work-tree|--namespace) +[^ ;&|]+| +-[^ ;&|]+)*"

DANGEROUS_PATTERNS=(
  "$GIT +push"
  "$GIT +reset +--hard"
  "$GIT +clean( [^;&|]*)? +(-[[:alnum:]]*f|--force)"
  "$GIT +branch( [^;&|]*)? +-D"
  # "." alone, not a file name that starts with a dot (.gitignore)
  "$GIT +(checkout|restore)( +--)? +\.($|[ ;&|])"
  "push --force"
  "reset --hard"
  # rm with both recursive and force: -rf, -fr, -Rf, -rfv, -r -f, --recursive --force
  "(^|[;&|(/ ])rm( [^;&|]*)? +(-[[:alnum:]]*[rR]|--recursive)([[:alnum:]]*f|( [^;&|]*)? +(-[[:alnum:]]*f|--force))"
  "(^|[;&|(/ ])rm( [^;&|]*)? +(-[[:alnum:]]*f|--force)([[:alnum:]]*[rR]|( [^;&|]*)? +(-[[:alnum:]]*[rR]|--recursive))"
)

for pattern in "${DANGEROUS_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qE "$pattern"; then
    # Ask instead of block: Claude Code shows the user an Allow / Deny prompt
    if command -v jq >/dev/null 2>&1; then
      jq -n --arg reason "Guarded command (matches '$pattern'). Allow only if you want it to run." '{
        hookSpecificOutput: {
          hookEventName: "PreToolUse",
          permissionDecision: "ask",
          permissionDecisionReason: $reason
        }
      }'
    else
      echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"Guarded command. Allow only if you want it to run."}}'
    fi
    exit 0
  fi
done

exit 0

#!/bin/bash

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command')

DANGEROUS_PATTERNS=(
  "git push"
  "git reset --hard"
  "git clean -fd"
  "git clean -f"
  "git branch -D"
  "git checkout \."
  "git restore \."
  "push --force"
  "reset --hard"
  # rm with both recursive and force: -rf, -fr, -Rf, -rfv, -r -f, --recursive --force
  "(^|[;&|(/ ])rm( [^;&|]*)? +(-[[:alnum:]]*[rR]|--recursive)([[:alnum:]]*f|( [^;&|]*)? +(-[[:alnum:]]*f|--force))"
  "(^|[;&|(/ ])rm( [^;&|]*)? +(-[[:alnum:]]*f|--force)([[:alnum:]]*[rR]|( [^;&|]*)? +(-[[:alnum:]]*[rR]|--recursive))"
)

for pattern in "${DANGEROUS_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qE "$pattern"; then
    # Ask instead of block: Claude Code shows the user an Allow / Deny prompt
    jq -n --arg reason "Guarded command (matches '$pattern'). Allow only if you want it to run." '{
      hookSpecificOutput: {
        hookEventName: "PreToolUse",
        permissionDecision: "ask",
        permissionDecisionReason: $reason
      }
    }'
    exit 0
  fi
done

exit 0

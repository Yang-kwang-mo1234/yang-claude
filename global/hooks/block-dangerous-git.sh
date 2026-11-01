#!/bin/bash

INPUT=$(cat)
# Without jq, match against the raw JSON so the guard still works
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command' 2>/dev/null) || COMMAND="$INPUT"

# Spaces and tabs between words
S="[[:space:]]+"
# What may come right before a command: line start, ; & | ( `, a quote (bash -c "rm ..."), a space, / (/bin/rm) or \ (\rm)
PRE="(^|[;&|(\`\"'[:space:]/\\])"
# "git" plus any global options before the subcommand: -C <path>, -c <key=value>, --no-pager ...
GIT="git($S(-[Cc]|--git-dir|--work-tree|--namespace)$S[^[:space:];&|]+|$S-[^[:space:];&|]+)*"

DANGEROUS_PATTERNS=(
  "$GIT${S}push"
  # every commit asks, so the user always confirms it with a button
  "$GIT${S}commit($|[[:space:];&|\"'])"
  "$GIT${S}reset$S--hard"
  "$GIT${S}clean([[:space:]][^;&|]*)?$S(-[[:alnum:]]*f|--force)"
  "$GIT${S}branch([[:space:]][^;&|]*)?$S-D"
  # "." alone, not a file name that starts with a dot (.gitignore)
  "$GIT$S(checkout|restore)($S--)?$S\.($|[[:space:];&|])"
  "$GIT${S}stash$S(drop|clear)"
  "$GIT${S}update-ref([[:space:]][^;&|]*)?$S-d"
  "$GIT${S}filter-(branch|repo)"
  "push$S--force"
  "reset$S--hard"
  # any recursive rm: -r, -R, -rf, -fr, -rfv, -f -r, --recursive
  "${PRE}rm([[:space:]][^;&|]*)?$S(-[[:alnum:]]*[rR]|--recursive)"
  "${PRE}find([[:space:]][^;&|]*)?$S(-delete|-exec(dir)?${S}rm)"
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

#!/bin/sh
# SessionStart hook: inject activation + review state as additionalContext.
# From .claude/skills/task-observer/references/environments.md ("A session-start hook").
OBS_WORKSPACE="/Users/jerry/.claude/task-observer"
d="$OBS_WORKSPACE/skill-observations"      # the pinned absolute path
open=$(find "$d/observation-log" -maxdepth 1 -name '*.md' -exec grep -l '^status: open$' {} + 2>/dev/null | wc -l | tr -d ' ')
last=$(tr -d '\r' 2>/dev/null < "$d/last-review-date.txt"); last=${last:-never}   # a CRLF file must not carry \r into the JSON
msg="Make the first tool call of this session one batched call that both lists the task-observer workspace ($OBS_WORKSPACE) and invokes the task-observer skill; then run its Session Start Protocol. Observation files are created only by scripts/new-observation.sh in the skill directory, never by copying a header."
msg="$msg $open open observations in $d; last review: $last."   # always, zero included: a mispinned path reads 0 too
if [ "$open" -gt 0 ]; then
  cutoff=$(date -d '7 days ago' +%F 2>/dev/null || date -v-7d +%F)   # GNU, then BSD/macOS
  case "$last" in
    (never) msg="$msg Offer the review." ;;
    (*) [ "$(printf '%s\n%s\n' "$last" "$cutoff" | sort | head -1)" = "$last" ] && msg="$msg Offer the review." ;;
  esac
fi
msg=$(printf '%s' "$msg" | sed 's/\\/\\\\/g; s/"/\\"/g' | tr -d '\000-\037')   # JSON string: escape \ and ", drop control characters
printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"%s"}}\n' "$msg"

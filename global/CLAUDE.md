# CLAUDE.md

## Guarded commands

- `~/.claude/hooks/block-dangerous-git.sh` doesn't block guarded commands (git push, reset --hard, rm -rf and so on). It asks me with an Allow / Deny prompt instead.
- Run a guarded command on its own, not chained with other commands, so the prompt shows exactly what will run.
- If I deny it, or it is refused anyway, don't retry it, split it up, or run it another way (for example through the Terminal panel). Tell me what was refused and stop that step.
- After it runs, check the result (for example `git status`) before going on.

## Plans and diagrams

- When you write a plan as a document (an implementation plan, roadmap or rollout, or the plan you draft in plan mode), use the `html-plan` skill and make it a self-contained HTML file. The app's task list under a message stays as it is.
- When you draw a flow, process, sequence, state machine or architecture, use the `html-diagram` skill.
- Both skills come from plannotator/effective-html (MIT) and live in `~/.claude/skills/`. Their descriptions were changed locally so they trigger on their own; the rest is upstream as is.

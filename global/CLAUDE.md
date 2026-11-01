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

## Graphify

- When a project's `CLAUDE.md`, `AGENTS.md` or `.claude/` settings already have graphify instructions (for example a section or hook written by `graphify claude install`), follow them. They win over the defaults below.
- Otherwise, when `graphify-out/graph.json` exists, answer questions about the code's structure with `graphify query`, `path` or `explain` before grepping or reading whole files. Without a graph, use plain search and mention that `/graphify .` can build one.
- `graphify update` (or the Graft Update button above the prompt) refreshes the graph with the code files changed since the last build. Doc, paper and image changes need `/graphify --update`.
- The block below is written by `graphify install --platform claude`; leave it for the installer to refresh.

# graphify
- **graphify** (`~/.claude/skills/graphify/SKILL.md`) - any input to knowledge graph. Trigger: `/graphify`
When the user types `/graphify`, use the installed graphify skill or instructions before doing anything else.

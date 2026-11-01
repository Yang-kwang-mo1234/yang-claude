# CLAUDE.md

## Language

- 사용자에게 보이는 답변, 요약, 표는 항상 한국어로 쓴다. 코드, 명령어, 커밋 메시지, 파일 내용은 원래 언어를 따른다.

## Subagents and models

- Subagents default to Sonnet (`CLAUDE_CODE_SUBAGENT_MODEL` in `settings.json`).
- When a search or read would take many tool calls or flood the context (sweeping many files, summarizing long logs or output), hand it to the `quick` agent (Haiku) instead of doing it inline. A lookup that takes a call or two stays inline.
- Design, debugging, code review and writing code stay with the main model or a Sonnet subagent.

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
- The Graft button above the prompt reads **Graft Init** in a folder with no graph and builds the code graph (`graphify update .`). Once a graph exists it reads **Graft Update**, which runs `graphify update` to add the code files changed since the last build. Doc, paper and image changes need `/graphify .` or `/graphify --update`.
- The block below is written by `graphify install --platform claude`; leave it for the installer to refresh.

# graphify
- **graphify** (`~/.claude/skills/graphify/SKILL.md`) - any input to knowledge graph. Trigger: `/graphify`
When the user types `/graphify`, use the installed graphify skill or instructions before doing anything else.

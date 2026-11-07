# CLAUDE.md

## Language

- 사용자에게 보이는 답변, 요약, 표는 항상 한국어로 쓴다. 코드, 명령어, 커밋 메시지, 파일 내용은 원래 언어를 따른다.

## Subagents

- A search or read that would take many tool calls or flood the context (sweeping many files, summarizing long logs or output) goes to the `quick` agent (Haiku). A lookup of a call or two stays inline.
- Design, debugging, code review and writing code stay with the main model or a Sonnet subagent.
- A subagent that only writes or fixes code from a clear spec (for example a superpowers implementer task) is the `implementer` agent.

## Guarded commands

- A hook asks me Allow / Deny before guarded commands (git push, git commit, reset --hard, stash drop, rm -r, find -delete and so on).
- Every `git commit` goes through that prompt, even when I asked for it in chat. Never avoid the prompt (another command, a script, the Terminal panel).
- Run a guarded command on its own, not chained, so the prompt shows exactly what will run.
- If I deny it or it is refused, don't retry, split it up, or run it another way. Tell me what was refused and stop that step.
- After it runs, check the result (for example `git status`) before going on.

# graphify
- **graphify** (`~/.claude/skills/graphify/SKILL.md`) - any input to knowledge graph. Trigger: `/graphify`
When the user types `/graphify`, use the installed graphify skill or instructions before doing anything else.

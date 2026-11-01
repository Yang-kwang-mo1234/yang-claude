---
name: skills-update
description: 설치된 스킬 중 업스트림이 바뀐 것을 찾아 업데이트한다. /skills-update 로만 실행.
disable-model-invocation: true
---

# Skills Update

1. `node ~/.claude/skills/skills-update/check.mjs` 실행. 출력이 없으면 "업데이트 없음"이라고 말하고 끝낸다.
2. 출력된 줄(`종류 이름 저장소 경로 새해시`)을 표로 보여 주고, 종류별로 업데이트한다.

- **cli**: `npx -y skills update -g -y <이름...>` 한 번에 실행.
- **copy** (`~/.claude/skills/<이름>`, 로컬 수정 있음):
  1. 스크래치 폴더에 받기: `gh api "repos/<저장소>/tarball/HEAD" > s.tgz`, 압축을 풀고 `<경로>` 폴더만 쓴다.
  2. `diff -r ~/.claude/skills/<이름> <받은 폴더>`로 바뀐 내용을 2~3줄로 요약한다.
  3. 받은 폴더로 덮어쓴 뒤, `sources.json`의 `local`에 적힌 로컬 수정(예: description, `## Contents` 목차)을 기존 파일 그대로 다시 넣는다. 새 섹션이 생겼으면 목차에 추가한다.
  4. `sources.json`의 그 스킬 `hash`를 새해시로 바꾼다.
- **graphify**: `uv tool upgrade graphifyy` 후 `graphify install --platform claude`. 덮어써진 `SKILL.md`에 `## Contents` 목차를 다시 넣는다.
- **error**: 저장소나 경로를 찾지 못한 것. 고치지 말고 보고만 한다.

3. 끝나면 업데이트한 스킬과 바뀐 내용을 짧게 보고한다. `~/workspace/yang-claude/global/skills/`에도 복사본이 있으면 같은 파일로 맞추되, 커밋은 하지 않는다.

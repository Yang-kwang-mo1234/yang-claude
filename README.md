# yang-claude

이 저장소에 설치한 Claude Code 스킬, 플러그인, 훅, MCP 서버를 정리한 문서입니다.
각 항목의 요청 프롬프트를 Claude Code에 그대로 붙여 넣으면 같은 설정을 다시 만들 수 있습니다.

## 새 PC에 설치하기

```bash
git clone https://github.com/Yang-kwang-mo1234/yang-claude.git && cd yang-claude && ./install.sh
```

`install.sh`는 `global/` 폴더의 전역 설정을 `~/.claude`에 설치합니다. `jq`가 필요합니다 (`brew install jq`).

- 스킬, 훅, `CLAUDE.md`는 PC에 없을 때만 복사합니다. 이미 있으면 건드리지 않습니다.
- graphify CLI가 없으면 `uv tool install graphifyy`로 설치합니다. `uv`가 없으면 설치 방법만 알려 줍니다.
- `settings.json`은 합칩니다. 기존 값이 우선이고, 훅은 한 번만 추가됩니다. 원래 파일은 실행할 때마다 `settings.json.bak.날짜-시각`으로 따로 남깁니다.
- 여러 번 실행해도 안전합니다.
- 설치 후 Claude Code를 다시 시작해야 적용됩니다.

### 전역 설정 (`global/` → `~/.claude/`)

| 이름 | 종류 | 하는 일 |
|---|---|---|
| `CLAUDE.md` | 전역 지침 | 위험 명령 처리 규칙, 계획/다이어그램은 HTML 스킬 사용, graphify 사용 규칙 |
| `block-dangerous-git.sh` | 훅 (PreToolUse, Bash) | `git push`, `reset --hard`, `rm -rf` 등을 실행 전에 Allow / Deny로 확인. `git -C 경로 push`처럼 옵션이 끼어도 잡고, `jq`가 없어도 동작 |
| find-skills | 스킬 | 필요한 스킬을 찾아 설치 |
| html-plan | 스킬 | 계획 문서를 HTML 파일로 작성 (plannotator/effective-html, 설명만 수정) |
| html-diagram | 스킬 | 흐름도, 구조도를 HTML로 작성 (plannotator/effective-html, 설명만 수정) |
| karpathy-guidelines | 스킬 | 코딩 실수를 줄이는 작업 원칙 |
| skills-update | 스킬 | `/skills-update`로 업스트림이 바뀐 스킬을 찾아 업데이트. 확인은 Node 스크립트(`check.mjs`, macOS/Windows 공통)가 GitHub 폴더 해시만 비교하고, 로컬 수정은 `sources.json`에 적어 둔 대로 다시 넣음 |
| graphify | 스킬 | 코드, 문서, 이미지를 지식 그래프로 만들고 `query`/`path`/`explain`으로 질문 (Graphify-Labs/graphify, 목차만 추가) |
| agent-monitor-pane | 플러그인 | 채팅 옆 모니터 창, 입력창 위 git 브랜치 줄과 **Graft Init / Update** 버튼. `settings.json`의 마켓플레이스 설정으로 GitHub에서 자동 설치 |

스킬 문서(`SKILL.md`)마다 맨 위에 목차(`## Contents`)가 있습니다.

PC의 전역 설정을 바꾼 뒤에는 바뀐 파일을 `global/`에 다시 복사해서 커밋하세요.

## 설치 현황

| 이름 | 종류 | 설정 위치 | 하는 일 |
|---|---|---|---|
| commit-commands | 플러그인 (스킬) | `.claude/settings.json` | `/commit`, `/commit-push-pr`로 커밋과 PR 작업 |
| superpowers | 플러그인 (스킬) | `.claude/settings.json` | 브레인스토밍, 계획, TDD, 디버깅, 코드 리뷰 같은 작업 절차 스킬 모음 |
| context7 | MCP 서버 | `.mcp.json` | 라이브러리의 최신 공식 문서 조회 |
| protect-secrets | 훅 | `.claude/settings.json`, `.claude/hooks/protect-secrets.sh` | `.env`, 키, 인증서 파일 수정 차단 |

---

## 1. Commit Commands 플러그인

```text
아래 Anthropic 공식 GitHub 저장소의 Commit Commands 플러그인을 설치해 줘.

GitHub:
https://github.com/anthropics/claude-plugins-official/tree/main/plugins/commit-commands

1. 공식 문서에서 최신 설치 방법을 확인하고 플러그인을 현재 프로젝트 범위로 설치해 줘.
2. 설치가 끝나면 플러그인에 들어 있는 명령어 목록을 확인해 줘.
3. 각 명령어가 어떤 일을 하는지 초보자도 이해할 수 있게 설명해 줘.
4. 현재 저장소의 GitHub 연결과 gh 로그인 상태를 확인해서 바로 쓸 수 있는지 알려 줘.

설치 후에는 실제로 커밋하지 말고 사용 방법만 보여 줘.
```

- 설치 명령: `claude plugin install commit-commands@anthropic-plugin-directory --scope project`
- 명령어:
  - `/commit-commands:commit`: 변경 내용을 보고 커밋 메시지를 써서 커밋
  - `/commit-commands:commit-push-pr`: 커밋, 푸시, PR 생성을 한 번에 실행
  - `/commit-commands:clean_gone`: 원격에서 지워진 로컬 브랜치 정리

## 2. Superpowers 플러그인

```text
아래 GitHub 저장소의 Superpowers 플러그인을 Anthropic 공식 플러그인 디렉터리에서 설치해 줘.

GitHub:
https://github.com/obra/superpowers

1. 공식 문서에서 최신 설치 방법을 확인하고 플러그인을 현재 프로젝트 범위로 설치해 줘.
2. 설치가 끝나면 플러그인에 들어 있는 스킬 목록을 확인해 줘.
3. 각 스킬이 언제 쓰이는지 초보자도 이해할 수 있게 설명해 줘.
4. 스킬이 커밋이나 푸시를 하려고 할 때 CLAUDE.md의 커밋 규칙이 우선하는지 확인해 줘.

설치 후에는 실제 작업을 시작하지 말고 사용 방법만 보여 줘.
```

- 설치 명령: `claude plugin install superpowers@anthropic-plugin-directory --scope project`
- 동작: 세션을 시작할 때 `using-superpowers` 스킬이 자동으로 실행되고, 작업에 맞는 스킬을 Claude가 알아서 고릅니다. 직접 부를 때는 `/superpowers:brainstorming`처럼 씁니다.
- 주요 스킬:
  - `brainstorming`: 기능을 만들기 전에 요구사항과 설계를 먼저 정리
  - `writing-plans`, `executing-plans`: 구현 계획을 쓰고 그대로 실행
  - `test-driven-development`: 테스트를 먼저 쓰고 구현
  - `systematic-debugging`: 버그 원인을 찾은 뒤에 고치기
  - `requesting-code-review`, `receiving-code-review`: 코드 리뷰 요청과 반영
  - `verification-before-completion`: 끝났다고 말하기 전에 실제로 확인
- 커밋 규칙: 일부 스킬은 단계 중에 커밋하라고 하지만, 이 저장소의 `CLAUDE.md`가 우선합니다. Claude는 커밋, 푸시 전에 항상 먼저 묻습니다.

## 3. context7 MCP 서버

```text
아래 GitHub 저장소의 context7 MCP 서버를 현재 프로젝트에 추가해 줘.

GitHub:
https://github.com/upstash/context7

1. 공식 문서에서 최신 설치 방법을 확인하고 프로젝트 범위(.mcp.json)로 추가해 줘.
2. 추가가 끝나면 서버 연결 상태를 확인해 줘.
3. MCP 서버가 무엇이고 context7이 어떤 문제를 해결하는지 초보자도 이해할 수 있게 설명해 줘.
4. 실제로 사용할 때 어떻게 요청하면 되는지 예시를 보여 줘.

승인이 필요한 단계가 있으면 내가 해야 할 일을 알려 줘.
```

- 설치 명령: `claude mcp add --scope project context7 -- npx -y @upstash/context7-mcp`
- 처음 쓸 때: 새 세션을 시작하면 프로젝트 MCP 서버 승인 창이 한 번 뜹니다. 승인해야 켜집니다.
- 사용법: 요청에 "context7로 최신 문서 확인해서"를 덧붙입니다.

## 4. 비밀 파일 보호 훅 (protect-secrets)

```text
Claude Code 공식 훅 문서를 참고해서 비밀 파일 보호 훅을 현재 프로젝트에 만들어 줘.

문서:
https://code.claude.com/docs/en/hooks

1. Claude가 파일을 수정하거나 만들기 전에 실행되는 PreToolUse 훅을 .claude/settings.json에 등록해 줘.
2. .env, .env.*, *.pem, *.key, id_rsa, credentials.json 같은 비밀 파일은 수정을 막아 줘.
3. .env.example, .env.sample, .env.template 같은 예시 파일은 허용해 줘.
4. 훅 스크립트는 .claude/hooks/protect-secrets.sh에 만들어 줘.
5. 차단되는 경우와 허용되는 경우를 직접 테스트해서 결과를 보여 줘.

훅이 무엇이고 왜 필요한지 초보자도 이해할 수 있게 설명해 줘.
```

- 동작: 대상 파일이 비밀 파일이면 exit code 2로 작업을 막고, Claude에게 사용자가 직접 수정하라고 안내합니다.
- 차단되는 파일: `.env`, `.env.*`, `*.pem`, `*.key`, `*.p12`, `*.pfx`, `id_rsa*`, `id_ed25519*`, `credentials.json`, `secrets.*`

## 5. graphify 스킬과 Graft Init / Update 버튼

```text
아래 GitHub 저장소의 graphify 스킬을 Claude Code 전역(~/.claude/skills)에 설치해 줘.

GitHub:
https://github.com/Graphify-Labs/graphify

1. graphify CLI를 최신 버전으로 설치하고, Claude Code용 스킬을 전역으로 설치해 줘.
2. 기존 지침(CLAUDE.md, AGENTS.md)에 graphify 관련 설정이 있으면 그 지침을 따르도록 전역 CLAUDE.md에 규칙을 넣어 줘.
3. agent-monitor 플러그인의 입력창 위 git 브랜치 줄 오른쪽 끝에 "Graft Update" 버튼을 만들어 줘.
   누르면 처음 그래프를 만든 뒤 바뀐 파일을 다시 반영하는 graphify update를 실행해야 해.
4. 브랜치 이름이 길면 버튼이 아래로 밀리지 않도록 이름 뒤쪽을 "..."으로 잘라 줘.
5. graphify init이 안 된 프로젝트라면 버튼을 "Graft Init"으로 바꿔서 누르면 그래프를 처음 만들게 해 줘.
6. 테스트로 검증하고 이상이 없으면 커밋하고 푸시해 줘.
```

- CLI 설치: `uv tool install --upgrade graphifyy` (`install.sh`가 없을 때 대신 설치합니다)
- 스킬 설치: `graphify install --platform claude`. `~/.claude/skills/graphify`에 스킬을 복사하고, 전역 `CLAUDE.md` 끝에 `# graphify` 등록 블록을 씁니다. 이 블록은 설치 프로그램이 관리하니 직접 고치지 않습니다.
- 처음 쓸 때: 프로젝트 폴더에서 Claude에게 `/graphify .`를 요청하면 `graphify-out/`에 그래프(`graph.json`), 대화형 HTML, `GRAPH_REPORT.md`가 생깁니다. 코드만 있으면 LLM 비용이 없고, 문서·이미지가 있으면 토큰이 듭니다.
- 질문: `graphify query "인증은 어떻게 동작해?"`, `graphify path "A" "B"`, `graphify explain "X"`
- 지침 (`global/CLAUDE.md`의 `## Graphify`):
  - 프로젝트의 `CLAUDE.md`, `AGENTS.md`, `.claude/` 설정에 graphify 지침이 이미 있으면(예: `graphify claude install`이 쓴 섹션이나 훅) 그 지침을 따릅니다.
  - 없으면 `graphify-out/graph.json`이 있을 때 코드 구조 질문은 graphify로 먼저 찾습니다. 그래프가 없으면 평소처럼 검색합니다.
- **Graft Init / Graft Update 버튼** (agent-monitor-pane 0.2.8 이상):
  - 입력창 위 git 브랜치 줄 오른쪽 끝에 있습니다.
  - 세션 폴더에 그래프(`graphify-out/graph.json`)가 없으면 **Graft Init**입니다. 누르면 `graphify update .`로 코드 그래프를 처음 만들고, 버튼이 **Graft Update**로 바뀝니다.
  - **Graft Update**를 누르면 `graphify update`로 처음 만든 뒤 바뀐 코드 파일을 반영합니다. 코드는 매번 빠르게 다시 읽지만, 바뀐 것이 없으면 그래프 파일은 그대로 둡니다.
  - 둘 다 LLM 비용이 없고, 결과를 알림으로 보여 줍니다.
  - 코드만 그래프로 만듭니다. 문서·이미지까지 넣으려면 Claude에게 `/graphify .`(처음)나 `/graphify --update`(이후)를 요청하세요.
  - 그래프는 프로젝트의 `graphify-out/`에 생깁니다. 커밋하지 않으려면 그 프로젝트의 `.gitignore`에 `graphify-out/`을 넣으세요.
  - 브랜치 이름이 길면 버튼이 다음 줄로 밀리지 않도록 이름 뒤쪽을 `...`으로 자릅니다.
- 이미 설치된 패널은 패널 아래쪽 **Update** 버튼으로 0.2.8을 받은 뒤 새 세션을 열면 버튼이 나옵니다.

## 6. skills-update 스킬

```text
"/skills-update"로 동작하는 스킬을 만들어 줘.
설치된 스킬 중 업스트림이 업데이트된 스킬을 찾고, 업데이트가 있으면 지침에 따라 업데이트해야 해.
가장 간단하고 토큰을 적게 쓰는 방법으로 만들고, Windows에서도 동작하게 Node로 작성해 줘.
```

- 설치: `./install.sh`가 `global/skills/skills-update`를 `~/.claude/skills/skills-update`에 복사합니다. 직접 설치하려면 이 폴더를 그대로 복사하세요. 설치 후 Claude Code를 다시 시작합니다.
- 필요한 것: Node 18 이상, `gh` (`gh auth login`으로 로그인). macOS와 Windows(Git Bash)에서 똑같이 동작하고, `jq`는 필요 없습니다.
- 사용: Claude Code에서 `/skills-update`를 입력합니다. `disable-model-invocation: true`라서 입력할 때만 실행되고, 평소에는 스킬 목록에 설명이 올라가지 않습니다.
- 동작:
  1. `check.mjs`가 스킬마다 GitHub 폴더 해시(트리 SHA)를 비교해서 바뀐 스킬만 출력합니다. 바뀐 것이 없으면 Claude가 파일을 읽지 않고 끝나서 토큰을 거의 쓰지 않습니다.
  2. `npx skills`로 설치한 스킬(`~/.agents/.skill-lock.json`)은 `npx skills update -g -y`로 업데이트합니다.
  3. `~/.claude/skills`에 복사한 스킬은 업스트림 파일로 덮어쓰고, `sources.json`의 `local`에 적힌 로컬 수정(description, `## Contents` 목차)을 다시 넣은 뒤 해시를 갱신합니다.
  4. graphify는 PyPI 버전을 비교하고, 바뀌었으면 `uv tool upgrade graphifyy`와 `graphify install --platform claude`를 실행합니다.
- 복사본 스킬을 새로 추가하면 `sources.json`에 저장소(`repo`), 경로(`path`), 현재 해시(`hash`), 로컬 수정 내용(`local`)을 한 줄 추가하세요. 현재 해시는 `gh api repos/<저장소>/git/trees/HEAD:<경로> --jq .sha`로 확인합니다.
- 커밋은 하지 않습니다. 업데이트한 뒤 `global/skills/`의 복사본을 맞추고 직접 커밋하세요.

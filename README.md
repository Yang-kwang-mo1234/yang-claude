# yang-claude

이 저장소에 설치한 Claude Code 스킬, 플러그인, 훅, MCP 서버를 정리한 문서입니다.
각 항목의 요청 프롬프트를 Claude Code에 그대로 붙여 넣으면 같은 설정을 다시 만들 수 있습니다.

## 설치 현황

| 이름 | 종류 | 설정 위치 | 하는 일 |
|---|---|---|---|
| commit-commands | 플러그인 (스킬) | `.claude/settings.json` | `/commit`, `/commit-push-pr`로 커밋과 PR 작업 |
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

## 2. context7 MCP 서버

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

## 3. 비밀 파일 보호 훅 (protect-secrets)

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

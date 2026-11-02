# Changelog

## v1.0.0 - 2026-11-02

첫 릴리스. 지금까지 정리한 전역 설정을 묶었습니다.

- 전역 `CLAUDE.md`: 한국어 응답, 하위 에이전트 모델 규칙, 위험 명령 처리, 계획·다이어그램은 HTML 스킬, graphify 사용 규칙
- 에이전트: `quick`(Haiku), `implementer`(Sonnet)
- 훅: `block-dangerous-git.sh`(커밋·push·삭제 명령 확인), `protect-secrets.sh`(비밀 파일 보호)
- `settings.json`: Sonnet 하위 에이전트, `permissions.ask`·`autoMode.soft_deny` 이중 안전망, agent-monitor 플러그인
- 스킬: find-skills, html-plan, html-diagram, graphify
- `install.sh`로 새 PC에 설치, 이후 업데이트는 yang-skills의 `/skills-update`로 릴리스 단위 반영

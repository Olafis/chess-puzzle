# 기여 가이드

버그 수정, 기능 제안, PR을 환영합니다.

## 개발 환경 설정

1. [README.md](README.md)의 빠른 시작 따라하기
2. `web/.env` 및 `pipeline/.env` 설정 (각 `.env.example` 참고)

### pipeline 가상환경 (선택)

`pipeline/` Python 스크립트는 가상환경 없이 `pip install -r requirements.txt`로도 실행 가능합니다.  
conda를 쓰려면:

```bash
# 생성
conda create -n chess-puzzle python=3.11

# 활성화
conda activate chess-puzzle

# 의존성 설치
cd pipeline && pip install -r requirements.txt
```

## 개발 규칙

- **코드 스타일**: `web/`는 ESLint, `pipeline/`는 PEP 8
- **커밋**: 의미 있는 메시지 작성 (예: `fix: 퍼즐 로딩 오류 수정`)
- **PR**: 변경 사항 요약, 관련 이슈 번호(선택)

## 브랜치

- `main`: 기본 브랜치
- `feature/xxx` 또는 `fix/xxx`: 작업 브랜치

## PR 전 체크리스트

- [ ] `cd web && npm run build` 성공
- [ ] `cd web && npm run lint` 통과
- [ ] `pipeline/` 경로 변경 시 `python scripts/generate_puzzles.py` 등 실행 확인

## 파일 위치 참고

| 경로 | 용도 |
|------|------|
| `web/src/app/` | 페이지 및 API 라우트 |
| `web/src/components/` | 공용 컴포넌트 |
| `web/src/lib/` | 유틸, 인증, DB |
| `pipeline/` | analyzer, tagger, db (모듈) |
| `pipeline/scripts/` | generate_puzzles, clear_db 등 실행 스크립트 |

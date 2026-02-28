# 체스 퍼즐 플랫폼

Lichess 실전 경기에서 추출한 체스 퍼즐을 풀고 레이팅을 겨루는 웹 플랫폼.

## 목차

- [기술 스택](#기술-스택)
- [프로젝트 구조](#프로젝트-구조)
- [빠른 시작](#빠른-시작)
- [문서](#문서)
- [기여하기](#기여하기)

## 기술 스택

| 영역 | 기술 |
|------|------|
| 프론트엔드 | Next.js 15, React, Tailwind CSS |
| 백엔드 | Next.js API Routes, Prisma |
| DB | PostgreSQL |
| 인증 | NextAuth.js (Credentials, Google, GitHub) |
| 퍼즐 생성 | Python, Stockfish, chess, chess.pgn |

## 프로젝트 구조

```
Puzzle_Site/
├── web/                 # Next.js 웹 앱
│   ├── src/
│   │   ├── app/         # 페이지 및 API
│   │   ├── components/
│   │   └── lib/
│   └── prisma/         # 스키마, 마이그레이션
├── pipeline/            # PGN → 퍼즐 생성 (Python)
│   ├── analyzer.py
│   ├── tagger.py
│   ├── db.py
│   └── scripts/         # generate_puzzles, clear_db, test_tagger 등
├── pgn/                 # PGN 파일 (gitignore, 별도 다운로드)
├── docs/                # 내부 문서
│   └── PRD.md
├── docker-compose.yml   # PostgreSQL, Redis (로컬용)
├── DEPLOY.md            # 배포 가이드
└── CONTRIBUTING.md      # 기여 가이드
```

## 빠른 시작

### 1. DB 실행

```bash
docker-compose up -d postgres
```

> Redis는 현재 미사용. 필요 시 `docker-compose up -d` 로 함께 실행.

### 2. 웹 앱

```bash
cd web
cp .env.example .env     # 환경 변수 설정
npm install
npx prisma generate
npm run dev
```

http://localhost:3000 접속

### 3. 퍼즐 생성 (선택)

Lichess PGN 다운로드: https://database.lichess.org/

```bash
conda activate chess-puzzle
cd pipeline
cp .env.example .env     # 환경 변수 설정
python scripts/generate_puzzles.py --pgn ../pgn/lichess_db_xxx.pgn --limit 1000
```

자세한 내용은 [pipeline/README.md](pipeline/README.md) 참고.

## 문서

| 문서 | 설명 |
|------|------|
| [DEPLOY.md](DEPLOY.md) | Vercel + Supabase 배포 가이드 |
| [pipeline/README.md](pipeline/README.md) | 퍼즐 파이프라인 사용법 |
| [CONTRIBUTING.md](CONTRIBUTING.md) | 기여 방법 |
| [docs/PRD.md](docs/PRD.md) | 제품 요구사항 (내부 참고) |

## 기여하기

버그 수정, 기능 제안, PR 환영합니다. [CONTRIBUTING.md](CONTRIBUTING.md)를 먼저 읽어 주세요.

## 라이선스

MIT

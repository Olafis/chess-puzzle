# 퍼즐 파이프라인

체스 PGN 기보에서 퍼즐을 추출하는 파이프라인입니다.

## 구조

```
pipeline/
├── analyzer.py      # Stockfish 기반 블런더 분석
├── tagger.py        # 전술 테마 감지
├── db.py            # DB 접근
├── scripts/         # 실행 스크립트
│   ├── generate_puzzles.py   # 메인: PGN → 퍼즐 생성
│   ├── clear_db.py           # DB 전체 초기화
│   ├── debug_tagger.py       # 테마 감지 디버깅
│   └── test_tagger.py        # tagger 단위 테스트
├── requirements.txt
└── .env.example
```

## 사전 요구사항

- conda `chess-puzzle` 환경
- PostgreSQL (`docker-compose up -d postgres`)
- Stockfish (`pipeline/bin/stockfish_bin` 또는 `STOCKFISH_PATH`)
- Lichess PGN 파일

## 1. 환경 설정

```bash
cd pipeline
cp .env.example .env
# .env에서 DATABASE_URL, STOCKFISH_PATH 등 수정
```

## 2. DB 전체 초기화

```bash
conda activate chess-puzzle
cd pipeline
python scripts/clear_db.py
```

## 3. PGN 기보 준비

https://database.lichess.org/ 에서 다운로드.

경로 예: `../pgn/lichess_db_xxx.pgn` (pipeline에서 상대 경로)

## 4. 퍼즐 생성

```bash
conda activate chess-puzzle
cd pipeline
python scripts/generate_puzzles.py --pgn ../pgn/lichess_db_xxx.pgn
```

### 옵션

| 옵션 | 기본값 | 설명 |
|------|--------|------|
| `--pgn` | (필수) | PGN 파일 경로 |
| `--limit` | 0 (전체) | 분석할 최대 경기 수 |
| `--depth` | 20 | Stockfish 분석 깊이 |
| `--skip` | 0 | 앞에서 건너뛸 경기 수 |
| `--verbose` | - | 상세 로그 |

### 예시

```bash
python scripts/generate_puzzles.py --pgn ../pgn/xxx.pgn --limit 500
python scripts/generate_puzzles.py --pgn ../pgn/xxx.pgn --skip 1000 --limit 2000
python scripts/generate_puzzles.py --pgn ../pgn/xxx.pgn --verbose
```

## 환경 변수 (.env)

| 변수 | 설명 |
|------|------|
| `DATABASE_URL` | PostgreSQL 연결 문자열 |
| `STOCKFISH_PATH` | Stockfish 경로 (기본: `pipeline/bin/stockfish_bin`) |
| `STOCKFISH_DEPTH` | 분석 깊이 (기본 20) |
| `MIN_ADVANTAGE` | 블런더 감지 임계값 (기본 2.0) |

## 유틸리티 스크립트

| 스크립트 | 용도 |
|----------|------|
| `scripts/test_tagger.py` | tagger 단위 테스트 (DB 불필요) |
| `scripts/debug_tagger.py` | DB 퍼즐의 테마 감지 결과 상세 출력 |

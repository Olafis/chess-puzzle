"""
DB 접근 모듈.

퍼즐, 경기(Game) CRUD 및 Prisma 스키마와 연동.
pipeline/ 디렉터리에서 실행 시 .env의 DATABASE_URL 사용.
"""
import os
import psycopg2
import psycopg2.extras
from dotenv import load_dotenv
from dataclasses import dataclass
from typing import Optional
from nanoid import generate

# URL-safe 알파뉴메릭 ID (리체스 스타일, 8자)
PUZZLE_ID_ALPHABET = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
PUZZLE_ID_SIZE = 5

def new_puzzle_id() -> str:
    return generate(PUZZLE_ID_ALPHABET, PUZZLE_ID_SIZE)

# pipeline/.env 로드 (실행 위치와 무관)
load_dotenv(os.path.join(os.path.dirname(os.path.abspath(__file__)), ".env"))


@dataclass
class GameRecord:
    pgn: str
    white_player: str
    black_player: str
    white_elo: Optional[int]
    black_elo: Optional[int]
    event: Optional[str]
    site: Optional[str]
    date: Optional[str]
    result: Optional[str]
    source: Optional[str]  # lichess game ID


@dataclass
class PuzzleRecord:
    fen: str
    moves: list[str]              # UCI 포맷 정답 수순
    rating: int
    themes: list[str]             # PuzzleTheme enum values
    game_phase: str               # OPENING / MIDDLEGAME / ENDGAME
    opening_eco: Optional[str]
    opening_name: Optional[str]
    source_game_id: Optional[str]
    move_index: Optional[int]
    blunder_move: Optional[str]       # 상대가 둔 블런더 수 (UCI)
    pre_blunder_fen: Optional[str]    # 블런더 직전 포지션 FEN (인트로 애니메이션용)


def get_connection():
    return psycopg2.connect(os.environ["DATABASE_URL"])


def upsert_game(conn, game: GameRecord) -> Optional[str]:
    """경기를 DB에 저장하고 ID를 반환. 이미 있으면 기존 ID 반환."""
    with conn.cursor() as cur:
        cur.execute(
            """
            INSERT INTO "Game" (id, pgn, "whitePlayer", "blackPlayer",
                "whiteElo", "blackElo", event, site, date, result, source, "createdAt")
            VALUES (gen_random_uuid()::text, %s, %s, %s, %s, %s, %s, %s,
                %s::timestamptz, %s, %s, NOW())
            ON CONFLICT (source) DO UPDATE SET source = EXCLUDED.source
            RETURNING id
            """,
            (
                game.pgn,
                game.white_player,
                game.black_player,
                game.white_elo,
                game.black_elo,
                game.event,
                game.site,
                game.date,
                game.result,
                game.source,
            ),
        )
        row = cur.fetchone()
        return row[0] if row else None


# Prisma PuzzleTheme enum과 동기화 (SQL 인젝션 방지)
ALLOWED_THEMES = frozenset({
    "FORK", "PIN", "SKEWER", "DISCOVERED_ATTACK", "DOUBLE_CHECK",
    "MATE_IN_1", "MATE_IN_2", "MATE_IN_3", "MATE_IN_4", "MATE_IN_5",
    "QUEEN_SACRIFICE", "ROOK_ENDGAME", "PAWN_PROMOTION", "TRAP",
    "BACK_RANK", "HANGING_PIECE", "DEFLECTION", "DECOY", "INTERFERENCE", "ZUGZWANG",
})


def insert_puzzle(conn, puzzle: PuzzleRecord) -> Optional[str]:
    """퍼즐을 DB에 저장. 동일 FEN이 이미 있으면 스킵."""
    with conn.cursor() as cur:
        # 동일 FEN 중복 체크
        cur.execute('SELECT id FROM "Puzzle" WHERE fen = %s LIMIT 1', (puzzle.fen,))
        if cur.fetchone():
            return None

        # 테마 화이트리스트 검증 (SQL 인젝션 방지)
        safe_themes = [t for t in puzzle.themes if t in ALLOWED_THEMES]
        if not safe_themes:
            safe_themes = ["HANGING_PIECE"]
        themes_sql = "{" + ",".join(safe_themes) + "}"

        cur.execute(
            """
            INSERT INTO "Puzzle" (id, fen, moves, rating, themes, "gamePhase",
                "openingEco", "openingName", "sourceGameId", "moveIndex",
                "blunderMove", "preBblunderFen",
                "isActive", "createdAt", "updatedAt",
                "ratingDeviation", volatility, "solveCount", "failCount",
                "likeCount", "dislikeCount")
            VALUES (%s, %s, %s, %s, %s::"PuzzleTheme"[],
                %s::"GamePhase", %s, %s, %s, %s, %s, %s,
                true, NOW(), NOW(),
                350, 0.06, 0, 0, 0, 0)
            RETURNING id
            """,
            (
                new_puzzle_id(),
                puzzle.fen,
                puzzle.moves,
                puzzle.rating,
                themes_sql,
                puzzle.game_phase,
                puzzle.opening_eco,
                puzzle.opening_name,
                puzzle.source_game_id,
                puzzle.move_index,
                puzzle.blunder_move,
                puzzle.pre_blunder_fen,
            ),
        )
        row = cur.fetchone()
        return row[0] if row else None


def puzzle_count(conn) -> int:
    with conn.cursor() as cur:
        cur.execute('SELECT COUNT(*) FROM "Puzzle"')
        return cur.fetchone()[0]

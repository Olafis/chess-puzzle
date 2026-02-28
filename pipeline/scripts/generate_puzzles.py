"""
체스 퍼즐 생성 파이프라인 CLI.

사용법:
  conda activate chess-puzzle
  cd pipeline && python scripts/generate_puzzles.py --pgn ../pgn/lichess_db_xxx.pgn
"""
import os
import sys

_PIPELINE_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, _PIPELINE_ROOT)

import click
import chess
import chess.pgn
from tqdm import tqdm

from analyzer import analyze_game, PuzzleCandidate
from tagger import detect_themes, detect_game_phase
from db import get_connection, upsert_game, insert_puzzle, puzzle_count
from db import GameRecord, PuzzleRecord


def parse_elo(value: str | None) -> int | None:
    try:
        return int(value) if value and value != "?" else None
    except ValueError:
        return None


def parse_date(value: str | None) -> str | None:
    if not value or value == "????.??.??":
        return None
    try:
        parts = value.split(".")
        if len(parts) == 3 and all(p.isdigit() for p in parts):
            return f"{parts[0]}-{parts[1]}-{parts[2]}T00:00:00Z"
    except Exception:
        pass
    return None


def extract_lichess_id(site: str | None) -> str | None:
    if not site:
        return None
    parts = site.rstrip("/").split("/")
    return parts[-1] if parts else None


def estimate_puzzle_rating(
    white_elo: int | None,
    black_elo: int | None,
    eval_change: float,
    solution_moves: list[str],
    themes: list[str],
) -> int:
    """
    블런더 강도, 플레이어 레이팅, 수순 길이, MATE_IN_N 테마로 퍼즐 난이도 추정.
    """
    base = 1500
    if white_elo and black_elo:
        base = (white_elo + black_elo) // 2

    if eval_change >= 8.0:
        eval_mod = -200
    elif eval_change >= 5.0:
        eval_mod = -100
    elif eval_change >= 3.0:
        eval_mod = 0
    else:
        eval_mod = +100

    attacker_moves = (len(solution_moves) + 1) // 2
    if attacker_moves >= 4:
        length_mod = 300
    elif attacker_moves >= 3:
        length_mod = 200
    elif attacker_moves >= 2:
        length_mod = 100
    else:
        length_mod = 0

    mate_mod = 0
    for t in themes:
        if t.startswith("MATE_IN_"):
            try:
                n = int(t.split("_")[-1])
                mate_mod = max(mate_mod, (n - 1) * 80)
            except ValueError:
                pass
            break

    return max(600, min(3000, base + eval_mod + length_mod + mate_mod))


@click.command()
@click.option("--pgn", required=True, type=click.Path(exists=True),
              help="PGN 파일 경로")
@click.option("--limit", default=0, type=int,
              help="분석할 최대 경기 수 (0 = 전체)")
@click.option("--depth", default=20, type=int,
              help="Stockfish 분석 깊이")
@click.option("--min-advantage", default=2.0, type=float,
              help="블런더 탐지 최소 평가값 변화 (폰 단위)")
@click.option("--skip", default=0, type=int,
              help="앞에서 건너뛸 경기 수")
@click.option("--verbose", is_flag=True, default=False,
              help="상세 로그 출력")
def main(pgn, limit, depth, min_advantage, skip, verbose):
    """리체스 PGN 파일에서 체스 퍼즐을 자동 생성합니다."""
    os.environ["STOCKFISH_DEPTH"] = str(depth)
    os.environ["MIN_ADVANTAGE"] = str(min_advantage)

    conn = get_connection()
    conn.autocommit = False

    puzzles_before = puzzle_count(conn)
    click.echo(f"현재 DB 퍼즐 수: {puzzles_before}")

    games_processed = 0
    games_skipped = 0
    puzzles_created = 0
    puzzles_duplicate = 0

    with open(pgn, encoding="utf-8", errors="ignore") as f:
        progress = tqdm(desc="경기 분석 중", unit="games")

        while True:
            game = chess.pgn.read_game(f)
            if game is None:
                break

            if games_skipped < skip:
                games_skipped += 1
                continue

            if limit > 0 and games_processed >= limit:
                break

            games_processed += 1
            progress.update(1)

            headers = game.headers
            white = headers.get("White", "Unknown")
            black = headers.get("Black", "Unknown")
            site = headers.get("Site", "")
            lichess_id = extract_lichess_id(site)
            white_elo = parse_elo(headers.get("WhiteElo"))
            black_elo = parse_elo(headers.get("BlackElo"))
            opening_eco = headers.get("ECO")
            opening_name = headers.get("Opening")

            board = game.board()
            moves = list(game.mainline_moves())

            if len(moves) < 10:
                if verbose:
                    click.echo(f"  스킵 (짧은 경기): {white} vs {black}")
                continue

            try:
                candidates: list[PuzzleCandidate] = analyze_game(board, moves)
            except Exception as e:
                if verbose:
                    click.echo(f"  분석 오류: {e}", err=True)
                continue

            if not candidates:
                continue

            try:
                game_record = GameRecord(
                    pgn=str(game),
                    white_player=white,
                    black_player=black,
                    white_elo=white_elo,
                    black_elo=black_elo,
                    event=headers.get("Event"),
                    site=site,
                    date=parse_date(headers.get("UTCDate") or headers.get("Date")),
                    result=headers.get("Result"),
                    source=lichess_id,
                )
                game_id = upsert_game(conn, game_record)
            except Exception as e:
                conn.rollback()
                if verbose:
                    click.echo(f"  경기 저장 오류: {e}", err=True)
                continue

            for candidate in candidates:
                puzzle_board = chess.Board(candidate.fen)
                move_number = (candidate.move_index // 2) + 1

                themes = detect_themes(puzzle_board, candidate.moves)
                game_phase = detect_game_phase(puzzle_board, move_number)
                rating = estimate_puzzle_rating(
                    white_elo,
                    black_elo,
                    candidate.eval_before + candidate.eval_after,
                    candidate.moves,
                    themes,
                )

                puzzle_record = PuzzleRecord(
                    fen=candidate.fen,
                    moves=candidate.moves,
                    rating=rating,
                    themes=themes,
                    game_phase=game_phase,
                    opening_eco=opening_eco,
                    opening_name=opening_name,
                    source_game_id=game_id,
                    move_index=candidate.move_index,
                    blunder_move=candidate.blunder_move,
                    pre_blunder_fen=candidate.pre_blunder_fen,
                )

                try:
                    puzzle_id = insert_puzzle(conn, puzzle_record)
                    if puzzle_id:
                        puzzles_created += 1
                        if verbose:
                            click.echo(
                                f"  퍼즐 생성: {candidate.fen[:30]}... "
                                f"테마={themes} 레이팅={rating}"
                            )
                    else:
                        puzzles_duplicate += 1
                except Exception as e:
                    conn.rollback()
                    if verbose:
                        click.echo(f"  퍼즐 저장 오류: {e}", err=True)
                    continue

            conn.commit()
            progress.set_postfix(puzzles=puzzles_created)

    progress.close()
    conn.close()

    puzzles_total = puzzles_before + puzzles_created
    click.echo("\n─── 완료 ───────────────────────────────")
    click.echo(f"분석한 경기 수 : {games_processed}")
    click.echo(f"생성된 퍼즐 수 : {puzzles_created}")
    click.echo(f"중복 스킵 수   : {puzzles_duplicate}")
    click.echo(f"DB 총 퍼즐 수  : {puzzles_total}")


if __name__ == "__main__":
    main()

"""
tagger.py 디버깅 스크립트.

DB의 퍼즐을 가져와 각 패턴 감지 함수 결과를 상세 출력합니다.

실행: cd pipeline && python scripts/debug_tagger.py
"""
import os
import sys

_PIPELINE_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, _PIPELINE_ROOT)

import chess
from db import get_connection
from tagger import (
    detect_themes,
    _is_fork, _creates_pin, _is_skewer, _is_discovered_attack,
    _is_double_check, _is_queen_sacrifice, _involves_promotion,
    _is_back_rank, _is_hanging_piece_tactic, _is_rook_endgame,
    _is_deflection, _is_decoy, _is_trapped_piece, _is_interference,
    _detect_mate,
)


def debug_puzzle(fen: str, moves: list[str]):
    board = chess.Board(fen)
    first_move = chess.Move.from_uci(moves[0])

    print(f"\nFEN: {fen}")
    print(f"수순: {moves}")
    print(f"첫 수: {moves[0]} ({board.san(first_move)})")
    print(f"현재 차례: {'백' if board.turn == chess.WHITE else '흑'}")
    print()

    legal = first_move in board.legal_moves
    print(f"  합법적인 수: {legal}")
    if not legal:
        print("  ❌ 첫 수가 합법적이지 않습니다!")
        return

    checks = [
        ("MATE", lambda: _detect_mate(board, moves)),
        ("DOUBLE_CHECK", lambda: _is_double_check(board, first_move)),
        ("FORK", lambda: _is_fork(board, first_move)),
        ("PIN", lambda: _creates_pin(board, first_move)),
        ("SKEWER", lambda: _is_skewer(board, first_move)),
        ("DISCOVERED_ATTACK", lambda: _is_discovered_attack(board, first_move)),
        ("QUEEN_SACRIFICE", lambda: _is_queen_sacrifice(board, first_move)),
        ("PROMOTION", lambda: _involves_promotion(moves)),
        ("BACK_RANK", lambda: _is_back_rank(board, first_move)),
        ("HANGING_PIECE", lambda: _is_hanging_piece_tactic(board, first_move)),
        ("ROOK_ENDGAME", lambda: _is_rook_endgame(board)),
        ("DEFLECTION", lambda: _is_deflection(board, first_move)),
        ("DECOY", lambda: _is_decoy(board, first_move)),
        ("TRAP", lambda: _is_trapped_piece(board, first_move)),
        ("INTERFERENCE", lambda: _is_interference(board, first_move)),
    ]

    for name, fn in checks:
        try:
            result = fn()
            mark = "✅" if result else "  "
            print(f"  {mark} {name}: {result}")
        except Exception as e:
            print(f"  ❌ {name}: 오류 - {e}")

    actual = detect_themes(board, moves)
    print(f"\n  detect_themes(): {actual}")

    b = board.copy()
    b.push(first_move)
    captured = board.piece_at(first_move.to_square)
    print(f"\n  [이동 후 상태]")
    print(f"  잡은 기물: {captured}")
    print(f"  체크: {b.is_check()}")
    print(f"  남은 수비 응수 수: {b.legal_moves.count()}")


def main():
    conn = get_connection()
    cur = conn.cursor()
    cur.execute(
        'SELECT fen, moves FROM "Puzzle" ORDER BY "createdAt" LIMIT 10'
    )
    puzzles = cur.fetchall()
    conn.close()

    if not puzzles:
        print("DB에 퍼즐이 없습니다.")
        return

    print(f"총 {len(puzzles)}개 퍼즐 디버깅 시작\n")
    print("=" * 60)

    for i, (fen, moves) in enumerate(puzzles, 1):
        print(f"\n[퍼즐 {i}]")
        debug_puzzle(fen, moves)
        print("-" * 60)


if __name__ == "__main__":
    main()

"""
Stockfish 기반 퍼즐 추출 모듈.

Python-Puzzle-Creator 알고리즘을 참고해 재작성.
핵심 로직:
  1. investigate(): 블런더 여부 판단 (CP 범위 + 기물 수)
  2. _is_ambiguous(): 최선수가 유일한지 확인
  3. _extract_solution(): 강제 수순 추출 (공격측/수비측 교대)
"""
import os
import chess
import chess.engine
from dataclasses import dataclass
from dotenv import load_dotenv

_PIPELINE_DIR = os.path.dirname(os.path.abspath(__file__))
load_dotenv(os.path.join(_PIPELINE_DIR, ".env"))

_SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
_DEFAULT_STOCKFISH = os.path.join(_SCRIPT_DIR, "bin", "stockfish_bin")
STOCKFISH_PATH = os.environ.get("STOCKFISH_PATH", _DEFAULT_STOCKFISH)

# ── 탐색 시간 ────────────────────────────────────────────────────
SCAN_TIME   = 0.1   # 1패스: 전체 경기 빠른 스캔
VERIFY_TIME = 0.2   # 2패스: 수순 추출 및 유일성 검증

# ── 블런더 탐지 기준 (Python-Puzzle-Creator investigate() 참고) ──
# 폰 단위 (1.0 = 100cp)
MIN_EVAL_BEFORE  = -1.1   # 블런더 전 최솟값: 이미 크게 지는 포지션 제외
MAX_EVAL_BEFORE  =  8.5   # 블런더 전 최댓값: 이미 압승이면 블런더 가치 없음
MIN_EVAL_AFTER   =  1.0   # 블런더 후 상대 최소 이득 (얕은 스캔 기준 완화)

# ── 기물 기준 ────────────────────────────────────────────────────
MIN_MATERIAL_COUNT = 7    # 최소 기물 수 (기물이 너무 적은 단순 엔딩 제외)

# ── 수순 기준 ────────────────────────────────────────────────────
MIN_SOLUTION_GAP = 1.5    # 최선수 vs 차선수 최소 차이 (폰 단위)
MIN_MOVE_COUNT   = 2      # 공격측 최소 수 수
MAX_MOVE_COUNT   = 10     # 공격측 최대 수 수


@dataclass
class PuzzleCandidate:
    fen: str              # 블런더 직후 포지션 FEN (퍼즐 시작점)
    pre_blunder_fen: str  # 블런더 직전 포지션 FEN (인트로 애니메이션용)
    moves: list[str]      # UCI 정답 수순
    blunder_move: str     # 블런더 수 (UCI)
    eval_before: float    # 블런더 전 평가 (현재 플레이어 관점, 폰 단위)
    eval_after: float     # 블런더 후 평가 (상대 플레이어 관점, 폰 단위)
    move_index: int       # 경기에서 몇 번째 수


def cp_to_pawns(score: chess.engine.Score) -> float:
    """Stockfish 점수를 폰 단위로 변환. 메이트는 ±100으로 클램핑."""
    if score.is_mate():
        return 100.0 if (score.mate() or 0) > 0 else -100.0
    cp = score.score()
    return (cp / 100.0) if cp is not None else 0.0


def _investigate(eval_before: float, eval_after: float, board: chess.Board) -> bool:
    """
    블런더가 퍼즐로 만들 가치가 있는지 판단.
    Python-Puzzle-Creator의 investigate() 로직 참고.

    eval_before: 블런더 수를 두기 전 평가 (현재 플레이어 관점, 양수 = 유리)
    eval_after:  블런더 수를 둔 후 평가 (상대 플레이어 관점, 양수 = 상대 유리)
    """
    piece_count = chess.popcount(board.occupied)

    # 메이트 상황: 블런더 전 안 지고 있었고, 블런더 후 상대가 메이트 수순을 가짐
    # (cp_to_pawns에서 메이트는 ±100으로 처리하므로 아래 일반 조건에서 자동 처리됨)

    # 일반 조건 (Python-Puzzle-Creator: a.cp > -110, a.cp < 850, b.cp > 200, b.cp < 850)
    if (MIN_EVAL_BEFORE < eval_before < MAX_EVAL_BEFORE
            and eval_after > MIN_EVAL_AFTER
            and piece_count >= MIN_MATERIAL_COUNT):
        return True

    return False


def _is_ambiguous(engine: chess.engine.SimpleEngine, board: chess.Board) -> bool:
    """
    현재 포지션에서 최선수가 유일한지 확인.
    Python-Puzzle-Creator의 ambiguous() 로직 참고.

    최선수(r1)와 차선수(r2) 차이가 MIN_SOLUTION_GAP 미만이면 모호한 포지션.
    """
    info = engine.analyse(board, chess.engine.Limit(time=VERIFY_TIME), multipv=2)
    if len(info) < 2:
        return False  # 수가 하나뿐이면 유일

    r1 = cp_to_pawns(info[0]["score"].relative)
    r2 = cp_to_pawns(info[1]["score"].relative)
    return abs(r1 - r2) < MIN_SOLUTION_GAP


def _extract_solution(
    engine: chess.engine.SimpleEngine,
    board: chess.Board,
) -> list[str]:
    """
    블런더 후 포지션에서 강제 수순을 추출.
    - 공격측(홀수 스텝): 최선수만 추가
    - 수비측(짝수 스텝): 유일한 응수일 때만 계속, 모호하면 중단
    Python-Puzzle-Creator의 position_list.generate() 로직 참고.
    """
    solution = []
    b = board.copy()

    for step in range(MAX_MOVE_COUNT * 2):
        if b.is_game_over():
            break

        is_attacker = (step % 2 == 0)

        info = engine.analyse(b, chess.engine.Limit(time=VERIFY_TIME), multipv=2)
        if not info:
            break

        pv = info[0].get("pv")
        if not pv:
            break
        best_move = pv[0]

        # 공격측/수비측 모두 최선수가 유일해야 강제 수순
        # (첫 수는 analyze_game에서 investigate로 이미 걸러짐)
        if len(info) >= 2:
            r1 = cp_to_pawns(info[0]["score"].relative)
            r2 = cp_to_pawns(info[1]["score"].relative)
            if abs(r1 - r2) < MIN_SOLUTION_GAP:
                # 공격측이면 애매한 수순이므로 여기서 중단
                # 수비측이면 강제 응수가 없으므로 중단
                break

        solution.append(best_move.uci())
        b.push(best_move)

        if b.is_checkmate():
            break

    # 마지막이 수비 응수(짝수 길이)로 끝나면 제거
    if len(solution) % 2 == 0 and solution:
        solution = solution[:-1]

    return solution if len(solution) >= MIN_MOVE_COUNT else []


def analyze_game(board: chess.Board, moves: list[chess.Move]) -> list[PuzzleCandidate]:
    """
    한 경기를 분석해 퍼즐 후보 목록을 반환합니다.

    2패스 구조:
      1패스: 전체 포지션을 빠르게 평가 → 블런더 후보 탐지
      2패스: 블런더 후보만 정밀 분석 → 수순 추출 + 모호성 검사
    """
    candidates = []

    with chess.engine.SimpleEngine.popen_uci(STOCKFISH_PATH) as engine:

        # ── 1패스: 전 포지션 빠르게 평가 ──────────────────────────
        evals: list[float] = []
        snapshots: list[chess.Board] = []

        b = board.copy()
        for move in moves:
            if move not in b.legal_moves:
                break
            snapshots.append(b.copy())
            info = engine.analyse(b, chess.engine.Limit(time=SCAN_TIME))
            evals.append(cp_to_pawns(info["score"].relative))
            b.push(move)
        snapshots.append(b.copy())

        # ── 2패스: 블런더 후보 정밀 검증 ──────────────────────────
        for i in range(len(evals) - 1):
            eval_before = evals[i]      # 블런더 수 두기 전 (현재 플레이어 관점)
            eval_after  = evals[i + 1]  # 블런더 수 둔 후 (상대 플레이어 관점)
            pre_board   = snapshots[i]
            post_board  = snapshots[i + 1]

            # investigate() 조건 미충족 시 스킵
            if not _investigate(eval_before, eval_after, pre_board):
                continue

            # 강제 수순 추출 (내부에서 모호성 검사 포함)
            solution = _extract_solution(engine, post_board.copy())
            if not solution:
                continue

            # 공격측 수 수 범위 확인
            attacker_moves_count = (len(solution) + 1) // 2
            if not (MIN_MOVE_COUNT <= attacker_moves_count <= MAX_MOVE_COUNT):
                continue

            candidates.append(
                PuzzleCandidate(
                    fen=post_board.fen(),
                    pre_blunder_fen=pre_board.fen(),
                    moves=solution,
                    blunder_move=moves[i].uci(),
                    eval_before=eval_before,
                    eval_after=eval_after,
                    move_index=i,
                )
            )

    return candidates

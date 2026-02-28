"""
전술 패턴 자동 태깅 모듈 v2.

Lichess scalachess Tagger 접근법과 chess programming 표준 알고리즘 기반.

v1 대비 주요 수정:
- FORK    : 이동한 기물 기준 공격 계산 (전체 공격 아님)
- PIN     : 신규 생성된 절대 핀(킹 핀)만 감지, 기존 핀 제외
- SKEWER  : delta 방향 버그 제거 → chess.ray() / chess.between() 사용
- DISCOVERED_ATTACK : 킹 + 고가치 무방비 기물 모두 감지
- DEFLECTION   : 핵심 수비 기물 제거 후 수비 대상 노출 감지
- DECOY        : 유인 후 포크·되잡기 이득 정확히 시뮬레이션
- INTERFERENCE : 슬라이더 방어선 차단 로직 재작성
- TRAPPED_PIECE: 폰 제외, 도피처 탐색 최적화

참고:
- https://github.com/lichess-org/scalachess (Tagger.scala)
- python-chess 1.11.2 API: chess.ray(), chess.between(), Board.attacks()
"""
import chess
from typing import Optional

# ─── 상수 ──────────────────────────────────────────────────────────────────────

VALUABLE    = frozenset({chess.QUEEN, chess.ROOK, chess.BISHOP, chess.KNIGHT})
VALUABLE_K  = frozenset({chess.QUEEN, chess.ROOK, chess.BISHOP, chess.KNIGHT, chess.KING})
SLIDERS     = frozenset({chess.QUEEN, chess.ROOK, chess.BISHOP})

PIECE_VALUE: dict[chess.PieceType, int] = {
    chess.PAWN:   100,
    chess.KNIGHT: 300,
    chess.BISHOP: 310,
    chess.ROOK:   500,
    chess.QUEEN:  900,
    chess.KING:   20_000,
}


# ─── 공개 API ──────────────────────────────────────────────────────────────────

def detect_themes(board: chess.Board, solution_moves: list[str]) -> list[str]:
    """
    퍼즐의 시작 포지션과 정답 수순을 분석해 전술 테마를 감지합니다.

    Args:
        board: 퍼즐 시작 포지션 (공격측 차례)
        solution_moves: UCI 포맷 정답 수순

    Returns:
        감지된 테마 문자열 목록 (미감지 시 ["HANGING_PIECE"])
    """
    if not solution_moves:
        return ["HANGING_PIECE"]

    first_move = chess.Move.from_uci(solution_moves[0])
    if first_move not in board.legal_moves:
        return ["HANGING_PIECE"]

    themes: set[str] = set()

    # 수순 전체 분석이 필요한 패턴
    mate = _detect_mate(board, solution_moves)
    if mate:
        themes.add(mate)

    if _involves_promotion(solution_moves):
        themes.add("PAWN_PROMOTION")

    # 첫 번째 수 기준 패턴
    if _is_double_check(board, first_move):
        themes.add("DOUBLE_CHECK")

    if _is_fork(board, first_move):
        themes.add("FORK")

    if _creates_pin(board, first_move):
        themes.add("PIN")

    if _is_skewer(board, first_move):
        themes.add("SKEWER")

    if _is_discovered_attack(board, first_move):
        themes.add("DISCOVERED_ATTACK")

    if _is_queen_sacrifice(board, first_move):
        themes.add("QUEEN_SACRIFICE")

    if _is_back_rank(board, first_move):
        themes.add("BACK_RANK")

    if _is_hanging_piece_tactic(board, first_move):
        themes.add("HANGING_PIECE")

    if _is_rook_endgame(board):
        themes.add("ROOK_ENDGAME")

    if _is_deflection(board, first_move):
        themes.add("DEFLECTION")

    if _is_decoy(board, first_move):
        themes.add("DECOY")

    if _is_trapped_piece(board, first_move):
        themes.add("TRAP")

    if _is_interference(board, first_move):
        themes.add("INTERFERENCE")

    return list(themes) if themes else ["HANGING_PIECE"]


def detect_game_phase(board: chess.Board, move_number: int) -> str:
    """경기 단계 감지 (수 번호 + 기물 수 기준)"""
    if move_number <= 15:
        return "OPENING"
    piece_count = len(board.piece_map())
    if move_number >= 41 or piece_count <= 10:
        return "ENDGAME"
    return "MIDDLEGAME"


# ─── 내부 헬퍼 ────────────────────────────────────────────────────────────────

def _pv(piece_type: chess.PieceType) -> int:
    """기물 가치(센티폰) 반환"""
    return PIECE_VALUE.get(piece_type, 0)


def _first_beyond(board: chess.Board, from_sq: int, through_sq: int) -> Optional[int]:
    """
    from_sq → through_sq 방향으로, through_sq를 넘어 첫 번째 점유된 칸을 반환.

    chess.ray()  : from_sq와 through_sq를 포함하는 전체 직선 (랭크/파일/대각)
    chess.between(): 두 칸 사이의 칸들 (양 끝 제외)

    'beyond': chess.between(from_sq, sq)에 through_sq가 포함되는 sq
    즉, from_sq와 sq 사이에 through_sq가 끼어있는 칸.
    """
    full_ray = chess.BB_RAYS[from_sq][through_sq]
    if not full_ray:
        return None

    through_bb = chess.BB_SQUARES[through_sq]
    candidates: list[tuple[int, int]] = []

    for sq in chess.SquareSet(full_ray & board.occupied):
        if sq == from_sq or sq == through_sq:
            continue
        # through_sq가 from_sq ~ sq 사이에 있어야 함
        if through_bb & chess.between(from_sq, sq):
            candidates.append((chess.square_distance(from_sq, sq), sq))

    return min(candidates)[1] if candidates else None


# ─── 패턴 감지 함수들 ──────────────────────────────────────────────────────────

def _detect_mate(board: chess.Board, moves: list[str]) -> Optional[str]:
    """메이트 인 N 감지 (최대 5수). 공격측 기준 N수"""
    b = board.copy()
    for i, uci in enumerate(moves, 1):
        move = chess.Move.from_uci(uci)
        if move not in b.legal_moves:
            return None
        b.push(move)
        if b.is_checkmate():
            n = (i + 1) // 2
            return f"MATE_IN_{n}" if 1 <= n <= 5 else None
    return None


def _is_double_check(board: chess.Board, move: chess.Move) -> bool:
    """이동 후 이중 체크(두 기물이 동시에 킹을 공격)"""
    b = board.copy()
    b.push(move)
    if not b.is_check():
        return False
    king_sq = b.king(b.turn)
    return king_sq is not None and len(b.attackers(not b.turn, king_sq)) >= 2


def _is_fork(board: chess.Board, move: chess.Move) -> bool:
    """
    포크: 이동한 기물 하나가 적 고가치 기물 2개 이상을 동시에 공격.

    - 이동한 기물이 되잡히지 않는 경우: 2개 이상 공격이면 포크
    - 이동한 기물이 되잡히는 경우: 가장 비싼 공격 대상이 이동 기물보다 비싸야 포크
      (최소한 한 기물은 살릴 수 없으므로)
    """
    b = board.copy()
    b.push(move)

    mover_sq = move.to_square
    mover = b.piece_at(mover_sq)
    if mover is None:
        return False

    mover_val = _pv(mover.piece_type)
    opp_color = b.turn

    # 이동한 기물이 공격하는 적 기물 목록
    attacked: list[tuple[int, chess.Piece]] = [
        (sq, p)
        for sq in b.attacks(mover_sq)
        if (p := b.piece_at(sq)) and p.color == opp_color and p.piece_type in VALUABLE_K
    ]

    if len(attacked) < 2:
        return False

    # 이동한 기물이 즉시 되잡히지 않으면 무조건 포크
    if not b.is_attacked_by(opp_color, mover_sq):
        return True

    # 되잡히는 경우: 가장 비싼 공격 대상이 이동 기물보다 비싸야 이득
    best_target_val = max(_pv(p.piece_type) for _, p in attacked)
    return best_target_val > mover_val


def _creates_pin(board: chess.Board, move: chess.Move) -> bool:
    """
    신규 절대 핀(킹 핀) 생성 감지.

    이동 전에 없었던 새로운 핀만 True. 기존 핀은 무시.
    python-chess is_pinned()는 킹에 대한 절대 핀만 감지.
    """
    opp_color = not board.turn

    # 이동 전 상대방의 핀된 기물 집합
    pins_before: set[int] = {
        sq for sq, p in board.piece_map().items()
        if p.color == opp_color and board.is_pinned(opp_color, sq)
    }

    b = board.copy()
    b.push(move)

    # 이동 후 신규 핀 확인
    for sq, p in b.piece_map().items():
        if p.color == opp_color and sq not in pins_before and b.is_pinned(opp_color, sq):
            return True

    return False


def _is_skewer(board: chess.Board, move: chess.Move) -> bool:
    """
    스큐어: 슬라이더가 고가치 적 기물(킹/퀸/루크)을 공격하고,
    그 기물 너머 같은 방향에 또 다른 적 기물이 있는 패턴.

    기물이 피하면 뒤 기물이 잡히므로 고가치 기물을 강제 이동시킴.

    v1 버그 수정: delta 방향 계산 대신 chess.ray() 사용.
    """
    b = board.copy()
    b.push(move)

    mover_sq = move.to_square
    mover = b.piece_at(mover_sq)
    if mover is None or mover.piece_type not in SLIDERS:
        return False

    opp_color = b.turn
    # 스큐어의 앞 기물: 킹, 퀸, 루크 (고가치여서 피해야 함)
    skewer_front = {chess.KING, chess.QUEEN, chess.ROOK}

    # 슬라이더가 공격하는 적 기물 탐색
    for target_sq in b.attacks(mover_sq):
        target = b.piece_at(target_sq)
        if not target or target.color != opp_color:
            continue
        if target.piece_type not in skewer_front:
            continue

        # target 너머 같은 방향의 첫 번째 적 기물
        beyond_sq = _first_beyond(b, mover_sq, target_sq)
        if beyond_sq is None:
            continue

        beyond_piece = b.piece_at(beyond_sq)
        if beyond_piece and beyond_piece.color == opp_color:
            return True

    return False


def _is_discovered_attack(board: chess.Board, move: chess.Move) -> bool:
    """
    발견 공격: 기물을 이동해 뒤에 있던 슬라이더의 공격선을 개방.

    감지 범위:
    1. 적 킹에 대한 발견 체크
    2. 고가치 무방비 적 기물에 대한 발견 공격

    v1 버그 수정: 킹만 체크 → 킹 + 고가치 무방비 기물 모두 체크.
    이동한 기물 자체의 새 공격은 제외(move.to_square).
    """
    attacker_color = board.turn
    opp_color = not attacker_color

    b = board.copy()
    b.push(move)

    def newly_attacked(sq: int) -> bool:
        """이동 전에 없었고 이동한 기물 자체가 아닌 공격자가 생겼는지"""
        before = set(board.attackers(attacker_color, sq)) if board.piece_at(sq) else set()
        after = set(b.attackers(attacker_color, sq))
        new = (after - before) - {move.to_square}
        return bool(new)

    # 1. 적 킹에 대한 발견 체크
    king_sq = b.king(opp_color)
    if king_sq is not None and newly_attacked(king_sq):
        return True

    # 2. 고가치 무방비 기물에 대한 발견 공격
    for sq, p in b.piece_map().items():
        if p.color != opp_color or p.piece_type not in VALUABLE:
            continue
        if newly_attacked(sq) and not b.is_attacked_by(opp_color, sq):
            return True

    return False


def _is_queen_sacrifice(board: chess.Board, move: chess.Move) -> bool:
    """퀸을 상대가 즉시 잡을 수 있는 칸에 두는 수"""
    piece = board.piece_at(move.from_square)
    if piece is None or piece.piece_type != chess.QUEEN:
        return False
    b = board.copy()
    b.push(move)
    return b.is_attacked_by(b.turn, move.to_square)


def _involves_promotion(moves: list[str]) -> bool:
    """수순에 폰 프로모션 포함 여부 (UCI 5글자: e7e8q 등)"""
    return any(len(m) == 5 for m in moves)


def _is_back_rank(board: chess.Board, move: chess.Move) -> bool:
    """
    백 랭크 메이트 패턴.
    루크 또는 퀸이 백 랭크에서 체크하고, 킹이 폰에 갇혀 탈출 불가.
    """
    piece = board.piece_at(move.from_square)
    if piece is None or piece.piece_type not in {chess.ROOK, chess.QUEEN}:
        return False

    b = board.copy()
    b.push(move)

    if not b.is_check():
        return False

    king_sq = b.king(b.turn)
    if king_sq is None:
        return False

    back_rank = chess.BB_RANK_1 if b.turn == chess.WHITE else chess.BB_RANK_8
    if not (chess.BB_SQUARES[king_sq] & back_rank):
        return False

    # 킹이 앞 랭크로 탈출 가능한지 확인
    escape_rank = chess.BB_RANK_2 if b.turn == chess.WHITE else chess.BB_RANK_7
    king_neighbors = chess.SquareSet(chess.BB_KING_ATTACKS[king_sq])
    escape_squares = king_neighbors & chess.SquareSet(escape_rank)

    for sq in escape_squares:
        if not b.piece_at(sq) and not b.is_attacked_by(not b.turn, sq):
            return False  # 탈출 가능

    return True


def _is_hanging_piece_tactic(board: chess.Board, move: chess.Move) -> bool:
    """무방비(행잉) 적 기물을 잡는 수: 잡은 후 되받아치지 못함"""
    target = board.piece_at(move.to_square)
    if target is None:
        return False
    b = board.copy()
    b.push(move)
    return not b.is_attacked_by(b.turn, move.to_square)


def _is_rook_endgame(board: chess.Board) -> bool:
    """루크만 남은 엔드게임 포지션 (양측 루크만, 최대 4개)"""
    non_pawn_king = [
        p for p in board.piece_map().values()
        if p.piece_type not in {chess.PAWN, chess.KING}
    ]
    types = {p.piece_type for p in non_pawn_king}
    return types == {chess.ROOK} and len(non_pawn_king) <= 4


def _is_deflection(board: chess.Board, move: chess.Move) -> bool:
    """
    유인 이탈(디플렉션): 수비 역할을 맡은 적 기물을 제거해
    그 기물이 수비하던 다른 적 기물이 노출되는 패턴.

    감지 조건:
    1. 우리가 적 기물을 잡는 수
    2. 잡힌 기물이 다른 적 기물을 수비하고 있었음
    3. 수비가 해제된 기물이 이제 우리에게 공격받음
    4. 노출된 기물의 가치 ≥ 잡은 기물의 가치 (이득이 있어야 의미 있는 전술)

    v1 버그 수정: 노출 가능 기물 범위를 ROOK/QUEEN → 전체 VALUABLE_K로 확장.
    """
    attacker_color = board.turn
    opp_color = not attacker_color

    # 잡는 수인지
    captured = board.piece_at(move.to_square)
    if captured is None or captured.color != opp_color:
        return False

    captured_val = _pv(captured.piece_type)

    # 잡히기 전 이 기물이 수비하던 적 기물들
    defended: list[tuple[int, chess.Piece]] = [
        (sq, p)
        for sq in board.attacks(move.to_square)
        if sq != move.to_square
        and (p := board.piece_at(sq)) and p.color == opp_color
        and p.piece_type in VALUABLE_K
    ]

    if not defended:
        return False

    b = board.copy()
    b.push(move)

    for def_sq, def_piece in defended:
        # 수비 해제 후 공격받는가?
        if not b.is_attacked_by(attacker_color, def_sq):
            continue
        # 노출된 기물의 가치가 우리가 잡은 기물 이상이어야 의미 있는 전술
        if _pv(def_piece.piece_type) >= captured_val:
            return True

    return False


def _is_decoy(board: chess.Board, move: chess.Move) -> bool:
    """
    유인 희생(디코이): 우리 기물을 특정 칸에 두면 적이 잡게 되고,
    잡고 난 후 그 기물이 불리한 위치(포크당하거나 즉시 되잡힘)에 놓이는 패턴.

    감지 조건 (둘 중 하나):
    A. 적이 잡으면 우리가 더 비싼 기물을 되잡을 수 있음
    B. 적이 잡으면 그 기물이 우리 기물에게 포크당함 (2+ 고가치 기물 동시 공격)
    """
    attacker_color = board.turn
    opp_color = not attacker_color

    moved_piece = board.piece_at(move.from_square)
    if moved_piece is None:
        return False

    b_after = board.copy()
    b_after.push(move)

    capturers = list(b_after.attackers(opp_color, move.to_square))
    if not capturers:
        return False

    moved_val = _pv(moved_piece.piece_type)

    for cap_sq in capturers:
        capturer = b_after.piece_at(cap_sq)
        if capturer is None:
            continue

        cap_move = chess.Move(cap_sq, move.to_square)
        if cap_move not in b_after.legal_moves:
            continue

        capturer_val = _pv(capturer.piece_type)
        b2 = b_after.copy()
        b2.push(cap_move)

        # 조건 A: 잡은 기물보다 비싼 기물을 되잡음
        if b2.is_attacked_by(attacker_color, move.to_square) and capturer_val > moved_val:
            return True

        # 조건 B: 우리의 다음 수가 적 기물 2개 이상을 공격 (포크 발생)
        for our_move in b2.legal_moves:
            our_piece = b2.piece_at(our_move.from_square)
            if our_piece is None or our_piece.color != attacker_color:
                continue
            b3 = b2.copy()
            b3.push(our_move)
            fork_count = sum(
                1 for sq in b3.attacks(our_move.to_square)
                if (p := b3.piece_at(sq))
                and p.color == opp_color
                and p.piece_type in VALUABLE_K
            )
            if fork_count >= 2:
                return True

    return False


def _is_trapped_piece(board: chess.Board, move: chess.Move) -> bool:
    """
    기물 포획(트랩): 이동 후 적 기물(폰·킹 제외)에 안전한 도피처가 없어짐.

    v1 개선: 폰 제외, 도피처 탐색 시 되잡히는 도피도 불안전으로 처리.
    """
    attacker_color = board.turn
    opp_color = not attacker_color

    b = board.copy()
    b.push(move)

    for sq, piece in b.piece_map().items():
        if piece.color != opp_color:
            continue
        if piece.piece_type in {chess.KING, chess.PAWN}:
            continue
        if not b.is_attacked_by(attacker_color, sq):
            continue

        has_safe = False
        for escape in b.legal_moves:
            if escape.from_square != sq:
                continue
            b2 = b.copy()
            b2.push(escape)
            if not b2.is_attacked_by(attacker_color, escape.to_square):
                has_safe = True
                break

        if not has_safe:
            return True

    return False


def _is_interference(board: chess.Board, move: chess.Move) -> bool:
    """
    간섭(인터피어런스): 우리 기물이 착지한 칸이 적 슬라이더의 방어선 위에 있어,
    그 슬라이더가 수비하던 다른 적 기물의 방어가 끊기는 패턴.

    감지 조건:
    1. 이동 전: 적 슬라이더 S가 칸 L을 공격하고 있었음
    2. 우리 기물이 L에 착지 → S의 시야 차단
    3. S가 L 너머에서 수비하던 적 기물 X가 이제 우리에게 공격받음

    v1 버그 수정: 슬라이더 2개 동시 차단 조건 제거 → 1개 슬라이더 방어선 차단으로 수정.
    """
    attacker_color = board.turn
    opp_color = not attacker_color

    landing = move.to_square

    b = board.copy()
    b.push(move)

    our_piece = b.piece_at(landing)
    if our_piece is None:
        return False

    for slider_sq, slider in board.piece_map().items():
        if slider.color != opp_color or slider.piece_type not in SLIDERS:
            continue

        # 이동 전 이 슬라이더가 landing 칸을 공격하고 있었는가?
        if not (board.attacks(slider_sq) & chess.BB_SQUARES[landing]):
            continue

        # landing 너머 방향에 있는 첫 번째 점유 칸 (이동 전 보드 기준)
        beyond_sq = _first_beyond(board, slider_sq, landing)
        if beyond_sq is None:
            continue

        beyond_piece = board.piece_at(beyond_sq)
        if beyond_piece is None or beyond_piece.color != opp_color:
            continue
        if beyond_piece.piece_type not in VALUABLE_K:
            continue

        # 이동 후 beyond_sq가 우리에게 공격받는가?
        if b.is_attacked_by(attacker_color, beyond_sq):
            return True

    return False

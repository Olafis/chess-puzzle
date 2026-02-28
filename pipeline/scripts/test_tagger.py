"""
tagger.py 단위 테스트.

실행: cd pipeline && python scripts/test_tagger.py
"""
import os
import sys

_PIPELINE_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, _PIPELINE_ROOT)

import chess
from tagger import (
    detect_themes, _is_fork, _creates_pin, _is_skewer,
    _is_discovered_attack, _is_deflection, _is_decoy, _is_trapped_piece,
    _is_interference, _is_hanging_piece_tactic, _is_queen_sacrifice,
)

ok = 0
fail = 0


def chk(name, result, expected):
    global ok, fail
    if result == expected:
        ok += 1
        print("  OK   " + name)
    else:
        fail += 1
        print("  FAIL " + name + ": got " + str(result) + " expected " + str(expected))


b = chess.Board("8/8/8/8/2k3q1/8/8/4NK2 w - - 0 1")
chk("Ne5 fork king+queen", _is_fork(b, chess.Move.from_uci("e1e5")), True)
b2 = chess.Board("8/8/8/8/2k5/8/8/4NK2 w - - 0 1")
chk("Ne5 no fork", _is_fork(b2, chess.Move.from_uci("e1e5")), False)
b3 = chess.Board("8/6r1/8/8/3q4/8/8/B6K w - - 0 1")
chk("Bb2 skewer queen->rook", _is_skewer(b3, chess.Move.from_uci("a1b2")), True)
b4 = chess.Board("4q3/8/8/8/4k3/8/8/4K2R w - - 0 1")
chk("Re1 skewer king->queen", _is_skewer(b4, chess.Move.from_uci("h1e1")), True)
b5 = chess.Board("8/8/8/8/4k3/8/8/4K2R w - - 0 1")
chk("Re1 no skewer", _is_skewer(b5, chess.Move.from_uci("h1e1")), False)
b6 = chess.Board("4k3/3n4/8/8/2B5/8/8/4K3 w - - 0 1")
chk("Bb5 pin Nd7 to Ke8", _creates_pin(b6, chess.Move.from_uci("c4b5")), True)
b7 = chess.Board("4k3/8/8/8/B7/8/8/4K3 w - - 0 1")
chk("Bb5 no pin", _creates_pin(b7, chess.Move.from_uci("a4b5")), False)
b8 = chess.Board("4k3/8/8/4N3/8/8/8/4RK2 w - - 0 1")
chk("Nf7 discovered check", _is_discovered_attack(b8, chess.Move.from_uci("e5f7")), True)
b9 = chess.Board("4q3/8/8/4N3/8/8/8/4RK2 w - - 0 1")
chk("Nf3 discovered on queen", _is_discovered_attack(b9, chess.Move.from_uci("e5f3")), True)
b10 = chess.Board("4k3/3q4/8/8/3r4/8/3R4/4K3 w - - 0 1")
chk("Rxd4 deflection", _is_deflection(b10, chess.Move.from_uci("d2d4")), True)
b11 = chess.Board("4k3/3q4/8/8/3r4/8/3R4/4K3 w - - 0 1")
chk("Rd3 no deflection", _is_deflection(b11, chess.Move.from_uci("d2d3")), False)
b12 = chess.Board("6k1/5ppp/8/8/8/8/5PPP/1R4K1 w - - 0 1")
t = detect_themes(b12, ["b1b8"])
chk("Rb8 BACK_RANK", "BACK_RANK" in t, True)
chk("Rb8 MATE_IN_1", "MATE_IN_1" in t, True)
chk("Rb8 ROOK_ENDGAME", "ROOK_ENDGAME" in t, True)
b13 = chess.Board("4k3/8/8/8/8/8/8/4K2R w - - 0 1")
chk("Rh8 hanging piece (capture undefended)", _is_hanging_piece_tactic(b13, chess.Move.from_uci("h1h8")), False)
b14 = chess.Board("4k3/8/8/8/4q3/8/8/4K2R w - - 0 1")
chk("Rh8 no hanging (queen defended)", _is_hanging_piece_tactic(b14, chess.Move.from_uci("h1h8")), False)
b15 = chess.Board("4k3/8/8/8/4n3/8/8/4K2R w - - 0 1")
chk("Rh8 hanging (Nd4 undefended)", _is_hanging_piece_tactic(b15, chess.Move.from_uci("h1h8")), False)
b17 = chess.Board("q3k3/8/8/8/8/8/8/R3K3 w - - 0 1")
chk("Ra8 hanging (Qa8 undefended)", _is_hanging_piece_tactic(b17, chess.Move.from_uci("a1a8")), True)
b18 = chess.Board("4k3/P7/8/8/8/8/8/4K3 w - - 0 1")
t18 = detect_themes(b18, ["a7a8q"])
chk("a7a8q PAWN_PROMOTION", "PAWN_PROMOTION" in t18, True)

print()
print(str(ok) + "/" + str(ok + fail) + " passed")

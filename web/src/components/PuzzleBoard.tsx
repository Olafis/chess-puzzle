"use client";
import { useEffect, useState, useCallback, useRef } from "react";
import { Chessboard } from "react-chessboard";
import { Chess } from "chess.js";
import { useSession } from "next-auth/react";
import { useRouter } from "next/navigation";
import type { Square } from "chess.js";

interface DraggingPieceDataType {
  isSparePiece: boolean;
  position: string;
  pieceType: string;
}

interface SourceGame {
  id: string;
  whitePlayer: string;
  blackPlayer: string;
  whiteElo: number | null;
  blackElo: number | null;
  event: string | null;
  result: string | null;
  source: string | null;
}

interface Puzzle {
  id: string;
  fen: string;
  moves: string[];
  blunderMove: string | null;
  preBblunderFen: string | null;
  rating: number;
  themes: string[];
  gamePhase: string;
  openingEco: string | null;
  openingName: string | null;
  sourceGame: SourceGame | null;
}

type Phase = "intro" | "blunder" | "playing" | "wrong" | "correct_wait" | "solved" | "gave_up";

interface RatingChange {
  before: number;
  after: number;
  delta: number;
}

const THEME_LABEL: Record<string, string> = {
  FORK: "포크", PIN: "핀", SKEWER: "스큐어", DISCOVERED_ATTACK: "발견 공격",
  DOUBLE_CHECK: "이중 체크", MATE_IN_1: "메이트 인 1", MATE_IN_2: "메이트 인 2",
  MATE_IN_3: "메이트 인 3", MATE_IN_4: "메이트 인 4", MATE_IN_5: "메이트 인 5",
  QUEEN_SACRIFICE: "퀸 희생", ROOK_ENDGAME: "룩 엔드게임", PAWN_PROMOTION: "폰 프로모션",
  TRAP: "기물 포획", BACK_RANK: "백 랭크", HANGING_PIECE: "행잉 피스", DEFLECTION: "디플렉션",
  DECOY: "디코이", INTERFERENCE: "인터퍼런스", ZUGZWANG: "쭉츠방",
};

const REPORT_TYPE_LABEL: Record<string, string> = {
  MULTIPLE_SOLUTIONS: "정답이 여러 개 있음",
  WRONG_DIFFICULTY: "난이도가 잘못됨",
  NONSENSE: "퍼즐이 의미없음",
  CATEGORY_WRONG: "카테고리 오분류",
};

const PUZZLE_THEMES = [
  "FORK", "PIN", "SKEWER", "DISCOVERED_ATTACK", "DOUBLE_CHECK",
  "MATE_IN_1", "MATE_IN_2", "MATE_IN_3", "MATE_IN_4", "MATE_IN_5",
  "QUEEN_SACRIFICE", "ROOK_ENDGAME", "PAWN_PROMOTION", "TRAP",
  "BACK_RANK", "HANGING_PIECE", "DEFLECTION", "DECOY", "INTERFERENCE", "ZUGZWANG",
] as const;

export function PuzzleBoard({ puzzle }: { puzzle: Puzzle }) {
  const { data: session } = useSession();
  const router = useRouter();

  const ANIM_MS = 200;     // 기물 이동 애니메이션 시간
  const HIGHLIGHT_MS = 600; // 정답/응수 하이라이트 유지 시간
  const INTRO_PAUSE = 800;  // 블런더 직전 포지션 보여주는 시간

  // 블런더 인트로가 가능한 경우: preBblunderFen + blunderMove 둘 다 있어야 함
  const hasBlunderIntro = !!(puzzle.preBblunderFen && puzzle.blunderMove);
  // 인트로 시작 FEN: 블런더 직전 포지션 (없으면 퍼즐 시작 FEN)
  const initialFen = hasBlunderIntro ? puzzle.preBblunderFen! : puzzle.fen;

  const [chess] = useState(() => new Chess(puzzle.fen));
  const [fen, setFen] = useState(initialFen);
  const [phase, setPhase] = useState<Phase>(hasBlunderIntro ? "intro" : "playing");
  const [moveIndex, setMoveIndex] = useState(0);
  const [squareStyles, setSquareStyles] = useState<Record<string, React.CSSProperties>>({});
  const [selectedSquare, setSelectedSquare] = useState<Square | null>(null);
  const [hintCount, setHintCount] = useState(0); // 0: 미사용, 1: 출발칸, 2: 정답 공개
  const hintUsed = hintCount > 0;
  const [ratingChange, setRatingChange] = useState<RatingChange | null>(null);
  const [loadingNext, setLoadingNext] = useState(false);
  const [feedbackVote, setFeedbackVote] = useState<boolean | null>(null);
  const [feedbackReportType, setFeedbackReportType] = useState<string | null>(null);
  const [feedbackLoading, setFeedbackLoading] = useState(false);
  const [categoryVote, setCategoryVote] = useState<string | null>(null);
  const [categoryVoteLoading, setCategoryVoteLoading] = useState(false);
  const [showReportMenu, setShowReportMenu] = useState(false);
  const [showCategoryMenu, setShowCategoryMenu] = useState(false);
  const startTime = useRef(Date.now());
  const attemptSubmitted = useRef(false);

  // solved/gave_up 시 기존 피드백 로드
  useEffect(() => {
    if (!session?.user?.id || (phase !== "solved" && phase !== "gave_up")) return;
    Promise.all([
      fetch(`/api/puzzles/${puzzle.id}/feedback`).then((r) => r.json()),
      fetch(`/api/puzzles/${puzzle.id}/vote`).then((r) => r.json()),
    ])
      .then(([fb, vote]) => {
        setFeedbackVote(fb.vote ?? null);
        setFeedbackReportType(fb.reportType ?? null);
        setCategoryVote(vote.myVote ?? null);
      })
      .catch(() => {});
  }, [session?.user?.id, phase, puzzle.id]);

  // 플레이어 색 — 퍼즐 시작 FEN 기준으로 고정 (수를 둬도 보드 방향 불변)
  const playerColor = new Chess(puzzle.fen).turn() === "w" ? "white" : "black";

  // 블런더 인트로 애니메이션 시퀀스
  useEffect(() => {
    if (!hasBlunderIntro) return;

    // 1단계: INTRO_PAUSE 후 블런더 수 애니메이션 재생
    const t1 = setTimeout(() => {
      const from = puzzle.blunderMove!.slice(0, 2) as Square;
      const to   = puzzle.blunderMove!.slice(2, 4) as Square;
      setPhase("blunder");
      // FEN을 퍼즐 시작(=블런더 직후)으로 변경 → Chessboard가 애니메이션으로 기물 이동
      setFen(puzzle.fen);
      setSquareStyles({
        [from]: { backgroundColor: "rgba(239,68,68,0.45)" },
        [to]:   { backgroundColor: "rgba(239,68,68,0.45)" },
      });
    }, INTRO_PAUSE);

    // 2단계: 블런더 애니메이션 완료 + 하이라이트 확인 후 playing 전환
    const t2 = setTimeout(() => {
      setSquareStyles({});
      setPhase("playing");
      startTime.current = Date.now(); // 실제 풀기 시작 시간 기록
    }, INTRO_PAUSE + ANIM_MS + HIGHLIGHT_MS);

    return () => { clearTimeout(t1); clearTimeout(t2); };
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  // 클릭 가능한 칸 하이라이트 계산
  function getLegalMoveSquares(square: Square): Record<string, React.CSSProperties> {
    const moves = chess.moves({ square, verbose: true });
    const styles: Record<string, React.CSSProperties> = {
      [square]: { backgroundColor: "rgba(255,255,0,0.4)" },
    };
    for (const m of moves) {
      const isCapture = chess.get(m.to) !== undefined;
      styles[m.to] = isCapture
        ? {
            background: "radial-gradient(circle, rgba(239,68,68,0) 55%, rgba(239,68,68,0.5) 55%)",
            borderRadius: "50%",
          }
        : {
            background: "radial-gradient(circle, rgba(0,0,0,0.2) 36%, transparent 36%)",
            borderRadius: "50%",
          };
    }
    return styles;
  }

  // 수 처리 공통 로직
  const tryMove = useCallback(
    (from: Square, to: Square, promotionPiece?: string) => {
      if (phase !== "playing") return false;

      const expectedMove = puzzle.moves[moveIndex];
      const promotion = promotionPiece ?? expectedMove?.[4] ?? "q";
      const moveStr = `${from}${to}${expectedMove?.[4] ? promotion : ""}`;
      const isCorrect =
        moveStr === expectedMove ||
        `${from}${to}` === expectedMove.slice(0, 4);

      if (!isCorrect) {
        // 합법적인 수인지 확인
        const legal = chess.moves({ square: from, verbose: true }).some((m) => m.to === to);
        if (!legal) return false;

        // 오답 피드백
        setSquareStyles({
          [from]: { backgroundColor: "rgba(239,68,68,0.45)" },
          [to]: { backgroundColor: "rgba(239,68,68,0.45)" },
        });
        setSelectedSquare(null);
        setPhase("wrong");
        if (!attemptSubmitted.current) {
          attemptSubmitted.current = true;
          submitAttempt(false);
        }
        setTimeout(() => {
          setSquareStyles({});
          setPhase("playing");
        }, ANIM_MS + HIGHLIGHT_MS);
        return false;
      }

      // 정답
      try {
        chess.move({ from, to, promotion });
      } catch {
        return false;
      }
      setFen(chess.fen());
      setSquareStyles({
        [from]: { backgroundColor: "rgba(34,197,94,0.4)" },
        [to]: { backgroundColor: "rgba(34,197,94,0.4)" },
      });
      setSelectedSquare(null);
      // 애니메이션 완료(ANIM_MS) + 하이라이트 확인 시간(HIGHLIGHT_MS) 후 응수
      setTimeout(() => playOpponentMove(moveIndex + 1), ANIM_MS + HIGHLIGHT_MS);
      return true;
    },
    [phase, moveIndex, puzzle.moves, chess]
  );

  // 상대 응수 자동 실행
  const playOpponentMove = useCallback(
    (nextIndex: number) => {
      if (nextIndex >= puzzle.moves.length) {
        // 퍼즐 완료
        setSquareStyles({});
        setPhase("solved");
        if (!attemptSubmitted.current) {
          attemptSubmitted.current = true;
          submitAttempt(true);
        }
        return;
      }

      setPhase("correct_wait");

      const move = puzzle.moves[nextIndex];
      try {
        chess.move({
          from: move.slice(0, 2) as Square,
          to: move.slice(2, 4) as Square,
          promotion: move[4] ?? "q",
        });
      } catch {
        setPhase("playing");
        return;
      }

      // FEN 업데이트 → Chessboard가 애니메이션으로 기물 이동
      setFen(chess.fen());
      setSquareStyles({
        [move.slice(0, 2)]: { backgroundColor: "rgba(148,163,184,0.25)" },
        [move.slice(2, 4)]: { backgroundColor: "rgba(148,163,184,0.25)" },
      });
      setMoveIndex(nextIndex + 1);

      // 애니메이션 완료(ANIM_MS) + 응수 확인 시간(HIGHLIGHT_MS) 후 다음 단계
      setTimeout(() => {
        if (nextIndex + 1 >= puzzle.moves.length) {
          setPhase("solved");
          if (!attemptSubmitted.current) {
            attemptSubmitted.current = true;
            submitAttempt(true);
          }
        } else {
          setSquareStyles({});
          setPhase("playing");
        }
      }, ANIM_MS + HIGHLIGHT_MS);
    },
    [chess, puzzle.moves]
  );

  // 클릭 이동
  function onSquareClick(square: Square) {
    if (phase !== "playing") return;

    const piece = chess.get(square);

    if (selectedSquare) {
      // 같은 칸 클릭 → 선택 해제
      if (selectedSquare === square) {
        setSelectedSquare(null);
        setSquareStyles({});
        return;
      }
      // 내 기물 다시 선택
      if (piece && piece.color === chess.turn()[0]) {
        setSelectedSquare(square);
        setSquareStyles(getLegalMoveSquares(square));
        return;
      }
      // 이동 시도
      tryMove(selectedSquare, square);
    } else {
      // 내 기물만 선택 가능
      if (!piece || piece.color !== chess.turn()[0]) return;
      setSelectedSquare(square);
      setSquareStyles(getLegalMoveSquares(square));
    }
  }

  // 드래그 이동
  function onDrop(
    sourceSquare: Square,
    targetSquare: Square,
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    piece: DraggingPieceDataType
  ): boolean {
    setSelectedSquare(null);
    return tryMove(sourceSquare, targetSquare);
  }

  // API 제출
  async function submitAttempt(solved: boolean) {
    if (!session) return;
    try {
      const res = await fetch(`/api/puzzles/${puzzle.id}/attempt`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          solved,
          hintUsed,
          timeSpentSeconds: Math.round((Date.now() - startTime.current) / 1000),
        }),
      });
      if (res.ok) {
        const data = await res.json();
        setRatingChange(data.ratingChange);
      }
    } catch {}
  }

  // 힌트 (1회: 출발칸 표시 / 2회: 현재 둬야 할 한 수 출발+도착 표시)
  function handleHint() {
    if (phase !== "playing") return;
    const expected = puzzle.moves[moveIndex];
    if (!expected) return;

    const from = expected.slice(0, 2) as Square;
    const to   = expected.slice(2, 4) as Square;

    if (hintCount === 0) {
      setHintCount(1);
      setSquareStyles({ [from]: { backgroundColor: "rgba(234,179,8,0.55)" } });
    } else {
      setHintCount(2);
      setSelectedSquare(null);
      setSquareStyles({
        [from]: { backgroundColor: "rgba(234,179,8,0.6)" },
        [to]:   { backgroundColor: "rgba(234,179,8,0.6)" },
      });
    }
  }

  // 포기 — 전체 수순을 모두 실행하고 결과 포지션 + 모든 수 하이라이트 표시
  function handleGiveUp() {
    setPhase("gave_up");
    setSelectedSquare(null);
    if (!attemptSubmitted.current) {
      attemptSubmitted.current = true;
      submitAttempt(false);
    }
    const ch = new Chess(puzzle.fen);
    const moveSquares: Record<string, React.CSSProperties> = {};
    for (const move of puzzle.moves) {
      try {
        ch.move({ from: move.slice(0, 2) as Square, to: move.slice(2, 4) as Square, promotion: move[4] ?? "q" });
      } catch {}
      moveSquares[move.slice(0, 2)] = { backgroundColor: "rgba(148,163,184,0.25)" };
      moveSquares[move.slice(2, 4)] = { backgroundColor: "rgba(148,163,184,0.25)" };
    }
    setFen(ch.fen());
    setSquareStyles(moveSquares);
  }

  // 다음 퍼즐 이동
  async function goNextPuzzle() {
    setLoadingNext(true);
    try {
      const res = await fetch("/api/puzzles/random");
      const data = await res.json();
      if (data.puzzle?.id) {
        router.push(`/puzzle/${data.puzzle.id}`);
      }
    } catch {
      setLoadingNext(false);
    }
  }

  const statusMsg = () => {
    if (phase === "intro") return "상대의 실수를 살펴보세요...";
    if (phase === "blunder") return "상대가 실수를 했습니다!";
    if (phase === "playing") return `${playerColor === "white" ? "백" : "흑"}의 최선수를 찾으세요`;
    if (phase === "wrong") return "틀렸습니다. 다시 시도해보세요.";
    if (phase === "correct_wait") return "좋습니다! ✓";
    if (phase === "solved") return "퍼즐 완료! 🎉";
    if (phase === "gave_up") return "정답 수순입니다";
    return "";
  };

  const statusColor = () => {
    if (phase === "solved") return "text-green-600 dark:text-green-400";
    if (phase === "wrong") return "text-red-600 dark:text-red-400";
    if (phase === "gave_up") return "text-zinc-500 dark:text-zinc-400";
    if (phase === "correct_wait") return "text-yellow-600 dark:text-yellow-400";
    return "text-zinc-700 dark:text-zinc-200";
  };

  const submitFeedback = async (vote: boolean) => {
    if (!session?.user?.id || feedbackLoading) return;
    setFeedbackLoading(true);
    try {
      const res = await fetch(`/api/puzzles/${puzzle.id}/feedback`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ vote: feedbackVote === vote ? null : vote }),
      });
      if (res.ok) {
        const data = await res.json();
        setFeedbackVote(data.feedback?.vote ?? null);
      }
    } catch {
      // ignore
    } finally {
      setFeedbackLoading(false);
    }
  };

  const submitReport = async (reportType: string) => {
    if (!session?.user?.id || feedbackLoading) return;
    setFeedbackLoading(true);
    try {
      const res = await fetch(`/api/puzzles/${puzzle.id}/feedback`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ reportType: feedbackReportType === reportType ? null : reportType }),
      });
      if (res.ok) {
        const data = await res.json();
        setFeedbackReportType(data.feedback?.reportType ?? null);
        setShowReportMenu(false);
      }
    } catch {
      // ignore
    } finally {
      setFeedbackLoading(false);
    }
  };

  const submitCategoryVote = async (suggestedTheme: string) => {
    if (!session?.user?.id || categoryVoteLoading) return;
    setCategoryVoteLoading(true);
    try {
      const res = await fetch(`/api/puzzles/${puzzle.id}/vote`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ suggestedTheme }),
      });
      if (res.ok) {
        const data = await res.json();
        setCategoryVote(data.vote?.suggestedTheme ?? suggestedTheme);
        setShowCategoryMenu(false);
      }
    } catch {
      // ignore
    } finally {
      setCategoryVoteLoading(false);
    }
  };

  return (
    <div className="flex flex-col lg:flex-row gap-8 items-start justify-center">
      {/* 체스보드 */}
      <div className="relative w-full max-w-[720px]">
        {phase === "intro" && (
          <div className="absolute inset-0 z-10 flex items-center justify-center bg-black/55 rounded-sm pointer-events-none">
            <p className="text-white text-base font-medium animate-pulse tracking-wide">
              상대의 실수를 확인하세요...
            </p>
          </div>
        )}
        <Chessboard
          options={{
            id: "puzzle-board",
            position: fen,
            boardOrientation: playerColor as "white" | "black",
            allowDragging: phase === "playing",
            squareStyles,
            darkSquareStyle: { backgroundColor: "#4a7c59" },
            lightSquareStyle: { backgroundColor: "#f0d9b5" },
            showAnimations: true,
            animationDurationInMs: ANIM_MS,
            onPieceDrop: ({ sourceSquare, targetSquare, piece }) =>
              targetSquare ? onDrop(sourceSquare as Square, targetSquare as Square, piece) : false,
            onSquareClick: ({ square }) => onSquareClick(square as Square),
          }}
        />
      </div>

      {/* 사이드 패널 */}
      <div className="w-full lg:w-80 lg:min-w-[320px] space-y-4">
        {/* 퍼즐 정보 */}
        <div className="bg-white dark:bg-zinc-900 rounded-xl p-5 border border-zinc-200 dark:border-zinc-800">
          <div className="flex items-center justify-between mb-3">
            <span className="text-sm text-zinc-500 dark:text-zinc-400 font-mono">#{puzzle.id}</span>
            <span className="text-base font-semibold text-zinc-700 dark:text-zinc-300">레이팅 {puzzle.rating}</span>
          </div>
          <div className="flex flex-wrap gap-2 mb-4">
            {puzzle.themes.map((t) => (
              <span key={t} className="text-sm bg-zinc-200 dark:bg-zinc-800 text-zinc-600 dark:text-zinc-300 px-2.5 py-1 rounded-full">
                {THEME_LABEL[t] ?? t}
              </span>
            ))}
            <span className="text-sm bg-zinc-100 dark:bg-zinc-800/60 text-zinc-500 dark:text-zinc-400 px-2.5 py-1 rounded-full">
              {puzzle.gamePhase === "OPENING" ? "오프닝" : puzzle.gamePhase === "MIDDLEGAME" ? "미들게임" : "엔드게임"}
            </span>
          </div>
          {puzzle.sourceGame && (
            <div className="text-sm text-zinc-500 dark:text-zinc-400 border-t border-zinc-200 dark:border-zinc-800 pt-4 space-y-1">
              <p className="font-medium text-zinc-600 dark:text-zinc-400">원본 경기</p>
              <p>
                {puzzle.sourceGame.whitePlayer}
                {puzzle.sourceGame.whiteElo ? ` (${puzzle.sourceGame.whiteElo})` : ""} vs{" "}
                {puzzle.sourceGame.blackPlayer}
                {puzzle.sourceGame.blackElo ? ` (${puzzle.sourceGame.blackElo})` : ""}
              </p>
              {puzzle.sourceGame.event && <p>{puzzle.sourceGame.event}</p>}
              {puzzle.sourceGame.source && (
                <a
                  href={`https://lichess.org/${puzzle.sourceGame.source}`}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="text-blue-400 hover:underline"
                >
                  Lichess에서 보기 →
                </a>
              )}
            </div>
          )}
          {puzzle.openingName && (
            <p className="text-sm text-zinc-500 dark:text-zinc-600 mt-3">
              {puzzle.openingEco} · {puzzle.openingName}
            </p>
          )}
        </div>

        {/* 상태 */}
        <div className="bg-white dark:bg-zinc-900 rounded-xl p-5 border border-zinc-200 dark:border-zinc-800">
          <p className={`text-base font-semibold ${statusColor()}`}>{statusMsg()}</p>
          {phase === "solved" && ratingChange && (
            <div className="mt-2 flex items-center gap-2 text-sm">
              <span className="text-zinc-500 dark:text-zinc-400">레이팅</span>
              <span className="font-mono text-zinc-900 dark:text-white">{ratingChange.before}</span>
              <span className="text-zinc-500 dark:text-zinc-600">→</span>
              <span className="font-mono text-zinc-900 dark:text-white">{ratingChange.after}</span>
              <span className={`font-bold ${ratingChange.delta >= 0 ? "text-green-400" : "text-red-400"}`}>
                ({ratingChange.delta >= 0 ? "+" : ""}{ratingChange.delta})
              </span>
            </div>
          )}
          {!session && (phase === "solved" || phase === "gave_up") && (
            <p className="text-sm text-zinc-500 dark:text-zinc-600 mt-2">로그인하면 레이팅이 기록됩니다</p>
          )}
        </div>

        {/* 좋아요/싫어요/신고/카테고리 (로그인 + solved/gave_up) */}
        {session && (phase === "solved" || phase === "gave_up") && (
          <div className="bg-white dark:bg-zinc-900 rounded-xl p-5 border border-zinc-200 dark:border-zinc-800 space-y-4">
            <div>
              <p className="text-sm text-zinc-500 dark:text-zinc-400 mb-3">이 퍼즐이 도움이 되었나요?</p>
              <div className="flex gap-3">
                <button
                  onClick={() => submitFeedback(true)}
                  disabled={feedbackLoading}
                  className={`flex-1 py-3 rounded-lg border text-base font-medium transition-colors disabled:opacity-50 ${
                    feedbackVote === true
                      ? "bg-green-500/20 border-green-500/50 text-green-600 dark:text-green-400"
                      : "border-zinc-300 dark:border-zinc-700 text-zinc-600 dark:text-zinc-400 hover:bg-zinc-100 dark:hover:bg-zinc-800"
                  }`}
                >
                  👍 좋아요
                </button>
                <button
                  onClick={() => submitFeedback(false)}
                  disabled={feedbackLoading}
                  className={`flex-1 py-3 rounded-lg border text-base font-medium transition-colors disabled:opacity-50 ${
                    feedbackVote === false
                      ? "bg-red-500/20 border-red-500/50 text-red-600 dark:text-red-400"
                      : "border-zinc-300 dark:border-zinc-700 text-zinc-600 dark:text-zinc-400 hover:bg-zinc-100 dark:hover:bg-zinc-800"
                  }`}
                >
                  👎 싫어요
                </button>
              </div>
            </div>

            {/* 신고 */}
            <div className="border-t border-zinc-200 dark:border-zinc-800 pt-4">
              <p className="text-sm text-zinc-500 dark:text-zinc-400 mb-2">문제가 있나요?</p>
              {showReportMenu ? (
                <div className="space-y-1">
                  {(Object.keys(REPORT_TYPE_LABEL) as string[]).map((rt) => (
                    <button
                      key={rt}
                      onClick={() => submitReport(rt)}
                      disabled={feedbackLoading}
                      className={`w-full py-2 px-3 rounded text-left text-sm transition-colors disabled:opacity-50 ${
                        feedbackReportType === rt
                          ? "bg-amber-500/20 border border-amber-500/50 text-amber-600 dark:text-amber-400"
                          : "border border-zinc-300 dark:border-zinc-700 text-zinc-600 dark:text-zinc-400 hover:bg-zinc-100 dark:hover:bg-zinc-800"
                      }`}
                    >
                      {REPORT_TYPE_LABEL[rt]}
                    </button>
                  ))}
                  <button
                    onClick={() => setShowReportMenu(false)}
                    className="w-full py-2 text-sm text-zinc-500 hover:text-zinc-700 dark:hover:text-zinc-300"
                  >
                    닫기
                  </button>
                </div>
              ) : (
                <button
                  onClick={() => setShowReportMenu(true)}
                  className="text-sm text-zinc-500 hover:text-zinc-700 dark:hover:text-zinc-300 underline"
                >
                  {feedbackReportType ? `신고됨: ${REPORT_TYPE_LABEL[feedbackReportType]}` : "신고하기"}
                </button>
              )}
            </div>

            {/* 카테고리 재분류 투표 */}
            <div className="border-t border-zinc-200 dark:border-zinc-800 pt-4">
              <p className="text-sm text-zinc-500 dark:text-zinc-400 mb-2">카테고리가 틀렸나요?</p>
              {showCategoryMenu ? (
                <div className="space-y-1 max-h-40 overflow-y-auto">
                  {PUZZLE_THEMES.filter((t) => !puzzle.themes.includes(t)).map((theme) => (
                    <button
                      key={theme}
                      onClick={() => submitCategoryVote(theme)}
                      disabled={categoryVoteLoading}
                      className={`w-full py-2 px-3 rounded text-left text-sm transition-colors disabled:opacity-50 ${
                        categoryVote === theme
                          ? "bg-blue-500/20 border border-blue-500/50 text-blue-600 dark:text-blue-400"
                          : "border border-zinc-300 dark:border-zinc-700 text-zinc-600 dark:text-zinc-400 hover:bg-zinc-100 dark:hover:bg-zinc-800"
                      }`}
                    >
                      {THEME_LABEL[theme] ?? theme}
                    </button>
                  ))}
                  <button
                    onClick={() => setShowCategoryMenu(false)}
                    className="w-full py-2 text-sm text-zinc-500 hover:text-zinc-700 dark:hover:text-zinc-300"
                  >
                    닫기
                  </button>
                </div>
              ) : (
                <button
                  onClick={() => setShowCategoryMenu(true)}
                  className="text-sm text-zinc-500 hover:text-zinc-700 dark:hover:text-zinc-300 underline"
                >
                  {categoryVote ? `투표함: ${THEME_LABEL[categoryVote] ?? categoryVote}` : "올바른 카테고리 투표"}
                </button>
              )}
            </div>
          </div>
        )}

        {/* 버튼 */}
        <div className="space-y-3">
          {phase === "playing" && (
            <>
              <button
                onClick={handleHint}
                className="w-full py-3 rounded-lg border border-yellow-500/40 text-yellow-400 text-base font-medium hover:bg-yellow-500/10 transition-colors"
              >
                {hintCount === 0 && "💡 힌트"}
                {hintCount === 1 && "💡 정답 보기 (한 수)"}
                {hintCount >= 2 && "💡 힌트 사용됨"}
              </button>
              <button
                onClick={handleGiveUp}
                className="w-full py-3 rounded-lg border border-zinc-300 dark:border-zinc-700 text-zinc-600 dark:text-zinc-400 text-base hover:bg-zinc-100 dark:hover:bg-zinc-800 transition-colors"
              >
                포기하기
              </button>
            </>
          )}
          {(phase === "solved" || phase === "gave_up") && (
            <>
              <button
                onClick={goNextPuzzle}
                disabled={loadingNext}
                className="w-full py-3 rounded-lg bg-white text-black text-base font-semibold hover:bg-zinc-200 transition-colors disabled:opacity-50"
              >
                {loadingNext ? "로딩 중..." : "다음 퍼즐 →"}
              </button>
              {puzzle.sourceGame?.source && (
                <a
                  href={`https://lichess.org/${puzzle.sourceGame.source}`}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="w-full py-3 rounded-lg border border-zinc-300 dark:border-zinc-700 text-zinc-600 dark:text-zinc-400 text-base hover:bg-zinc-100 dark:hover:bg-zinc-800 transition-colors text-center block"
                >
                  전체 경기 보기 (Lichess)
                </a>
              )}
            </>
          )}
        </div>
      </div>
    </div>
  );
}

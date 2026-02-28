import Link from "next/link";
import { prisma } from "@/lib/prisma";
import { GamePhase, PuzzleTheme, Prisma } from "@prisma/client";

export const dynamic = "force-dynamic";

const THEME_LABEL: Record<string, string> = {
  FORK: "포크", PIN: "핀", SKEWER: "스큐어", DISCOVERED_ATTACK: "발견 공격",
  DOUBLE_CHECK: "이중 체크", MATE_IN_1: "메이트 인 1", MATE_IN_2: "메이트 인 2",
  MATE_IN_3: "메이트 인 3", MATE_IN_4: "메이트 인 4", MATE_IN_5: "메이트 인 5",
  QUEEN_SACRIFICE: "퀸 희생", ROOK_ENDGAME: "룩 엔드게임", PAWN_PROMOTION: "폰 프로모션",
  BACK_RANK: "백 랭크", HANGING_PIECE: "행잉 피스",
  TRAP: "기물 포획", DEFLECTION: "유인 이탈", DECOY: "유인 희생",
  INTERFERENCE: "간섭", ZUGZWANG: "추크츠방",
};

const PHASE_LABEL: Record<string, string> = {
  OPENING: "오프닝", MIDDLEGAME: "미들게임", ENDGAME: "엔드게임",
};

interface PageProps {
  searchParams: {
    theme?: string;
    phase?: string;
    minRating?: string;
    maxRating?: string;
    sort?: string;
    page?: string;
  };
}

const PAGE_SIZE = 20;

export default async function PuzzlesPage({ searchParams }: PageProps) {
  const page = Math.max(1, Number(searchParams.page ?? "1"));
  const sort = searchParams.sort ?? "rating";

  const where: Prisma.PuzzleWhereInput = { isActive: true };

  const themeParam = searchParams.theme;
  if (themeParam && Object.values(PuzzleTheme).includes(themeParam as PuzzleTheme)) {
    where.themes = { hasSome: [themeParam as PuzzleTheme] };
  }

  const phaseParam = searchParams.phase;
  if (phaseParam && Object.values(GamePhase).includes(phaseParam as GamePhase)) {
    where.gamePhase = phaseParam as GamePhase;
  }

  const minRating = searchParams.minRating ? Number(searchParams.minRating) : undefined;
  const maxRating = searchParams.maxRating ? Number(searchParams.maxRating) : undefined;
  if (minRating || maxRating) {
    where.rating = {
      ...(minRating ? { gte: minRating } : {}),
      ...(maxRating ? { lte: maxRating } : {}),
    };
  }

  const orderBy: Prisma.PuzzleOrderByWithRelationInput =
    sort === "newest" ? { createdAt: "desc" }
    : sort === "popular" ? { solveCount: "desc" }
    : { rating: "asc" };

  const [puzzles, total] = await Promise.all([
    prisma.puzzle.findMany({
      where,
      orderBy,
      skip: (page - 1) * PAGE_SIZE,
      take: PAGE_SIZE,
      select: {
        id: true,
        rating: true,
        themes: true,
        gamePhase: true,
        openingEco: true,
        openingName: true,
        solveCount: true,
        failCount: true,
        sourceGame: {
          select: { whitePlayer: true, blackPlayer: true, result: true },
        },
      },
    }),
    prisma.puzzle.count({ where }),
  ]);

  const totalPages = Math.ceil(total / PAGE_SIZE);

  function buildUrl(params: Record<string, string | undefined>) {
    const merged = {
      ...(themeParam ? { theme: themeParam } : {}),
      ...(phaseParam ? { phase: phaseParam } : {}),
      ...(minRating ? { minRating: String(minRating) } : {}),
      ...(maxRating ? { maxRating: String(maxRating) } : {}),
      sort,
      page: "1",
      ...params,
    };
    const qs = Object.entries(merged)
      .filter(([, v]) => v)
      .map(([k, v]) => `${k}=${encodeURIComponent(v!)}`)
      .join("&");
    return `/puzzles?${qs}`;
  }

  const RATING_PRESETS = [
    { label: "전체", min: undefined as number | undefined, max: undefined as number | undefined },
    { label: "800~1200", min: 800, max: 1200 },
    { label: "1200~1500", min: 1200, max: 1500 },
    { label: "1500~1800", min: 1500, max: 1800 },
    { label: "1800~2100", min: 1800, max: 2100 },
    { label: "2100+", min: 2100, max: 4000 },
  ];

  return (
    <div className="max-w-5xl mx-auto px-4 py-8">
      <div className="flex items-center justify-between mb-6">
        <h1 className="text-2xl font-bold text-zinc-900 dark:text-white">퍼즐 탐색</h1>
        <span className="text-sm text-zinc-500 dark:text-zinc-400">총 {total.toLocaleString()}개</span>
      </div>

      {/* 필터 */}
      <div className="bg-white dark:bg-zinc-900 border border-zinc-200 dark:border-zinc-800 rounded-xl p-4 mb-6 space-y-3">
        {/* 전술 테마 */}
        <div>
          <p className="text-xs text-zinc-500 dark:text-zinc-400 mb-2">전술 테마</p>
          <div className="flex flex-wrap gap-1.5">
            <Link
              href={buildUrl({ theme: undefined })}
              className={`text-xs px-3 py-1 rounded-full border transition-colors ${
                !themeParam
                  ? "bg-zinc-900 dark:bg-white text-white dark:text-black border-zinc-900 dark:border-white"
                  : "border-zinc-300 dark:border-zinc-700 text-zinc-600 dark:text-zinc-400 hover:border-zinc-500"
              }`}
            >
              전체
            </Link>
            {Object.entries(THEME_LABEL).map(([key, label]) => (
              <Link
                key={key}
                href={buildUrl({ theme: key })}
                className={`text-xs px-3 py-1 rounded-full border transition-colors ${
                  themeParam === key
                    ? "bg-zinc-900 dark:bg-white text-white dark:text-black border-zinc-900 dark:border-white"
                    : "border-zinc-300 dark:border-zinc-700 text-zinc-600 dark:text-zinc-400 hover:border-zinc-500"
                }`}
              >
                {label}
              </Link>
            ))}
          </div>
        </div>

        {/* 난이도(레이팅) */}
        <div>
          <p className="text-xs text-zinc-500 dark:text-zinc-400 mb-2">난이도</p>
          <div className="flex flex-wrap gap-1.5">
            {RATING_PRESETS.map((p) => {
              const isActive = (p.min === undefined && !minRating && !maxRating) ||
                (p.min === minRating && p.max === maxRating);
              return (
                <Link
                  key={p.label}
                  href={buildUrl({
                    minRating: p.min !== undefined ? String(p.min) : undefined,
                    maxRating: p.max !== undefined ? String(p.max) : undefined,
                  })}
                  className={`text-xs px-3 py-1 rounded-full border transition-colors ${
                    isActive
                      ? "bg-zinc-900 dark:bg-white text-white dark:text-black border-zinc-900 dark:border-white"
                      : "border-zinc-300 dark:border-zinc-700 text-zinc-600 dark:text-zinc-400 hover:border-zinc-500"
                  }`}
                >
                  {p.label}
                </Link>
              );
            })}
          </div>
        </div>

        {/* 경기 단계 + 정렬 */}
        <div className="flex flex-wrap gap-4">
          <div>
            <p className="text-xs text-zinc-500 dark:text-zinc-400 mb-2">경기 단계</p>
            <div className="flex gap-1.5">
              {([undefined, "OPENING", "MIDDLEGAME", "ENDGAME"] as const).map((p) => (
                <Link
                  key={p ?? "all"}
                  href={buildUrl({ phase: p })}
                  className={`text-xs px-3 py-1 rounded-full border transition-colors ${
                    phaseParam === p
                      ? "bg-zinc-900 dark:bg-white text-white dark:text-black border-zinc-900 dark:border-white"
                      : "border-zinc-300 dark:border-zinc-700 text-zinc-600 dark:text-zinc-400 hover:border-zinc-500"
                  }`}
                >
                  {p ? PHASE_LABEL[p] : "전체"}
                </Link>
              ))}
            </div>
          </div>

          <div>
            <p className="text-xs text-zinc-500 dark:text-zinc-400 mb-2">정렬</p>
            <div className="flex gap-1.5">
              {[
                { value: "rating", label: "난이도순" },
                { value: "newest", label: "최신순" },
                { value: "popular", label: "인기순" },
              ].map((s) => (
                <Link
                  key={s.value}
                  href={buildUrl({ sort: s.value })}
                  className={`text-xs px-3 py-1 rounded-full border transition-colors ${
                    sort === s.value
                      ? "bg-zinc-900 dark:bg-white text-white dark:text-black border-zinc-900 dark:border-white"
                      : "border-zinc-300 dark:border-zinc-700 text-zinc-600 dark:text-zinc-400 hover:border-zinc-500"
                  }`}
                >
                  {s.label}
                </Link>
              ))}
            </div>
          </div>
        </div>
      </div>

      {/* 퍼즐 목록 */}
      {puzzles.length === 0 ? (
        <div className="text-center py-20 text-zinc-500 dark:text-zinc-400">
          해당 조건의 퍼즐이 없습니다
        </div>
      ) : (
        <div className="space-y-2">
          {puzzles.map((puzzle) => {
            const solveRate =
              puzzle.solveCount + puzzle.failCount > 0
                ? Math.round((puzzle.solveCount / (puzzle.solveCount + puzzle.failCount)) * 100)
                : null;

            return (
              <Link
                key={puzzle.id}
                href={`/puzzle/${puzzle.id}`}
                className="flex items-center gap-4 bg-white dark:bg-zinc-900 hover:bg-zinc-50 dark:hover:bg-zinc-800 border border-zinc-200 dark:border-zinc-800 hover:border-zinc-300 dark:hover:border-zinc-700 rounded-xl px-4 py-3 transition-colors group"
              >
                {/* 레이팅 */}
                <div className="w-14 text-center">
                  <div className="text-sm font-semibold text-zinc-900 dark:text-white">{puzzle.rating}</div>
                  <div className="text-xs text-zinc-500 dark:text-zinc-600">레이팅</div>
                </div>

                {/* 테마 태그 */}
                <div className="flex-1 flex flex-wrap gap-1">
                  {puzzle.themes.slice(0, 3).map((t) => (
                    <span key={t} className="text-xs bg-zinc-200 dark:bg-zinc-800 group-hover:bg-zinc-300 dark:group-hover:bg-zinc-700 text-zinc-600 dark:text-zinc-400 px-2 py-0.5 rounded-full transition-colors">
                      {THEME_LABEL[t] ?? t}
                    </span>
                  ))}
                  <span className="text-xs text-zinc-500 dark:text-zinc-600 px-2 py-0.5">
                    {PHASE_LABEL[puzzle.gamePhase]}
                  </span>
                </div>

                {/* 경기 정보 */}
                {puzzle.sourceGame && (
                  <div className="hidden sm:block text-xs text-zinc-500 dark:text-zinc-600 text-right min-w-[120px]">
                    <p>{puzzle.sourceGame.whitePlayer}</p>
                    <p>vs {puzzle.sourceGame.blackPlayer}</p>
                  </div>
                )}

                {/* 정답률 */}
                {solveRate !== null && (
                  <div className="w-12 text-right">
                    <span className={`text-xs font-medium ${solveRate >= 50 ? "text-green-500" : "text-red-400"}`}>
                      {solveRate}%
                    </span>
                  </div>
                )}

                {/* ID */}
                <div className="text-xs font-mono text-zinc-500 dark:text-zinc-700 w-12 text-right">
                  #{puzzle.id}
                </div>
              </Link>
            );
          })}
        </div>
      )}

      {/* 페이지네이션 */}
      {totalPages > 1 && (
        <div className="flex justify-center gap-2 mt-8">
          {page > 1 && (
            <Link
              href={buildUrl({ page: String(page - 1) })}
              className="px-4 py-2 text-sm border border-zinc-300 dark:border-zinc-700 rounded-lg text-zinc-600 dark:text-zinc-400 hover:bg-zinc-100 dark:hover:bg-zinc-800 transition-colors"
            >
              ← 이전
            </Link>
          )}
          <span className="px-4 py-2 text-sm text-zinc-500 dark:text-zinc-400">
            {page} / {totalPages}
          </span>
          {page < totalPages && (
            <Link
              href={buildUrl({ page: String(page + 1) })}
              className="px-4 py-2 text-sm border border-zinc-300 dark:border-zinc-700 rounded-lg text-zinc-600 dark:text-zinc-400 hover:bg-zinc-100 dark:hover:bg-zinc-800 transition-colors"
            >
              다음 →
            </Link>
          )}
        </div>
      )}
    </div>
  );
}

import Link from "next/link";
import { prisma } from "@/lib/prisma";

export const dynamic = "force-dynamic";

const THEME_LABEL: Record<string, string> = {
  FORK: "포크", PIN: "핀", SKEWER: "스큐어", DISCOVERED_ATTACK: "발견 공격",
  DOUBLE_CHECK: "이중 체크", MATE_IN_1: "메이트 인 1", MATE_IN_2: "메이트 인 2",
  MATE_IN_3: "메이트 인 3", QUEEN_SACRIFICE: "퀸 희생", BACK_RANK: "백 랭크",
  HANGING_PIECE: "행잉 피스", TRAP: "기물 포획", DEFLECTION: "유인 이탈",
  DECOY: "유인 희생", INTERFERENCE: "간섭",
};

export default async function Home() {
  const [puzzleCount, topPlayers] = await Promise.all([
    prisma.puzzle.count({ where: { isActive: true } }),
    prisma.user.findMany({
      where: { rating: { gt: 1500 } },
      orderBy: { rating: "desc" },
      take: 3,
      select: {
        id: true,
        username: true,
        name: true,
        image: true,
        rating: true,
        _count: { select: { puzzleAttempts: { where: { solved: true } } } },
      },
    }),
  ]);

  return (
    <div className="max-w-4xl mx-auto px-4 py-12">
      {/* 히어로 */}
      <div className="text-center mb-16">
        <div className="text-6xl mb-5">♟</div>
        <h1 className="text-4xl sm:text-5xl font-bold mb-4 tracking-tight text-zinc-900 dark:text-white">
          실전에서 배우는<br />체스 전술
        </h1>
        <p className="text-zinc-600 dark:text-zinc-400 text-lg mb-8 max-w-lg mx-auto">
          Lichess 실전 경기에서 추출한 퍼즐을 풀고<br />레이팅을 올려보세요
        </p>

        <div className="flex flex-col sm:flex-row gap-3 justify-center">
          {puzzleCount > 0 ? (
            <Link
              href="/puzzle/random"
              className="bg-zinc-900 dark:bg-white text-white dark:text-black px-8 py-3 rounded-xl font-semibold text-lg hover:bg-zinc-800 dark:hover:bg-zinc-200 transition-colors"
            >
              퍼즐 풀기 시작
            </Link>
          ) : (
            <span className="bg-zinc-800 text-zinc-400 px-8 py-3 rounded-xl font-semibold text-lg cursor-not-allowed">
              퍼즐 준비 중...
            </span>
          )}
          <Link
            href="/puzzles"
            className="border border-zinc-400 dark:border-zinc-700 text-zinc-700 dark:text-zinc-300 px-8 py-3 rounded-xl font-semibold text-lg hover:bg-zinc-200 dark:hover:bg-zinc-900 transition-colors"
          >
            퍼즐 탐색
          </Link>
        </div>
      </div>

      {/* 통계 카드 */}
      <div className="grid grid-cols-3 gap-4 mb-16">
        {[
          { label: "퍼즐 수", value: puzzleCount > 0 ? puzzleCount.toLocaleString() : "-" },
          { label: "전술 테마", value: "20+" },
          { label: "레이팅 시스템", value: "Glicko-2" },
        ].map((s) => (
          <div key={s.label} className="bg-white dark:bg-zinc-900 border border-zinc-200 dark:border-zinc-800 rounded-xl p-5 text-center">
            <div className="text-2xl font-bold text-zinc-900 dark:text-white">{s.value}</div>
            <div className="text-sm text-zinc-500 dark:text-zinc-400 mt-1">{s.label}</div>
          </div>
        ))}
      </div>

      {/* 리더보드 미리보기 */}
      {topPlayers.length > 0 && (
        <div className="mb-16">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-lg font-semibold text-zinc-800 dark:text-zinc-300">상위 플레이어</h2>
            <Link href="/leaderboard" className="text-sm text-zinc-500 dark:text-zinc-400 hover:text-zinc-700 dark:hover:text-zinc-300 transition-colors">
              전체 보기 →
            </Link>
          </div>
          <div className="space-y-2">
            {topPlayers.map((player, i) => {
              const displayName = player.name || player.username || "익명";
              const medals = ["🥇", "🥈", "🥉"];
              return (
                <Link
                  key={player.id}
                  href={`/profile/${player.id}`}
                  className="flex items-center gap-4 bg-white dark:bg-zinc-900 hover:bg-zinc-100 dark:hover:bg-zinc-800 border border-zinc-200 dark:border-zinc-800 hover:border-zinc-300 dark:hover:border-zinc-700 rounded-xl px-4 py-3 transition-colors"
                >
                  <span className="text-xl w-8 text-center">{medals[i]}</span>
                  {player.image ? (
                    <img src={player.image} alt={displayName} className="w-8 h-8 rounded-full" />
                  ) : (
                    <div className="w-8 h-8 rounded-full bg-zinc-700 flex items-center justify-center text-xs font-semibold">
                      {displayName[0]?.toUpperCase() ?? "?"}
                    </div>
                  )}
                  <span className="flex-1 text-sm font-medium text-zinc-900 dark:text-white">{displayName}</span>
                  <div className="text-right">
                    <p className="text-sm font-semibold text-zinc-900 dark:text-white">{player.rating}</p>
                    <p className="text-xs text-zinc-500 dark:text-zinc-400">{player._count.puzzleAttempts}개 해결</p>
                  </div>
                </Link>
              );
            })}
          </div>
        </div>
      )}

      {/* 전술 테마 */}
      <div>
        <h2 className="text-lg font-semibold mb-4 text-zinc-700 dark:text-zinc-300">전술 카테고리</h2>
        <div className="flex flex-wrap gap-2">
          {Object.entries(THEME_LABEL).map(([key, label]) => (
            <Link
              key={key}
              href={`/puzzles?theme=${key}`}
              className="bg-white dark:bg-zinc-900 border border-zinc-300 dark:border-zinc-800 text-zinc-700 dark:text-zinc-300 text-sm px-3 py-1.5 rounded-full hover:border-zinc-500 dark:hover:border-zinc-600 hover:text-zinc-900 dark:hover:text-white transition-colors"
            >
              {label}
            </Link>
          ))}
        </div>
      </div>
    </div>
  );
}

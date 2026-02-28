"use client";

import { useState, useEffect, useCallback } from "react";
import Link from "next/link";

interface RankUser {
  id: string;
  username: string | null;
  name: string | null;
  image: string | null;
}

interface GlobalRank {
  rank: number;
  user: RankUser;
  rating: number;
  solvedCount: number;
}

interface PeriodRank {
  rank: number;
  user: RankUser;
  solvedCount: number;
  rating: number | null;
}

type Tab = "global" | "weekly" | "monthly";

const TAB_LABEL: Record<Tab, string> = {
  global: "전체",
  weekly: "이번 주",
  monthly: "이번 달",
};

const MEDAL: Record<number, string> = { 1: "🥇", 2: "🥈", 3: "🥉" };

function Avatar({ user, size = "sm" }: { user: RankUser; size?: "sm" | "lg" }) {
  const dim = size === "lg" ? "w-10 h-10 text-sm" : "w-8 h-8 text-xs";
  const displayName = user.name || user.username || "?";
  const initial = displayName[0]?.toUpperCase() ?? "?";

  if (user.image) {
    return (
      <img
        src={user.image}
        alt=""
        className={`${dim} rounded-full object-cover flex-shrink-0`}
      />
    );
  }
  return (
    <div
      className={`${dim} rounded-full bg-zinc-400 dark:bg-zinc-700 flex items-center justify-center font-semibold flex-shrink-0 text-zinc-900 dark:text-white`}
    >
      {initial}
    </div>
  );
}

function RankBadge({ rank }: { rank: number }) {
  if (rank <= 3) {
    return <span className="text-xl w-8 text-center">{MEDAL[rank]}</span>;
  }
  return (
    <span className="w-8 text-center text-sm font-mono text-zinc-500 dark:text-zinc-400">
      {rank}
    </span>
  );
}

export default function LeaderboardPage() {
  const [tab, setTab] = useState<Tab>("global");
  const [rankings, setRankings] = useState<(GlobalRank | PeriodRank)[]>([]);
  const [pagination, setPagination] = useState({ page: 1, totalPages: 1, total: 0 });
  const [page, setPage] = useState(1);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetchRankings = useCallback(async (currentTab: Tab, currentPage: number) => {
    setLoading(true);
    setError(null);
    try {
      const periodMap: Record<Tab, string> = {
        global: "all",
        weekly: "weekly",
        monthly: "monthly",
      };
      const url = `/api/leaderboard?period=${periodMap[currentTab]}&page=${currentPage}`;
      const res = await fetch(url);
      if (!res.ok) throw new Error("서버 오류");
      const data = await res.json();
      setRankings(data.rankings);
      setPagination(data.pagination);
    } catch {
      setError("랭킹을 불러오는 데 실패했습니다.");
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchRankings(tab, page);
  }, [tab, page, fetchRankings]);

  const handleTabChange = (newTab: Tab) => {
    setTab(newTab);
    setPage(1);
  };

  return (
    <div className="max-w-3xl mx-auto px-4 py-8">
      {/* 헤더 */}
      <div className="mb-8">
        <h1 className="text-2xl font-bold mb-1 text-zinc-900 dark:text-white">리더보드</h1>
        <p className="text-sm text-zinc-500 dark:text-zinc-400">퍼즐 레이팅 기준 상위 플레이어</p>
      </div>

      {/* 탭 */}
      <div className="flex gap-1 bg-zinc-200 dark:bg-zinc-900 border border-zinc-300 dark:border-zinc-800 rounded-xl p-1 mb-6 w-fit">
        {(["global", "weekly", "monthly"] as Tab[]).map((t) => (
          <button
            key={t}
            onClick={() => handleTabChange(t)}
            className={`px-4 py-1.5 text-sm font-medium rounded-lg transition-colors ${
              tab === t
                ? "bg-white dark:bg-white text-zinc-900 dark:text-black shadow-sm"
                : "text-zinc-600 dark:text-zinc-400 hover:text-zinc-900 dark:hover:text-white"
            }`}
          >
            {TAB_LABEL[t]}
          </button>
        ))}
      </div>

      {/* 설명 텍스트 */}
      {tab !== "global" && (
        <p className="text-xs text-zinc-600 dark:text-zinc-500 mb-4">
          {tab === "weekly" ? "최근 7일" : "최근 30일"} 동안 가장 많은 퍼즐을 해결한 유저 순입니다.
        </p>
      )}

      {/* 콘텐츠 */}
      {loading ? (
        <div className="space-y-2">
          {Array.from({ length: 10 }).map((_, i) => (
            <div key={i} className="h-16 bg-zinc-200 dark:bg-zinc-900 border border-zinc-300 dark:border-zinc-800 rounded-xl animate-pulse" />
          ))}
        </div>
      ) : error ? (
        <div className="text-center py-16 text-zinc-500 dark:text-zinc-400">{error}</div>
      ) : rankings.length === 0 ? (
        <div className="text-center py-16 text-zinc-500 dark:text-zinc-400">
          <p className="text-4xl mb-4">🏆</p>
          <p>아직 랭킹 데이터가 없습니다.</p>
          <Link
            href="/puzzle"
            className="mt-4 inline-block text-sm text-zinc-500 dark:text-zinc-400 hover:text-zinc-900 dark:hover:text-white underline"
          >
            퍼즐 풀러 가기
          </Link>
        </div>
      ) : (
        <>
          {/* 상위 3명 하이라이트 */}
          {page === 1 && rankings.length >= 3 && (
            <div className="grid grid-cols-3 gap-3 mb-6">
              {/* 2위 */}
              <div className="flex flex-col items-center pt-4">
                <Avatar user={rankings[1].user} size="lg" />
                <div className="text-2xl mt-2">🥈</div>
                <p className="text-sm font-medium mt-1 text-center truncate w-full px-1 text-zinc-900 dark:text-white">
                  {rankings[1].user.name || rankings[1].user.username || "익명"}
                </p>
                <p className="text-xs text-zinc-500 dark:text-zinc-400">
                  {tab === "global"
                    ? `${(rankings[1] as GlobalRank).rating} 점`
                    : `${rankings[1].solvedCount}개 해결`}
                </p>
              </div>
              {/* 1위 */}
              <div className="flex flex-col items-center border border-zinc-300 dark:border-zinc-700 rounded-xl py-4 bg-zinc-100 dark:bg-zinc-900/60">
                <Avatar user={rankings[0].user} size="lg" />
                <div className="text-2xl mt-2">🥇</div>
                <p className="text-sm font-semibold mt-1 text-center truncate w-full px-1 text-zinc-900 dark:text-white">
                  {rankings[0].user.name || rankings[0].user.username || "익명"}
                </p>
                <p className="text-xs text-zinc-500 dark:text-zinc-400">
                  {tab === "global"
                    ? `${(rankings[0] as GlobalRank).rating} 점`
                    : `${rankings[0].solvedCount}개 해결`}
                </p>
              </div>
              {/* 3위 */}
              <div className="flex flex-col items-center pt-4">
                <Avatar user={rankings[2].user} size="lg" />
                <div className="text-2xl mt-2">🥉</div>
                <p className="text-sm font-medium mt-1 text-center truncate w-full px-1 text-zinc-900 dark:text-white">
                  {rankings[2].user.name || rankings[2].user.username || "익명"}
                </p>
                <p className="text-xs text-zinc-500 dark:text-zinc-400">
                  {tab === "global"
                    ? `${(rankings[2] as GlobalRank).rating} 점`
                    : `${rankings[2].solvedCount}개 해결`}
                </p>
              </div>
            </div>
          )}

          {/* 전체 목록 */}
          <div className="space-y-2">
            {rankings.map((entry) => {
              const displayName = entry.user.name || entry.user.username || "익명";
              const isGlobal = tab === "global";
              const globalEntry = entry as GlobalRank;

              return (
                <Link
                  key={entry.user.id}
                  href={`/profile/${entry.user.id}`}
                  className="flex items-center gap-4 bg-white dark:bg-zinc-900 hover:bg-zinc-50 dark:hover:bg-zinc-800 border border-zinc-200 dark:border-zinc-800 hover:border-zinc-300 dark:hover:border-zinc-700 rounded-xl px-4 py-3 transition-colors group"
                >
                  <RankBadge rank={entry.rank} />

                  <Avatar user={entry.user} />

                  <div className="flex-1 min-w-0">
                    <p className="text-sm font-medium text-zinc-900 dark:text-white truncate">{displayName}</p>
                    {entry.user.username && entry.user.username !== entry.user.name && (
                      <p className="text-xs text-zinc-500 dark:text-zinc-600 truncate">@{entry.user.username}</p>
                    )}
                  </div>

                  <div className="text-right flex-shrink-0">
                    {isGlobal ? (
                      <>
                        <p className="text-sm font-semibold text-zinc-900 dark:text-white">{globalEntry.rating}</p>
                        <p className="text-xs text-zinc-500 dark:text-zinc-400">{globalEntry.solvedCount}개 해결</p>
                      </>
                    ) : (
                      <>
                        <p className="text-sm font-semibold text-zinc-900 dark:text-white">{entry.solvedCount}개</p>
                        <p className="text-xs text-zinc-500 dark:text-zinc-400">해결</p>
                      </>
                    )}
                  </div>
                </Link>
              );
            })}
          </div>

          {/* 페이지네이션 */}
          {pagination.totalPages > 1 && (
            <div className="flex justify-center gap-2 mt-8">
              <button
                disabled={page <= 1}
                onClick={() => setPage((p) => p - 1)}
                className="px-4 py-2 text-sm border border-zinc-300 dark:border-zinc-700 rounded-lg text-zinc-600 dark:text-zinc-400 hover:bg-zinc-100 dark:hover:bg-zinc-800 transition-colors disabled:opacity-30 disabled:cursor-not-allowed"
              >
                ← 이전
              </button>
              <span className="px-4 py-2 text-sm text-zinc-500 dark:text-zinc-400">
                {page} / {pagination.totalPages}
              </span>
              <button
                disabled={page >= pagination.totalPages}
                onClick={() => setPage((p) => p + 1)}
                className="px-4 py-2 text-sm border border-zinc-300 dark:border-zinc-700 rounded-lg text-zinc-600 dark:text-zinc-400 hover:bg-zinc-100 dark:hover:bg-zinc-800 transition-colors disabled:opacity-30 disabled:cursor-not-allowed"
              >
                다음 →
              </button>
            </div>
          )}
        </>
      )}
    </div>
  );
}

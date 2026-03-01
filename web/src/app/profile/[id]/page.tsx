"use client";
import { useEffect, useState, useCallback } from "react";
import { useSession } from "next-auth/react";
import { useParams, useRouter } from "next/navigation";
import Link from "next/link";

// ─── 타입 ─────────────────────────────────────────────────────────────────────

interface CategoryRating {
  category: string;
  rating: number;
  rd: number;
}

interface User {
  id: string;
  username: string | null;
  name: string | null;
  image: string | null;
  rating: number;
  createdAt: string;
  categoryRatings: CategoryRating[];
}

interface Stats {
  totalAttempts: number;
  solvedAttempts: number;
  solveRate: number;
  hintUsageRate: number;
  avgSolveSeconds: number | null;
}

interface RatingPoint {
  date: string;
  rating: number;
}

interface CategoryStat {
  category: string;
  total: number;
  solved: number;
  solveRate: number;
}

interface Attempt {
  id: string;
  solved: boolean;
  hintUsed: boolean;
  timeSpentSeconds: number | null;
  ratingBefore: number;
  ratingAfter: number;
  createdAt: string;
  puzzle: {
    id: string;
    rating: number;
    themes: string[];
    gamePhase: string;
  };
}

// ─── 상수 ─────────────────────────────────────────────────────────────────────

const THEME_LABEL: Record<string, string> = {
  FORK: "포크", PIN: "핀", SKEWER: "스큐어", DISCOVERED_ATTACK: "발견 공격",
  DOUBLE_CHECK: "이중 체크", MATE_IN_1: "메이트 인 1", MATE_IN_2: "메이트 인 2",
  MATE_IN_3: "메이트 인 3", MATE_IN_4: "메이트 인 4", MATE_IN_5: "메이트 인 5",
  QUEEN_SACRIFICE: "퀸 희생", ROOK_ENDGAME: "룩 엔드게임", PAWN_PROMOTION: "폰 프로모션",
  TRAP: "트랩", BACK_RANK: "백 랭크", HANGING_PIECE: "행잉 피스",
  DEFLECTION: "디플렉션", DECOY: "디코이", INTERFERENCE: "인터퍼런스", ZUGZWANG: "쭉츠방",
};

// ─── 서브 컴포넌트: 레이팅 SVG 차트 ──────────────────────────────────────────

function RatingChart({ data }: { data: RatingPoint[] }) {
  if (data.length < 2) {
    return (
      <div className="h-36 flex items-center justify-center text-zinc-500 dark:text-zinc-600 text-sm">
        데이터가 부족합니다 (퍼즐을 풀면 그래프가 표시됩니다)
      </div>
    );
  }

  const W = 600;
  const H = 120;
  const PAD = { top: 12, right: 12, bottom: 24, left: 44 };
  const chartW = W - PAD.left - PAD.right;
  const chartH = H - PAD.top - PAD.bottom;

  const ratings = data.map((d) => d.rating);
  const minR = Math.min(...ratings) - 30;
  const maxR = Math.max(...ratings) + 30;

  const xScale = (i: number) => (i / (data.length - 1)) * chartW;
  const yScale = (r: number) => chartH - ((r - minR) / (maxR - minR)) * chartH;

  const pathD = data
    .map((d, i) => `${i === 0 ? "M" : "L"} ${xScale(i).toFixed(1)} ${yScale(d.rating).toFixed(1)}`)
    .join(" ");

  const areaD =
    pathD +
    ` L ${xScale(data.length - 1).toFixed(1)} ${chartH} L 0 ${chartH} Z`;

  // Y축 눈금 (3개)
  const yTicks = [minR + 30, Math.round((minR + maxR) / 2), maxR - 30];

  // X축: 첫/중간/마지막 날짜
  const xTicks = [0, Math.floor(data.length / 2), data.length - 1];

  return (
    <svg
      viewBox={`0 0 ${W} ${H}`}
      className="w-full"
      style={{ height: 120 }}
    >
      <g transform={`translate(${PAD.left}, ${PAD.top})`}>
        {/* 그리드 */}
        {yTicks.map((r) => (
          <line
            key={r}
            x1={0} y1={yScale(r).toFixed(1)}
            x2={chartW} y2={yScale(r).toFixed(1)}
            stroke="#3f3f46" strokeWidth="1"
          />
        ))}

        {/* Y축 레이블 */}
        {yTicks.map((r) => (
          <text
            key={r}
            x={-6} y={yScale(r)}
            dominantBaseline="middle"
            textAnchor="end"
            fontSize={10}
            fill="#71717a"
          >
            {r}
          </text>
        ))}

        {/* X축 레이블 */}
        {xTicks.map((i) => (
          <text
            key={i}
            x={xScale(i)} y={chartH + 14}
            textAnchor="middle"
            fontSize={10}
            fill="#71717a"
          >
            {new Date(data[i].date).toLocaleDateString("ko-KR", { month: "short", day: "numeric" })}
          </text>
        ))}

        {/* 영역 채우기 */}
        <path d={areaD} fill="rgba(255,255,255,0.04)" />

        {/* 라인 */}
        <path d={pathD} fill="none" stroke="#a1a1aa" strokeWidth="1.5" strokeLinejoin="round" />

        {/* 마지막 포인트 */}
        <circle
          cx={xScale(data.length - 1).toFixed(1)}
          cy={yScale(data[data.length - 1].rating).toFixed(1)}
          r="3"
          fill="white"
        />
      </g>
    </svg>
  );
}

// ─── 메인 컴포넌트 ────────────────────────────────────────────────────────────

export default function ProfilePage() {
  const { id } = useParams<{ id: string }>();
  const { data: session } = useSession();
  const router = useRouter();
  const isOwner = session?.user?.id === id;

  const [user, setUser] = useState<User | null>(null);
  const [stats, setStats] = useState<Stats | null>(null);
  const [ratingHistory, setRatingHistory] = useState<RatingPoint[]>([]);
  const [categoryStats, setCategoryStats] = useState<CategoryStat[]>([]);
  const [attempts, setAttempts] = useState<Attempt[]>([]);
  const [attemptsPage, setAttemptsPage] = useState(1);
  const [attemptsTotalPages, setAttemptsTotalPages] = useState(1);
  const [loading, setLoading] = useState(true);
  const [attemptsLoading, setAttemptsLoading] = useState(false);

  // 편집 상태
  const [editing, setEditing] = useState(false);
  const [editName, setEditName] = useState("");
  const [editUsername, setEditUsername] = useState("");
  const [editError, setEditError] = useState("");
  const [editLoading, setEditLoading] = useState(false);

  // 데이터 로드
  useEffect(() => {
    async function load() {
      setLoading(true);
      try {
        const [statsRes] = await Promise.all([
          fetch(`/api/users/${id}/stats`),
        ]);
        if (!statsRes.ok) { router.push("/"); return; }
        const statsData = await statsRes.json();
        setUser(statsData.user);
        setStats(statsData.stats);
        setRatingHistory(statsData.ratingHistory ?? []);
        setCategoryStats(statsData.categoryStats ?? []);
        setEditName(statsData.user.name ?? "");
        setEditUsername(statsData.user.username ?? "");
      } catch {
        router.push("/");
      } finally {
        setLoading(false);
      }
    }
    load();
  }, [id, router]);

  // 시도 기록 로드
  const loadAttempts = useCallback(async (page: number) => {
    setAttemptsLoading(true);
    try {
      const res = await fetch(`/api/users/${id}/attempts?page=${page}`);
      const data = await res.json();
      setAttempts(data.attempts ?? []);
      setAttemptsTotalPages(data.pagination?.totalPages ?? 1);
    } finally {
      setAttemptsLoading(false);
    }
  }, [id]);

  useEffect(() => { loadAttempts(attemptsPage); }, [attemptsPage, loadAttempts]);

  // 프로필 저장
  async function saveEdit() {
    setEditError("");
    setEditLoading(true);
    try {
      const res = await fetch("/api/users/me", {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ name: editName, username: editUsername || undefined }),
      });
      const data = await res.json();
      if (!res.ok) { setEditError(data.error ?? "저장 실패"); return; }
      setUser((prev) => prev ? { ...prev, name: data.user.name, username: data.user.username } : prev);
      setEditing(false);
    } finally {
      setEditLoading(false);
    }
  }

  // ─── 로딩 ────────────────────────────────────────────────────────────────

  if (loading) {
    return (
      <div className="max-w-4xl mx-auto px-4 py-12 space-y-4">
        {[1, 2, 3].map((i) => (
          <div key={i} className="h-24 bg-zinc-200 dark:bg-zinc-900 rounded-xl animate-pulse" />
        ))}
      </div>
    );
  }

  if (!user) return null;

  const displayName = user.name || user.username || "익명";
  const joinedYear = new Date(user.createdAt).getFullYear();

  // ─── 렌더 ────────────────────────────────────────────────────────────────

  return (
    <div className="max-w-4xl mx-auto px-4 py-8 space-y-5">

      {/* ① 유저 헤더 */}
      <div className="bg-white dark:bg-zinc-900 border border-zinc-200 dark:border-zinc-800 rounded-xl p-6">
        <div className="flex items-start gap-4">
          {/* 아바타 */}
          {user.image ? (
            <img src={user.image} alt={displayName} className="w-16 h-16 rounded-full flex-shrink-0" />
          ) : (
            <div className="w-16 h-16 rounded-full bg-zinc-400 dark:bg-zinc-700 flex items-center justify-center text-2xl font-bold flex-shrink-0 text-zinc-900 dark:text-white">
              {displayName[0]?.toUpperCase() ?? "?"}
            </div>
          )}

          {/* 이름 정보 */}
          <div className="flex-1 min-w-0">
            {editing ? (
              <div className="space-y-2">
                <input
                  value={editName}
                  onChange={(e) => setEditName(e.target.value)}
                  placeholder="표시 이름"
                  className="w-full bg-zinc-100 dark:bg-zinc-800 border border-zinc-300 dark:border-zinc-700 rounded-lg px-3 py-2 text-sm text-zinc-900 dark:text-white placeholder-zinc-500 focus:outline-none focus:border-zinc-500"
                />
                <input
                  value={editUsername}
                  onChange={(e) => setEditUsername(e.target.value)}
                  placeholder="아이디 (영문, 숫자, _)"
                  className="w-full bg-zinc-100 dark:bg-zinc-800 border border-zinc-300 dark:border-zinc-700 rounded-lg px-3 py-2 text-sm text-zinc-900 dark:text-white placeholder-zinc-500 focus:outline-none focus:border-zinc-500"
                />
                {editError && <p className="text-red-400 text-xs">{editError}</p>}
                <div className="flex gap-2">
                  <button
                    onClick={saveEdit}
                    disabled={editLoading}
                    className="px-4 py-1.5 bg-white text-black text-xs font-medium rounded-lg hover:bg-zinc-200 disabled:opacity-50 transition-colors"
                  >
                    {editLoading ? "저장 중..." : "저장"}
                  </button>
                  <button
                    onClick={() => { setEditing(false); setEditError(""); }}
                    className="px-4 py-1.5 border border-zinc-300 dark:border-zinc-700 text-zinc-600 dark:text-zinc-400 text-xs rounded-lg hover:bg-zinc-100 dark:hover:bg-zinc-800 transition-colors"
                  >
                    취소
                  </button>
                </div>
              </div>
            ) : (
              <>
                <div className="flex items-center gap-2 flex-wrap">
                  <h1 className="text-xl font-bold text-zinc-900 dark:text-white truncate">{displayName}</h1>
                  {user.username && (
                    <span className="text-zinc-500 dark:text-zinc-400 text-sm font-mono">@{user.username}</span>
                  )}
                  {isOwner && (
                    <button
                      onClick={() => setEditing(true)}
                      className="text-xs text-zinc-500 dark:text-zinc-600 hover:text-zinc-700 dark:hover:text-zinc-400 transition-colors border border-zinc-300 dark:border-zinc-700 px-2 py-0.5 rounded"
                    >
                      편집
                    </button>
                  )}
                </div>
                <p className="text-zinc-500 dark:text-zinc-400 text-sm mt-0.5">{joinedYear}년 가입</p>
              </>
            )}
          </div>

          {/* 레이팅 */}
          <div className="text-right flex-shrink-0">
            <div className="text-3xl font-bold font-mono text-zinc-900 dark:text-white">{user.rating}</div>
            <div className="text-xs text-zinc-500 dark:text-zinc-400 mt-0.5">종합 레이팅</div>
          </div>
        </div>
      </div>

      {/* ② 핵심 통계 카드 */}
      {stats && (
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
          {[
            { label: "총 시도", value: stats.totalAttempts.toLocaleString() },
            {
              label: "정답률",
              value: stats.totalAttempts > 0
                ? `${(stats.solveRate * 100).toFixed(1)}%`
                : "—",
            },
            {
              label: "힌트 사용률",
              value: stats.totalAttempts > 0
                ? `${(stats.hintUsageRate * 100).toFixed(1)}%`
                : "—",
            },
            {
              label: "평균 풀이",
              value: stats.avgSolveSeconds != null
                ? `${Math.round(stats.avgSolveSeconds)}초`
                : "—",
            },
          ].map((s) => (
            <div key={s.label} className="bg-white dark:bg-zinc-900 border border-zinc-200 dark:border-zinc-800 rounded-xl p-4">
              <div className="text-xl font-bold font-mono text-zinc-900 dark:text-white">{s.value}</div>
              <div className="text-xs text-zinc-500 dark:text-zinc-400 mt-1">{s.label}</div>
            </div>
          ))}
        </div>
      )}

      {/* ③ 레이팅 그래프 */}
      <div className="bg-white dark:bg-zinc-900 border border-zinc-200 dark:border-zinc-800 rounded-xl p-5">
        <h2 className="text-sm font-semibold text-zinc-700 dark:text-zinc-300 mb-4">레이팅 추이 (최근 30일)</h2>
        <RatingChart data={ratingHistory} />
      </div>

      {/* ④ 테마별 성과 */}
      {categoryStats.length > 0 && (
        <div className="bg-white dark:bg-zinc-900 border border-zinc-200 dark:border-zinc-800 rounded-xl p-5">
          <h2 className="text-sm font-semibold text-zinc-700 dark:text-zinc-300 mb-4">전술 테마별 정답률</h2>
          <div className="space-y-3">
            {categoryStats.map((s) => (
              <div key={s.category}>
                <div className="flex justify-between items-center mb-1">
                  <span className="text-xs text-zinc-600 dark:text-zinc-400">
                    {THEME_LABEL[s.category] ?? s.category}
                  </span>
                  <span className="text-xs text-zinc-500 dark:text-zinc-400 font-mono">
                    {s.solved}/{s.total} ({(s.solveRate * 100).toFixed(0)}%)
                  </span>
                </div>
                <div className="h-1.5 bg-zinc-200 dark:bg-zinc-800 rounded-full overflow-hidden">
                  <div
                    className="h-full rounded-full transition-all duration-500"
                    style={{
                      width: `${(s.solveRate * 100).toFixed(1)}%`,
                      backgroundColor: s.solveRate >= 0.7 ? "#4ade80" : s.solveRate >= 0.4 ? "#facc15" : "#f87171",
                    }}
                  />
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* ⑤ 카테고리별 레이팅 */}
      {user.categoryRatings.length > 0 && (
        <div className="bg-white dark:bg-zinc-900 border border-zinc-200 dark:border-zinc-800 rounded-xl p-5">
          <h2 className="text-sm font-semibold text-zinc-700 dark:text-zinc-300 mb-4">카테고리별 레이팅</h2>
          <div className="grid grid-cols-2 sm:grid-cols-3 gap-2">
            {user.categoryRatings.map((cr) => (
              <div key={cr.category} className="bg-zinc-100 dark:bg-zinc-800/50 rounded-lg p-3">
                <div className="text-xs text-zinc-500 dark:text-zinc-400 mb-1">
                  {THEME_LABEL[cr.category] ?? cr.category}
                </div>
                <div className="text-lg font-bold font-mono text-zinc-900 dark:text-white">{cr.rating}</div>
                <div className="text-xs text-zinc-500 dark:text-zinc-600">±{Math.round(cr.rd)}</div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* ⑥ 최근 풀기 기록 */}
      <div className="bg-white dark:bg-zinc-900 border border-zinc-200 dark:border-zinc-800 rounded-xl p-5">
        <h2 className="text-sm font-semibold text-zinc-700 dark:text-zinc-300 mb-4">최근 풀기 기록</h2>

        {attemptsLoading ? (
          <div className="space-y-2">
            {[1, 2, 3].map((i) => (
              <div key={i} className="h-10 bg-zinc-200 dark:bg-zinc-800 rounded animate-pulse" />
            ))}
          </div>
        ) : attempts.length === 0 ? (
          <p className="text-zinc-500 dark:text-zinc-600 text-sm text-center py-6">아직 풀기 기록이 없습니다</p>
        ) : (
          <>
            <div className="overflow-x-auto">
              <table className="w-full text-sm">
                <thead>
                  <tr className="text-xs text-zinc-500 dark:text-zinc-400 border-b border-zinc-300 dark:border-zinc-800">
                    <th className="text-left pb-2 font-normal">퍼즐</th>
                    <th className="text-left pb-2 font-normal">테마</th>
                    <th className="text-center pb-2 font-normal">결과</th>
                    <th className="text-right pb-2 font-normal">레이팅 변화</th>
                    <th className="text-right pb-2 font-normal">시간</th>
                    <th className="text-right pb-2 font-normal">날짜</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-zinc-200 dark:divide-zinc-800/60">
                  {attempts.map((a) => {
                    const delta = a.ratingAfter - a.ratingBefore;
                    return (
                      <tr key={a.id} className="hover:bg-zinc-100 dark:hover:bg-zinc-800/30 transition-colors">
                        <td className="py-2.5 pr-3">
                          <Link
                            href={`/puzzle/${a.puzzle.id}`}
                            className="font-mono text-xs text-zinc-500 dark:text-zinc-400 hover:text-zinc-900 dark:hover:text-white transition-colors"
                          >
                            #{a.puzzle.id}
                          </Link>
                          <span className="ml-2 text-xs text-zinc-500 dark:text-zinc-600">{a.puzzle.rating}</span>
                        </td>
                        <td className="py-2.5 pr-3">
                          <div className="flex flex-wrap gap-1">
                            {a.puzzle.themes.slice(0, 2).map((t) => (
                              <span key={t} className="text-xs bg-zinc-200 dark:bg-zinc-800 text-zinc-600 dark:text-zinc-400 px-1.5 py-0.5 rounded">
                                {THEME_LABEL[t] ?? t}
                              </span>
                            ))}
                          </div>
                        </td>
                        <td className="py-2.5 text-center">
                          {a.solved ? (
                            <span className="text-green-400 font-bold">○</span>
                          ) : (
                            <span className="text-red-400 font-bold">×</span>
                          )}
                          {a.hintUsed && (
                            <span className="ml-1 text-yellow-600 text-xs">힌트</span>
                          )}
                        </td>
                        <td className="py-2.5 text-right font-mono text-xs">
                          <span className={delta >= 0 ? "text-green-400" : "text-red-400"}>
                            {delta >= 0 ? "+" : ""}{delta}
                          </span>
                          <span className="text-zinc-500 dark:text-zinc-600 ml-1">→{a.ratingAfter}</span>
                        </td>
                        <td className="py-2.5 text-right text-xs text-zinc-500 dark:text-zinc-400">
                          {a.timeSpentSeconds != null ? `${a.timeSpentSeconds}초` : "—"}
                        </td>
                        <td className="py-2.5 text-right text-xs text-zinc-500 dark:text-zinc-600">
                          {new Date(a.createdAt).toLocaleDateString("ko-KR", {
                            month: "short", day: "numeric",
                          })}
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </div>

            {/* 페이지네이션 */}
            {attemptsTotalPages > 1 && (
              <div className="flex items-center justify-center gap-2 mt-4">
                <button
                  onClick={() => setAttemptsPage((p) => Math.max(1, p - 1))}
                  disabled={attemptsPage === 1}
                  className="px-3 py-1.5 text-xs border border-zinc-300 dark:border-zinc-700 text-zinc-600 dark:text-zinc-400 rounded hover:bg-zinc-100 dark:hover:bg-zinc-800 disabled:opacity-30 transition-colors"
                >
                  이전
                </button>
                <span className="text-xs text-zinc-500 dark:text-zinc-400">
                  {attemptsPage} / {attemptsTotalPages}
                </span>
                <button
                  onClick={() => setAttemptsPage((p) => Math.min(attemptsTotalPages, p + 1))}
                  disabled={attemptsPage === attemptsTotalPages}
                  className="px-3 py-1.5 text-xs border border-zinc-300 dark:border-zinc-700 text-zinc-600 dark:text-zinc-400 rounded hover:bg-zinc-100 dark:hover:bg-zinc-800 disabled:opacity-30 transition-colors"
                >
                  다음
                </button>
              </div>
            )}
          </>
        )}
      </div>
    </div>
  );
}

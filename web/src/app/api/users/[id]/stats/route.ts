import { NextRequest, NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";

export async function GET(
  _req: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const user = await prisma.user.findUnique({
      where: { id: params.id },
      select: {
        id: true,
        username: true,
        name: true,
        image: true,
        rating: true,
        styleProfile: true,
        createdAt: true,
        categoryRatings: {
          select: { category: true, rating: true, rd: true },
          orderBy: { rating: "desc" },
        },
      },
    });

    if (!user) {
      return NextResponse.json({ error: "User not found" }, { status: 404 });
    }

    // 전체 시도 통계
    const [totalAttempts, solvedAttempts, hintAttempts] = await Promise.all([
      prisma.puzzleAttempt.count({ where: { userId: params.id } }),
      prisma.puzzleAttempt.count({ where: { userId: params.id, solved: true } }),
      prisma.puzzleAttempt.count({ where: { userId: params.id, hintUsed: true } }),
    ]);

    // 평균 풀이 시간
    const avgTimeResult = await prisma.puzzleAttempt.aggregate({
      where: { userId: params.id, timeSpentSeconds: { not: null } },
      _avg: { timeSpentSeconds: true },
    });

    // 최근 30일 레이팅 변화 (날짜별 최신 값)
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

    const recentAttempts = await prisma.puzzleAttempt.findMany({
      where: { userId: params.id, createdAt: { gte: thirtyDaysAgo } },
      select: { ratingAfter: true, createdAt: true, solved: true },
      orderBy: { createdAt: "asc" },
    });

    // 일별 그룹핑 (활동 히트맵용)
    const dailyActivity: Record<string, { attempts: number; solved: number }> = {};
    for (const a of recentAttempts) {
      const day = a.createdAt.toISOString().slice(0, 10);
      if (!dailyActivity[day]) dailyActivity[day] = { attempts: 0, solved: 0 };
      dailyActivity[day].attempts++;
      if (a.solved) dailyActivity[day].solved++;
    }

    // 레이팅 히스토리 (시도마다 ratingAfter 기록)
    const ratingHistory = recentAttempts.map((a) => ({
      date: a.createdAt.toISOString(),
      rating: a.ratingAfter,
    }));

    // 전술 카테고리별 정답률
    const categoryStats = await prisma.$queryRaw<
      { category: string; total: bigint; solved: bigint }[]
    >`
      SELECT p.themes[1]::text as category,
             COUNT(*) as total,
             COUNT(*) FILTER (WHERE pa.solved = true) as solved
      FROM "PuzzleAttempt" pa
      JOIN "Puzzle" p ON pa."puzzleId" = p.id
      WHERE pa."userId" = ${params.id}
        AND array_length(p.themes, 1) > 0
      GROUP BY p.themes[1]
      ORDER BY total DESC
      LIMIT 10
    `;

    return NextResponse.json({
      user,
      stats: {
        totalAttempts,
        solvedAttempts,
        solveRate: totalAttempts > 0 ? solvedAttempts / totalAttempts : 0,
        hintUsageRate: totalAttempts > 0 ? hintAttempts / totalAttempts : 0,
        avgSolveSeconds: avgTimeResult._avg.timeSpentSeconds,
      },
      ratingHistory,
      dailyActivity,
      categoryStats: categoryStats.map((s) => ({
        category: s.category,
        total: Number(s.total),
        solved: Number(s.solved),
        solveRate: Number(s.total) > 0 ? Number(s.solved) / Number(s.total) : 0,
      })),
    });
  } catch (error) {
    console.error("[GET /api/users/[id]/stats]", error);
    return NextResponse.json({ error: "Internal server error" }, { status: 500 });
  }
}

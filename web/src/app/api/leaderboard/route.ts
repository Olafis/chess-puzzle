import { NextRequest, NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";
import { PuzzleTheme } from "@prisma/client";

export const dynamic = "force-dynamic";
const PAGE_SIZE = 50;

export async function GET(req: NextRequest) {
  try {
    const { searchParams } = req.nextUrl;
    const categoryParam = searchParams.get("category");
    const periodParam = searchParams.get("period") ?? "all"; // all | monthly | weekly
    const page = Math.max(1, Number(searchParams.get("page") ?? "1"));

    // 카테고리별 랭킹
    if (categoryParam && Object.values(PuzzleTheme).includes(categoryParam as PuzzleTheme)) {
      const category = categoryParam as PuzzleTheme;

      const [rankings, total] = await Promise.all([
        prisma.userCategoryRating.findMany({
          where: { category },
          orderBy: { rating: "desc" },
          skip: (page - 1) * PAGE_SIZE,
          take: PAGE_SIZE,
          include: {
            user: {
              select: { id: true, username: true, name: true, image: true },
            },
          },
        }),
        prisma.userCategoryRating.count({ where: { category } }),
      ]);

      return NextResponse.json({
        type: "category",
        category,
        rankings: rankings.map((r, i) => ({
          rank: (page - 1) * PAGE_SIZE + i + 1,
          user: r.user,
          rating: r.rating,
          rd: r.rd,
        })),
        pagination: {
          page,
          limit: PAGE_SIZE,
          total,
          totalPages: Math.ceil(total / PAGE_SIZE),
        },
      });
    }

    // 기간 필터 (주간/월간)
    let dateFilter: Date | undefined;
    if (periodParam === "weekly") {
      dateFilter = new Date();
      dateFilter.setDate(dateFilter.getDate() - 7);
    } else if (periodParam === "monthly") {
      dateFilter = new Date();
      dateFilter.setMonth(dateFilter.getMonth() - 1);
    }

    if (dateFilter) {
      // 기간별 랭킹: 해당 기간에 가장 많이 푼 유저 순
      const periodRankings = await prisma.puzzleAttempt.groupBy({
        by: ["userId"],
        where: {
          createdAt: { gte: dateFilter },
          solved: true,
        },
        _count: { userId: true },
        _max: { ratingAfter: true },
        orderBy: { _count: { userId: "desc" } },
        skip: (page - 1) * PAGE_SIZE,
        take: PAGE_SIZE,
      });

      const userIds = periodRankings.map((r) => r.userId);
      const users = await prisma.user.findMany({
        where: { id: { in: userIds } },
        select: { id: true, username: true, name: true, image: true, rating: true },
      });
      const userMap = Object.fromEntries(users.map((u) => [u.id, u]));

      const total = await prisma.puzzleAttempt.groupBy({
        by: ["userId"],
        where: { createdAt: { gte: dateFilter }, solved: true },
        _count: { userId: true },
      });

      return NextResponse.json({
        type: "period",
        period: periodParam,
        rankings: periodRankings.map((r, i) => ({
          rank: (page - 1) * PAGE_SIZE + i + 1,
          user: userMap[r.userId],
          solvedCount: r._count.userId,
          rating: r._max.ratingAfter,
        })),
        pagination: {
          page,
          limit: PAGE_SIZE,
          total: total.length,
          totalPages: Math.ceil(total.length / PAGE_SIZE),
        },
      });
    }

    // 전체 랭킹 (rating 기준)
    const [rankings, total] = await Promise.all([
      prisma.user.findMany({
        where: { rating: { gt: 0 } },
        orderBy: { rating: "desc" },
        skip: (page - 1) * PAGE_SIZE,
        take: PAGE_SIZE,
        select: {
          id: true,
          username: true,
          name: true,
          image: true,
          rating: true,
          createdAt: true,
          _count: { select: { puzzleAttempts: { where: { solved: true } } } },
        },
      }),
      prisma.user.count({ where: { rating: { gt: 0 } } }),
    ]);

    return NextResponse.json({
      type: "global",
      period: "all",
      rankings: rankings.map((u, i) => ({
        rank: (page - 1) * PAGE_SIZE + i + 1,
        user: { id: u.id, username: u.username, name: u.name, image: u.image },
        rating: u.rating,
        solvedCount: u._count.puzzleAttempts,
      })),
      pagination: {
        page,
        limit: PAGE_SIZE,
        total,
        totalPages: Math.ceil(total / PAGE_SIZE),
      },
    });
  } catch (error) {
    console.error("[GET /api/leaderboard]", error);
    return NextResponse.json({ error: "Internal server error" }, { status: 500 });
  }
}

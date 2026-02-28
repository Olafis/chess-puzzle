import { NextRequest, NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";
import { auth } from "@/lib/auth";
import { updateRating, applyHintPenalty } from "@/lib/glicko2";

interface AttemptBody {
  solved: boolean;
  hintUsed: boolean;
  timeSpentSeconds?: number;
}

export async function POST(
  req: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const session = await auth();
    if (!session?.user?.id) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const body: AttemptBody = await req.json();
    const { solved, hintUsed = false, timeSpentSeconds } = body;

    if (typeof solved !== "boolean") {
      return NextResponse.json({ error: "solved field is required" }, { status: 400 });
    }
    if (typeof hintUsed !== "boolean") {
      return NextResponse.json({ error: "hintUsed must be boolean" }, { status: 400 });
    }
    // timeSpentSeconds 검증 (DoS/비정상 값 방지)
    const sanitizedTime =
      typeof timeSpentSeconds === "number" && timeSpentSeconds >= 0 && timeSpentSeconds <= 86400
        ? Math.round(timeSpentSeconds)
        : undefined;

    const [puzzle, user] = await Promise.all([
      prisma.puzzle.findUnique({
        where: { id: params.id, isActive: true },
        select: { id: true, rating: true, ratingDeviation: true, volatility: true, themes: true },
      }),
      prisma.user.findUnique({
        where: { id: session.user.id },
        select: { id: true, rating: true },
      }),
    ]);

    if (!puzzle) {
      return NextResponse.json({ error: "Puzzle not found" }, { status: 404 });
    }
    if (!user) {
      return NextResponse.json({ error: "User not found" }, { status: 404 });
    }

    // Glicko-2 레이팅 계산
    // 유저 기준: 퍼즐을 풀면 승(1), 못 풀면 패(0)
    const userPlayer = { rating: user.rating, rd: 200, vol: 0.06 };
    const puzzlePlayer = {
      rating: puzzle.rating,
      rd: puzzle.ratingDeviation,
      vol: puzzle.volatility,
    };

    const userScore = solved ? 1 : 0;
    const puzzleScore = solved ? 0 : 1;

    let newUserRating = updateRating(userPlayer, puzzlePlayer, userScore);
    const newPuzzleRating = updateRating(puzzlePlayer, userPlayer, puzzleScore);

    // 힌트 사용 시 변동폭 50% 감소
    newUserRating = applyHintPenalty(
      { rating: userPlayer.rating, rd: userPlayer.rd, vol: userPlayer.vol },
      newUserRating,
      hintUsed
    );

    // 카테고리별 레이팅 업데이트 (upsert)
    const categoryUpdates = puzzle.themes.map((theme) =>
      prisma.userCategoryRating.upsert({
        where: { userId_category: { userId: user.id, category: theme } },
        update: {
          rating: newUserRating.rating,
          rd: newUserRating.rd,
          vol: newUserRating.vol,
        },
        create: {
          userId: user.id,
          category: theme,
          rating: newUserRating.rating,
          rd: newUserRating.rd,
          vol: newUserRating.vol,
        },
      })
    );

    // 트랜잭션으로 원자적 처리
    const [attempt] = await prisma.$transaction([
      prisma.puzzleAttempt.create({
        data: {
          userId: user.id,
          puzzleId: puzzle.id,
          solved,
          hintUsed,
          timeSpentSeconds: sanitizedTime,
          ratingBefore: user.rating,
          ratingAfter: newUserRating.rating,
        },
      }),
      prisma.user.update({
        where: { id: user.id },
        data: { rating: newUserRating.rating },
      }),
      prisma.puzzle.update({
        where: { id: puzzle.id },
        data: {
          rating: newPuzzleRating.rating,
          ratingDeviation: newPuzzleRating.rd,
          volatility: newPuzzleRating.vol,
          solveCount: solved ? { increment: 1 } : undefined,
          failCount: !solved ? { increment: 1 } : undefined,
        },
      }),
      ...categoryUpdates,
    ]);

    return NextResponse.json({
      attempt: {
        id: attempt.id,
        solved,
        hintUsed,
      },
      ratingChange: {
        before: user.rating,
        after: newUserRating.rating,
        delta: newUserRating.rating - user.rating,
      },
    });
  } catch (error) {
    console.error("[POST /api/puzzles/[id]/attempt]", error);
    return NextResponse.json({ error: "Internal server error" }, { status: 500 });
  }
}

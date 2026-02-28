import { NextRequest, NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";
import { auth } from "@/lib/auth";
import { GamePhase, PuzzleTheme, Prisma } from "@prisma/client";

const RATING_WINDOW = 200; // 유저 레이팅 ±200 범위

export async function GET(req: NextRequest) {
  try {
    const { searchParams } = req.nextUrl;
    const themeParam = searchParams.get("theme");
    const phaseParam = searchParams.get("phase");

    // 로그인 유저면 레이팅 매칭, 아니면 1200~1600 기본 범위
    const session = await auth();
    let targetRating = 1400;

    if (session?.user?.id) {
      const user = await prisma.user.findUnique({
        where: { id: session.user.id },
        select: { rating: true },
      });
      if (user) targetRating = user.rating;
    }

    const where: Prisma.PuzzleWhereInput = {
      isActive: true,
      rating: {
        gte: targetRating - RATING_WINDOW,
        lte: targetRating + RATING_WINDOW,
      },
    };

    // 이미 푼 퍼즐 제외 (로그인 시)
    if (session?.user?.id) {
      const solvedIds = await prisma.puzzleAttempt.findMany({
        where: { userId: session.user.id, solved: true },
        select: { puzzleId: true },
      });
      if (solvedIds.length > 0) {
        where.id = { notIn: solvedIds.map((a) => a.puzzleId) };
      }
    }

    if (themeParam) {
      const themes = themeParam.split(",").filter((t) =>
        Object.values(PuzzleTheme).includes(t as PuzzleTheme)
      ) as PuzzleTheme[];
      if (themes.length > 0) where.themes = { hasSome: themes };
    }

    if (phaseParam && Object.values(GamePhase).includes(phaseParam as GamePhase)) {
      where.gamePhase = phaseParam as GamePhase;
    }

    const count = await prisma.puzzle.count({ where });
    if (count === 0) {
      // 조건 완화 후 재시도 (이미 푼 퍼즐 포함, 레이팅 범위 확장)
      const fallback = await prisma.puzzle.findFirst({
        where: { isActive: true },
        orderBy: { createdAt: "desc" },
        include: { sourceGame: { select: { whitePlayer: true, blackPlayer: true, result: true } } },
      });
      if (!fallback) {
        return NextResponse.json({ error: "No puzzles available" }, { status: 404 });
      }
      return NextResponse.json({ puzzle: fallback });
    }

    // 랜덤 오프셋으로 퍼즐 선택
    const skip = Math.floor(Math.random() * count);
    const puzzle = await prisma.puzzle.findFirst({
      where,
      skip,
      include: {
        sourceGame: {
          select: {
            id: true,
            whitePlayer: true,
            blackPlayer: true,
            whiteElo: true,
            blackElo: true,
            event: true,
            result: true,
          },
        },
      },
    });

    return NextResponse.json({ puzzle });
  } catch (error) {
    console.error("[GET /api/puzzles/random]", error);
    return NextResponse.json({ error: "Internal server error" }, { status: 500 });
  }
}

import { NextRequest, NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";
import { GamePhase, PuzzleTheme, Prisma } from "@prisma/client";

export const dynamic = "force-dynamic";
const PAGE_SIZE = 20;

export async function GET(req: NextRequest) {
  try {
    const { searchParams } = req.nextUrl;

    const page = Math.max(1, Number(searchParams.get("page") ?? "1"));
    const limit = Math.min(50, Math.max(1, Number(searchParams.get("limit") ?? PAGE_SIZE)));
    const skip = (page - 1) * limit;

    // 필터 파싱
    const themeParam = searchParams.get("theme");
    const phaseParam = searchParams.get("phase");
    const ecoParam = searchParams.get("eco");
    const minRating = searchParams.get("minRating");
    const maxRating = searchParams.get("maxRating");
    const sortParam = searchParams.get("sort") ?? "rating"; // rating | newest | popular

    const where: Prisma.PuzzleWhereInput = { isActive: true };

    if (themeParam) {
      const themes = themeParam.split(",").filter((t) =>
        Object.values(PuzzleTheme).includes(t as PuzzleTheme)
      ) as PuzzleTheme[];
      if (themes.length > 0) {
        where.themes = { hasSome: themes };
      }
    }

    if (phaseParam && Object.values(GamePhase).includes(phaseParam as GamePhase)) {
      where.gamePhase = phaseParam as GamePhase;
    }

    if (ecoParam) {
      where.openingEco = { startsWith: ecoParam.toUpperCase() };
    }

    if (minRating || maxRating) {
      where.rating = {
        ...(minRating ? { gte: Number(minRating) } : {}),
        ...(maxRating ? { lte: Number(maxRating) } : {}),
      };
    }

    const orderBy: Prisma.PuzzleOrderByWithRelationInput =
      sortParam === "newest"
        ? { createdAt: "desc" }
        : sortParam === "popular"
        ? { solveCount: "desc" }
        : { rating: "asc" };

    const [puzzles, total] = await Promise.all([
      prisma.puzzle.findMany({
        where,
        orderBy,
        skip,
        take: limit,
        select: {
          id: true,
          fen: true,
          rating: true,
          themes: true,
          gamePhase: true,
          openingEco: true,
          openingName: true,
          solveCount: true,
          failCount: true,
          likeCount: true,
          dislikeCount: true,
          moveIndex: true,
          createdAt: true,
          sourceGame: {
            select: {
              whitePlayer: true,
              blackPlayer: true,
              event: true,
              date: true,
              result: true,
            },
          },
        },
      }),
      prisma.puzzle.count({ where }),
    ]);

    return NextResponse.json({
      puzzles,
      pagination: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit),
      },
    });
  } catch (error) {
    console.error("[GET /api/puzzles]", error);
    return NextResponse.json({ error: "Internal server error" }, { status: 500 });
  }
}

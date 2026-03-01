import { prisma } from "@/lib/prisma";
import { GamePhase, PuzzleTheme, Prisma } from "@prisma/client";

const RATING_WINDOW = 200;

const puzzleSelect = {
  id: true,
  fen: true,
  moves: true,
  blunderMove: true,
  preBblunderFen: true,
  rating: true,
  themes: true,
  gamePhase: true,
  openingEco: true,
  openingName: true,
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
} as const;

export type RandomPuzzleResult = Awaited<ReturnType<typeof getRandomPuzzle>>;

export interface GetRandomPuzzleOptions {
  userId?: string | null;
  userRating?: number;
  theme?: string | null;
  phase?: string | null;
}

/**
 * 레이팅에 맞는 랜덤 퍼즐 반환.
 * 로그인 시: 유저 레이팅 ±200, 이미 푼 퍼즐 제외
 * 비로그인 시: 1200~1600 범위
 */
export async function getRandomPuzzle(options: GetRandomPuzzleOptions = {}) {
  const { userId, userRating = 1400, theme: themeParam, phase: phaseParam } = options;

  const targetRating = userRating ?? 1400;

  const where: Prisma.PuzzleWhereInput = {
    isActive: true,
    rating: {
      gte: targetRating - RATING_WINDOW,
      lte: targetRating + RATING_WINDOW,
    },
  };

  if (userId) {
    const solvedIds = await prisma.puzzleAttempt.findMany({
      where: { userId, solved: true },
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
    const fallback = await prisma.puzzle.findFirst({
      where: { isActive: true },
      orderBy: { createdAt: "desc" },
      select: puzzleSelect,
    });
    return fallback;
  }

  const skip = Math.floor(Math.random() * count);
  return prisma.puzzle.findFirst({
    where,
    skip,
    select: puzzleSelect,
  });
}

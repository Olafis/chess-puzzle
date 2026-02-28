import { NextRequest, NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";

export async function GET(
  _req: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const game = await prisma.game.findUnique({
      where: { id: params.id },
      include: {
        puzzles: {
          where: { isActive: true },
          select: {
            id: true,
            fen: true,
            moves: true,
            rating: true,
            themes: true,
            gamePhase: true,
            moveIndex: true,
            solveCount: true,
          },
          orderBy: { moveIndex: "asc" },
        },
      },
    });

    if (!game) {
      return NextResponse.json({ error: "Game not found" }, { status: 404 });
    }

    return NextResponse.json({ game });
  } catch (error) {
    console.error("[GET /api/games/[id]]", error);
    return NextResponse.json({ error: "Internal server error" }, { status: 500 });
  }
}

import { NextRequest, NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";
import { auth } from "@/lib/auth";

export async function GET(
  req: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const puzzle = await prisma.puzzle.findUnique({
      where: { id: params.id, isActive: true },
      include: {
        sourceGame: {
          select: {
            id: true,
            whitePlayer: true,
            blackPlayer: true,
            whiteElo: true,
            blackElo: true,
            event: true,
            site: true,
            date: true,
            result: true,
            source: true,
          },
        },
      },
    });

    if (!puzzle) {
      return NextResponse.json({ error: "Puzzle not found" }, { status: 404 });
    }

    // 로그인한 유저의 이전 시도 여부 확인
    const session = await auth();
    let userAttempt = null;

    if (session?.user?.id) {
      userAttempt = await prisma.puzzleAttempt.findFirst({
        where: { userId: session.user.id, puzzleId: params.id },
        orderBy: { createdAt: "desc" },
        select: { solved: true, hintUsed: true, createdAt: true },
      });
    }

    // moves는 정답이므로 미해결 퍼즐엔 숨기지 않음 (클라이언트에서 검증)
    return NextResponse.json({ puzzle, userAttempt });
  } catch (error) {
    console.error("[GET /api/puzzles/[id]]", error);
    return NextResponse.json({ error: "Internal server error" }, { status: 500 });
  }
}

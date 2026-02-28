import { NextRequest, NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";
import { auth } from "@/lib/auth";
import { PuzzleTheme } from "@prisma/client";

const MIN_VOTES_TO_RECLASSIFY = 10;
const MAJORITY_THRESHOLD = 0.6; // 60% 이상 동의 시 자동 업데이트

export async function POST(
  req: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const session = await auth();
    if (!session?.user?.id) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const { suggestedTheme } = await req.json();

    if (!suggestedTheme || !Object.values(PuzzleTheme).includes(suggestedTheme)) {
      return NextResponse.json({ error: "유효하지 않은 테마입니다" }, { status: 400 });
    }

    const puzzle = await prisma.puzzle.findUnique({
      where: { id: params.id, isActive: true },
      select: { id: true, themes: true },
    });

    if (!puzzle) {
      return NextResponse.json({ error: "Puzzle not found" }, { status: 404 });
    }

    // 투표 upsert (유저당 퍼즐당 1표)
    const vote = await prisma.puzzleCategoryVote.upsert({
      where: { userId_puzzleId: { userId: session.user.id, puzzleId: params.id } },
      update: { suggestedTheme },
      create: { userId: session.user.id, puzzleId: params.id, suggestedTheme },
    });

    // 해당 퍼즐의 전체 투표 집계
    const votes = await prisma.puzzleCategoryVote.groupBy({
      by: ["suggestedTheme"],
      where: { puzzleId: params.id },
      _count: { suggestedTheme: true },
      orderBy: { _count: { suggestedTheme: "desc" } },
    });

    const totalVotes = votes.reduce((sum, v) => sum + v._count.suggestedTheme, 0);

    // 다수결 자동 업데이트 (최소 10표, 60% 이상)
    let reclassified = false;
    if (totalVotes >= MIN_VOTES_TO_RECLASSIFY && votes.length > 0) {
      const topVote = votes[0];
      const ratio = topVote._count.suggestedTheme / totalVotes;

      if (ratio >= MAJORITY_THRESHOLD) {
        const newTheme = topVote.suggestedTheme;
        if (!puzzle.themes.includes(newTheme)) {
          await prisma.puzzle.update({
            where: { id: params.id },
            data: { themes: { set: [...puzzle.themes, newTheme] } },
          });
          reclassified = true;
        }
      }
    }

    return NextResponse.json({
      vote,
      voteStats: votes.map((v) => ({
        theme: v.suggestedTheme,
        count: v._count.suggestedTheme,
        ratio: totalVotes > 0 ? v._count.suggestedTheme / totalVotes : 0,
      })),
      totalVotes,
      reclassified,
    });
  } catch (error) {
    console.error("[POST /api/puzzles/[id]/vote]", error);
    return NextResponse.json({ error: "Internal server error" }, { status: 500 });
  }
}

export async function GET(
  req: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const session = await auth();
    const votes = await prisma.puzzleCategoryVote.groupBy({
      by: ["suggestedTheme"],
      where: { puzzleId: params.id },
      _count: { suggestedTheme: true },
      orderBy: { _count: { suggestedTheme: "desc" } },
    });

    const totalVotes = votes.reduce((sum, v) => sum + v._count.suggestedTheme, 0);

    let myVote: PuzzleTheme | null = null;
    if (session?.user?.id) {
      const my = await prisma.puzzleCategoryVote.findUnique({
        where: { userId_puzzleId: { userId: session.user.id, puzzleId: params.id } },
        select: { suggestedTheme: true },
      });
      myVote = my?.suggestedTheme ?? null;
    }

    return NextResponse.json({
      voteStats: votes.map((v) => ({
        theme: v.suggestedTheme,
        count: v._count.suggestedTheme,
        ratio: totalVotes > 0 ? v._count.suggestedTheme / totalVotes : 0,
      })),
      totalVotes,
      myVote,
    });
  } catch (error) {
    console.error("[GET /api/puzzles/[id]/vote]", error);
    return NextResponse.json({ error: "Internal server error" }, { status: 500 });
  }
}

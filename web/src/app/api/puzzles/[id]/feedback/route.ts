import { NextRequest, NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";
import { auth } from "@/lib/auth";
import { ReportType } from "@prisma/client";

interface FeedbackBody {
  vote?: boolean | null;       // true = 좋아요, false = 싫어요, null = 취소
  reportType?: ReportType;
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

    const body: FeedbackBody = await req.json();
    const { vote, reportType } = body;

    if (vote === undefined && !reportType) {
      return NextResponse.json(
        { error: "vote 또는 reportType 중 하나는 필요합니다" },
        { status: 400 }
      );
    }

    if (reportType && !Object.values(ReportType).includes(reportType)) {
      return NextResponse.json({ error: "유효하지 않은 reportType" }, { status: 400 });
    }

    const puzzle = await prisma.puzzle.findUnique({
      where: { id: params.id, isActive: true },
      select: { id: true, likeCount: true, dislikeCount: true },
    });

    if (!puzzle) {
      return NextResponse.json({ error: "Puzzle not found" }, { status: 404 });
    }

    // 기존 피드백 조회 (like/dislike 증감 계산용)
    const existing = await prisma.puzzleFeedback.findUnique({
      where: { userId_puzzleId: { userId: session.user.id, puzzleId: params.id } },
    });

    const feedback = await prisma.puzzleFeedback.upsert({
      where: { userId_puzzleId: { userId: session.user.id, puzzleId: params.id } },
      update: {
        ...(vote !== undefined ? { vote } : {}),
        ...(reportType !== undefined ? { reportType: reportType || null } : {}),
      },
      create: {
        userId: session.user.id,
        puzzleId: params.id,
        vote: vote ?? null,
        reportType: reportType ?? null,
      },
    });

    // 퍼즐 좋아요/싫어요 카운트 재계산
    if (vote !== undefined) {
      const likeIncrement = calcIncrement(existing?.vote ?? null, vote, true);
      const dislikeIncrement = calcIncrement(existing?.vote ?? null, vote, false);

      const updatedPuzzle = await prisma.puzzle.update({
        where: { id: params.id },
        data: {
          likeCount: { increment: likeIncrement },
          dislikeCount: { increment: dislikeIncrement },
        },
        select: { likeCount: true, dislikeCount: true, isActive: true },
      });

      // 싫어요 비율 30% 초과 시 자동 숨김
      const total = updatedPuzzle.likeCount + updatedPuzzle.dislikeCount;
      if (total >= 10 && updatedPuzzle.dislikeCount / total > 0.3) {
        await prisma.puzzle.update({
          where: { id: params.id },
          data: { isActive: false },
        });
      }

      return NextResponse.json({ feedback, puzzle: updatedPuzzle });
    }

    return NextResponse.json({ feedback });
  } catch (error) {
    console.error("[POST /api/puzzles/[id]/feedback]", error);
    return NextResponse.json({ error: "Internal server error" }, { status: 500 });
  }
}

// 이전 투표 → 새 투표로 바뀔 때의 증감값 계산
function calcIncrement(
  prevVote: boolean | null,
  newVote: boolean | null,
  isLike: boolean
): number {
  const target = isLike ? true : false;
  let delta = 0;
  if (prevVote === target) delta -= 1; // 이전에 같은 투표 → 취소
  if (newVote === target) delta += 1;  // 새로운 투표 → 추가
  return delta;
}

// 현재 피드백 조회
export async function GET(
  req: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const session = await auth();
    if (!session?.user?.id) {
      return NextResponse.json({ vote: null, reportType: null });
    }

    const feedback = await prisma.puzzleFeedback.findUnique({
      where: { userId_puzzleId: { userId: session.user.id, puzzleId: params.id } },
      select: { vote: true, reportType: true },
    });

    return NextResponse.json(feedback ?? { vote: null, reportType: null });
  } catch (error) {
    console.error("[GET /api/puzzles/[id]/feedback]", error);
    return NextResponse.json({ error: "Internal server error" }, { status: 500 });
  }
}

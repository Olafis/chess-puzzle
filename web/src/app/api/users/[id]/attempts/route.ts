import { NextRequest, NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";
import { auth } from "@/lib/auth";

const PAGE_SIZE = 20;

export async function GET(
  req: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    // 본인 또는 공개 프로필만 조회 가능
    const session = await auth();
    const isOwner = session?.user?.id === params.id;

    const { searchParams } = req.nextUrl;
    const page = Math.max(1, Number(searchParams.get("page") ?? "1"));
    const onlySolved = searchParams.get("solved") === "true";

    const where = {
      userId: params.id,
      ...(onlySolved ? { solved: true } : {}),
    };

    const [attempts, total] = await Promise.all([
      prisma.puzzleAttempt.findMany({
        where,
        orderBy: { createdAt: "desc" },
        skip: (page - 1) * PAGE_SIZE,
        take: PAGE_SIZE,
        select: {
          id: true,
          solved: true,
          hintUsed: true,
          timeSpentSeconds: true,
          ratingBefore: true,
          ratingAfter: true,
          createdAt: true,
          puzzle: {
            select: {
              id: true,
              fen: true,
              rating: true,
              themes: true,
              gamePhase: true,
            },
          },
        },
      }),
      prisma.puzzleAttempt.count({ where }),
    ]);

    return NextResponse.json({
      attempts,
      isOwner,
      pagination: {
        page,
        limit: PAGE_SIZE,
        total,
        totalPages: Math.ceil(total / PAGE_SIZE),
      },
    });
  } catch (error) {
    console.error("[GET /api/users/[id]/attempts]", error);
    return NextResponse.json({ error: "Internal server error" }, { status: 500 });
  }
}

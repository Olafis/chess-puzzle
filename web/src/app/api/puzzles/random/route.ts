import { NextRequest, NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";
import { auth } from "@/lib/auth";
import { getRandomPuzzle } from "@/lib/puzzles";

export const dynamic = "force-dynamic";

export async function GET(req: NextRequest) {
  try {
    const { searchParams } = req.nextUrl;
    const themeParam = searchParams.get("theme");
    const phaseParam = searchParams.get("phase");

    const session = await auth();
    let userRating = 1400;

    if (session?.user?.id) {
      const user = await prisma.user.findUnique({
        where: { id: session.user.id },
        select: { rating: true },
      });
      if (user) userRating = user.rating;
    }

    const puzzle = await getRandomPuzzle({
      userId: session?.user?.id ?? null,
      userRating,
      theme: themeParam,
      phase: phaseParam,
    });

    if (!puzzle) {
      return NextResponse.json({ error: "No puzzles available" }, { status: 404 });
    }

    return NextResponse.json({ puzzle });
  } catch (error) {
    console.error("[GET /api/puzzles/random]", error);
    return NextResponse.json({ error: "Internal server error" }, { status: 500 });
  }
}

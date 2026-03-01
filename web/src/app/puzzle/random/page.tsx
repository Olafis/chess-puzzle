import { redirect } from "next/navigation";
import { auth } from "@/lib/auth";
import { prisma } from "@/lib/prisma";
import { getRandomPuzzle } from "@/lib/puzzles";

export const dynamic = "force-dynamic";

/**
 * 레이팅에 맞는 랜덤 퍼즐로 리다이렉트.
 * 로그인 시: 유저 레이팅 ±200, 이미 푼 퍼즐 제외
 * 비로그인 시: 1200~1600 범위
 */
export default async function RandomPuzzlePage() {
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
  });

  if (puzzle?.id) {
    redirect(`/puzzle/${puzzle.id}`);
  }

  redirect("/");
}

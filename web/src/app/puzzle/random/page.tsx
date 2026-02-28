import { redirect } from "next/navigation";
import { headers } from "next/headers";

export const dynamic = "force-dynamic";

/**
 * 레이팅에 맞는 랜덤 퍼즐로 리다이렉트.
 * 로그인 시: 유저 레이팅 ±200, 이미 푼 퍼즐 제외
 * 비로그인 시: 1200~1600 범위
 */
export default async function RandomPuzzlePage() {
  const base = process.env.NEXTAUTH_URL || "http://localhost:3000";
  const headersList = await headers();
  const cookie = headersList.get("cookie") ?? "";

  const res = await fetch(`${base}/api/puzzles/random`, {
    headers: { cookie },
    cache: "no-store",
  });

  if (!res.ok) {
    redirect("/");
  }

  const data = await res.json();
  if (data.puzzle?.id) {
    redirect(`/puzzle/${data.puzzle.id}`);
  }

  redirect("/");
}

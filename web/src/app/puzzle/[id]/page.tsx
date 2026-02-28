import { notFound } from "next/navigation";
import { prisma } from "@/lib/prisma";
import { PuzzleBoard } from "@/components/PuzzleBoard";

interface Props {
  params: { id: string };
}

export default async function PuzzlePage({ params }: Props) {
  const puzzle = await prisma.puzzle.findUnique({
    where: { id: params.id, isActive: true },
    select: {
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
          source: true,
        },
      },
    },
  });

  if (!puzzle) notFound();

  return (
    <div className="max-w-7xl mx-auto px-4 py-6">
      <PuzzleBoard puzzle={puzzle} />
    </div>
  );
}

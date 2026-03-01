export default function PuzzleLoading() {
  return (
    <div className="max-w-7xl mx-auto px-4 py-6 flex justify-center items-center min-h-[60vh]">
      <div className="flex flex-col items-center gap-4">
        <div className="w-12 h-12 border-2 border-zinc-400 dark:border-zinc-600 border-t-transparent rounded-full animate-spin" />
        <p className="text-sm text-zinc-500 dark:text-zinc-400">퍼즐 불러오는 중...</p>
      </div>
    </div>
  );
}

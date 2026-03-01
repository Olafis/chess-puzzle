export default function PuzzlesLoading() {
  return (
    <div className="max-w-6xl mx-auto px-4 py-8">
      <div className="animate-pulse space-y-4">
        <div className="h-8 w-48 bg-zinc-200 dark:bg-zinc-800 rounded" />
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
          {[1, 2, 3, 4, 5, 6].map((i) => (
            <div key={i} className="h-32 bg-zinc-200 dark:bg-zinc-800 rounded-xl" />
          ))}
        </div>
      </div>
    </div>
  );
}

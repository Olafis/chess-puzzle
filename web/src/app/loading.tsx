export default function Loading() {
  return (
    <div className="max-w-4xl mx-auto px-4 py-12 flex justify-center items-center min-h-[50vh]">
      <div className="flex flex-col items-center gap-4">
        <div className="w-10 h-10 border-2 border-zinc-400 dark:border-zinc-600 border-t-transparent rounded-full animate-spin" />
        <p className="text-sm text-zinc-500 dark:text-zinc-400">로딩 중...</p>
      </div>
    </div>
  );
}

"use client";

export default function GlobalError({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  return (
    <html lang="ko">
      <body className="bg-zinc-950 text-zinc-100 min-h-screen flex flex-col items-center justify-center p-8">
        <h1 className="text-2xl font-bold text-red-400 mb-4">오류가 발생했습니다</h1>
        <p className="text-zinc-500 mb-6 text-center max-w-md">{error.message}</p>
        <button
          onClick={reset}
          className="px-6 py-2 rounded-lg bg-white text-black font-medium hover:bg-zinc-200 transition-colors"
        >
          다시 시도
        </button>
      </body>
    </html>
  );
}

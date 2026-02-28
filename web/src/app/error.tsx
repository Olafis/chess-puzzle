"use client";

import { useEffect } from "react";

export default function Error({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  useEffect(() => {
    console.error("[App Error]", error.message, error.digest);
  }, [error]);

  return (
    <div className="min-h-[50vh] flex flex-col items-center justify-center px-4">
      <h2 className="text-xl font-semibold text-red-400 mb-2">문제가 발생했습니다</h2>
      <p className="text-zinc-500 text-sm mb-4 text-center max-w-md">
        {error.message}
      </p>
      <button
        onClick={reset}
        className="px-4 py-2 rounded-lg bg-zinc-800 border border-zinc-700 text-zinc-300 hover:bg-zinc-700 transition-colors"
      >
        다시 시도
      </button>
    </div>
  );
}

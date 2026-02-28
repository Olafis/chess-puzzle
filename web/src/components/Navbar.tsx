"use client";
import { useState, useEffect } from "react";
import Link from "next/link";
import { useSession, signOut } from "next-auth/react";
import { usePathname } from "next/navigation";
import { useTheme } from "next-themes";

const NAV_LINKS = [
  { href: "/puzzles", label: "퍼즐" },
  { href: "/leaderboard", label: "리더보드" },
];

export function Navbar() {
  const { data: session } = useSession();
  const pathname = usePathname();
  const [mobileOpen, setMobileOpen] = useState(false);
  const [mounted, setMounted] = useState(false);
  const { theme, setTheme } = useTheme();

  useEffect(() => setMounted(true), []);

  const isActive = (href: string) =>
    pathname === href || pathname.startsWith(href + "/");

  return (
    <nav className="border-b border-zinc-300 dark:border-zinc-800 bg-white/90 dark:bg-zinc-950/80 backdrop-blur-sm sticky top-0 z-50">
      <div className="max-w-7xl mx-auto h-16 px-4 flex items-center justify-between">
        {/* 로고 */}
        <Link href="/" className="flex items-center gap-2 font-bold text-zinc-900 dark:text-white text-xl" onClick={() => setMobileOpen(false)}>
          <span className="text-2xl">♟</span>
          PuzzleChess
        </Link>

        {/* 데스크탑 네비 */}
        <div className="hidden md:flex items-center gap-8">
          {NAV_LINKS.map(({ href, label }) => (
            <Link
              key={href}
              href={href}
              className={`text-base transition-colors ${
                isActive(href) ? "text-zinc-900 dark:text-white font-medium" : "text-zinc-600 dark:text-zinc-400 hover:text-zinc-900 dark:hover:text-white"
              }`}
            >
              {label}
            </Link>
          ))}
        </div>

        {/* 우측 */}
        <div className="flex items-center gap-4">
          {session ? (
            <>
              <Link
                href={`/profile/${session.user.id}`}
                className="flex items-center gap-2 text-base text-zinc-600 dark:text-zinc-300 hover:text-zinc-900 dark:hover:text-white transition-colors"
              >
                {session.user.image ? (
                  <img src={session.user.image} alt="" className="w-8 h-8 rounded-full" />
                ) : (
                  <div className="w-8 h-8 rounded-full bg-zinc-700 flex items-center justify-center text-sm font-semibold">
                    {(session.user.name || session.user.email || "?")[0]?.toUpperCase() ?? "?"}
                  </div>
                )}
                <span className="hidden sm:inline">{session.user.name ?? session.user.email}</span>
              </Link>
              <button
                onClick={() => signOut({ callbackUrl: "/" })}
                className="text-base text-zinc-500 hover:text-zinc-700 dark:hover:text-zinc-300 transition-colors"
              >
                로그아웃
              </button>
            </>
          ) : (
            <>
              <Link href="/login" className="text-base text-zinc-600 dark:text-zinc-400 hover:text-zinc-900 dark:hover:text-white transition-colors">
                로그인
              </Link>
              <Link
                href="/register"
                className="text-base bg-zinc-900 dark:bg-white text-white dark:text-black px-4 py-2 rounded-md font-medium hover:bg-zinc-800 dark:hover:bg-zinc-200 transition-colors"
              >
                회원가입
              </Link>
            </>
          )}

          {/* 테마 토글 (mounted 후에만 아이콘 표시 → hydration 오류 방지) */}
          <button
            onClick={() => setTheme(theme === "dark" ? "light" : "dark")}
            className="p-2 rounded-lg text-zinc-600 dark:text-zinc-400 hover:bg-zinc-200 dark:hover:bg-zinc-800 transition-colors w-10 h-10 flex items-center justify-center"
            aria-label="테마 전환"
          >
            {mounted ? (theme === "dark" ? "☀️" : "🌙") : <span className="w-6 h-6" />}
          </button>
          <button
            className="md:hidden p-2 text-zinc-600 dark:text-zinc-400 hover:text-zinc-900 dark:hover:text-white"
            onClick={() => setMobileOpen((v) => !v)}
            aria-label="메뉴"
          >
            {mobileOpen ? (
              <svg xmlns="http://www.w3.org/2000/svg" className="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
              </svg>
            ) : (
              <svg xmlns="http://www.w3.org/2000/svg" className="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6h16M4 12h16M4 18h16" />
              </svg>
            )}
          </button>
        </div>
      </div>

      {/* 모바일 드롭다운 */}
      {mobileOpen && (
        <div className="md:hidden border-t border-zinc-300 dark:border-zinc-800 bg-white dark:bg-zinc-950 px-4 py-4 space-y-1">
          {NAV_LINKS.map(({ href, label }) => (
            <Link
              key={href}
              href={href}
              onClick={() => setMobileOpen(false)}
              className={`block py-3 text-base transition-colors ${
                isActive(href) ? "text-zinc-900 dark:text-white font-medium" : "text-zinc-600 dark:text-zinc-400"
              }`}
            >
              {label}
            </Link>
          ))}
        </div>
      )}
    </nav>
  );
}

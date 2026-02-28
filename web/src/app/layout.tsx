import type { Metadata } from "next";
import localFont from "next/font/local";
import "./globals.css";
import { Navbar } from "@/components/Navbar";
import { SessionProvider } from "@/components/SessionProvider";
import { ThemeProvider } from "@/components/ThemeProvider";

const geistSans = localFont({
  src: "./fonts/GeistVF.woff",
  variable: "--font-geist-sans",
  weight: "100 900",
});

export const metadata: Metadata = {
  title: "PuzzleChess",
  description: "체스 퍼즐 플랫폼 - 실전 경기에서 추출한 전술 퍼즐",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="ko" suppressHydrationWarning>
      <body className={`${geistSans.variable} font-sans bg-zinc-100 text-zinc-900 dark:bg-zinc-950 dark:text-zinc-100 antialiased`}>
        <ThemeProvider attribute="class" defaultTheme="dark" enableSystem>
          <SessionProvider>
            <Navbar />
            <main className="min-h-[calc(100vh-64px)]">{children}</main>
          </SessionProvider>
        </ThemeProvider>
      </body>
    </html>
  );
}

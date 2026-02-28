import { NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";
import { auth } from "@/lib/auth";

export async function GET() {
  try {
    const session = await auth();
    if (!session?.user?.id) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const user = await prisma.user.findUnique({
      where: { id: session.user.id },
      select: {
        id: true,
        username: true,
        name: true,
        email: true,
        image: true,
        rating: true,
        styleProfile: true,
        createdAt: true,
        categoryRatings: {
          select: { category: true, rating: true, rd: true },
          orderBy: { rating: "desc" },
        },
      },
    });

    if (!user) {
      return NextResponse.json({ error: "User not found" }, { status: 404 });
    }

    return NextResponse.json({ user });
  } catch (error) {
    console.error("[GET /api/users/me]", error);
    return NextResponse.json({ error: "Internal server error" }, { status: 500 });
  }
}

const USERNAME_REGEX = /^[a-zA-Z0-9_]{3,20}$/;

export async function PATCH(req: Request) {
  try {
    const session = await auth();
    if (!session?.user?.id) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    let body: unknown;
    try {
      body = await req.json();
    } catch {
      return NextResponse.json({ error: "잘못된 요청 형식입니다" }, { status: 400 });
    }

    if (typeof body !== "object" || body === null) {
      return NextResponse.json({ error: "잘못된 요청입니다" }, { status: 400 });
    }

    const raw = body as Record<string, unknown>;
    const username = typeof raw.username === "string" ? raw.username.trim().slice(0, 20) || null : undefined;
    const name = typeof raw.name === "string" ? raw.name.trim().slice(0, 50) || null : undefined;

    if (username !== undefined && username !== null && !USERNAME_REGEX.test(username)) {
      return NextResponse.json(
        { error: "사용자명은 3~20자의 영문, 숫자, 밑줄(_)만 사용 가능합니다" },
        { status: 400 }
      );
    }

    if (username) {
      const existing = await prisma.user.findFirst({
        where: { username, id: { not: session.user.id } },
      });
      if (existing) {
        return NextResponse.json({ error: "이미 사용 중인 사용자명입니다" }, { status: 409 });
      }
    }

    const user = await prisma.user.update({
      where: { id: session.user.id },
      data: {
        ...(username !== undefined ? { username } : {}),
        ...(name !== undefined ? { name } : {}),
      },
      select: { id: true, username: true, name: true, email: true, image: true, rating: true },
    });

    return NextResponse.json({ user });
  } catch (error) {
    console.error("[PATCH /api/users/me]", error);
    return NextResponse.json({ error: "Internal server error" }, { status: 500 });
  }
}

import { NextRequest, NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";
import bcrypt from "bcryptjs";

const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const USERNAME_REGEX = /^[a-zA-Z0-9_]{3,20}$/;
const MIN_PASSWORD_LENGTH = 8;
const MAX_FIELD_LENGTH = 200;

function sanitizeString(value: unknown): string | null {
  if (typeof value !== "string") return null;
  return value.trim().slice(0, MAX_FIELD_LENGTH) || null;
}

export async function POST(req: NextRequest) {
  try {
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
    const email = sanitizeString(raw.email);
    const password = sanitizeString(raw.password);
    const username = sanitizeString(raw.username);
    const name = sanitizeString(raw.name);

    if (!email || !password) {
      return NextResponse.json({ error: "이메일과 비밀번호는 필수입니다" }, { status: 400 });
    }
    if (!EMAIL_REGEX.test(email)) {
      return NextResponse.json({ error: "유효하지 않은 이메일 형식입니다" }, { status: 400 });
    }
    if (password.length < MIN_PASSWORD_LENGTH) {
      return NextResponse.json(
        { error: `비밀번호는 최소 ${MIN_PASSWORD_LENGTH}자 이상이어야 합니다` },
        { status: 400 }
      );
    }
    // bcrypt 72바이트 제한
    if (password.length > 72) {
      return NextResponse.json({ error: "비밀번호가 너무 깁니다 (최대 72자)" }, { status: 400 });
    }
    if (username && !USERNAME_REGEX.test(username)) {
      return NextResponse.json(
        { error: "사용자명은 3~20자의 영문, 숫자, 밑줄(_)만 사용 가능합니다" },
        { status: 400 }
      );
    }

    // 이메일 소문자 정규화
    const normalizedEmail = email.toLowerCase();

    const existingEmail = await prisma.user.findUnique({ where: { email: normalizedEmail } });
    if (existingEmail) {
      return NextResponse.json({ error: "이미 사용 중인 이메일입니다" }, { status: 409 });
    }

    if (username) {
      const existingUsername = await prisma.user.findUnique({ where: { username } });
      if (existingUsername) {
        return NextResponse.json({ error: "이미 사용 중인 사용자명입니다" }, { status: 409 });
      }
    }

    const passwordHash = await bcrypt.hash(password, 12);

    const user = await prisma.user.create({
      data: {
        email: normalizedEmail,
        passwordHash,
        username: username ?? null,
        name: name ?? username ?? normalizedEmail.split("@")[0],
      },
      select: { id: true, email: true, username: true, name: true, rating: true, createdAt: true },
    });

    return NextResponse.json({ user }, { status: 201 });
  } catch (error) {
    console.error("[POST /api/auth/register]", error);
    return NextResponse.json({ error: "Internal server error" }, { status: 500 });
  }
}

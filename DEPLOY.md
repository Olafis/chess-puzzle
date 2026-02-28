# 배포 가이드

## 1. GitHub 푸시

> `web/` 안에 기존 `.git`이 있으면 루트에서 `git init` 전에 제거: `rm -rf web/.git`

```bash
cd ~/01_Workspace/01_Projects/Puzzle_Site
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/Puzzle_Site.git
git push -u origin main
```

## 2. DB 준비 (Supabase 추천)

1. [Supabase](https://supabase.com) 가입 → 새 프로젝트 생성
2. **Settings → Database**에서 Connection string 복사
3. `postgresql://postgres.[프로젝트ID]:[비밀번호]@aws-0-[리전].pooler.supabase.com:6543/postgres` 형식
4. **Connection pooling** URL 사용 (포트 6543)

## 3. Vercel 배포

1. [Vercel](https://vercel.com) 가입 → **Add New Project**
2. GitHub 저장소 연결 → **Import**
3. **Root Directory**: `web` 지정
4. **Environment Variables** 추가:

| 변수 | 값 |
|------|-----|
| `DATABASE_URL` | Supabase Connection string |
| `NEXTAUTH_URL` | `https://your-app.vercel.app` (배포 후 도메인) |
| `NEXTAUTH_SECRET` | `openssl rand -base64 32`로 생성 |
| `GOOGLE_CLIENT_ID` | Google OAuth 클라이언트 ID |
| `GOOGLE_CLIENT_SECRET` | Google OAuth 시크릿 |
| `GITHUB_CLIENT_ID` | GitHub OAuth (선택) |
| `GITHUB_CLIENT_SECRET` | GitHub OAuth (선택) |

5. **Deploy** 클릭

## 4. DB 마이그레이션

Supabase는 빈 DB로 시작합니다. 로컬에서 원격 DB로 마이그레이션:

```bash
cd web
DATABASE_URL="postgresql://[Supabase Connection String]" npx prisma migrate deploy
```

## 5. OAuth 콜백 URL 설정

**Google Cloud Console**:
- 사용자 인증 정보 → OAuth 2.0 클라이언트 ID
- 승인된 리디렉션 URI: `https://your-app.vercel.app/api/auth/callback/google`

**GitHub** (사용 시):
- Settings → Developer settings → OAuth Apps
- Authorization callback URL: `https://your-app.vercel.app/api/auth/callback/github`

## 6. NEXTAUTH_URL 수정

첫 배포 후 Vercel이 부여한 도메인(예: `puzzle-chess-xxx.vercel.app`)으로:
- Vercel → Settings → Environment Variables → `NEXTAUTH_URL` 수정
- **Redeploy** 실행

---

## 7. Rate Limiting (선택)

Vercel Pro/Enterprise는 기본 Rate Limit이 있음. 무료 플랜에서 회원가입/API 남용이 우려되면:

- **Vercel Edge Middleware** 또는 **Upstash Redis** 기반 rate limiter 추가 검토
- Supabase RLS로 DB 레벨 보호는 이미 적용됨

---

## 요약

| 서비스 | 용도 |
|--------|------|
| **Vercel** | Next.js 웹 앱 (무료) |
| **Supabase** | PostgreSQL (무료 500MB) |
| **Redis** | 현재 미사용 → 생략 가능 |

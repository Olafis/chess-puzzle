# 웹 앱 (Next.js)

체스 퍼즐 플랫폼의 프론트엔드 및 API.

## 개발

```bash
# 루트에서
cd web
cp .env.example .env   # 환경 변수 설정
npm install
npx prisma generate
npm run dev
```

http://localhost:3000

## 스크립트

| 명령 | 설명 |
|------|------|
| `npm run dev` | 개발 서버 |
| `npm run build` | 프로덕션 빌드 |
| `npm run start` | 프로덕션 서버 |
| `npm run lint` | ESLint |
| `npm run test:e2e` | Playwright E2E |

## 구조

- `src/app/` - App Router (페이지, API)
- `src/components/` - 공용 컴포넌트
- `src/lib/` - auth, prisma, glicko2
- `prisma/` - 스키마, 마이그레이션

전체 프로젝트는 [루트 README](../README.md) 참고.

-- 수동 마이그레이션 (Supabase SQL Editor에서 전체 복사 후 실행)
-- prisma migrate deploy가 안 될 때 사용

-- 1. init
CREATE TYPE "GamePhase" AS ENUM ('OPENING', 'MIDDLEGAME', 'ENDGAME');
CREATE TYPE "PuzzleTheme" AS ENUM ('FORK', 'PIN', 'SKEWER', 'DISCOVERED_ATTACK', 'DOUBLE_CHECK', 'MATE_IN_1', 'MATE_IN_2', 'MATE_IN_3', 'MATE_IN_4', 'MATE_IN_5', 'QUEEN_SACRIFICE', 'ROOK_ENDGAME', 'PAWN_PROMOTION', 'TRAP', 'BACK_RANK', 'HANGING_PIECE', 'DEFLECTION', 'DECOY', 'INTERFERENCE', 'ZUGZWANG');
CREATE TYPE "ReportType" AS ENUM ('MULTIPLE_SOLUTIONS', 'WRONG_DIFFICULTY', 'NONSENSE', 'CATEGORY_WRONG');

CREATE TABLE "Account" ("id" TEXT NOT NULL, "userId" TEXT NOT NULL, "type" TEXT NOT NULL, "provider" TEXT NOT NULL, "providerAccountId" TEXT NOT NULL, "refresh_token" TEXT, "access_token" TEXT, "expires_at" INTEGER, "token_type" TEXT, "scope" TEXT, "id_token" TEXT, "session_state" TEXT, CONSTRAINT "Account_pkey" PRIMARY KEY ("id"));
CREATE TABLE "Session" ("id" TEXT NOT NULL, "sessionToken" TEXT NOT NULL, "userId" TEXT NOT NULL, "expires" TIMESTAMP(3) NOT NULL, CONSTRAINT "Session_pkey" PRIMARY KEY ("id"));
CREATE TABLE "VerificationToken" ("identifier" TEXT NOT NULL, "token" TEXT NOT NULL, "expires" TIMESTAMP(3) NOT NULL);
CREATE TABLE "User" ("id" TEXT NOT NULL, "username" TEXT, "email" TEXT NOT NULL, "emailVerified" TIMESTAMP(3), "image" TEXT, "name" TEXT, "rating" INTEGER NOT NULL DEFAULT 1500, "styleProfile" JSONB, "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP, "updatedAt" TIMESTAMP(3) NOT NULL, CONSTRAINT "User_pkey" PRIMARY KEY ("id"));
CREATE TABLE "UserCategoryRating" ("id" TEXT NOT NULL, "userId" TEXT NOT NULL, "category" "PuzzleTheme" NOT NULL, "rating" INTEGER NOT NULL DEFAULT 1500, "rd" DOUBLE PRECISION NOT NULL DEFAULT 350, "vol" DOUBLE PRECISION NOT NULL DEFAULT 0.06, "updatedAt" TIMESTAMP(3) NOT NULL, CONSTRAINT "UserCategoryRating_pkey" PRIMARY KEY ("id"));
CREATE TABLE "Game" ("id" TEXT NOT NULL, "pgn" TEXT NOT NULL, "whitePlayer" TEXT NOT NULL, "blackPlayer" TEXT NOT NULL, "whiteElo" INTEGER, "blackElo" INTEGER, "event" TEXT, "site" TEXT, "date" TIMESTAMP(3), "result" TEXT, "source" TEXT, "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP, CONSTRAINT "Game_pkey" PRIMARY KEY ("id"));
CREATE TABLE "Puzzle" ("id" TEXT NOT NULL, "fen" TEXT NOT NULL, "moves" TEXT[], "rating" INTEGER NOT NULL DEFAULT 1500, "ratingDeviation" DOUBLE PRECISION NOT NULL DEFAULT 350, "volatility" DOUBLE PRECISION NOT NULL DEFAULT 0.06, "solveCount" INTEGER NOT NULL DEFAULT 0, "failCount" INTEGER NOT NULL DEFAULT 0, "themes" "PuzzleTheme"[], "gamePhase" "GamePhase" NOT NULL, "openingEco" TEXT, "openingName" TEXT, "likeCount" INTEGER NOT NULL DEFAULT 0, "dislikeCount" INTEGER NOT NULL DEFAULT 0, "isActive" BOOLEAN NOT NULL DEFAULT true, "sourceGameId" TEXT, "moveIndex" INTEGER, "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP, "updatedAt" TIMESTAMP(3) NOT NULL, CONSTRAINT "Puzzle_pkey" PRIMARY KEY ("id"));
CREATE TABLE "PuzzleAttempt" ("id" TEXT NOT NULL, "userId" TEXT NOT NULL, "puzzleId" TEXT NOT NULL, "solved" BOOLEAN NOT NULL, "hintUsed" BOOLEAN NOT NULL DEFAULT false, "timeSpentSeconds" INTEGER, "ratingBefore" INTEGER NOT NULL, "ratingAfter" INTEGER NOT NULL, "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP, CONSTRAINT "PuzzleAttempt_pkey" PRIMARY KEY ("id"));
CREATE TABLE "PuzzleFeedback" ("id" TEXT NOT NULL, "userId" TEXT NOT NULL, "puzzleId" TEXT NOT NULL, "vote" BOOLEAN, "reportType" "ReportType", "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP, "updatedAt" TIMESTAMP(3) NOT NULL, CONSTRAINT "PuzzleFeedback_pkey" PRIMARY KEY ("id"));
CREATE TABLE "PuzzleCategoryVote" ("id" TEXT NOT NULL, "userId" TEXT NOT NULL, "puzzleId" TEXT NOT NULL, "suggestedTheme" "PuzzleTheme" NOT NULL, "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP, CONSTRAINT "PuzzleCategoryVote_pkey" PRIMARY KEY ("id"));

CREATE UNIQUE INDEX "Account_provider_providerAccountId_key" ON "Account"("provider", "providerAccountId");
CREATE UNIQUE INDEX "Session_sessionToken_key" ON "Session"("sessionToken");
CREATE UNIQUE INDEX "VerificationToken_token_key" ON "VerificationToken"("token");
CREATE UNIQUE INDEX "VerificationToken_identifier_token_key" ON "VerificationToken"("identifier", "token");
CREATE UNIQUE INDEX "User_username_key" ON "User"("username");
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");
CREATE UNIQUE INDEX "UserCategoryRating_userId_category_key" ON "UserCategoryRating"("userId", "category");
CREATE UNIQUE INDEX "Game_source_key" ON "Game"("source");
CREATE INDEX "Puzzle_rating_idx" ON "Puzzle"("rating");
CREATE INDEX "Puzzle_themes_idx" ON "Puzzle"("themes");
CREATE INDEX "Puzzle_gamePhase_idx" ON "Puzzle"("gamePhase");
CREATE INDEX "Puzzle_openingEco_idx" ON "Puzzle"("openingEco");
CREATE INDEX "Puzzle_isActive_idx" ON "Puzzle"("isActive");
CREATE INDEX "PuzzleAttempt_userId_idx" ON "PuzzleAttempt"("userId");
CREATE INDEX "PuzzleAttempt_puzzleId_idx" ON "PuzzleAttempt"("puzzleId");
CREATE INDEX "PuzzleFeedback_puzzleId_idx" ON "PuzzleFeedback"("puzzleId");
CREATE UNIQUE INDEX "PuzzleFeedback_userId_puzzleId_key" ON "PuzzleFeedback"("userId", "puzzleId");
CREATE INDEX "PuzzleCategoryVote_puzzleId_idx" ON "PuzzleCategoryVote"("puzzleId");
CREATE UNIQUE INDEX "PuzzleCategoryVote_userId_puzzleId_key" ON "PuzzleCategoryVote"("userId", "puzzleId");

ALTER TABLE "Account" ADD CONSTRAINT "Account_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "Session" ADD CONSTRAINT "Session_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "UserCategoryRating" ADD CONSTRAINT "UserCategoryRating_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "Puzzle" ADD CONSTRAINT "Puzzle_sourceGameId_fkey" FOREIGN KEY ("sourceGameId") REFERENCES "Game"("id") ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE "PuzzleAttempt" ADD CONSTRAINT "PuzzleAttempt_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "PuzzleAttempt" ADD CONSTRAINT "PuzzleAttempt_puzzleId_fkey" FOREIGN KEY ("puzzleId") REFERENCES "Puzzle"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "PuzzleFeedback" ADD CONSTRAINT "PuzzleFeedback_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "PuzzleFeedback" ADD CONSTRAINT "PuzzleFeedback_puzzleId_fkey" FOREIGN KEY ("puzzleId") REFERENCES "Puzzle"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "PuzzleCategoryVote" ADD CONSTRAINT "PuzzleCategoryVote_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "PuzzleCategoryVote" ADD CONSTRAINT "PuzzleCategoryVote_puzzleId_fkey" FOREIGN KEY ("puzzleId") REFERENCES "Puzzle"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- 2. add_password_hash
ALTER TABLE "User" ADD COLUMN "passwordHash" TEXT;

-- 3. add_blunder_move
ALTER TABLE "Puzzle" ADD COLUMN "blunderMove" TEXT;

-- 4. add_pre_blunder_fen
ALTER TABLE "Puzzle" ADD COLUMN "preBblunderFen" TEXT;

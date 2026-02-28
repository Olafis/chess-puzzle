/**
 * Glicko-2 Rating System
 * Reference: http://www.glicko.net/glicko/glicko2.pdf
 */

const SCALE = 173.7178;
const TAU = 0.5; // system constant (0.3 ~ 1.2 권장)

export interface GlickoPlayer {
  rating: number;
  rd: number;    // Rating Deviation
  vol: number;   // Volatility
}

export interface GlickoResult {
  rating: number;
  rd: number;
  vol: number;
}

function toGlicko2Scale(r: number, rd: number) {
  return { mu: (r - 1500) / SCALE, phi: rd / SCALE };
}

function toGlicko1Scale(mu: number, phi: number) {
  return { rating: Math.round(SCALE * mu + 1500), rd: SCALE * phi };
}

function g(phi: number): number {
  return 1 / Math.sqrt(1 + (3 * phi * phi) / (Math.PI * Math.PI));
}

function E(mu: number, muJ: number, phiJ: number): number {
  return 1 / (1 + Math.exp(-g(phiJ) * (mu - muJ)));
}

/**
 * 단일 대결 후 레이팅 업데이트
 * @param player 현재 플레이어 (유저 or 퍼즐)
 * @param opponent 상대 (퍼즐 or 유저)
 * @param score 1 = 승리, 0 = 패배
 */
export function updateRating(
  player: GlickoPlayer,
  opponent: GlickoPlayer,
  score: number
): GlickoResult {
  const { mu, phi } = toGlicko2Scale(player.rating, player.rd);
  const { mu: muJ, phi: phiJ } = toGlicko2Scale(opponent.rating, opponent.rd);
  const sigma = player.vol;

  const gPhiJ = g(phiJ);
  const eVal = E(mu, muJ, phiJ);

  // 분산 v
  const v = 1 / (gPhiJ * gPhiJ * eVal * (1 - eVal));

  // 개선값 delta
  const delta = v * gPhiJ * (score - eVal);

  // 변동성 업데이트 (Illinois algorithm)
  const newSigma = updateVolatility(phi, sigma, v, delta);

  // RD 업데이트
  const phiStar = Math.sqrt(phi * phi + newSigma * newSigma);
  const newPhi = 1 / Math.sqrt(1 / (phiStar * phiStar) + 1 / v);

  // 레이팅 업데이트
  const newMu = mu + newPhi * newPhi * gPhiJ * (score - eVal);

  const result = toGlicko1Scale(newMu, newPhi);
  return {
    rating: Math.max(100, Math.min(3000, result.rating)),
    rd: Math.max(30, Math.min(350, result.rd)),
    vol: newSigma,
  };
}

function updateVolatility(
  phi: number,
  sigma: number,
  v: number,
  delta: number
): number {
  const a = Math.log(sigma * sigma);
  const deltaSquared = delta * delta;
  const phiSquared = phi * phi;

  function f(x: number): number {
    const ex = Math.exp(x);
    const phiSquaredPlusVPlusEx = phiSquared + v + ex;
    return (
      (ex * (deltaSquared - phiSquaredPlusVPlusEx)) /
        (2 * phiSquaredPlusVPlusEx * phiSquaredPlusVPlusEx) -
      (x - a) / (TAU * TAU)
    );
  }

  let A = a;
  let B: number;

  if (deltaSquared > phiSquared + v) {
    B = Math.log(deltaSquared - phiSquared - v);
  } else {
    let k = 1;
    while (f(a - k * TAU) < 0) k++;
    B = a - k * TAU;
  }

  let fA = f(A);
  let fB = f(B);

  for (let i = 0; i < 100; i++) {
    const C = A + ((A - B) * fA) / (fB - fA);
    const fC = f(C);

    if (fC * fB <= 0) {
      A = B;
      fA = fB;
    } else {
      fA = fA / 2;
    }

    B = C;
    fB = fC;

    if (Math.abs(B - A) < 1e-6) break;
  }

  return Math.exp(A / 2);
}

/**
 * 힌트 사용 시 레이팅 변동폭 50% 감소 적용
 */
export function applyHintPenalty(
  before: GlickoResult,
  after: GlickoResult,
  hintUsed: boolean
): GlickoResult {
  if (!hintUsed) return after;
  return {
    rating: Math.round(before.rating + (after.rating - before.rating) * 0.5),
    rd: after.rd,
    vol: after.vol,
  };
}

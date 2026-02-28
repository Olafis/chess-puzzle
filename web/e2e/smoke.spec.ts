import { test, expect } from "@playwright/test";

test.describe("Smoke tests", () => {
  test("홈 페이지 로드", async ({ page }) => {
    await page.goto("/");
    await expect(page.locator("h1")).toContainText("체스 전술");
    await expect(page.getByRole("link", { name: "퍼즐 풀기 시작" })).toBeVisible();
    await expect(page.getByRole("link", { name: "퍼즐 탐색" })).toBeVisible();
  });

  test("퍼즐 탐색 페이지 로드", async ({ page }) => {
    await page.goto("/puzzles");
    await expect(page.locator("h1")).toContainText("퍼즐 탐색");
    await expect(page.getByText("난이도", { exact: true }).first()).toBeVisible();
  });

  test("리더보드 페이지 로드", async ({ page }) => {
    await page.goto("/leaderboard");
    await expect(page.locator("h1")).toContainText("리더보드");
  });

  test("로그인 페이지 로드", async ({ page }) => {
    await page.goto("/login");
    await expect(page.getByPlaceholder("you@example.com")).toBeVisible();
    await expect(page.getByPlaceholder("••••••••")).toBeVisible();
    await expect(page.getByRole("button", { name: "Google로 로그인" })).toBeVisible();
  });

  test("회원가입 페이지 로드", async ({ page }) => {
    await page.goto("/register");
    await expect(page.locator("h1")).toContainText("회원가입");
    await expect(page.getByRole("button", { name: "Google로 가입" })).toBeVisible();
  });

  test("로그인 → 회원가입 링크", async ({ page }) => {
    await page.goto("/login");
    const registerLink = page.getByRole("main").getByRole("link", { name: "회원가입" });
    await expect(registerLink).toBeVisible();
    await registerLink.click();
    await expect(page).toHaveURL(/\/register/);
  });

  test("회원가입 → 로그인 링크", async ({ page }) => {
    await page.goto("/register");
    const loginLink = page.getByRole("main").getByRole("link", { name: "로그인" });
    await expect(loginLink).toBeVisible();
    await loginLink.click();
    await expect(page).toHaveURL(/\/login/);
  });
});

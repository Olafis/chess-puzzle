import { test, expect } from "@playwright/test";

test.describe("퍼즐 플로우", () => {
  test("랜덤 퍼즐 페이지 리다이렉트", async ({ page }) => {
    await page.goto("/puzzle/random");
    await page.waitForURL(/\/puzzle\/[a-zA-Z0-9]+/, { timeout: 15000 });
    await expect(page.getByText("레이팅")).toBeVisible({ timeout: 5000 });
  });

  test("퍼즐 탐색에서 난이도 필터 클릭", async ({ page }) => {
    await page.goto("/puzzles");
    await page.getByRole("link", { name: "1200~1500" }).first().click();
    await expect(page).toHaveURL(/minRating=1200/);
  });

  test("퍼즐 탐색에서 테마 필터 클릭", async ({ page }) => {
    await page.goto("/puzzles");
    await page.getByRole("link", { name: "포크" }).first().click();
    await expect(page).toHaveURL(/theme=FORK/);
  });

  test("퍼즐 탐색에서 정렬 변경", async ({ page }) => {
    await page.goto("/puzzles");
    await page.getByRole("link", { name: "최신순" }).first().click();
    await expect(page).toHaveURL(/sort=newest/);
  });

  test("퍼즐 상세 페이지 요소 확인", async ({ page }) => {
    await page.goto("/puzzle/random");
    await page.waitForURL(/\/puzzle\/[a-zA-Z0-9]+/, { timeout: 15000 });
    // 레이팅 또는 상태 메시지(백/흑의 최선수) 표시
    await expect(
      page.getByText("레이팅").or(page.getByText(/백|흑/).first())
    ).toBeVisible({ timeout: 8000 });
  });
});

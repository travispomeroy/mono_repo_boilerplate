import { test, expect } from '@playwright/test';

test.describe('Home Page', () => {
  test('should display the home page', async ({ page }) => {
    await page.goto('/');

    await expect(page).toHaveTitle(/Polyrepo/);
    await expect(page.getByRole('heading', { name: /Welcome to Polyrepo/i })).toBeVisible();
  });

  test('should have navigation bar', async ({ page }) => {
    await page.goto('/');

    await expect(page.getByRole('banner')).toBeVisible();
    await expect(page.getByText('Polyrepo')).toBeVisible();
  });

  test('should display API status card', async ({ page }) => {
    await page.goto('/');

    await expect(page.getByText('API Status')).toBeVisible();
  });
});

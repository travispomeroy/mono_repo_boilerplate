import { Given, When, Then } from '@cucumber/cucumber';
import { expect, Page } from '@playwright/test';

let page: Page;

Given('I am on the home page', async function () {
  await page.goto('/');
});

When('I navigate to {string}', async function (path: string) {
  await page.goto(path);
});

Then('I should see the welcome message', async function () {
  await expect(page.getByRole('heading', { name: /Welcome to Polyrepo/i })).toBeVisible();
});

Then('I should see the navigation bar', async function () {
  await expect(page.getByRole('banner')).toBeVisible();
});

Then('I should see the API status card', async function () {
  await expect(page.getByText('API Status')).toBeVisible();
});

Then('I should see the 404 page', async function () {
  await expect(page.getByText('404')).toBeVisible();
  await expect(page.getByText('Page Not Found')).toBeVisible();
});

Then('I should see a {string} button', async function (buttonText: string) {
  await expect(page.getByRole('button', { name: buttonText })).toBeVisible();
});

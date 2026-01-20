import { describe, it, expect } from 'vitest';
import { store } from './store';

describe('Redux Store', () => {
  it('should have initial state', () => {
    const state = store.getState();

    expect(state).toHaveProperty('api');
    expect(state).toHaveProperty('auth');
  });

  it('should have auth initial state', () => {
    const state = store.getState();

    expect(state.auth.isAuthenticated).toBe(false);
    expect(state.auth.isLoading).toBe(true);
    expect(state.auth.user).toBeNull();
    expect(state.auth.accessToken).toBeNull();
  });
});

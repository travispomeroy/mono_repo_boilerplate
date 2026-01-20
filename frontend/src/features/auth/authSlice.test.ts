import { describe, it, expect } from 'vitest';
import authReducer, {
  setCredentials,
  setLoading,
  setError,
  logout,
} from './authSlice';

describe('authSlice', () => {
  const initialState = {
    isAuthenticated: false,
    isLoading: true,
    user: null,
    accessToken: null,
    error: null,
  };

  it('should return the initial state', () => {
    expect(authReducer(undefined, { type: 'unknown' })).toEqual(initialState);
  });

  it('should handle setCredentials', () => {
    const user = { id: '1', email: 'test@example.com', name: 'Test User' };
    const accessToken = 'test-token';

    const actual = authReducer(
      initialState,
      setCredentials({ user, accessToken })
    );

    expect(actual.isAuthenticated).toBe(true);
    expect(actual.isLoading).toBe(false);
    expect(actual.user).toEqual(user);
    expect(actual.accessToken).toBe(accessToken);
    expect(actual.error).toBeNull();
  });

  it('should handle setLoading', () => {
    const actual = authReducer(initialState, setLoading(false));
    expect(actual.isLoading).toBe(false);
  });

  it('should handle setError', () => {
    const error = 'Authentication failed';
    const actual = authReducer(initialState, setError(error));

    expect(actual.isLoading).toBe(false);
    expect(actual.error).toBe(error);
  });

  it('should handle logout', () => {
    const loggedInState = {
      isAuthenticated: true,
      isLoading: false,
      user: { id: '1', email: 'test@example.com', name: 'Test User' },
      accessToken: 'test-token',
      error: null,
    };

    const actual = authReducer(loggedInState, logout());

    expect(actual.isAuthenticated).toBe(false);
    expect(actual.isLoading).toBe(false);
    expect(actual.user).toBeNull();
    expect(actual.accessToken).toBeNull();
    expect(actual.error).toBeNull();
  });
});

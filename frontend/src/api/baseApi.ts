import { createApi, fetchBaseQuery } from '@reduxjs/toolkit/query/react';
import type { RootState } from '@/app/store';

const baseQuery = fetchBaseQuery({
  baseUrl: '/api/v1',
  prepareHeaders: (headers, { getState }) => {
    const token = (getState() as RootState).auth.accessToken;
    if (token) {
      headers.set('Authorization', `Bearer ${token}`);
    }
    headers.set('Content-Type', 'application/json');
    return headers;
  },
});

export const baseApi = createApi({
  reducerPath: 'api',
  baseQuery,
  tagTypes: ['DomainA', 'DomainB', 'DomainC'],
  endpoints: (builder) => ({
    ping: builder.query<{ status: string; message: string; timestamp: string }, void>({
      query: () => '/ping',
    }),
  }),
});

export const { usePingQuery } = baseApi;

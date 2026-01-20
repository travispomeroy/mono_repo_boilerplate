import { Box, Typography, Card, CardContent, CircularProgress } from '@mui/material';
import { usePingQuery } from '@/api/baseApi';

export function HomePage() {
  const { data, isLoading, isError } = usePingQuery();

  return (
    <Box>
      <Typography variant="h3" component="h1" gutterBottom>
        Welcome to Polyrepo
      </Typography>
      <Typography variant="body1" paragraph>
        A modern monorepo with React frontend and Spring Boot Modulith backend.
      </Typography>

      <Card sx={{ maxWidth: 400, mt: 3 }}>
        <CardContent>
          <Typography variant="h6" gutterBottom>
            API Status
          </Typography>
          {isLoading && <CircularProgress size={24} />}
          {isError && (
            <Typography color="error">
              Unable to connect to the backend API
            </Typography>
          )}
          {data && (
            <Box>
              <Typography>Status: {data.status}</Typography>
              <Typography>Message: {data.message}</Typography>
              <Typography variant="caption" color="text.secondary">
                {data.timestamp}
              </Typography>
            </Box>
          )}
        </CardContent>
      </Card>
    </Box>
  );
}

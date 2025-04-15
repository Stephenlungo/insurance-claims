import React from 'react';
import DashboardLayout from './DashboardLayout';
import { Typography, Paper, Box } from '@mui/material';

const DashboardHome = () => {
 
  const user = JSON.parse(localStorage.getItem('user'));

  return (
    <DashboardLayout>
      <Paper elevation={3} sx={{ p: 4 }}>
        <Typography variant="h4" gutterBottom>
          Welcome back, {user?.profile?.first_name || 'User'}!
        </Typography>
        <Typography variant="body1" color="text.secondary">
          From here, you can submit a new insurance claim, view existing claims, and track their progress.
        </Typography>
        <Box mt={2}>
          <Typography variant="h6">Your Role: {user?.role}</Typography>
          <Typography variant="body2" color="text.secondary">
            {user?.role === 'admin' ? 'You have admin privileges.' : 'You are a regular user.'}
          </Typography>
        </Box>
  
      </Paper>
    </DashboardLayout>
  );
};

export default DashboardHome;

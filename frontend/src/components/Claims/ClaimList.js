import React, { useEffect, useState, useCallback, useMemo } from 'react';
import {
  Paper,
  Typography,
  List,
  ListItem,
  ListItemText,
  CircularProgress,
  Box,
  Select,
  MenuItem,
  FormControl,
  InputLabel,
  Chip,
  Button,
  Link,
} from '@mui/material';
import axios from 'axios';
import io from 'socket.io-client';
import DashboardLayout from '../DashboardLayout';
import SettleClaimModal from './SettleClaimModal';

const ClaimList = () => {
  const [claims, setClaims] = useState([]);
  const [loading, setLoading] = useState(true);
  const [openModal, setOpenModal] = useState(false);
  const [selectedClaimId, setSelectedClaimId] = useState(null);
  const [formData, setFormData] = useState({
    settlement_amount: '',
    payment_reference: '',
  });

  const user = JSON.parse(localStorage.getItem('user'));

  // Memoize socket to avoid re-creating it on every render
  const socket = useMemo(() => io('http://localhost:5000'), []);

  const fetchClaims = useCallback(async () => {
    const token = localStorage.getItem('token');
    const endpoint =
      user?.role === 'admin'
        ? 'http://localhost:5000/claims/all'
        : 'http://localhost:5000/claims/my-claims';

    try {
      const res = await axios.get(endpoint, {
        headers: { Authorization: `Bearer ${token}` },
      });
      setClaims(res.data);
    } catch {
      alert('Failed to fetch claims');
    } finally {
      setLoading(false);
    }
  }, [user?.role]);

  const handleStatusChange = async (claimId, newStatus) => {
    const token = localStorage.getItem('token');
    try {
      await axios.patch(
        `http://localhost:5000/claims/${claimId}/update-status`,
        { status: newStatus },
        {
          headers: { Authorization: `Bearer ${token}` },
        }
      );
      fetchClaims();
    } catch {
      alert('Failed to update claim status');
    }
  };

  const handleOpenModal = (claimId) => {
    setSelectedClaimId(claimId);
    setFormData({ settlement_amount: '', payment_reference: '' });
    setOpenModal(true);
  };

  const handleSettleSubmit = async (claimId) => {
    const token = localStorage.getItem('token');

    try {
      await axios.post(
        `http://localhost:5000/claims/${claimId}/settle`,
        {
          settlement_amount: parseFloat(formData.settlement_amount),
          payment_reference: formData.payment_reference,
        },
        {
          headers: {
            Authorization: `Bearer ${token}`,
            'Content-Type': 'application/json',
          },
        }
      );
      setOpenModal(false);
      fetchClaims();
    } catch (err) {
      console.error('Settle Error:', err?.response?.data || err.message);
      alert('Failed to settle claim');
    }
  };

  // Real-time updates with Socket.io
  useEffect(() => {
    fetchClaims();

    socket.on('claimStatusUpdated', (updatedClaim) => {
      setClaims((prevClaims) =>
        prevClaims.map((claim) =>
          claim.id === updatedClaim.id ? updatedClaim : claim
        )
      );
    });

    return () => {
      socket.off('claimStatusUpdated');
    };
  }, [fetchClaims, socket]);

  return (
    <DashboardLayout>
      <Paper elevation={3} sx={{ p: 4 }}>
        <Typography variant="h5" gutterBottom>
          {user?.role === 'admin' ? 'All Claims' : 'My Claims'}
        </Typography>
        {loading ? (
          <CircularProgress />
        ) : (
          <List>
            {claims.map((claim) => (
              <ListItem key={claim.id} divider alignItems="flex-start">
                <ListItemText
                  primary={
                    user?.role === 'admin'
                      ? `Claimant: ${claim.user?.profile?.first_name} ${claim.user?.profile?.last_name}`
                      : ''
                  }
                  secondary={
                    <>
                      Type: {claim.claim_type || 'N/A'} |{' '}
                      <Chip
                        label={claim.status.replace('_', ' ')}
                        size="small"
                        sx={{
                          backgroundColor:
                            claim.status === 'Approved'
                              ? 'green'
                              : claim.status === 'Denied'
                              ? 'red'
                              : claim.status === 'Under_Review'
                              ? 'orange'
                              : claim.status === 'Settled'
                              ? 'purple'
                              : 'grey',
                          color: '#fff',
                          fontWeight: 'bold',
                          textTransform: 'capitalize',
                          mx: 1,
                        }}
                      />{' '}
                      | Priority: {claim.priority}
                    </>
                  }
                />
                <Box ml={2}>
                  <Typography variant="body2" color="textSecondary">
                    Incident: {claim.incident_description || 'No description provided'}
                  </Typography>
                  <Typography variant="body2" color="textSecondary">
                    Created At: {new Date(claim.created_at).toLocaleString()}
                  </Typography>
                </Box>
                {claim.documents?.length > 0 && (
                  <Box sx={{ ml: 2 }}>
                    <Link
                      href={`http://localhost:5000/uploads/${claim.documents[0].file_name}`}
                      target="_blank"
                      variant="body2"
                    >
                      Download
                    </Link>
                  </Box>
                )}
                {user?.role === 'admin' && (
                  <>
                    <Box sx={{ ml: 2, width: 150 }}>
                      <FormControl fullWidth size="small">
                        <InputLabel>Status</InputLabel>
                        <Select
                          value={claim.status}
                          label="Status"
                          onChange={(e) => handleStatusChange(claim.id, e.target.value)}
                        >
                          <MenuItem value="Pending">Pending</MenuItem>
                          <MenuItem value="Under_Review">Under Review</MenuItem>
                          <MenuItem value="Approved">Approved</MenuItem>
                          <MenuItem value="Denied">Denied</MenuItem>
                          <MenuItem value="Settled">Settled</MenuItem>
                        </Select>
                      </FormControl>
                    </Box>
                    <Button
                      variant="outlined"
                      size="small"
                      sx={{ ml: 2, mt: 1 }}
                      onClick={() => handleOpenModal(claim.id)}
                    >
                      Settle
                    </Button>
                  </>
                )}
              </ListItem>
            ))}
          </List>
        )}
      </Paper>

      <SettleClaimModal
        open={openModal}
        onClose={() => setOpenModal(false)}
        claimId={selectedClaimId}
        formData={formData}
        onChange={(e) =>
          setFormData({ ...formData, [e.target.name]: e.target.value })
        }
        onSubmit={handleSettleSubmit}
      />
    </DashboardLayout>
  );
};

export default ClaimList;

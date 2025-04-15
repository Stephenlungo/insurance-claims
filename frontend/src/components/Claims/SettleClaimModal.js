// src/components/SettleClaimModal.js
import React from 'react';
import {
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  TextField,
  Button,
} from '@mui/material';

const SettleClaimModal = ({ open, onClose, claimId, formData, onChange, onSubmit }) => {
  return (
    <Dialog open={open} onClose={onClose}>
      <DialogTitle>Settle Claim</DialogTitle>
      <DialogContent>
        <TextField
          margin="dense"
          label="Settlement Amount"
          type="number"
          fullWidth
          name="settlement_amount"
          value={formData.settlement_amount}
          onChange={onChange}
        />
        <TextField
          margin="dense"
          label="Payment Reference"
          fullWidth
          name="payment_reference"
          value={formData.payment_reference}
          onChange={onChange}
        />
      </DialogContent>
      <DialogActions>
        <Button onClick={onClose} variant="outlined">
          Cancel
        </Button>
        <Button onClick={() => onSubmit(claimId)} variant="contained">
          Submit
        </Button>
      </DialogActions>
    </Dialog>
  );
};

export default SettleClaimModal;

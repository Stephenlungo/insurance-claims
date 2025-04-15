import React, { useState } from 'react';
import DashboardLayout from '../DashboardLayout';
import {
  TextField,
  Button,
  Paper,
  Typography,
  Box,
  MenuItem,
  Select,
  InputLabel,
  FormControl,
  FormHelperText
} from '@mui/material';
import axios from 'axios';
import { useFormik } from 'formik';
import * as Yup from 'yup';

// Validation schema
const validationSchema = Yup.object({
  claim_type: Yup.string().required('Claim type is required'),
  incident_description: Yup.string().required('Incident description is required'),
  priority: Yup.string().required('Priority is required'),
});

const ClaimForm = () => {
  const [file, setFile] = useState(null);

  const formik = useFormik({
    initialValues: {
      claim_type: '',
      incident_description: '',
      status: 'Pending',
      priority: 'Normal',
    },
    validationSchema,
    onSubmit: async (values, { resetForm }) => {
      const token = localStorage.getItem('token');

      const formData = new FormData();
      formData.append('claim_type', values.claim_type);
      formData.append('incident_description', values.incident_description);
      formData.append('status', values.status);
      formData.append('priority', values.priority);

      if (file) {
        formData.append('document', file);
      }

      try {
        await axios.post('http://localhost:5000/claims', formData, {
          headers: {
            Authorization: `Bearer ${token}`,
            'Content-Type': 'multipart/form-data',
          },
        });
        alert('Claim submitted!');
        resetForm();
        setFile(null);
      } catch (err) {
        alert('Failed to submit claim');
      }
    },
  });

  const claimTypes = ['Fire Damage', 'Water Damage', 'Acts of God', 'Theft', 'Vandalism'];

  const handleFileChange = (e) => {
    const file = e.target.files[0];
    if (file) {
      setFile(file);
    }
  };

  return (
    <DashboardLayout>
      <Paper elevation={3} sx={{ p: 4 }}>
        <Typography variant="h5" gutterBottom>
          Submit a New Claim
        </Typography>

        <form onSubmit={formik.handleSubmit}>
          <FormControl
            fullWidth
            margin="normal"
            error={formik.touched.claim_type && Boolean(formik.errors.claim_type)}
          >
            <InputLabel>Claim Type</InputLabel>
            <Select
              name="claim_type"
              value={formik.values.claim_type}
              onChange={formik.handleChange}
              onBlur={formik.handleBlur}
            >
              {claimTypes.map((type) => (
                <MenuItem key={type} value={type}>
                  {type}
                </MenuItem>
              ))}
            </Select>
            <FormHelperText>{formik.touched.claim_type && formik.errors.claim_type}</FormHelperText>
          </FormControl>

          <TextField
            label="Incident Description"
            name="incident_description"
            multiline
            rows={4}
            fullWidth
            margin="normal"
            value={formik.values.incident_description}
            onChange={formik.handleChange}
            error={formik.touched.incident_description && Boolean(formik.errors.incident_description)}
            helperText={formik.touched.incident_description && formik.errors.incident_description}
          />

          <FormControl
            fullWidth
            margin="normal"
            error={formik.touched.priority && Boolean(formik.errors.priority)}
          >
            <InputLabel>Priority</InputLabel>
            <Select
              name="priority"
              value={formik.values.priority}
              onChange={formik.handleChange}
              onBlur={formik.handleBlur}
            >
              <MenuItem value="Normal">Normal</MenuItem>
              <MenuItem value="High">High</MenuItem>
            </Select>
            <FormHelperText>{formik.touched.priority && formik.errors.priority}</FormHelperText>
          </FormControl>

          {/* File Upload Section */}
          <Box mt={2}>
            <input
              type="file"
              accept="image/*,application/pdf" 
              onChange={handleFileChange}
            />
            {file && (
              <Typography variant="body2" mt={1}>
                Selected file: {file.name}
              </Typography>
            )}
          </Box>

          <Box mt={2}>
            <Button type="submit" variant="contained" fullWidth>
              Submit
            </Button>
          </Box>
        </form>
      </Paper>
    </DashboardLayout>
  );
};

export default ClaimForm;

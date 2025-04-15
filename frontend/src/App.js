import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import Login from './components/Auth/Login';
import Register from './components/Auth/Register';
import DashboardHome from './components/DashboardHome';
import ClaimForm from './components/Claims/ClaimForm';
import ClaimList from './components/Claims/ClaimList';
import PrivateRoute from './components/Utils/PrivateRoute';
import RoleRoute from './components/Utils/RoleRoute';

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/login" element={<Login />} />
        <Route path="/register" element={<Register />} />

        <Route
          path="/dashboard"
          element={
            <PrivateRoute>
              <DashboardHome />
            </PrivateRoute>
          }
        />

        <Route
          path="/dashboard/claims"
          element={
            <PrivateRoute>
              <RoleRoute allowedRoles={['user', 'admin']}>
                <ClaimList />
              </RoleRoute>
            </PrivateRoute>
          }
        />

        {/* Only accessible to non-admins */}
        <Route
          path="/dashboard/new-claim"
          element={
            <PrivateRoute>
              <RoleRoute allowedRoles={['user', 'client']}>
                <ClaimForm />
              </RoleRoute>
            </PrivateRoute>
          }
        />

        {/* Only accessible to non-admins */}
        <Route
          path="/dashboard/my-claims"
          element={
            <PrivateRoute>
              <RoleRoute allowedRoles={['user', 'client']}>
                <ClaimList />
              </RoleRoute>
            </PrivateRoute>
          }
        />
        {/* Only accessible to non-admins */}
        <Route
          path="/dashboard/track-claims"
          element={
            <PrivateRoute>
              <RoleRoute allowedRoles={['user', 'client']}>
                <ClaimList />
              </RoleRoute>
            </PrivateRoute>
          }
        />

        <Route path="*" element={<Navigate to="/login" />} />
      </Routes>
    </Router>
  );
}

export default App;

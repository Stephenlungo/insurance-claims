
import React from 'react';
import { Navigate } from 'react-router-dom';

const RoleRoute = ({ allowedRoles, children }) => {
  const user = JSON.parse(localStorage.getItem('user'));

  if (!user || !allowedRoles.includes(user.role)) {
    return <Navigate to="/dashboard" replace />;
  }

  return children;
};

export default RoleRoute;

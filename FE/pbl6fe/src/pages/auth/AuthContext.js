import React, {createContext, useState, useContext} from 'react';

const AuthContext = createContext('AuthContext');

export const AuthProvider = ({children}) => {
  const [token, setToken] = useState(null);

  const login = (token) => {
    setToken(token);
  };

  const logout = () => {
    setToken(null);
  };

  return (
    <AuthContext.Provider value={{token, login, logout}}>
      {children}
    </AuthContext.Provider>
  )
};

export const useAuth = () => {
  return useContext(AuthContext);
};

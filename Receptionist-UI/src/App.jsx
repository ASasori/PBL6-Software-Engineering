import { useState } from "react";
import { Route, Routes, Navigate } from "react-router-dom";

import Sidebar from "./components/common/Sidebar";
import Login from "./pages/Login";

import OverviewPage from "./pages/OverviewPage";
import ProductsPage from "./pages/Rooms";
import UsersPage from "./pages/UsersPage";
import SalesPage from "./pages/SalesPage";
import OrdersPage from "./pages/OrdersPage";
import SettingsPage from "./pages/SettingsPage";
import ProtectedRoute from "./components/ProtectedRoute";

function App() {
	const [isLoggedIn, setIsLoggedIn] = useState(() => {
		return localStorage.getItem('isLoggedIn') === 'true'; // Kiểm tra localStorage
	});

	const handleLogin = () => {
		setIsLoggedIn(true);
		localStorage.setItem('isLoggedIn', 'true'); // Lưu trạng thái đăng nhập
	};

	const handleLogout = () => {
		setIsLoggedIn(false);
		localStorage.removeItem('isLoggedIn');
		localStorage.removeItem('authToken'); // Xóa trạng thái đăng nhập
	};

	return (
		<div className='flex h-screen overflow-hidden text-gray-100 bg-gray-900'>
			{isLoggedIn && <Sidebar />}
			<div className={`flex-1 ${isLoggedIn ? "relative overflow-y-auto" : "absolute inset-0"}`}>
				<Routes>
					<Route path='/login' element={!isLoggedIn ? <Login onLogin={handleLogin} /> : <Navigate to="/" />} />
					<Route path='/' element={<ProtectedRoute element={<OverviewPage />} isLoggedIn={isLoggedIn} />} />
					<Route path='/rooms' element={<ProtectedRoute element={<ProductsPage />} isLoggedIn={isLoggedIn} />} />
					<Route path='/users' element={<ProtectedRoute element={<UsersPage />} isLoggedIn={isLoggedIn} />} />
					<Route path='/bookings' element={<ProtectedRoute element={<OrdersPage />} isLoggedIn={isLoggedIn} />} />
					<Route path='/sales' element={<ProtectedRoute element={<SalesPage />} isLoggedIn={isLoggedIn} />} />
					<Route path='/settings' element={<ProtectedRoute element={<SettingsPage handleLogout={handleLogout} />} isLoggedIn={isLoggedIn} />} />
				</Routes>
			</div>
		</div>
	);
}

export default App;

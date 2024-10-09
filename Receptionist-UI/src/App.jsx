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

function App() {
	const [isLoggedIn, setIsLoggedIn] = useState(false);

	const handleLogin = () => {
		setIsLoggedIn(true);
	};

	return (
		<div className='flex h-screen overflow-hidden text-gray-100 bg-gray-900'>
			{isLoggedIn && <Sidebar />}
			<div className={`flex-1 ${isLoggedIn ? "relative overflow-y-auto" : "absolute inset-0"}`}>
				<Routes>
					{!isLoggedIn && <Route path='/login' element={<Login onLogin={handleLogin} />} />}
					<Route path='/' element={isLoggedIn ? <OverviewPage /> : <Navigate to="/login" />} />
					<Route path='/rooms' element={isLoggedIn ? <ProductsPage /> : <Navigate to="/login" />} />
					<Route path='/users' element={isLoggedIn ? <UsersPage /> : <Navigate to="/login" />} />
					<Route path='/bookings' element={isLoggedIn ? <OrdersPage /> : <Navigate to="/login" />} />
					<Route path='/sales' element={isLoggedIn ? <SalesPage /> : <Navigate to="/login" />} />
					<Route path='/settings' element={isLoggedIn ? <SettingsPage /> : <Navigate to="/login" />} />
				</Routes>
			</div>
		</div>

	);
}

export default App;

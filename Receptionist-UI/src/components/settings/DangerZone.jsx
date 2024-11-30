import { motion } from "framer-motion";
import { Trash2 } from "lucide-react";
import logout from "../../api/logout";
import { useState } from "react";
import { useNavigate } from "react-router-dom"; // Import useNavigate

const DangerZone = () => {
	const [errorMessage, setErrorMessage] = useState('');
	const [successMessage, setSuccessMessage] = useState('');
	const token = localStorage.getItem('access');
	const navigate = useNavigate(); // Khởi tạo useNavigate

	const handleLogout = async () => {
		if (token) {
			try {
				await logout(token);
				setSuccessMessage('Logout successful!'); // Thông báo thành công
				localStorage.removeItem('access'); // Xóa token sau khi logout
				localStorage.setItem('isLoggedIn', 'false'); // Cập nhật trạng thái đăng nhập

				// Chuyển hướng đến trang /login
				navigate('/login');
			} catch (err) {
				console.error('Failed to logout:', err);
				setErrorMessage('Failed to logout. Please try again.'); // Thông báo lỗi
			}
		}
	};

	return (
		<motion.div
			className='p-6 mb-8 bg-red-900 bg-opacity-50 border border-red-700 shadow-lg backdrop-filter backdrop-blur-lg rounded-xl'
			initial={{ opacity: 0, y: 20 }}
			animate={{ opacity: 1, y: 0 }}
			transition={{ duration: 0.5, delay: 0.2 }}
		>
			<div className='flex items-center mb-4'>
				<Trash2 className='mr-3 text-red-400' size={24} />
				<h2 className='text-xl font-semibold text-gray-100'>Danger Zone</h2>
			</div>
			<p className='mb-4 text-gray-300'>Permanently delete your account and all of your content.</p>
			<button
				onClick={handleLogout}
				className='px-4 py-2 font-bold text-white transition duration-200 bg-red-600 rounded hover:bg-red-700'
			>
				Log Out
			</button>
			{successMessage && <p className='mt-4 text-green-300'>{successMessage}</p>}
			{errorMessage && <p className='mt-4 text-red-300'>{errorMessage}</p>}
		</motion.div>
	);
};

export default DangerZone;

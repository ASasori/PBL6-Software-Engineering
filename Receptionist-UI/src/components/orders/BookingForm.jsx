import React, { useState, useEffect } from "react";
import DatePicker from "react-datepicker";
import "react-datepicker/dist/react-datepicker.css";
import { format } from "date-fns";
import { toast, ToastContainer } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";

import BookingAPI from "../../api/booking"
import CustomerAPI from "../../api/customer"

const BookingForm = () => {
	const [checkInDate, setCheckInDate] = useState(null);
	const [checkOutDate, setCheckOutDate] = useState(null);
	const [rooms, setRooms] = useState([]);
	const [selectedRooms, setSelectedRooms] = useState([]);
	const [customers, setCustomers] = useState([]);
	const [coupons, setCoupons] = useState([]);
	const [fullName, setFullName] = useState("");
	const [email, setEmail] = useState("");
	const [phone, setPhone] = useState("");
	const [numAdults, setNumAdults] = useState(1);
	const [numChildren, setNumChildren] = useState(0);
	const [paymentIntent, setPaymentIntent] = useState("");
	const [totalDays, setTotalDays] = useState(0);
	const [selectedCustomer, setSelectedCustomer] = useState("");
	const [selectedDiscount, setSelectedDiscount] = useState([]);

	const formatDate = (date) => format(date, "yyyy-MM-dd");
	const token = localStorage.getItem('access');

	useEffect(() => {
		const fetchCustomers = async () => {
			try {
				const response = await CustomerAPI.getCustomers(token);
				console.log(response);
				if (response && response.length > 0) {
					setCustomers(response);
				} else {
					toast.warn("Không có khách hàng nào!");
				}
			} catch (error) {
				console.error("Error fetching customers:", error);
				toast.error("Lỗi khi tải danh sách khách hàng.");
			}
		};

		fetchCustomers();
	}, [token]);

	useEffect(() => {
		const fetchCoupons = async () => {
			try {
				const response = await BookingAPI.ListCoupons(token);
				console.log(response);
				if (response && response.length > 0) {
					setCoupons(response);  // Lưu danh sách coupons vào state
				} else {
					toast.warn("Không có coupon nào!");
				}
			} catch (error) {
				console.error("Error fetching coupons:", error);
				toast.error("Lỗi khi tải danh sách coupon.");
			}
		};

		fetchCoupons();
	}, [token]);


	// Tính toán số ngày thuê phòng
	useEffect(() => {
		if (checkInDate && checkOutDate) {
			const diffTime = Math.abs(checkOutDate - checkInDate);
			const days = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
			setTotalDays(days);
		}
	}, [checkInDate, checkOutDate]);

	const handleCheckRooms = async () => {
		if (!checkInDate || !checkOutDate) {
			toast.warn("Vui lòng chọn ngày check-in và check-out");
			return;
		}

		try {
			const formattedCheckInDate = formatDate(checkInDate);
			const formattedCheckOutDate = formatDate(checkOutDate);

			const response = await BookingAPI.ListAvailableRoom(
				formattedCheckInDate,
				formattedCheckOutDate,
				token
			);
			console.log(response);

			if (response.error) {
				alert(response.error);
			} else {
				setRooms(Array.isArray(response) ? response : []);
			}
		} catch (err) {
			console.error("Error fetching available rooms:", err);
			toast.error("Đã xảy ra lỗi khi kiểm tra phòng trống.");
		}
	};


	// Xử lý khi chọn hoặc bỏ chọn phòng
	const handleRoomSelect = (roomId) => {
		setSelectedRooms((prevSelectedRooms) => {
			if (prevSelectedRooms.includes(roomId)) {
				return prevSelectedRooms.filter((id) => id !== roomId);
			} else {
				return [...prevSelectedRooms, roomId];
			}
		});
	};

	const handleBooking = async () => {
		if (selectedRooms.length > 0) {
			const bookingData = {
				user_id: selectedCustomer,
				rooms: selectedRooms,
				coupons: selectedDiscount,
				full_name: fullName,
				email: email,
				phone: phone,
				check_in_date: formatDate(checkInDate),
				check_out_date: formatDate(checkOutDate),
				num_adults: parseInt(numAdults),
				num_children: parseInt(numChildren),
				payment_intent: paymentIntent,
			};
			console.log(bookingData)
			try {
				const result = await BookingAPI.CreateBooking(bookingData, token); // Gọi API tạo booking
				console.log("Booking created:", result);
				toast.success("Đặt phòng thành công!");
			} catch (error) {
				console.error("Booking error:", error);
				toast.error("Đã có lỗi xảy ra khi đặt phòng.");
			}
		} else {
			toast.warn("Vui lòng chọn ít nhất một phòng trước khi đặt!");
		}
	};

	return (
		<div className="max-w-4xl p-8 mx-auto bg-white rounded-lg shadow-lg">
			<h2 className="mb-8 text-4xl font-semibold text-center text-gray-800">Đặt Phòng</h2>

			<div className="grid grid-cols-1 gap-6 mb-8 md:grid-cols-2">
				<div>
					<label className="block mb-2 font-medium text-gray-700">Ngày Check-In</label>
					<DatePicker
						selected={checkInDate}
						onChange={(date) => setCheckInDate(date)}
						dateFormat="yyyy/MM/dd"
						className="w-full px-4 py-3 text-gray-800 transition-all duration-300 bg-white border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
						placeholderText="Chọn ngày check-in"
					/>
				</div>
				<div>
					<label className="block mb-2 font-medium text-gray-700">Ngày Check-Out</label>
					<DatePicker
						selected={checkOutDate}
						onChange={(date) => setCheckOutDate(date)}
						dateFormat="yyyy/MM/dd"
						className="w-full px-4 py-3 text-gray-800 transition-all duration-300 bg-white border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
						placeholderText="Chọn ngày check-out"
					/>
				</div>
			</div>

			<button
				onClick={handleCheckRooms}
				className="w-full py-3 text-white transition-all duration-300 ease-in-out bg-blue-500 rounded-lg hover:bg-blue-600 focus:outline-none"
			>
				Kiểm tra phòng
			</button>


			{/* Hiển thị thông tin ngày và số ngày */}
			{checkInDate && checkOutDate && (
				<div className="mt-6 space-y-4">
					<div>
						<label className="block font-medium text-gray-700">Ngày Check-In:</label>
						<input
							type="text"
							value={checkInDate ? checkInDate.toLocaleDateString() : ""}
							readOnly
							className="w-full px-4 py-2 text-gray-800 transition duration-300 ease-in-out bg-gray-100 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
						/>
					</div>
					<div>
						<label className="block font-medium text-gray-700">Ngày Check-Out:</label>
						<input
							type="text"
							value={checkOutDate ? checkOutDate.toLocaleDateString() : ""}
							readOnly
							className="w-full px-4 py-2 text-gray-800 transition duration-300 ease-in-out bg-gray-100 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
						/>
					</div>
					<div>
						<label className="block font-medium text-gray-700">Số ngày thuê:</label>
						<input
							type="text"
							value={totalDays}
							readOnly
							className="w-full px-4 py-2 text-gray-800 transition duration-300 ease-in-out bg-gray-100 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
						/>
					</div>
				</div>

			)}

			{/* Hiển thị danh sách phòng */}
			{rooms.length > 0 && (
				<div className="mt-6">
					<label className="block mb-2 font-medium text-gray-700">Chọn phòng</label>
					<div className="space-y-4">
						{rooms.map((room) => (
							<div
								key={room.rid}
								className={`flex items-center pb-4 border-b p-4 rounded-lg shadow-md transition-all duration-300 ${selectedRooms.includes(room.rid)
									? 'bg-blue-100 border-blue-500'
									: 'bg-white border-gray-300 hover:bg-gray-50'
									}`}
							>
								<input
									type="checkbox"
									id={`room-${room.room_number}`}
									value={room.rid}
									checked={selectedRooms.includes(room.rid)}
									onChange={() => handleRoomSelect(room.rid)}
									className="mr-4"
								/>
								<div className="flex-1">
									<h3 className="mb-2 text-2xl font-semibold text-gray-800">{`Phòng ${room.room_number}`}</h3>
									<p className="mb-1 text-lg text-gray-600">
										Loại phòng:
										<span className="font-semibold text-indigo-600">{room.room_type.type}</span>
									</p>
									<p className="mb-1 text-lg text-gray-600">
										Giá:
										<span className="text-xl font-bold text-green-600">${room.room_type.price}</span>
									</p>
								</div>
								<div
									className={`px-4 py-2 text-sm rounded-lg ${room.is_available ? 'bg-green-500 text-white' : 'bg-red-500 text-white'
										}`}
								>
									{room.is_available ? 'Có sẵn' : 'Không có sẵn'}
								</div>
							</div>
						))}
					</div>

					<div>
						<br /><br />
						<label className="block mb-2 text-gray-600">Khách hàng</label>
						<select
							className="w-full px-4 py-3 text-black transition-all duration-200 ease-in-out bg-white border-2 border-gray-300 rounded-md shadow-md appearance-none focus:outline-none focus:ring-2 focus:ring-blue-600 focus:border-blue-600 hover:shadow-lg"
							onChange={(e) => setSelectedCustomer(e.target.value)}
							value={selectedCustomer}
						>
							<option value="" className="text-gray-500">Chọn khách hàng</option>
							{customers.map((customer) => (
								<option key={customer.id} value={customer.id} className="text-gray-800">
									{customer.full_name}
								</option>
							))}
						</select>
					</div>

					<div>
						<label className="block mb-2 text-gray-600">Họ và tên</label>
						<input
							type="text"
							value={fullName}
							onChange={(e) => setFullName(e.target.value)}
							className="w-full px-4 py-2 text-black border rounded-lg"
							placeholder="Nhập họ và tên"
						/>
					</div>
					<div>
						<label className="block mb-2 text-gray-600">Email</label>
						<input
							type="email"
							value={email}
							onChange={(e) => setEmail(e.target.value)}
							className="w-full px-4 py-2 text-black border rounded-lg"
							placeholder="Nhập email"
						/>
					</div>
					<div>
						<label className="block mb-2 text-gray-600">Số điện thoại</label>
						<input
							type="tel"
							value={phone}
							onChange={(e) => setPhone(e.target.value)}
							className="w-full px-4 py-2 text-black border rounded-lg"
							placeholder="Nhập số điện thoại"
						/>
					</div>
					<div>
						<label className="block mb-2 text-gray-600">Số người lớn</label>
						<input
							type="number"
							value={numAdults}
							onChange={(e) => setNumAdults(e.target.value)}
							className="w-full px-4 py-2 text-black border rounded-lg"
							min="1"
						/>
					</div>
					<div>
						<label className="block mb-2 text-gray-600">Số trẻ em</label>
						<input
							type="number"
							value={numChildren}
							onChange={(e) => setNumChildren(e.target.value)}
							className="w-full px-4 py-2 text-black border rounded-lg"
							min="0"
						/>
					</div>
					<div>
						<label className="block mb-2 text-gray-600">Stripe payment intent</label>
						<input
							type="text"
							value={paymentIntent}
							onChange={(e) => setPaymentIntent(e.target.value)}
							className="w-full px-4 py-2 text-black border rounded-lg"
							placeholder="Nhập họ và tên"
						/>
					</div>
					<div className="mt-6">
						<label className="block mb-2 text-gray-600">Giảm giá</label>
						<select
							className="w-full px-4 py-2 text-black border rounded-lg focus:outline-none"
							onChange={(e) => setSelectedDiscount(Array.from(e.target.selectedOptions, option => option.value))}
							value={selectedDiscount}
							multiple
						>
							{coupons.map((coupon) => (
								<option key={coupon.cid} value={coupon.cid}>
									{coupon.type === "Percentage"
										? `Giảm ${coupon.discount}%`
										: `Giảm ${coupon.discount} VND`}
								</option>
							))}
						</select>
					</div>

					<button
						onClick={handleBooking}
						className="w-full py-3 mt-6 text-white bg-green-500 rounded-lg hover:bg-green-600 focus:outline-none"
					>
						Đặt phòng
					</button>
				</div>
			)}

			{/* Thông tin cá nhân */}
			<div className="mt-6 space-y-4">

			</div>

			{/* Xác nhận đặt phòng */}

		</div>
	);
};

export default BookingForm;

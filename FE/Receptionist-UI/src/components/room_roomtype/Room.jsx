import { motion } from "framer-motion";
import { Edit, Search, Trash2, Plus, X } from "lucide-react";
import { useState, useEffect } from "react";
import RoomAPI from "../../api/room"
import RoomTypeAPI from "../../api/roomtype";

import { toast } from 'react-toastify';

const ProductsTable = () => {
	const [searchTerm, setSearchTerm] = useState("");
	const [isModalOpen, setIsModalOpen] = useState(false);
	const [isEditMode, setIsEditMode] = useState(false);
	const [editingRoom, setEditingRoom] = useState(null);

	const [newRoom, setNewRoom] = useState({
		room_number: "",
		room_type: "",
		is_available: true,
	});

	const [rooms, setRooms] = useState([])
	const [roomTypes, setRoomTypes] = useState([])
	const [filteredProducts, setFilteredProducts] = useState([])
	const token = localStorage.getItem('authToken')

	useEffect(() => {
		const fetchRooms = async () => {
			try {
				const roomsData = await RoomAPI.getRoom(token)
				setRooms(roomsData)
				setFilteredProducts(roomsData)

				const roomTypeAPI = new RoomTypeAPI()
				const roomTypeData = await roomTypeAPI.getRoomTypes(token)
				const roomTypeMap = {}
				roomTypeData.forEach((type) => {
					roomTypeMap[type.id] = type
				})
				setRoomTypes(roomTypeMap)
			} catch (e) {
				console.error("Error fetching rooms or room types:", e);
			}
		}
		fetchRooms()
	}, [token])

	const handleSearch = (e) => {
		const term = e.target.value.toLowerCase();
		setSearchTerm(term);
		const filtered = rooms.filter(
			(room) =>
				room.room_number.includes(term) || (roomTypes[room.room_type]?.type || "").toLowerCase().includes(term)
		);
		setFilteredProducts(filtered);
	};

	const handleAddRoom = () => {
		setIsModalOpen(true);
	};

	const handleCloseModal = () => {
		setIsModalOpen(false);
	};

	const handleInputChange = (e) => {
		const { name, value } = e.target;

		setNewRoom((prevRoom) => ({
			...prevRoom,
			[name]: value,
		}));
	};

	const handleSubmit = async (e) => {
		e.preventDefault();
		try {
			if (isEditMode) {
				// Cập nhật phòng nếu đang chỉnh sửa
				const updatedRoom = await RoomAPI.updateRoom(token, editingRoom.id, newRoom);

				// Cập nhật phòng trong danh sách
				const updatedRooms = rooms.map((room) =>
					room.id === editingRoom.id ? updatedRoom : room
				);
				setRooms(updatedRooms);
				setFilteredProducts(updatedRooms);

				toast.success("Phòng đã được cập nhật thành công!");
			} else {
				// Thêm phòng mới
				const createdRoom = await RoomAPI.createRoom(token, newRoom);

				setRooms([...rooms, createdRoom]);
				setFilteredProducts([...filteredProducts, createdRoom]);

				toast.success("Phòng đã được thêm thành công!");
			}

			// Reset form và đóng modal
			setNewRoom({
				room_number: "",
				room_type: "",
				is_available: true,
			});
			setIsEditMode(false); // Trở về chế độ thêm mới sau khi chỉnh sửa xong
			setEditingRoom(null); // Reset phòng đang chỉnh sửa
			setIsModalOpen(false); // Đóng modal
		} catch (error) {
			console.error("Error creating/updating room:", error);
			if (error.response && error.response.data && error.response.data.error) {
				toast.error(error.response.data.error);
			} else {
				toast.error("Có lỗi xảy ra, vui lòng thử lại.");
			}
		}
	};


	const handleEditRoom = (room) => {
		setIsEditMode(true);
		setNewRoom({
			room_number: room.room_number,
			room_type: room.room_type,
			is_available: room.is_available,
		});
		setEditingRoom(room);
		setIsModalOpen(true);
	}

	const handleDeleteRoom = async (roomId) => {
		if (window.confirm("Are you sure you want to delete this room?")) {
			try {
				await RoomAPI.deleteRoom(token, roomId)
				setRooms(rooms.filter((room) => room.id !== roomId));
				setFilteredProducts(filteredProducts.filter((room) => room.id !== roomId));
			} catch (e) {
				console.error("Error deleting room:", e);
			}
		}
	}

	return (
		<motion.div
			className='p-6 mb-8 bg-gray-800 bg-opacity-50 border border-gray-700 shadow-lg backdrop-blur-md rounded-xl'
			initial={{ opacity: 0, y: 20 }}
			animate={{ opacity: 1, y: 0 }}
			transition={{ delay: 0.2 }}
		>
			<div className='flex items-center justify-between mb-6'>
				<h2 className='text-xl font-semibold text-gray-100'>Room List</h2>
				<button onClick={handleAddRoom} className='flex items-center text-green-500 hover:text-green-400'>
					<Plus size={18} className='mr-2' />
					Add Room
				</button>
				<div className='relative'>
					<input
						type='text'
						placeholder='Search rooms...'
						className='py-2 pl-10 pr-4 text-white placeholder-gray-400 bg-gray-700 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500'
						onChange={handleSearch}
						value={searchTerm}
					/>
					<Search className='absolute left-3 top-2.5 text-gray-400' size={18} />
				</div>
			</div>

			<div className='overflow-x-auto max-h-96'>
				<table className='min-w-full divide-y divide-gray-700'>
					<thead>
						<tr>
							<th className='px-6 py-3 text-xs font-medium tracking-wider text-left text-gray-400 uppercase'>
								Room Number
							</th>
							<th className='px-6 py-3 text-xs font-medium tracking-wider text-left text-gray-400 uppercase'>
								Room Type
							</th>
							<th className='px-6 py-3 text-xs font-medium tracking-wider text-left text-gray-400 uppercase'>
								Price
							</th>
							<th className='px-6 py-3 text-xs font-medium tracking-wider text-left text-gray-400 uppercase'>
								Status
							</th>
							<th className='px-6 py-3 text-xs font-medium tracking-wider text-left text-gray-400 uppercase'>
								Sales
							</th>
							<th className='px-6 py-3 text-xs font-medium tracking-wider text-left text-gray-400 uppercase'>
								Actions
							</th>
						</tr>
					</thead>
					<tbody className='divide-y divide-gray-700'>
						{filteredProducts.map((room) => (
							<motion.tr
								key={room.id}
								initial={{ opacity: 0 }}
								animate={{ opacity: 1 }}
								transition={{ duration: 0.3 }}
							>
								<td className='flex items-center gap-2 px-6 py-4 text-sm font-medium text-gray-100 whitespace-nowrap'>
									<img
										src='https://images.unsplash.com/photo-1627989580309-bfaf3e58af6f?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8d2lyZWxlc3MlMjBlYXJidWRzfGVufDB8fDB8fHww'
										alt='Room img'
										className='rounded-full size-10'
									/>
									{room.room_number}
								</td>

								<td className='px-6 py-4 text-sm text-gray-300 whitespace-nowrap'>
									{roomTypes[room.room_type]?.type || "Unknown"}
								</td>

								<td className='px-6 py-4 text-sm text-gray-300 whitespace-nowrap'>
									${roomTypes[room.room_type]?.price || "N/A"}
								</td>
								<td className='px-6 py-4 whitespace-nowrap'>
									<span
										className={`px-2 inline-flex text-xs leading-5 font-semibold rounded-full ${room.is_available
											? "bg-green-800 text-green-100"
											: "bg-red-800 text-red-100"
											}`}
									>
										{room.is_available ? "Available" : "Not Available"}
									</span>
								</td>
								<td className='px-6 py-4 text-sm text-gray-300 whitespace-nowrap'>{room.sales || "N/A"}</td>
								<td className='px-6 py-4 text-sm text-gray-300 whitespace-nowrap'>
									<button onClick={()=>handleEditRoom(room)} className='mr-2 text-indigo-400 hover:text-indigo-300'>
										<Edit size={18} />
									</button>
									<button onClick={() => handleDeleteRoom(room.id)} className='text-red-400 hover:text-red-300'>
										<Trash2 size={18} />
									</button>
								</td>
							</motion.tr>
						))}
					</tbody>
				</table>
			</div>

			{/* Modal */}
			{isModalOpen && (
				<div className='fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-70'>
					<div className='w-full max-w-md p-8 bg-gray-800 rounded-lg shadow-lg'>
						<div className='flex items-center justify-between mb-4'>
							<h3 className='text-2xl font-semibold text-white'>
								{isEditMode ? "Update Room" : "Add New Room"}
							</h3>
							<button onClick={handleCloseModal} className='text-gray-400 hover:text-white'>
								<X size={24} />
							</button>
						</div>
						<form onSubmit={handleSubmit}>
							<div className='mb-6'>
								<label className='block mb-2 text-sm font-medium text-gray-300'>Room Number</label>
								<input
									type='text'
									name='room_number'
									value={newRoom.room_number}
									onChange={handleInputChange}
									className='w-full px-4 py-3 text-white bg-gray-700 border border-gray-600 rounded-md focus:outline-none focus:ring-2 focus:ring-green-500'
									required
								/>
							</div>
							<div className='mb-6'>
								<label className='block mb-2 text-sm font-medium text-gray-300'>Room Type</label>
								<select
									name='room_type'
									value={newRoom.room_type}
									onChange={handleInputChange}
									className='w-full px-4 py-3 text-white bg-gray-700 border border-gray-600 rounded-md focus:outline-none focus:ring-2 focus:ring-green-500'
									required
								>
									<option value='' disabled>Select Room Type</option>
									{roomTypes && Object.keys(roomTypes).map((key) => (
										<option key={key} value={key}>
											{roomTypes[key].type}
										</option>
									))}
								</select>
							</div>
							<div className='mb-6'>
								<label className='block mb-2 text-sm font-medium text-gray-300'>Status</label>
								<select
									name='is_available'
									value={newRoom.is_available === true ? 'true' : 'false'} 
									onChange={(e) => handleInputChange({ target: { name: 'is_available', value: e.target.value === 'true' } })} // Chuyển đổi string thành boolean
									className='w-full px-4 py-3 text-white bg-gray-700 border border-gray-600 rounded-md focus:outline-none focus:ring-2 focus:ring-green-500'
									required
								>
									<option value='' disabled>Select Status</option>
									<option value='true'>Available</option>
									<option value='false'>Not Available</option>
								</select>
							</div>


							<button type='submit' className='w-full px-4 py-3 text-white transition-colors bg-green-600 rounded-md hover:bg-green-500'>
								{isEditMode ? "Update Room" : "Add Room"}
							</button>
						</form>
					</div>
				</div>
			)}

		</motion.div>
	);
};

export default ProductsTable;

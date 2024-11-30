import { motion } from "framer-motion";
import { Edit, Search, Trash2, Plus } from "lucide-react";
import { useState, useEffect } from "react";
import RoomTypeAPI from "../../api/roomtype";

import { toast } from "react-toastify";

const RoomTypesTable = () => {
	const [searchTerm, setSearchTerm] = useState("");
	const [rooms, setRooms] = useState([]);
	const [filteredRooms, setFilteredRooms] = useState([]);
	const [isModalOpen, setModalOpen] = useState(false);
	const [isEditing, setIsEditing] = useState(false);
	const [editingRoomId, setEditingRoomId] = useState(null);

	const [roomData, setRoomData] = useState({
		type: "",
		price: "",
		beds: "",
		people: "",
	});

	const [loading, setLoading] = useState(true);
	const [error, setError] = useState(null);
	const token = localStorage.getItem('access');

	useEffect(() => {
		const fetchRoomTypes = async () => {
			setLoading(true);
			setError(null);
			const roomTypeAPI = new RoomTypeAPI();

			try {
				const data = await roomTypeAPI.getRoomTypes(token);
				setRooms(data);
				setFilteredRooms(data);
			} catch (e) {
				setError('Failed to fetch room types');
			} finally {
				setLoading(false);
			}
		};
		fetchRoomTypes();
	}, [token]);

	const handleSearch = (e) => {
		const term = e.target.value.toLowerCase();
		setSearchTerm(term);
		if (!term) {
			setFilteredRooms(rooms);
		} else {
			const filtered = rooms.filter((room) =>
				room.type.toLowerCase().includes(term)
			);
			setFilteredRooms(filtered);
		}
	};

	// Mở modal cho Add Room
	const handleAddRoomType = () => {
		setModalOpen(true);
		setIsEditing(false);
		setRoomData({ type: "", price: "", beds: "", people: "" });
	};

	// Mở modal cho Edit Room
	const handleEditRoomType = (roomtype) => {
		setModalOpen(true);
		setIsEditing(true);
		setEditingRoomId(roomtype.id);
		setRoomData({
			type: roomtype.type,
			price: roomtype.price,
			beds: roomtype.number_of_beds,
			people: roomtype.room_capacity,
		});
	};

	const handleInputChange = (e) => {
		const { name, value } = e.target;
		setRoomData((prev) => ({ ...prev, [name]: value }));
	};

	const handleSubmit = async (e) => {
		e.preventDefault();

		if (!roomData.type || !roomData.price || !roomData.beds || !roomData.people) {
			toast.error("Please fill out all fields");
			return;
		}

		const newRoomData = {
			type: roomData.type,
			price: parseFloat(roomData.price),
			number_of_beds: parseInt(roomData.beds, 10),
			room_capacity: parseInt(roomData.people, 10),
		};

		const roomTypeAPI = new RoomTypeAPI();

		if (isEditing) {
			// Update Room Type
			try {
				const updatedRoom = await roomTypeAPI.updateRoomType(token, editingRoomId, newRoomData);
				setFilteredRooms((prev) =>
					prev.map((room) =>
						room.id === editingRoomId ? updatedRoom : room
					)
				);
				setModalOpen(false);
				setRoomData({ type: "", price: "", beds: "", people: "" });
				setEditingRoomId(null);
			} catch (error) {
				console.error("Failed to update room type:", error);
				toast.error('Failed to update room type');
			}
		} else {
			// Create New Room Type
			try {
				const createdRoomType = await roomTypeAPI.createRoomType(token, newRoomData);
				setFilteredRooms((prev) => [...prev, createdRoomType]);
				setModalOpen(false);
				setRoomData({ type: "", price: "", beds: "", people: "" });
				toast.success('Room type added successfully');
			} catch (error) {
				console.error('Failed to create room type:', error);
				toast.error('Failed to create room type');
			}
		}
	};

	const handleDeleteRoomType = async (roomTypeId) => {
		const roomTypeAPI = new RoomTypeAPI();
		if (window.confirm("Are you sure you want to delete this room type?")) {
			try {
				await roomTypeAPI.deleteRoomType(token, roomTypeId);
				setFilteredRooms((prev) => prev.filter((room) => room.id !== roomTypeId));
				toast.success('Room type and associated rooms deleted successfully');
			} catch (e) {
				console.error('Failed to delete room type:', e);
				toast.error('Failed to delete room type');
			}
		}
	}

	if (loading) return <div>Loading...</div>;
	if (error) return <div>{error}</div>;

	return (
		<>
			<motion.div
				className='p-6 mb-8 bg-gray-800 bg-opacity-50 border border-gray-700 shadow-lg backdrop-blur-md rounded-xl'
				initial={{ opacity: 0, y: 20 }}
				animate={{ opacity: 1, y: 0 }}
				transition={{ delay: 0.2 }}
			>
				<div className='flex items-center justify-between mb-6'>
					<h2 className='text-xl font-semibold text-gray-100'>Room Types</h2>
					{/* <button
						onClick={handleAddRoomType}
						className='flex items-center text-green-500 hover:text-green-400'
					>
						<Plus size={18} className='mr-2' />
						Add Room Type
					</button> */}
					<div className='relative'>
						<input
							type='text'
							placeholder='Search room types...'
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
									Type
								</th>
								<th className='px-6 py-3 text-xs font-medium tracking-wider text-left text-gray-400 uppercase'>
									Price
								</th>
								<th className='px-6 py-3 text-xs font-medium tracking-wider text-left text-gray-400 uppercase'>
									Beds
								</th>
								<th className='px-6 py-3 text-xs font-medium tracking-wider text-left text-gray-400 uppercase'>
									People
								</th>
								<th className='px-6 py-3 text-xs font-medium tracking-wider text-left text-gray-400 uppercase'>
									Quantity
								</th>
								<th className='px-6 py-3 text-xs font-medium tracking-wider text-left text-gray-400 uppercase'>
									Actions
								</th>
							</tr>
						</thead>

						<tbody className='divide-y divide-gray-700'>
							{filteredRooms.map((room) => (
								<motion.tr
									key={room.id}
									initial={{ opacity: 0 }}
									animate={{ opacity: 1 }}
									transition={{ duration: 0.3 }}
								>
									<td className='px-6 py-4 text-sm font-medium text-gray-100 whitespace-nowrap'>
										{room.type}
									</td>
									<td className='px-6 py-4 text-sm text-gray-300 whitespace-nowrap'>
										${room.price}
									</td>
									<td className='px-6 py-4 text-sm text-gray-300 whitespace-nowrap'>
										{room.number_of_beds}
									</td>
									<td className='px-6 py-4 text-sm text-gray-300 whitespace-nowrap'>
										{room.room_capacity}
									</td>
									<td className='px-6 py-4 text-sm text-gray-300 whitespace-nowrap'>
										{room.quantity}
									</td>
									<td className='px-6 py-4 text-sm text-gray-300 whitespace-nowrap'>
										<button
											className='mr-2 text-indigo-400 hover:text-indigo-300'
											onClick={() => handleEditRoomType(room)}
										>
											<Edit size={18} />
										</button>
										<button
											className='text-red-500 hover:text-red-400'
											onClick={() => handleDeleteRoomType(room.id)}
										>
											<Trash2 size={18} />
										</button>
									</td>
								</motion.tr>
							))}
						</tbody>
					</table>
				</div>
			</motion.div>

			{/* Modal Add/Edit Room */}
			{isModalOpen && (
				<div className='fixed inset-0 flex items-center justify-center bg-black bg-opacity-50'>
					<div className='w-2/3 p-6 bg-gray-800 rounded-lg'>
						<h2 className='mb-4 text-xl text-gray-100'>
							{isEditing ? 'Update Room Type' : 'Add Room Type'}
						</h2>
						<form onSubmit={handleSubmit}>
							<div className='flex mb-4 space-x-4'>
								<div className='flex-1'>
									<label className='block text-gray-300'>Room Type</label>
									<input
										type='text'
										name='type'
										value={roomData.type}
										onChange={handleInputChange}
										className='w-full px-3 py-2 text-white bg-gray-700 rounded-md'
									/>
								</div>
								<div className='flex-1'>
									<label className='block text-gray-300'>Price</label>
									<input
										type='number'
										name='price'
										value={roomData.price}
										onChange={handleInputChange}
										className='w-full px-3 py-2 text-white bg-gray-700 rounded-md'
									/>
								</div>
								<div className='flex-1'>
									<label className='block text-gray-300'>Number of Beds</label>
									<input
										type='number'
										name='beds'
										value={roomData.beds}
										onChange={handleInputChange}
										className='w-full px-3 py-2 text-white bg-gray-700 rounded-md'
									/>
								</div>
								<div className='flex-1'>
									<label className='block text-gray-300'>Room Capacity</label>
									<input
										type='number'
										name='people'
										value={roomData.people}
										onChange={handleInputChange}
										className='w-full px-3 py-2 text-white bg-gray-700 rounded-md'
									/>
								</div>
							</div>
							<div className='flex justify-end'>
								<button
									type='button'
									className='px-4 py-2 mr-2 text-white bg-gray-600 rounded-md'
									onClick={() => setModalOpen(false)}
								>
									Cancel
								</button>
								<button
									type='submit'
									className={`px-4 py-2 rounded-md text-white ${isEditing ? 'bg-indigo-600' : 'bg-green-600'}`}
								>
									{isEditing ? 'Update Room Type' : 'Add Room Type'}
								</button>
							</div>
						</form>
					</div>
				</div>

			)}
		</>
	);
};

export default RoomTypesTable;

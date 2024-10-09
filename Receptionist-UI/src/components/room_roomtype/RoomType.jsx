import { motion } from "framer-motion";
import { Edit, Search, Trash2, Plus, X } from "lucide-react";
import { useState } from "react";

const ROOMTYPE_DATA = [
	{ id: 1, type: "Deluxe", price: 100, beds: 2, people: 4, quantity: 10 },
	{ id: 2, type: "Standard", price: 75, beds: 1, people: 2, quantity: 5 },
	{ id: 3, type: "Suite", price: 150, beds: 2, people: 4, quantity: 2 },
	{ id: 4, type: "Economy", price: 50, beds: 1, people: 2, quantity: 15 },
	{ id: 5, type: "Family", price: 120, beds: 3, people: 6, quantity: 8 },
];

const RoomTypesTable = () => {
	const [searchTerm, setSearchTerm] = useState("");
	const [filteredRooms, setFilteredRooms] = useState(ROOMTYPE_DATA);
	const [isModalOpen, setModalOpen] = useState(false);
	const [newRoom, setNewRoom] = useState({
		type: "",
		price: "",
		beds: "",
		people: "",
		quantity: "",
	});

	const handleSearch = (e) => {
		const term = e.target.value.toLowerCase();
		setSearchTerm(term);
		const filtered = ROOMTYPE_DATA.filter((room) =>
			room.type.toLowerCase().includes(term)
		);

		setFilteredRooms(filtered);
	};

	const handleAddRoomType = () => {
		setModalOpen(true);
	};

	const handleInputChange = (e) => {
		const { name, value } = e.target;
		setNewRoom((prev) => ({ ...prev, [name]: value }));
	};

	const handleSubmit = (e) => {
		e.preventDefault();
		const newRoomData = {
			id: ROOMTYPE_DATA.length + 1,
			type: newRoom.type,
			price: parseFloat(newRoom.price),
			beds: parseInt(newRoom.beds, 10),
			people: parseInt(newRoom.people, 10),
			quantity: parseInt(newRoom.quantity, 10),
		};
		setFilteredRooms((prev) => [...prev, newRoomData]);
		setModalOpen(false);
		setNewRoom({ type: "", price: "", beds: "", people: "", quantity: "" });
	};

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
					<button
						onClick={handleAddRoomType}
						className='flex items-center text-green-500 hover:text-green-400'
					>
						<Plus size={18} className='mr-2' />
						Add Room Type
					</button>
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

				<div className='overflow-x-auto'>
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
										${room.price.toFixed(2)}
									</td>
									<td className='px-6 py-4 text-sm text-gray-300 whitespace-nowrap'>
										{room.beds}
									</td>
									<td className='px-6 py-4 text-sm text-gray-300 whitespace-nowrap'>
										{room.people}
									</td>
									<td className='px-6 py-4 text-sm text-gray-300 whitespace-nowrap'>
										{room.quantity}
									</td>
									<td className='px-6 py-4 text-sm text-gray-300 whitespace-nowrap'>
										<button className='mr-2 text-indigo-400 hover:text-indigo-300'>
											<Edit size={18} />
										</button>
										<button className='text-red-400 hover:text-red-300'>
											<Trash2 size={18} />
										</button>
									</td>
								</motion.tr>
							))}
						</tbody>
					</table>
				</div>
			</motion.div>

			{/* Modal Add Room Type */}
			{isModalOpen && (
				<div className='fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-70'>
					<div className='w-full max-w-md p-8 bg-gray-800 rounded-lg shadow-lg'>
						<div className='flex items-center justify-between mb-4'>
							<h3 className='text-2xl font-semibold text-white'>Add New Room Type</h3>
							<button onClick={() => setModalOpen(false)} className='text-gray-400 hover:text-white'>
								<X size={24} />
							</button>
						</div>
						<form onSubmit={handleSubmit}>
							<div className='mb-6'>
								<label className='block mb-2 text-sm font-medium text-gray-300'>Room Type</label>
								<input
									type='text'
									name='type'
									value={newRoom.type}
									onChange={handleInputChange}
									className='w-full px-4 py-3 text-white bg-gray-700 border border-gray-600 rounded-md focus:outline-none focus:ring-2 focus:ring-green-500'
									required
								/>
							</div>
							<div className='mb-6'>
								<label className='block mb-2 text-sm font-medium text-gray-300'>Price</label>
								<input
									type='number'
									name='price'
									value={newRoom.price}
									onChange={handleInputChange}
									className='w-full px-4 py-3 text-white bg-gray-700 border border-gray-600 rounded-md focus:outline-none focus:ring-2 focus:ring-green-500'
									required
								/>
							</div>
							<div className='mb-6'>
								<label className='block mb-2 text-sm font-medium text-gray-300'>Beds</label>
								<input
									type='number'
									name='beds'
									value={newRoom.beds}
									onChange={handleInputChange}
									className='w-full px-4 py-3 text-white bg-gray-700 border border-gray-600 rounded-md focus:outline-none focus:ring-2 focus:ring-green-500'
									required
								/>
							</div>
							<div className='mb-6'>
								<label className='block mb-2 text-sm font-medium text-gray-300'>Max People</label>
								<input
									type='number'
									name='people'
									value={newRoom.people}
									onChange={handleInputChange}
									className='w-full px-4 py-3 text-white bg-gray-700 border border-gray-600 rounded-md focus:outline-none focus:ring-2 focus:ring-green-500'
									required
								/>
							</div>
							<button
								type='submit'
								className='w-full py-3 text-white bg-green-600 rounded-md hover:bg-green-500 focus:outline-none focus:ring-2 focus:ring-green-600'
							>
								Add Room Type
							</button>
						</form>
					</div>
				</div>

			)}
		</>
	);
};

export default RoomTypesTable;

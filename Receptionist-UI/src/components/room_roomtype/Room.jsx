import { motion } from "framer-motion";
import { Edit, Search, Trash2, Plus, X } from "lucide-react";
import { useState } from "react";

const PRODUCT_DATA = [
	{ id: 1, roomnumber: "101", roomtype: "Deluxe", price: 59.99, status: "Available", sales: 1200 },
	{ id: 2, roomnumber: "102", roomtype: "Standard", price: 39.99, status: "Occupied", sales: 800 },
	{ id: 3, roomnumber: "103", roomtype: "Suite", price: 199.99, status: "Available", sales: 650 },
	{ id: 4, roomnumber: "104", roomtype: "Economy", price: 29.99, status: "Available", sales: 950 },
	{ id: 5, roomnumber: "105", roomtype: "Family", price: 79.99, status: "Occupied", sales: 720 },
];

const ProductsTable = () => {
	const [searchTerm, setSearchTerm] = useState("");
	const [filteredProducts, setFilteredProducts] = useState(PRODUCT_DATA);
	const [isModalOpen, setIsModalOpen] = useState(false);
	const roomTypes = ["Normal", "Luxury", "Resident", "Suite"];
	const [newRoom, setNewRoom] = useState({
		roomnumber: "",
		roomtype: "",
		price: "",
		status: "Available",
	});

	const handleSearch = (e) => {
		const term = e.target.value.toLowerCase();
		setSearchTerm(term);
		const filtered = PRODUCT_DATA.filter(
			(product) =>
				product.roomnumber.includes(term) || product.roomtype.toLowerCase().includes(term)
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
		setNewRoom({ ...newRoom, [name]: value });
	};

	const handleSubmit = (e) => {
		e.preventDefault();
		console.log("New Room Data:", newRoom);
		// Xử lý lưu thông tin phòng mới ở đây
		setIsModalOpen(false);
	};

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

			<div className='overflow-x-auto'>
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
						{filteredProducts.map((product) => (
							<motion.tr
								key={product.id}
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
									{product.roomnumber}
								</td>

								<td className='px-6 py-4 text-sm text-gray-300 whitespace-nowrap'>
									{product.roomtype}
								</td>

								<td className='px-6 py-4 text-sm text-gray-300 whitespace-nowrap'>
									${product.price.toFixed(2)}
								</td>
								<td className='px-6 py-4 whitespace-nowrap'>
									<span
										className={`px-2 inline-flex text-xs leading-5 font-semibold rounded-full ${product.status === "Available"
											? "bg-green-800 text-green-100"
											: "bg-red-800 text-red-100"
											}`}
									>
										{product.status}
									</span>
								</td>
								<td className='px-6 py-4 text-sm text-gray-300 whitespace-nowrap'>{product.sales}</td>
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

			{/* Modal */}
			{isModalOpen && (
				<div className='fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-70'>
					<div className='w-full max-w-md p-8 bg-gray-800 rounded-lg shadow-lg'>
						<div className='flex items-center justify-between mb-4'>
							<h3 className='text-2xl font-semibold text-white'>Add New Room</h3>
							<button onClick={handleCloseModal} className='text-gray-400 hover:text-white'>
								<X size={24} />
							</button>
						</div>
						<form onSubmit={handleSubmit}>
							<div className='mb-6'>
								<label className='block mb-2 text-sm font-medium text-gray-300'>Room Number</label>
								<input
									type='text'
									name='roomnumber'
									value={newRoom.roomnumber}
									onChange={handleInputChange}
									className='w-full px-4 py-3 text-white bg-gray-700 border border-gray-600 rounded-md focus:outline-none focus:ring-2 focus:ring-green-500'
									required
								/>
							</div>
							<div className='mb-6'>
								<label className='block mb-2 text-sm font-medium text-gray-300'>Room Type</label>
								<select
									name='roomtype'
									value={newRoom.roomtype}
									onChange={handleInputChange}
									className='w-full px-4 py-3 text-white bg-gray-700 border border-gray-600 rounded-md focus:outline-none focus:ring-2 focus:ring-green-500'
									required
								>
									<option value='' disabled>Select Room Type</option>
									{roomTypes.map((type) => (
										<option key={type} value={type}>
											{type}
										</option>
									))}
								</select>
							</div>
							<div className='mb-6'>
								<label className='block mb-2 text-sm font-medium text-gray-300'>Status</label>
								<select
									name='status'
									value={newRoom.status}
									onChange={handleInputChange}
									className='w-full px-4 py-3 text-white bg-gray-700 border border-gray-600 rounded-md focus:outline-none focus:ring-2 focus:ring-green-500'
									required
								>
									<option value='Available'>Available</option>
									<option value='Occupied'>Occupied</option>
								</select>
							</div>
							<button type='submit' className='w-full px-4 py-3 text-white transition-colors bg-green-600 rounded-md hover:bg-green-500'>
								Add Room
							</button>
						</form>
					</div>
				</div>
			)}
		</motion.div>
	);
};

export default ProductsTable;

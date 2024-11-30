import { useState, useMemo, useEffect } from "react";
import { motion } from "framer-motion";
import { Search } from "lucide-react";
import CustomerAPI from "../../api/customer"



const UsersTable = () => {
	const [searchTerm, setSearchTerm] = useState("");
	const [customers, setCustomers] = useState([])
	const token = localStorage.getItem('access');
	useEffect(() => {
		const fetchCustomers = async () => {
			try {
				const data = await CustomerAPI.getCustomers(token)
				setCustomers(data)
			} catch (e) {
				console.error(e)
				// handle error here
			}
		}
		fetchCustomers()
	}, [token])

	const handleSearch = (e) => {
		const term = e.target.value.toLowerCase();
		setSearchTerm(term);
	};

	const filteredUsers = useMemo(() => {
		return customers.filter((user) => {
			const username = user.username ? user.username.toLowerCase() : "";
			const email = user.email ? user.email.toLowerCase() : "";
			const fullName = user.full_name ? user.full_name.toLowerCase() : "";
			const phone = user.phone ? user.phone : "";

			return (
				username.includes(searchTerm) ||
				email.includes(searchTerm) ||
				fullName.includes(searchTerm) ||
				phone.includes(searchTerm)
			);
		});
	}, [searchTerm, customers]);



	return (
		<motion.div
			className='p-6 bg-gray-800 bg-opacity-50 border border-gray-700 shadow-lg backdrop-blur-md rounded-xl'
			initial={{ opacity: 0, y: 20 }}
			animate={{ opacity: 1, y: 0 }}
			transition={{ delay: 0.2 }}
		>
			<div className='flex items-center justify-between mb-6'>
				<h2 className='text-xl font-semibold text-gray-100'>Customers</h2>
				<div className='relative'>
					<input
						type='text'
						placeholder='Search customers...'
						className='py-2 pl-10 pr-4 text-white placeholder-gray-400 bg-gray-700 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500'
						value={searchTerm}
						onChange={handleSearch}
					/>
					<Search className='absolute left-3 top-2.5 text-gray-400' size={18} />
				</div>
			</div>

			<div className='overflow-x-auto'>
				<table className='min-w-full divide-y divide-gray-700'>
					<thead>
						<tr>
							<th className='px-6 py-3 text-xs font-medium tracking-wider text-left text-gray-400 uppercase'>Username</th>
							<th className='px-6 py-3 text-xs font-medium tracking-wider text-left text-gray-400 uppercase'>Email</th>
							<th className='px-6 py-3 text-xs font-medium tracking-wider text-left text-gray-400 uppercase'>Role</th>
							<th className='px-6 py-3 text-xs font-medium tracking-wider text-left text-gray-400 uppercase'>Full Name</th>
							<th className='px-6 py-3 text-xs font-medium tracking-wider text-left text-gray-400 uppercase'>Phone</th>
						</tr>
					</thead>

					<tbody className='divide-y divide-gray-700'>
						{filteredUsers.length > 0 ? (
							filteredUsers.map((user) => (
								<motion.tr
									key={user.id}
									initial={{ opacity: 0 }}
									animate={{ opacity: 1 }}
									transition={{ duration: 0.3 }}
								>
									<td className='px-6 py-4 whitespace-nowrap'>
										<div className='flex items-center'>
											<div className='flex-shrink-0 w-10 h-10'>
												<div className='flex items-center justify-center w-10 h-10 font-semibold text-white rounded-full bg-gradient-to-r from-purple-400 to-blue-500'>
													{user.username.charAt(0)}
												</div>
											</div>
											<div className='ml-4'>
												<div className='text-sm font-medium text-gray-100'>{user.username}</div>
											</div>
										</div>
									</td>
									<td className='px-6 py-4 whitespace-nowrap'>
										<div className='text-sm text-gray-300'>{user.email}</div>
									</td>
									<td className='px-6 py-4 whitespace-nowrap'>
										<span className='inline-flex px-2 text-xs font-semibold leading-5 text-blue-100 bg-blue-800 rounded-full'>
											Customer
										</span>
									</td>
									<td className='px-6 py-4 whitespace-nowrap'>
										<div className='text-sm text-gray-300'>{user.full_name}</div>
									</td>
									<td className='px-6 py-4 whitespace-nowrap'>
										<div className='text-sm text-gray-300'>{user.phone}</div>
									</td>
								</motion.tr>
							))
						) : (
							<tr>
								<td colSpan={5} className='px-6 py-4 text-center text-gray-500'>
									No customers found.
								</td>
							</tr>
						)}
					</tbody>
				</table>
			</div>
		</motion.div>
	);
};

export default UsersTable;

import { useState, useEffect } from "react";
import { motion } from "framer-motion";
import { Search, Eye, Plus } from "lucide-react";
import { format } from 'date-fns';
import DatePicker from 'react-datepicker';
import BookingForm from './BookingForm'
import 'react-datepicker/dist/react-datepicker.css';
import './styles.css';

import BookingAPI from "../../api/booking";
import CustomerAPI from "../../api/customer"

const OrdersTable = () => {
	const [searchTerm, setSearchTerm] = useState("");
	const [filteredOrders, setFilteredOrders] = useState([]);
	const [orders, setOrders] = useState([]);
    const [users, setUsers] = useState({});
	const [loading, setLoading] = useState(true);
    const [showForm, setShowForm] = useState(false);
	
	useEffect(() => {
        const fetchBookings = async () => {
            const token = localStorage.getItem("access");
            try {
                const data = await BookingAPI.ListBooking(token);
                setOrders(data);
                setFilteredOrders(data);
        
                const userDetails = {};
                const userRequests = data.map((order) =>
                    CustomerAPI.CustomerDetali(order.user, token).then((user) => {
                        if (user) {
                            userDetails[order.user] = user;
                        }
                    })
                );
                await Promise.all(userRequests);
                setUsers(userDetails);
            } catch (error) {
                console.error("Failed to fetch bookings:", error);
            } finally {
                setLoading(false);
            }
        };
        
        fetchBookings();
    }, []);

	const handleSearch = (e) => {
        const term = e.target.value.toLowerCase();
        setSearchTerm(term);
        const filtered = orders.filter((order) => {
            const user = users[order.user];
            const username = user?.username?.toLowerCase() || "";
            const fullName = user?.full_name?.toLowerCase() || "";
            return (
                order.id.toLowerCase().includes(term) ||
                username.includes(term) ||
                fullName.includes(term)
            );
        });
        setFilteredOrders(filtered);
    };
    

	return (
        <motion.div
            className='p-6 bg-gray-800 bg-opacity-50 border border-gray-700 shadow-lg backdrop-blur-md rounded-xl'
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.4 }}
        >
            <div className='flex items-center justify-between mb-6'>
                <h2 className='text-xl font-semibold text-gray-100'>Booking List</h2>

                <button
                    className='flex items-center text-green-500 hover:text-green-400'
                    onClick={()=>setShowForm(true)}
                >
                    <Plus size={18} className='mr-2' />
                    Add Booking
                </button>

                <div className='relative'>
                    <input
                        type='text'
                        placeholder='Search orders...'
                        className='py-2 pl-10 pr-4 text-white placeholder-gray-400 bg-gray-700 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500'
                        value={searchTerm}
                        onChange={handleSearch}
                    />
                    <Search className='absolute left-3 top-2.5 text-gray-400' size={18} />
                </div>
            </div>

            {showForm && (
            <BookingForm/>
            )}  

            {/* Loading spinner */}
            {loading ? (
                <div className="text-center text-gray-400">Loading...</div>
            ) : (
                <div className='overflow-x-auto rounded-lg'>
                    <table className='min-w-full divide-y divide-gray-700'>
                        <thead>
                            <tr>
                                <th className='px-6 py-3 text-xs font-medium tracking-wider text-left text-gray-400 uppercase'>Order ID</th>
                                <th className='px-6 py-3 text-xs font-medium tracking-wider text-left text-gray-400 uppercase'>Customer</th>
                                <th className='px-6 py-3 text-xs font-medium tracking-wider text-left text-gray-400 uppercase'>Total</th>
                                <th className='px-6 py-3 text-xs font-medium tracking-wider text-left text-gray-400 uppercase'>Status</th>
                                <th className='px-6 py-3 text-xs font-medium tracking-wider text-left text-gray-400 uppercase'>Date</th>
                                <th className='px-6 py-3 text-xs font-medium tracking-wider text-left text-gray-400 uppercase'></th>
                            </tr>
                        </thead>
                        <tbody className='bg-gray-800 divide-y divide-gray-700'>
                            {filteredOrders.map((order) => (
                                <tr key={order.id}>
                                    <td className='px-6 py-4 text-sm text-gray-300'>{order.id}</td>
                                    <td className='px-6 py-4 text-sm text-gray-300'>
                                        {users[order.user] ? users[order.user].username || users[order.user].full_name : "Loading..."}
                                    </td>
                                    <td className='px-6 py-4 text-sm text-gray-300'>${order.total}</td>
                                    <td className='px-6 py-4 text-sm text-gray-300'>{order.payment_status}</td>
                                    <td className='px-6 py-4 text-sm text-gray-300'>{format(new Date(order.date), 'MM/dd/yyyy')}</td>
                                    <td className='px-6 py-4 text-sm text-gray-300'>
                                        <button className='text-blue-500 hover:text-blue-400'>
                                            <Eye size={18} />
                                        </button>
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>
            )}
        </motion.div>
    );
};

export default OrdersTable;
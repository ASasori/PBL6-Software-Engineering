import { UserCheck, UserPlus, UsersIcon, UserX } from "lucide-react";
import { motion } from "framer-motion";

import Header from "../components/common/Header";
import StatCard from "../components/common/StatCard";
import UsersTable from "../components/users/UsersTable";
import UserGrowthChart from "../components/users/UserGrowthChart";
import UserActivityHeatmap from "../components/users/UserActivityHeatmap";
import UserDemographicsChart from "../components/users/UserDemographicsChart";

import CustomerAPI from '../api/customer'
import { useEffect, useState } from "react";

const userStats = {
	totalUsers: 152845,
	newUsersToday: 243,
	activeUsers: 98520,
	churnRate: "2.4%",
};


const UsersPage = () => {

	const [totalCus, setTotalCus] = useState(0)
	const [totalCusToday, setTotalCusToday] = useState(0)
	const token = localStorage.getItem('access')
	
	useEffect(() => {
		const fetchCustomers = async () => {
			if (token) {
				try {
					const customers = await CustomerAPI.getCustomers(token);
					setTotalCus(customers.length);
				} catch (error) {
					console.error("Error fetching customers:", error);
				}
			}
		};

		const fetchCustomersToday = async () => {
			if (token) {
				try {
					const customers = await CustomerAPI.getCustomersToday(token);
					setTotalCusToday(customers.length);
				} catch (error) {
					console.error("Error fetching customers today:", error);
				}
			}
		}
		
		fetchCustomers();
		fetchCustomersToday();
	}, [token]);

	return (
		<div className='relative z-10 flex-1 overflow-auto'>
			<Header title='Users' />

			<main className='px-4 py-6 mx-auto max-w-7xl lg:px-8'>
				{/* STATS */}
				<motion.div
					className='grid grid-cols-1 gap-5 mb-8 sm:grid-cols-2 lg:grid-cols-4'
					initial={{ opacity: 0, y: 20 }}
					animate={{ opacity: 1, y: 0 }}
					transition={{ duration: 1 }}
				>
					<StatCard
						name='Total Users'
						icon={UsersIcon}
						value={totalCus}
						color='#6366F1'
					/>
					<StatCard name='New Users Today' icon={UserPlus} value={totalCusToday} color='#10B981' />
					<StatCard
						name='Active Users'
						icon={UserCheck}
						value={userStats.activeUsers.toLocaleString()}
						color='#F59E0B'
					/>
					<StatCard name='Churn Rate' icon={UserX} value={userStats.churnRate} color='#EF4444' />
				</motion.div>

				<UsersTable />

				{/* USER CHARTS */}
				{/* <div className='grid grid-cols-1 gap-6 mt-8 lg:grid-cols-2'>
					<UserGrowthChart />
					<UserActivityHeatmap />
					<UserDemographicsChart />
				</div> */}
			</main>
		</div>
	);
};
export default UsersPage;

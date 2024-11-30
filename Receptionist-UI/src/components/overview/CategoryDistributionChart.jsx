import React, { useEffect, useState } from 'react';
import { motion } from "framer-motion";
import { PieChart, Pie, Cell, Tooltip, ResponsiveContainer, Legend } from "recharts";
import RoomAPI from "../../api/room"

const COLORS = ["#8B5CF6", "#EC4899", "#10B981", "#F59E0B"];

const CategoryDistributionChart = () => {

	const [roomData, setRoomData] = useState([]);

	useEffect(() => {
		const fetchRooms = async () => {
			try {
				const token = localStorage.getItem('access'); 
				const rooms = await RoomAPI.getRoom(token); 

				const availableRooms = rooms.filter(room => room.is_available).length;
				const notAvailableRooms = rooms.filter(room => !room.is_available).length;

				setRoomData([
					{ name: 'Phòng trống', value: availableRooms },
					{ name: 'Phòng đã đặt', value: notAvailableRooms }
				]);
			} catch (error) {
				console.error('Error fetching room data:', error);
			}
		};

		fetchRooms();
	}, []);

	return (
		<motion.div
			className='p-6 bg-gray-800 bg-opacity-50 border border-gray-700 shadow-lg backdrop-blur-md rounded-xl'
			initial={{ opacity: 0, y: 20 }}
			animate={{ opacity: 1, y: 0 }}
			transition={{ delay: 0.3 }}
		>
			<h2 className='mb-4 text-lg font-medium text-gray-100'>Tình trạng phòng</h2>
			<div className='h-80'>
				<ResponsiveContainer width={'100%'} height={'100%'}>
					<PieChart>
						<Pie
							data={roomData}
							cx={'50%'}
							cy={'50%'}
							labelLine={false}
							outerRadius={80}
							fill='#8884d8'
							dataKey='value'
							label={({ name, percent }) => `${name} ${(percent * 100).toFixed(0)}%`}
						>
							{roomData.map((entry, index) => (
								<Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
							))}
						</Pie>
						<Tooltip
							contentStyle={{
								backgroundColor: 'rgba(31, 41, 55, 0.8)',
								borderColor: '#4B5563'
							}}
							itemStyle={{ color: '#E5E7EB' }}
						/>
						<Legend />
					</PieChart>
				</ResponsiveContainer>
			</div>
		</motion.div>
	);
};
export default CategoryDistributionChart;

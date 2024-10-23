import { motion } from "framer-motion";
import { useEffect, useState } from "react";
import Header from "../components/common/Header";
import StatCard from "../components/common/StatCard";

import { AlertTriangle, DollarSign, Package, TrendingUp } from "lucide-react";
import CategoryDistributionChart from "../components/overview/CategoryDistributionChart";
import SalesTrendChart from "../components/room_roomtype/SalesTrendChart";
import ProductsTable from "../components/room_roomtype/Room";
import RoomTypesTable from "../components/room_roomtype/RoomType";

import RoomAPI from "../api/room"
import RoomTypeAPI from "../api/roomtype";


const ProductsPage = () => {

	const [totalRooms, setTotalRooms] = useState(0)
	const [totalRoomTypes, setTotalRoomTypes] = useState(0)
	const token = localStorage.getItem('authToken')

	useEffect(() =>{
		const fetchData = async () => {
			try{
				const rooms = await RoomAPI.getRoom(token)
				setTotalRooms(rooms.length)

				const roomTypeAPI = new RoomTypeAPI()
				const roomtypes = await roomTypeAPI.getRoomTypes(token)
				setTotalRoomTypes(roomtypes.length)
			}catch(e){
				console.error("Error fetching data: ", e)
			}
		}
		fetchData()
	}, [token])
	
	return (
		<div className='relative z-10 flex-1 overflow-auto'>
			<Header title='Products' />

			<main className='px-4 py-6 mx-auto max-w-7xl lg:px-8'>
				{/* STATS */}
				<motion.div
					className='grid grid-cols-1 gap-5 mb-8 sm:grid-cols-2 lg:grid-cols-4'
					initial={{ opacity: 0, y: 20 }}
					animate={{ opacity: 1, y: 0 }}
					transition={{ duration: 1 }}
				>
					<StatCard name='Total Rooms' icon={Package} value={totalRooms} color='#6366F1' />
					<StatCard name='Total RoomTypes' icon={TrendingUp} value={totalRoomTypes} color='#10B981' />
					{/* <StatCard name='Top Orders' icon={AlertTriangle} value={23} color='#F59E0B' /> */}
					{/* <StatCard name='Total Revenue' icon={DollarSign} value={"$543,210"} color='#EF4444' /> */}
				</motion.div>

				<ProductsTable />
				<RoomTypesTable/>

				{/* CHARTS */}
				<div className='grid gap-8 grid-col-1 lg:grid-cols-2'>
					{/* <SalesTrendChart /> */}
					<CategoryDistributionChart />
				</div>
			</main>
		</div>
	);
};
export default ProductsPage;

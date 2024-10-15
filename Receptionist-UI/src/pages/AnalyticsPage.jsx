import Header from "../components/common/Header";

import OverviewCards from "../components/analytics/OverviewCards";
import RevenueChart from "../components/analytics/RevenueChart";
import ChannelPerformance from "../components/analytics/ChannelPerformance";
import ProductPerformance from "../components/analytics/ProductPerformance";
import UserRetention from "../components/analytics/UserRetention";
import CustomerSegmentation from "../components/analytics/CustomerSegmentation";
import AIPoweredInsights from "../components/analytics/AIPoweredInsights";

const AnalyticsPage = () => {
	return (
		<div className='relative z-10 flex-1 overflow-auto bg-gray-900'>
			<Header title={"Analytics Dashboard"} />

			<main className='px-4 py-6 mx-auto max-w-7xl lg:px-8'>
				<OverviewCards />
				<RevenueChart />

				<div className='grid grid-cols-1 gap-8 mb-8 lg:grid-cols-2'>
					<ChannelPerformance />
					<ProductPerformance />
					<UserRetention />
					<CustomerSegmentation />
				</div>
				<AIPoweredInsights />
			</main>
		</div>
	);
};
export default AnalyticsPage;

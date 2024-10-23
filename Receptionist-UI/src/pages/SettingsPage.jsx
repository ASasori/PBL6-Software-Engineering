import Header from "../components/common/Header";
import ConnectedAccounts from "../components/settings/ConnectedAccounts";
import DangerZone from "../components/settings/DangerZone";
import Notifications from "../components/settings/Notifications";
import Profile from "../components/settings/Profile";
import Security from "../components/settings/Security";

const SettingsPage = ({ handleLogout }) => { // Nhận handleLogout từ props
	return (
		<div className='relative z-10 flex-1 overflow-auto bg-gray-900'>
			<Header title='Settings' />
			<main className='max-w-4xl px-4 py-6 mx-auto lg:px-8'>
				<Profile />
				<Notifications />
				<Security />
				<ConnectedAccounts />
				<DangerZone handleLogout={handleLogout} /> {/* Truyền handleLogout vào DangerZone */}
			</main>
		</div>
	);
};

export default SettingsPage;

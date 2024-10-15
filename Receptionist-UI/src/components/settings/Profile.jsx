import { User } from "lucide-react";
import SettingSection from "./SettingSection";
import { useState } from "react";

const Profile = () => {

	const [isEditing, setIsEditing] = useState(false)

	const handleEditClick = () => {
		setIsEditing(true)
	}

	return (
		<SettingSection icon={User} title={"Profile"}>
			<div className='flex flex-col items-center mb-6 sm:flex-row'>
				<img
					src='https://randomuser.me/api/portraits/men/3.jpg'
					alt='Profile'
					className='object-cover w-20 h-20 mr-4 rounded-full'
				/>

				<div>
					<h3 className='text-lg font-semibold text-gray-100'>John Doe</h3>
					<p className='text-gray-400'>john.doe@example.com</p>
				</div>
			</div>

			<button onClick={handleEditClick} className='w-full px-4 py-2 font-bold text-white transition duration-200 bg-indigo-600 rounded hover:bg-indigo-700 sm:w-auto'>
				Edit Profile
			</button>

			{isEditing && (
				<div className="max-w-4xl px-4 py-10 mx-auto sm:px-6 lg:px-8">
					{/* Card */}
					<div className="p-4 bg-white shadow rounded-xl sm:p-7 dark:bg-neutral-800">
						<div className="mb-8">
							<h2 className="text-xl font-bold text-gray-800 dark:text-neutral-200">Thông tin cá nhân</h2>
							<p className="text-sm text-gray-600 dark:text-neutral-400">Quản lý tên, mật khẩu và cài đặt tài khoản của bạn.</p>
						</div>

						<form>
							{/* Grid */}
							<div className="grid gap-2 sm:grid-cols-12 sm:gap-6">
								{/* Ảnh đại diện */}
								<div className="sm:col-span-3">
									<label className="inline-block text-sm text-gray-800 mt-2.5 dark:text-neutral-200">Ảnh đại diện</label>
								</div>
								<div className="sm:col-span-9">
									<div className="flex items-center gap-5">
										<img className="inline-block rounded-full size-16 ring-2 ring-white dark:ring-neutral-900" src="https://preline.co/assets/img/160x160/img1.jpg" alt="Avatar" />
										<button type="button" className="inline-flex items-center px-3 py-2 text-sm font-medium text-gray-800 bg-white border border-gray-200 rounded-lg shadow-sm gap-x-2 hover:bg-gray-50 disabled:opacity-50 disabled:pointer-events-none focus:outline-none focus:bg-gray-50 dark:bg-transparent dark:border-neutral-700 dark:text-neutral-300 dark:hover:bg-neutral-800 dark:focus:bg-neutral-800">
											<svg className="shrink-0 size-4" xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
												<path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
												<polyline points="17 8 12 3 7 8" />
												<line x1="12" x2="12" y1="3" y2="15" />
											</svg>
											Tải lên ảnh
										</button>
									</div>
								</div>

								{/* Tên đầy đủ */}
								<div className="sm:col-span-3">
									<label htmlFor="full-name" className="inline-block text-sm text-gray-800 mt-2.5 dark:text-neutral-200">Tên đầy đủ</label>
								</div>
								<div className="sm:col-span-9">
									<input id="full-name" type="text" className="block w-full px-3 py-2 text-sm border-gray-200 rounded-lg shadow-sm pe-11 focus:border-blue-500 focus:ring-blue-500 disabled:opacity-50 disabled:pointer-events-none dark:bg-neutral-800 dark:border-neutral-700 dark:text-neutral-400 dark:placeholder-neutral-500 dark:focus:ring-neutral-600" placeholder="Maria Boone" required />
								</div>

								{/* Email */}
								<div className="sm:col-span-3">
									<label htmlFor="account-email" className="inline-block text-sm text-gray-800 mt-2.5 dark:text-neutral-200">Email</label>
								</div>
								<div className="sm:col-span-9">
									<input id="account-email" type="email" className="block w-full px-3 py-2 text-sm border-gray-200 rounded-lg shadow-sm pe-11 focus:border-blue-500 focus:ring-blue-500 disabled:opacity-50 disabled:pointer-events-none dark:bg-neutral-800 dark:border-neutral-700 dark:text-neutral-400 dark:placeholder-neutral-500 dark:focus:ring-neutral-600" placeholder="maria@site.com" required />
								</div>

								<div className="sm:col-span-3">
									<label htmlFor="current-password" className="inline-block text-sm text-gray-800 mt-2.5 dark:text-neutral-200">Mật khẩu</label>
								</div>
								<div className="sm:col-span-9">
									<input id="current-password" type="password" className="block w-full px-3 py-2 text-sm border-gray-200 rounded-lg shadow-sm pe-11 focus:border-blue-500 focus:ring-blue-500 disabled:opacity-50 disabled:pointer-events-none dark:bg-neutral-800 dark:border-neutral-700 dark:text-neutral-400 dark:placeholder-neutral-500 dark:focus:ring-neutral-600" placeholder="Nhập mật khẩu hiện tại" required />
									<input id="new-password" type="password" className="block w-full px-3 py-2 text-sm border-gray-200 rounded-lg shadow-sm pe-11 focus:border-blue-500 focus:ring-blue-500 disabled:opacity-50 disabled:pointer-events-none dark:bg-neutral-800 dark:border-neutral-700 dark:text-neutral-400 dark:placeholder-neutral-500 dark:focus:ring-neutral-600" placeholder="Nhập mật khẩu mới" required />
								</div>

								<div className="sm:col-span-3">
									<label htmlFor="account-phone" className="inline-block text-sm text-gray-800 mt-2.5 dark:text-neutral-200">Điện thoại</label>
									<span className="text-sm text-gray-400 dark:text-neutral-600">(Tùy chọn)</span>
								</div>
								<div className="sm:col-span-9">
									<input id="account-phone" type="text" className="block w-full px-3 py-2 text-sm border-gray-200 rounded-lg shadow-sm pe-11 focus:border-blue-500 focus:ring-blue-500 disabled:opacity-50 disabled:pointer-events-none dark:bg-neutral-800 dark:border-neutral-700 dark:text-neutral-400 dark:placeholder-neutral-500 dark:focus:ring-neutral-600" placeholder="+x(xxx)xxx-xx-xx" />
									<select className="block w-full px-3 py-2 text-sm border-gray-200 rounded-lg shadow-sm pe-9 sm:w-auto focus:border-blue-500 focus:ring-blue-500 disabled:opacity-50 disabled:pointer-events-none dark:bg-neutral-800 dark:border-neutral-700 dark:text-neutral-400 dark:placeholder-neutral-500 dark:focus:ring-neutral-600">
										<option selected>Di động</option>
										<option>Nhà</option>
										<option>Công việc</option>
										<option>Fax</option>
									</select>
								</div>

								<div className="sm:col-span-3">
									<label className="inline-block text-sm text-gray-800 mt-2.5 dark:text-neutral-200">Giới tính</label>
								</div>
								<div className="sm:col-span-9">
									<div className="sm:flex">
										<label className="relative flex w-full px-3 py-2 text-sm border border-gray-200 rounded-lg shadow-sm focus:z-10 focus:border-blue-500 focus:ring-blue-500 disabled:opacity-50 disabled:pointer-events-none dark:bg-neutral-800 dark:border-neutral-700 dark:text-neutral-400 dark:placeholder-neutral-500 dark:focus:ring-neutral-600">
											<input type="radio" name="gender" className="shrink-0 mt-0.5 border-gray-300 rounded-full text-blue-600 focus:ring-blue-500 disabled:opacity-50 disabled:pointer-events-none dark:bg-neutral-800 dark:border-neutral-500 dark:checked:bg-blue-500 dark:checked:border-blue-500 dark:focus:ring-offset-gray-800" value="male" />
											<span className="text-sm text-gray-500 ms-3 dark:text-neutral-400">Nam</span>
										</label>
										<label className="relative flex w-full px-3 py-2 text-sm border border-gray-200 rounded-lg shadow-sm focus:z-10 focus:border-blue-500 focus:ring-blue-500 disabled:opacity-50 disabled:pointer-events-none dark:bg-neutral-800 dark:border-neutral-700 dark:text-neutral-400 dark:placeholder-neutral-500 dark:focus:ring-neutral-600">
											<input type="radio" name="gender" className="shrink-0 mt-0.5 border-gray-300 rounded-full text-blue-600 focus:ring-blue-500 disabled:opacity-50 disabled:pointer-events-none dark:bg-neutral-800 dark:border-neutral-500 dark:checked:bg-blue-500 dark:checked:border-blue-500 dark:focus:ring-offset-gray-800" value="female" />
											<span className="text-sm text-gray-500 ms-3 dark:text-neutral-400">Nữ</span>
										</label>
									</div>
								</div>
							</div>

							{/* Nút Gửi */}
							<div className="mt-4">
								<button
									type="submit"
									className="inline-flex items-center justify-center px-4 py-2 text-sm font-medium text-white bg-blue-600 border border-transparent rounded-md shadow-sm hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 dark:bg-blue-500 dark:hover:bg-blue-400 dark:focus:ring-blue-400"
								>
									Lưu thay đổi
								</button>
								<button
									type="button" // Thay đổi từ "submit" thành "button"
									onClick={() => setIsEditing(false)} // Đóng phần chỉnh sửa khi nhấn nút
									className="inline-flex items-center justify-center px-4 py-2 ml-2 text-sm font-medium text-white bg-red-600 border border-transparent rounded-md shadow-sm hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 dark:bg-red-500 dark:hover:bg-red-400 dark:focus:ring-red-400" // Thêm class "ml-2" để tạo khoảng cách
								>
									Huỷ
								</button>
							</div>
						</form>
					</div>
				</div>
			)}
		</SettingSection>
	);
};
export default Profile;

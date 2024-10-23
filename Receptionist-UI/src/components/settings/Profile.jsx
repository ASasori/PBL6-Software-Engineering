import { User } from "lucide-react";
import SettingSection from "./SettingSection";
import { useState, useRef } from "react";

import updateProfile from "../../api/profile";

const Profile = () => {

    const [isEditing, setIsEditing] = useState(false)

    const [fullName, setFullName] = useState("")
    const [phone, setPhone] = useState("");
    const [gender, setGender] = useState("");
    const [country, setCountry] = useState("");
    const [city, setCity] = useState("");
    const [state, setState] = useState("");
    const [address, setAddress] = useState("");
    const [identityType, setIdentityType] = useState("");
    const [facebook, setFacebook] = useState("");
    const [twitter, setTwitter] = useState("");

    const [avatar, setAvatar] = useState(null);
    const [identityImage, setIdentityImage] = useState(null);
    const [identityImageName, setIdentityImageName] = useState('');

    const avatarInputRef = useRef(null);
    const identityInputRef = useRef(null);

    const token = localStorage.getItem('authToken');

    const [errorMessage, setErrorMessage] = useState('');
    const [successMessage, setSuccessMessage] = useState('');

    const handleAvatarChange = (e) => {
        const file = e.target.files[0]
        if (file) {
            const reader = new FileReader()
            reader.onloadend = () => {
                setAvatar(reader.result)
            }
            reader.readAsDataURL(file)
        }
    }

    const handleIdentityImageChange = (e) => {
        const file = e.target.files[0];
        if (file) {
            setIdentityImageName(file.name);
            const reader = new FileReader();
            reader.onloadend = () => {
                setIdentityImage(reader.result);
            };
            reader.readAsDataURL(file);
        }
    };

    const handleAvatarUploadClick = () => {
        avatarInputRef.current.click();
    };

    const handleIdentityImageUploadClick = () => {
        identityInputRef.current.click();
    };

    const handleSubmit = async (e) => {
        e.preventDefault()
        const formData = new FormData();
        formData.append('full_name', fullName);
        formData.append('phone', phone);
        formData.append('gender', gender);
        formData.append('country', country);
        formData.append('city', city);
        formData.append('state', state);
        formData.append('address', address);
        formData.append('facebook', facebook);
        formData.append('twitter', twitter);
        if (avatar) {
            formData.append('image', avatar);
        }
        if (identityImage) {
            formData.append('indentity_type', identityImage);
        }

        try {
            const response = await updateProfile(formData, token)
            setSuccessMessage('Profile updated successfully!');
            setErrorMessage('');
            console.log(response);
        } catch (err) {
            setErrorMessage('Failed to update profile.');
            setSuccessMessage('');
            console.error('Error details:', err.response.data);
        }
        setIsEditing(false);
    }

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
                    <h3 className='text-lg font-semibold text-gray-100'>{fullName}</h3>
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
                            <h2 className="text-xl font-bold text-gray-800 dark:text-neutral-200">Personal Information</h2>
                            <p className="text-sm text-gray-600 dark:text-neutral-400">Manage your personal information.</p>
                        </div>

                        <form onSubmit={handleSubmit}>
                            {/* Grid */}
                            <div className="grid gap-2 sm:grid-cols-12 sm:gap-6">

                                <div className="sm:col-span-3">
                                    <label className="inline-block text-sm text-gray-800 mt-2.5 dark:text-neutral-200">Avatar</label>
                                </div>
                                {/* Ảnh */}
                                <div className="sm:col-span-9">
                                    <div className="flex items-center gap-5">
                                        <img className="inline-block rounded-full size-16 ring-2 ring-white dark:ring-neutral-900" src={avatar || 'https://preline.co/assets/img/160x160/img1.jpg'} alt="Avatar" />
                                        <button onClick={handleAvatarUploadClick} type="button" className="inline-flex items-center px-3 py-2 text-sm font-medium text-gray-800 bg-white border border-gray-200 rounded-lg shadow-sm gap-x-2 hover:bg-gray-50 disabled:opacity-50 disabled:pointer-events-none focus:outline-none focus:bg-gray-50 dark:bg-transparent dark:border-neutral-700 dark:text-neutral-300 dark:hover:bg-neutral-800 dark:focus:bg-neutral-800">
                                            <svg className="shrink-0 size-4" xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                                                <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
                                                <polyline points="17 8 12 3 7 8" />
                                                <line x1="12" x2="12" y1="3" y2="15" />
                                            </svg>
                                            Upload Image
                                        </button>
                                        <input
                                            type="file"
                                            ref={avatarInputRef}
                                            style={{ display: 'none' }}
                                            accept="image/*"
                                            onChange={handleAvatarChange}
                                        />
                                    </div>
                                </div>

                                {/* Tên đầy đủ */}
                                <div className="sm:col-span-3">
                                    <label htmlFor="full-name" className="inline-block text-sm text-gray-800 mt-2.5 dark:text-neutral-200">Full Name</label>
                                </div>
                                <div className="sm:col-span-9">
                                    <input
                                        id="full-name"
                                        type="text"
                                        value={fullName}
                                        onChange={(e) => setFullName(e.target.value)}
                                        className="block w-full px-3 py-2 text-sm text-black border-gray-200 rounded-lg shadow-sm pe-11 focus:border-blue-500 focus:ring-blue-500 disabled:opacity-50 disabled:pointer-events-none dark:bg-neutral-800 dark:border-neutral-700 dark:text-neutral-400 dark:placeholder-neutral-500 dark:focus:ring-n"
                                        placeholder="Enter your Full Name"
                                    />
                                </div>

                                {/* Phone */}
                                <div className="sm:col-span-3">
                                    <label htmlFor="account-phone" className="inline-block text-sm text-gray-800 mt-2.5 dark:text-neutral-200">Phone</label>
                                </div>
                                <div className="sm:col-span-9">
                                    <input
                                        id="account-phone"
                                        type="tel"
                                        value={phone}
                                        onChange={(e) => setPhone(e.target.value)}
                                        className="block w-full px-3 py-2 text-sm text-black border-gray-200 rounded-lg shadow-sm pe-11 focus:border-blue-500 focus:ring-blue-500 disabled:opacity-50 disabled:pointer-events-none dark:bg-neutral-800 dark:border-neutral-700 dark:text-neutral-400 dark:placeholder-neutral-500 dark:focus:ring-neutral-600"
                                        placeholder="Enter your phone number"
                                    />
                                </div>
                                {/* Gender */}
                                <div className="sm:col-span-3">
                                    <label className="inline-block text-sm text-gray-800 mt-2.5 dark:text-neutral-200">Gender</label>
                                </div>
                                <div className="sm:col-span-9">
                                    <div className="sm:flex">
                                        <label className="relative flex w-full px-3 py-2 text-sm border border-gray-200 rounded-lg shadow-sm focus:z-10 focus:border-blue-500 focus:ring-blue-500 disabled:opacity-50 disabled:pointer-events-none dark:bg-neutral-800 dark:border-neutral-700 dark:text-neutral-400 dark:placeholder-neutral-500 dark:focus:ring-neutral-600">
                                            <input
                                                type="radio"
                                                name="gender"
                                                checked={gender === "Male"}
                                                onChange={() => setGender("Male")}
                                                className="shrink-0 mt-0.5 border-gray-300 rounded-full text-blue-600 focus:ring-blue-500 disabled:opacity-50 disabled:pointer-events-none dark:bg-neutral-800 dark:border-neutral-500 dark:checked:bg-blue-500 dark:checked:border-blue-500 dark:focus:ring-offset-gray-800"
                                            />
                                            <span className="text-sm text-gray-500 ms-3 dark:text-neutral-400">Male</span>
                                        </label>
                                        <label className="relative flex w-full px-3 py-2 text-sm border border-gray-200 rounded-lg shadow-sm focus:z-10 focus:border-blue-500 focus:ring-blue-500 disabled:opacity-50 disabled:pointer-events-none dark:bg-neutral-800 dark:border-neutral-700 dark:text-neutral-400 dark:placeholder-neutral-500 dark:focus:ring-neutral-600">
                                            <input
                                                type="radio"
                                                name="gender"
                                                checked={gender === "Female"}
                                                onChange={() => setGender("Female")}
                                                className="shrink-0 mt-0.5 border-gray-300 rounded-full text-blue-600 focus:ring-blue-500 disabled:opacity-50 disabled:pointer-events-none dark:bg-neutral-800 dark:border-neutral-500 dark:checked:bg-blue-500 dark:checked:border-blue-500 dark:focus:ring-offset-gray-800"
                                            />
                                            <span className="text-sm text-gray-500 ms-3 dark:text-neutral-400">Female</span>
                                        </label>
                                        <label className="relative flex w-full px-3 py-2 text-sm border border-gray-200 rounded-lg shadow-sm focus:z-10 focus:border-blue-500 focus:ring-blue-500 disabled:opacity-50 disabled:pointer-events-none dark:bg-neutral-800 dark:border-neutral-700 dark:text-neutral-400 dark:placeholder-neutral-500 dark:focus:ring-neutral-600">
                                            <input
                                                type="radio"
                                                name="gender"
                                                checked={gender === "Other"}
                                                onChange={() => setGender("Other")}
                                                className="shrink-0 mt-0.5 border-gray-300 rounded-full text-blue-600 focus:ring-blue-500 disabled:opacity-50 disabled:pointer-events-none dark:bg-neutral-800 dark:border-neutral-500 dark:checked:bg-blue-500 dark:checked:border-blue-500 dark:focus:ring-offset-gray-800"
                                            />
                                            <span className="text-sm text-gray-500 ms-3 dark:text-neutral-400">Other</span>
                                        </label>
                                    </div>
                                </div>
                                {/* Quốc gia */}
                                <div className="sm:col-span-3">
                                    <label htmlFor="country" className="inline-block text-sm text-gray-800 mt-2.5 dark:text-neutral-200">Country</label>
                                </div>
                                <div className="sm:col-span-9">
                                    <input
                                        id="country"
                                        type="text"
                                        value={country}
                                        onChange={(e) => setCountry(e.target.value)}
                                        className="block w-full px-3 py-2 text-sm text-black border-gray-200 rounded-lg shadow-sm pe-11 focus:border-blue-500 focus:ring-blue-500 disabled:opacity-50 disabled:pointer-events-none dark:bg-neutral-800 dark:border-neutral-700 dark:text-neutral-400 dark:placeholder-neutral-500 dark:focus:ring-neutral-600"
                                        placeholder="Enter your country"
                                    />
                                </div>

                                {/* Thành phố */}
                                <div className="sm:col-span-3">
                                    <label htmlFor="city" className="inline-block text-sm text-gray-800 mt-2.5 dark:text-neutral-200">City</label>
                                </div>
                                <div className="sm:col-span-9">
                                    <input
                                        id="city"
                                        type="text"
                                        value={city}
                                        onChange={(e) => setCity(e.target.value)}
                                        className="block w-full px-3 py-2 text-sm text-black border-gray-200 rounded-lg shadow-sm pe-11 focus:border-blue-500 focus:ring-blue-500 disabled:opacity-50 disabled:pointer-events-none dark:bg-neutral-800 dark:border-neutral-700 dark:text-neutral-400 dark:placeholder-neutral-500 dark:focus:ring-neutral-600"
                                        placeholder="Enter your city"
                                    />
                                </div>

                                {/* Bang/Tỉnh */}
                                <div className="sm:col-span-3">
                                    <label htmlFor="state" className="inline-block text-sm text-gray-800 mt-2.5 dark:text-neutral-200">State</label>
                                </div>
                                <div className="sm:col-span-9">
                                    <input
                                        id="state"
                                        type="text"
                                        value={state}
                                        onChange={(e) => setState(e.target.value)}
                                        className="block w-full px-3 py-2 text-sm text-black border-gray-200 rounded-lg shadow-sm pe-11 focus:border-blue-500 focus:ring-blue-500 disabled:opacity-50 disabled:pointer-events-none dark:bg-neutral-800 dark:border-neutral-700 dark:text-neutral-400 dark:placeholder-neutral-500 dark:focus:ring-neutral-600"
                                        placeholder="Enter your state"
                                    />
                                </div>

                                {/* Địa chỉ */}
                                <div className="sm:col-span-3">
                                    <label htmlFor="address" className="inline-block text-sm text-gray-800 mt-2.5 dark:text-neutral-200">Address</label>
                                </div>
                                <div className="sm:col-span-9">
                                    <input
                                        id="address"
                                        type="text"
                                        value={address}
                                        onChange={(e) => setAddress(e.target.value)}
                                        className="block w-full px-3 py-2 text-sm text-black border-gray-200 rounded-lg shadow-sm pe-11 focus:border-blue-500 focus:ring-blue-500 disabled:opacity-50 disabled:pointer-events-none dark:bg-neutral-800 dark:border-neutral-700 dark:text-neutral-400 dark:placeholder-neutral-500 dark:focus:ring-neutral-600"
                                        placeholder="Enter your address"
                                    />
                                </div>

                                {/* Identity Type */}
                                <div className="sm:col-span-3">
                                    <label htmlFor="identity-type" className="inline-block text-sm text-gray-800 mt-2.5 dark:text-neutral-200">Identity Type</label>
                                </div>
                                <div className="sm:col-span-9">
                                    <select
                                        id="identity-type"
                                        value={identityType}
                                        onChange={(e) => setIdentityType(e.target.value)}
                                        className="block w-full px-3 py-2 text-sm text-black border-gray-200 rounded-lg shadow-sm focus:border-blue-500 focus:ring-blue-500 disabled:opacity-50 disabled:pointer-events-none dark:bg-neutral-800 dark:border-neutral-700 dark:text-neutral-400 dark:placeholder-neutral-500 dark:focus:ring-neutral-600"

                                    >
                                        <option value="nid">Nation Identification Number</option>
                                        <option value="dl">Driver's License</option>
                                        <option value="ip">International Passport</option>
                                    </select>
                                </div>
                                {/* Indentity Image */}
                                <div className="sm:col-span-3">
                                    <label htmlFor="identity-type" className="inline-block text-sm text-gray-800 mt-2.5 dark:text-neutral-200">Identity Image</label>
                                </div>
                                <div className="sm:col-span-9">
                                    <div className="flex items-center gap-5">
                                        <button onClick={handleIdentityImageUploadClick} type="button" className="inline-flex items-center px-3 py-2 text-sm font-medium text-gray-800 bg-white border border-gray-200 rounded-lg shadow-sm gap-x-2 hover:bg-gray-50 disabled:opacity-50 disabled:pointer-events-none focus:outline-none focus:bg-gray-50 dark:bg-transparent dark:border-neutral-700 dark:text-neutral-300 dark:hover:bg-neutral-800 dark:focus:bg-neutral-800">
                                            <svg className="shrink-0 size-4" xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                                                <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
                                                <polyline points="17 8 12 3 7 8" />
                                                <line x1="12" x2="12" y1="3" y2="15" />
                                            </svg>
                                            Upload Image
                                        </button>
                                        <input
                                            type="file"
                                            ref={identityInputRef}
                                            style={{ display: 'none' }}
                                            accept="image/*"
                                            onChange={handleIdentityImageChange}
                                        />
                                    </div>
                                    {identityImageName && (
                                        <p className="mt-2 text-sm text-gray-600">Selected file: {identityImageName}</p> // Hiển thị tên file ảnh
                                    )}
                                </div>
                                {/* Facebook */}
                                <div className="sm:col-span-3">
                                    <label htmlFor="facebook" className="inline-block text-sm text-gray-800 mt-2.5 dark:text-neutral-200">Facebook</label>
                                </div>
                                <div className="sm:col-span-9">
                                    <input
                                        id="facebook"
                                        type="text"
                                        value={facebook}
                                        onChange={(e) => setFacebook(e.target.value)}
                                        className="block w-full px-3 py-2 text-sm text-black border-gray-200 rounded-lg shadow-sm pe-11 focus:border-blue-500 focus:ring-blue-500 disabled:opacity-50 disabled:pointer-events-none dark:bg-neutral-800 dark:border-neutral-700 dark:text-neutral-400 dark:placeholder-neutral-500 dark:focus:ring-neutral-600"
                                        placeholder="Facebook Profile Link"
                                    />
                                </div>

                                {/* Twitter */}
                                <div className="sm:col-span-3">
                                    <label htmlFor="twitter" className="inline-block text-sm text-gray-800 mt-2.5 dark:text-neutral-200">Twitter</label>
                                </div>
                                <div className="sm:col-span-9">
                                    <input
                                        id="twitter"
                                        type="text"
                                        value={twitter}
                                        onChange={(e) => setTwitter(e.target.value)}
                                        className="block w-full px-3 py-2 text-sm text-black border-gray-200 rounded-lg shadow-sm pe-11 focus:border-blue-500 focus:ring-blue-500 disabled:opacity-50 disabled:pointer-events-none dark:bg-neutral-800 dark:border-neutral-700 dark:text-neutral-400 dark:placeholder-neutral-500 dark:focus:ring-neutral-600"
                                        placeholder="Twitter Profile Link"
                                    />
                                </div>
                            </div>
                            {/* Nút Gửi */}
                            <div className="mt-4">
                                <button
                                    type="submit"
                                    className="inline-flex items-center justify-center px-4 py-2 text-sm font-medium text-white bg-blue-600 border border-transparent rounded-md shadow-sm hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 dark:bg-blue-500 dark:hover:bg-blue-400 dark:focus:ring-blue-400"
                                >
                                    Save
                                </button>
                                <button
                                    type="button"
                                    onClick={() => setIsEditing(false)}
                                    className="inline-flex items-center justify-center px-4 py-2 ml-2 text-sm font-medium text-white bg-red-600 border border-transparent rounded-md shadow-sm hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 dark:bg-red-500 dark:hover:bg-red-400 dark:focus:ring-red-400" // Thêm class "ml-2" để tạo khoảng cách
                                >
                                    Cancel
                                </button>
                            </div>

                            {errorMessage && <p style={{ color: 'red' }}>{errorMessage}</p>}
                            {successMessage && <p style={{ color: 'green' }}>{successMessage}</p>}
                        </form>
                    </div>
                </div>
            )}
        </SettingSection>
    );
};
export default Profile;

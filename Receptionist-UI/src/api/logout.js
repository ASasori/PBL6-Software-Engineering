import axios from 'axios';
import BASE_URL from './config';

const logout = async (token) => {
    try {
        // Gọi API logout
        const response = await axios.post(
            `${BASE_URL}/user/api/userauths/logout/`, 
            {},
            {
                headers: {
                    'Authorization': `Bearer ${token}`
                }
            }
        );

        localStorage.removeItem('access');
        console.log('Logout successful:', response.data);
        return response.data;
    } catch (e) {
        console.error('Error during logout:', e);
        throw e;
    }
}

export default logout;

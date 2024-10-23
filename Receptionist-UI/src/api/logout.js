import axios from 'axios';

const logout = async (token) => {
    try {
        // Gọi API logout
        const response = await axios.post(
            'http://127.0.0.1:8000/user/api/userauths/logout/', 
            {},
            {
                headers: {
                    'Authorization': `Token ${token}`
                }
            }
        );

        localStorage.removeItem('authToken');
        console.log('Logout successful:', response.data);
        return response.data;
    } catch (e) {
        console.error('Error during logout:', e);
        throw e;
    }
}

export default logout;

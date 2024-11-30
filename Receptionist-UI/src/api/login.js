import axios from 'axios';
import BASE_URL from './config';
const login = async (email, password) => {
    try {
        const response = await axios.post(
            `${BASE_URL}/user/api/userauths/login/`,
            {
                email: email,
                password: password,
            },
        );

        const { access, refresh } = response.data;
        console.log(">>>check access: " + access)
        // Lưu trữ access và refresh token trong localStorage
        localStorage.setItem('access',access)

        localStorage.setItem('refresh', refresh);
        console.log(">>>checkkkkk access: " + localStorage.getItem('access'))

        // Kiểm tra quyền hạn người dùng (nếu cần thiết)
        const userRole = response.data.role;
        if (userRole === 'Receptionist') {
            console.log('Access Token:', access);
            return response.data;
        } else {
            alert('Cút ra ngoài');
            return null;
        }
    } catch (e) {
        console.log('Error during login:', e);
        throw e;
    }
}


export default login;

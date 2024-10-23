import axios from 'axios'
import Csrf from './csrf'


const updateProfile = async (profileData, token) => {
    try{
        if(!token){
            throw new Error('Token is not authenticated')
        }
        const csrfToken = Csrf.getToken()

        const response = await axios.patch(
            'http://127.0.0.1:8000/receptionist/api/profile/update/',
            profileData,
            {
                headers: {
                    'Authorization': `Token ${token}`,
                    'X-CSRFToken': csrfToken 
                }
            }
        );

        console.log('Profile updated successfully:', response.data);
        return response.data;
    }catch (e) {
        console.log('Error during profile update:', e);
        throw e;
    }
}

export default updateProfile
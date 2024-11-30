import axios from 'axios'
import BASE_URL from './config';

const updateProfile = async (profileData, token) => {
    try{
        if(!token){
            throw new Error('Token is not authenticated')
        }

        const response = await axios.patch(
            `${BASE_URL}/receptionist/api/profile/update`,
            profileData,
            {
                headers: {
                    'Authorization': `Bearer ${token}`,
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
import axios from 'axios'
import Csrf from './csrf'

const login = async(email, password)=>{
    try{
        const csrfToken = Csrf.getToken()

        const response = await axios.post(
            'http://127.0.0.1:8000/user/api/userauths/login/', 
            {
                email: email, 
                password: password
            }, 
            {
                headers: {
                    'X-CSRFToken': csrfToken
                }
            }
        )

        const userRole = response.data.role

        if(userRole === 'Receptionist'){
            localStorage.setItem('authToken', response.data.token)
            console.log('Token:', response.data.token)
            return response.data
        }else{
            alert('Cút ra ngoài');
            return null;
        }
    }catch (e) {
        console.log('Error during login:', e)
        throw e
    }
}

export default login
import axios from 'axios'
import Csrf from './csrf';

const getCustomers = async(token)=>{
    try{
        const response = await axios.get(
            'http://127.0.0.1:8000/receptionist/api/customers/list/',
            {headers: {
                'Authorization': `Token ${token}`
            }}
        )
        return response.data;
    }catch(e){
        console.error('Error fetching customers:', e.message);
        throw e;
    }
}

export default getCustomers;
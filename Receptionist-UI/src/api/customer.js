import axios from 'axios'
import BASE_URL from './config';
class CustomerAPI{
    constructor(){
        this.baseURL = `${BASE_URL}/receptionist/api/customers/`;
    }

    async getCustomers(token){
        try{
            const response = await axios.get(`${this.baseURL}list/`,{
                headers: {
                    'Authorization': `Bearer ${token}`,
                },
            })
            return response.data;
        }catch(e){
            console.error('Error fetching customers:', e);
            throw e;
        }
    }

    async getCustomersToday(token){
        try{
            const response = await axios.get(`${this.baseURL}today/`,{
                headers: {
                    'Authorization': `Bearer ${token}`,
                },
            })
            return response.data;
        }catch(e){
            console.error('Error fetching customers today:', e);
            throw e;
        }
    }
    async CustomerDetali(customer_id, token){
        try{
            const response = await axios.get(`${this.baseURL}${customer_id}/`,{
                headers: {
                    'Authorization': `Bearer ${token}`,
                },
            })
            return response.data;
        }catch(e){
            console.error('Error fetching customer details:', e);
            throw e;
        }
    }
}

export default new CustomerAPI
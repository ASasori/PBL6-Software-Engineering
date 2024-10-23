import axios from 'axios'
import Csrf from './csrf';

class RoomAPI{
    constructor(){
        this.baseURL = 'http://127.0.0.1:8000/receptionist/api/rooms/';
    }

    async getRoom(token){
        try{
            const response = await axios.get(this.baseURL, {
                headers: {
                    'Authorization': `Token ${token}`
                }
            });
            return response.data;
        }catch(e){
            console.error('Error fetching rooms:', e);
            throw e;  
        }
    }

    
    async deleteRoom(token, roomId) {
        try{
            const response = await axios.delete(`${this.baseURL}${roomId}/delete/`, {
                headers: {
                    'Authorization': `Token ${token}`,
                    'X-CSRFToken': Csrf.getToken()
                }
            })
            return response.data
        }catch(e){
            console.error('Error deleting room: ', e);
            throw e;
        }
    }

    async createRoom(token, roomData){
        try{
            const response = await axios.post(`${this.baseURL}create/`, roomData, {
                headers: {
                    'Authorization': `Token ${token}`,
                    'Content-Type': 'application/json',
                    'X-CSRFToken': Csrf.getToken()
                }
            })
            return response.data
        }catch(e){
            console.error('Error creating room: ', e);
            throw e;
        }
    }

    async updateRoom(token, roomId, updatedRoom){
        try{
            const response = await axios.put(`${this.baseURL}${roomId}/update/`, updatedRoom, {
                headers: {
                    'Authorization': `Token ${token}`,
                    'Content-Type': 'application/json',
                    'X-CSRFToken': Csrf.getToken()
                }
            })
            return response.data
        }catch(e){
            console.error('Error updating room type: ', e);
            throw e;
        }
    }
}

export default new RoomAPI;
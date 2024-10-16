import axios from 'axios'
import Csrf from './csrf';

class RoomTypeAPI{
    constructor(){
        this.baseURL = 'http://127.0.0.1:8000/receptionist/api/roomtypes/';
    }

    async getRoomTypes(token){
        try{
            const response = await axios.get(this.baseURL,{
                headers: {
                    'Authorization': `Token ${token}`
                },
            })
            return response.data;
        }catch(e){
            console.error('Error fetching room types:', e);
            throw e;  
        }
    }

    async createRoomType(token, roomTypedata){
        try{
            const response = await axios.post(`${this.baseURL}create/`, roomTypedata, {
                headers:{
                    'Authorization': `Token ${token}`,
                    'Content-Type': 'application/json',
                    'X-CSRFToken': Csrf.getToken()
                }
            })
            return response.data
        }catch(e){
            console.error('Error creating room type: ', e)
            throw e;
        }
    }

    async deleteRoomType(token, roomTypeId, refreshRooms) {
        try{
            const response = await axios.delete(`${this.baseURL}${roomTypeId}/delete/`, {
                headers: {
                    'Authorization': `Token ${token}`,
                    'X-CSRFToken': Csrf.getToken()
                }
            })

            if(refreshRooms){
                refreshRooms()
            }

            return response.data
        }catch(e){
            console.error('Error deleting room type: ', e);
            throw e;
        }
    }

    async updateRoomType(token, roomTypeId, updatedRoomType){
        try{
            const response = await axios.put(`${this.baseURL}${roomTypeId}/update/`, updatedRoomType, {
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

export default RoomTypeAPI;
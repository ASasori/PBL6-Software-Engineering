import axios from 'axios';
import BASE_URL from './config';
const axiosInstance = axios.create({
    baseURL: `${BASE_URL}}/receptionist/api/bookings/`,
    headers: {
        'Content-Type': 'application/json'
    }
});

class BookingAPI {
    constructor() {
        this.axios = axiosInstance;
    }

    async ListAvailableRoom(checkInDate, checkOutDate, token) {
        try {
            const response = await this.axios.get('available_rooms/', {
                params: {
                    check_in_date: checkInDate,
                    check_out_date: checkOutDate
                },
                headers: {
                    'Authorization': `Bearer ${token}`
                }
            });
            return response.data;
        } catch (error) {
            return this.handleError(error);
        }
    }

    async CreateBooking(data, token) {
        try {
            const response = await this.axios.post('add/', data, {
                headers: {
                    'Authorization': `Bearer ${token}`
                }
            });
            return response.data;
        } catch (error) {
            return this.handleError(error);
        }
    }

    async ListBooking(token) {
        try {
            const response = await this.axios.get('list/', {
                headers: {
                    'Authorization': `Bearer ${token}`
                }
            });
            return response.data;
        } catch (error) {
            return this.handleError(error);
        }
    }

    async ListCoupons(token) {
        try {
            const response = await this.axios.get('list_coupons/', {
                headers: {
                    'Authorization': `Bearer ${token}`
                }
            });
            return response.data;
        } catch (error) {
            return this.handleError(error);
        }
    }

    handleError(error) {
        console.error('API error:', error);
        if (error.response) {
            return error.response.data;
        } else {
            return { error: "Can't connect to the server" };
        }
    }
}

export default new BookingAPI();
